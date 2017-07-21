// Copyright (c) Microsoft Corporation.  All rights reserved.
// MIT License
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the ""Software""), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED *AS IS*, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Mvc;
using System.Threading.Tasks;
using System.Web.Configuration;
using HealthVaultProviderManagementPortal.Models.Patient;
using Microsoft.HealthVault.Configuration;
using Microsoft.HealthVault.Web.Attributes;
using Microsoft.Rest;
using Microsoft.Rest.Serialization;
using Newtonsoft.Json;
using NodaTime;
using NodaTime.Serialization.JsonNet;
using static HealthVaultProviderManagementPortal.Helpers.RestClientFactory;

namespace HealthVaultProviderManagementPortal.Controllers
{
    /// <summary>
    /// Controller for creating and sending invitations to remote patients
    /// </summary>
    [RequireSignIn]
    public class PatientController : Controller
    {
        /// <summary>
        /// Gets a the timeline for a patient
        /// </summary>
        public async Task<ActionResult> Index(Guid personId, Guid recordId, DateTime? startDate, DateTime? endDate)
        {
            if (startDate == null)
            {
                return View();
            }

            var timeline = await GetTimeline(personId, recordId, startDate.Value, endDate);

            var timelineEntries = new List<TimelineEntryViewModel>();
            foreach (var task in timeline.Tasks)
            {
                timelineEntries.AddRange(ConvertToTimelineEntryViewModels(task));
            }

            var groupedTimelineEntries = timelineEntries.OrderBy(t => t.LocalDateTime).ThenByDescending(t => t.ScheduleType).GroupBy(st => st.LocalDateTime.Date);

            var model = new TimelineViewModel
            {
                StartDate = startDate,
                EndDate = endDate,
                TimelineEntries = groupedTimelineEntries
            };

            return View(model);
        }

        private async Task<TimelineResponse> GetTimeline(Guid personId, Guid recordId, DateTime startDate, DateTime? endDate)
        {
            var restHealthVaultUrl = WebConfigurationManager.AppSettings.Get("HV_RestHealthServiceUrl"); //TODO: use built in SDK function to retreive config settings when available

            // Construct URL
            var uriBuilder = new UriBuilder(restHealthVaultUrl)
            {
                Path = "Timeline"
            };

            var queryParameters = new List<string>
            {
                $"startDate={startDate.ToString("yyyy-MM-dd", CultureInfo.InvariantCulture)}"
            };

            if (endDate != null)
            {
                queryParameters.Add($"endDate={endDate.Value.ToString("yyyy-MM-dd", CultureInfo.InvariantCulture)}");
            }

            if (queryParameters.Count > 0)
            {
                uriBuilder.Query = string.Join("&", queryParameters);
            }

            var responseContent = await ExecuteRestRequest(personId, recordId, uriBuilder.Uri, HttpMethod.Get, "2.0-preview");

            return SafeJsonConvert.DeserializeObject<TimelineResponse>(responseContent, GetDeserializationSettings());
        }

        private static IList<TimelineEntryViewModel> ConvertToTimelineEntryViewModels(TimelineTask task)
        {
            var timelineEntries = new List<TimelineEntryViewModel>();
            if (task?.TimelineSnapshots == null || !task.TimelineSnapshots.Any()) return timelineEntries;

            // Each task can contain multiple snapshots of what the schedules and completion metrics looked like at a point in time
            foreach (var snapshot in task.TimelineSnapshots)
            {
                if (snapshot.Schedules != null && snapshot.Schedules.Any())
                {
                    foreach (var schedule in snapshot.Schedules)
                    {
                        // Check that the schedule is within this snapshot.
                        if (schedule.LocalDateTime >= snapshot.EffectiveStartInstant.InUtc().LocalDateTime &&
                            schedule.LocalDateTime <= snapshot.EffectiveEndInstant.InUtc().LocalDateTime)
                        {
                            // Add a timeline entry for the schedule
                            timelineEntries.Add(new TimelineEntryViewModel
                            {
                                TaskId = task.TaskId,
                                TaskName = task.TaskName,
                                TaskImageUrl = task.TaskImageUrl,
                                LocalDateTime = schedule.LocalDateTime,
                                ScheduleType = schedule.Type
                            });

                            // Add any out-of-window task occurrences to show on the timeline
                            schedule.Occurrences?.Where(o => !o.InWindow).ToList().ForEach(occurrence => AddOccurrence(timelineEntries, occurrence, task)); ;
                        }
                    }
                }

                // Add any unscheduled task occurrences to show on the timeline
                snapshot.UnscheduledOccurrences?.ForEach(occurrence => AddOccurrence(timelineEntries, occurrence, task));
            }

            return timelineEntries;
        }

        private static void AddOccurrence(List<TimelineEntryViewModel> timelineEntries, TimelineScheduleOccurrence occurrence, TimelineTask task)
        {
            // Don't add another entry if this occurrence has already been added to the timeline
            if (timelineEntries.Any(t => t.OccurrenceId.HasValue && t.OccurrenceId.Value == occurrence.Id))
            {
                return;
            }

            timelineEntries.Add(new TimelineEntryViewModel
            {
                TaskId = task.TaskId,
                TaskName = task.TaskName,
                TaskImageUrl = task.TaskImageUrl,
                LocalDateTime = occurrence.LocalDateTime,
                ScheduleType = TimelineScheduleType.Unscheduled,
                OccurrenceId = occurrence.Id
            });
        }

        private static async Task<string> ExecuteRestRequest(Guid personId, Guid recordId, Uri uri, HttpMethod requestMethod, string apiVersion)
        {
            // Create HTTP transport objects
            var httpRequest = new HttpRequestMessage
            {
                Method = requestMethod,
                RequestUri = uri,
            };
            httpRequest.Headers.Add("x-ms-version", apiVersion);

            var connection = await GetConnectionAsync(personId);
            await connection.AuthorizeRestRequestAsync(httpRequest, recordId);

            var httpClient = new HttpClient();
            var httpResponse = await httpClient.SendAsync(httpRequest);
            var responseContent = await httpResponse.Content.ReadAsStringAsync();
            if (!httpResponse.IsSuccessStatusCode)
            {
                throw new RestException(responseContent);
            }

            return responseContent;
        }

        private static JsonSerializerSettings GetDeserializationSettings()
        {
            var settings = new JsonSerializerSettings
            {
                DateFormatHandling = Newtonsoft.Json.DateFormatHandling.IsoDateFormat,
                DateTimeZoneHandling = Newtonsoft.Json.DateTimeZoneHandling.Utc,
                NullValueHandling = Newtonsoft.Json.NullValueHandling.Ignore,
                ReferenceLoopHandling = Newtonsoft.Json.ReferenceLoopHandling.Serialize,
                ContractResolver = new ReadOnlyJsonContractResolver(),
                Converters = new List<JsonConverter>
                {
                    new Iso8601TimeSpanConverter()
                }
            };

            settings.ConfigureForNodaTime(DateTimeZoneProviders.Tzdb);

            return settings;
        }
    }
}