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
using System.Net.Http;
using System.Net.Http.Headers;
using System.Web.Mvc;
using System.Threading.Tasks;
using System.Web.Configuration;
using System.Web.Routing;
using HealthVaultProviderManagementPortal.Models.Enums;
using HealthVaultProviderManagementPortal.Models.Patient;
using Microsoft.HealthVault.RestApi.Generated;
using Microsoft.HealthVault.Web.Attributes;
using Microsoft.Rest;
using Microsoft.Rest.Serialization;
using Newtonsoft.Json;
using NodaTime;
using NodaTime.Extensions;
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
        private const string ApiVersion = "2.0-preview";

        private static JsonSerializerSettings _serializerSettings = GetSerializationSettings();
        private static JsonSerializerSettings _deserializerSettings = GetDeserializationSettings();

        /// <summary>
        /// Gets a the timeline for a patient
        /// </summary>
        public async Task<ActionResult> Index(Guid personId, Guid recordId, DateTime? startDate, DateTime? endDate)
        {
            if (startDate == null)
            {
                return View();
            }

            var timeline = await GetTimeline(personId, recordId, startDate.Value, endDate, DateTimeZoneProviders.Tzdb.GetSystemDefault());

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
                TimelineEntryGroups = groupedTimelineEntries
            };

            return View(model);
        }

        [HttpGet]
        public async Task<ActionResult> TaskOccurrence(Guid personId, Guid recordId, Guid taskId)
        {
            var response = await ExecuteMicrosoftHealthVaultRestApiAsync(api => api.ActionPlanTasks.GetByIdAsync(taskId), personId, recordId);
            return View(response);
        }

        [HttpPost]
        public async Task<ActionResult> TaskOccurrence(Guid personId, Guid recordId, Guid taskId, DateTimeOffset trackingDateTime, DateTime? startDate, DateTime? endDate)
        {
            await PostTaskTracking(personId, recordId, taskId, trackingDateTime);
            var routeValues = new RouteValueDictionary
            {
                {"startDate", startDate?.ToString("d")},
                {"endDate", endDate?.ToString("d")},
                {"personId", personId},
                {"recordId", recordId},
            };

            return RedirectToAction("Index", routeValues);
        }

        private async Task<TimelineResponse> GetTimeline(Guid personId, Guid recordId, DateTime startDate, DateTime? endDate, DateTimeZone timeZone)
        {
            if (timeZone == null)
            {
                throw new ArgumentNullException(nameof(timeZone));
            }

            var restHealthVaultUrl = WebConfigurationManager.AppSettings.Get("HV_RestHealthServiceUrl"); //TODO: use built in SDK function to retreive config settings when available

            // Construct URL
            var uriBuilder = new UriBuilder(restHealthVaultUrl)
            {
                Path = "Timeline"
            };

            var queryParameters = new List<string>
            {
                $"startDate={startDate.ToString("yyyy-MM-dd", CultureInfo.InvariantCulture)}",
                $"timeZone={timeZone.Id}"
            };

            if (endDate != null)
            {
                queryParameters.Add($"endDate={endDate.Value.ToString("yyyy-MM-dd", CultureInfo.InvariantCulture)}");
            }

            uriBuilder.Query = string.Join("&", queryParameters);

            var responseContent = await ExecuteRestRequest(personId, recordId, uriBuilder.Uri, HttpMethod.Get, ApiVersion);

            return SafeJsonConvert.DeserializeObject<TimelineResponse>(responseContent, _deserializerSettings);
        }

        private async Task PostTaskTracking(Guid personId, Guid recordId, Guid taskId, DateTimeOffset trackingDateTime)
        {
            var restHealthVaultUrl = WebConfigurationManager.AppSettings.Get("HV_RestHealthServiceUrl"); //TODO: use built in SDK function to retreive config settings when available

            // Construct URL
            var uriBuilder = new UriBuilder(restHealthVaultUrl)
            {
                Path = "TaskTracking"
            };

            var taskTracking = new
            {
                taskId,
                trackingDateTime = trackingDateTime.ToZonedDateTime()
            };

            await ExecuteRestRequest(personId, recordId, uriBuilder.Uri, HttpMethod.Post, ApiVersion, SafeJsonConvert.SerializeObject(taskTracking, _serializerSettings));
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
                            // Add a timeline entry for the schedule. 
                            // Count all occurences for a frequency task, and only in-window ones for a scheduled task
                            timelineEntries.Add(new TimelineEntryViewModel
                            {
                                TaskId = task.TaskId,
                                TaskName = task.TaskName,
                                TaskImageUrl = task.TaskImageUrl,
                                LocalDateTime = schedule.LocalDateTime,
                                ScheduleType = schedule.Type,
                                CompletionMetrics = snapshot.CompletionMetrics,
                                InWindowOccurrenceCount = schedule.Occurrences?.Count(o => o.InWindow || snapshot.CompletionMetrics.CompletionType == ActionPlanTaskCompletionType.Frequency) ?? 0
                            });

                            // Add any out-of-window task occurrences for scheduled tasks to show on the timeline
                            schedule.Occurrences?
                                .Where(o => !o.InWindow && snapshot.CompletionMetrics.CompletionType == ActionPlanTaskCompletionType.Scheduled)
                                .ToList().ForEach(occurrence => AddOccurrence(timelineEntries, occurrence, task));
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

        private static async Task<string> ExecuteRestRequest(Guid personId, Guid recordId, Uri uri, HttpMethod requestMethod, string apiVersion, string requestBody = null)
        {
            // Create HTTP transport objects
            var httpRequest = new HttpRequestMessage
            {
                Method = requestMethod,
                RequestUri = uri
            };
            httpRequest.Headers.Add("x-ms-version", apiVersion);

            // Set up the request body if it has been specified
            if (!string.IsNullOrWhiteSpace(requestBody))
            {
                httpRequest.Content = new StringContent(requestBody);
                httpRequest.Content.Headers.ContentType = new MediaTypeHeaderValue("application/json");
            }

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

        private static JsonSerializerSettings GetSerializationSettings()
        {
            return new JsonSerializerSettings().ConfigureForNodaTime(DateTimeZoneProviders.Tzdb);
        }
    }
}