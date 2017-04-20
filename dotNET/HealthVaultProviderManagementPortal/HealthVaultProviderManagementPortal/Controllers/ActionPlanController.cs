// Copyright (c) Microsoft Corporation.  All rights reserved. 
// MIT License
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the ""Software""), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED *AS IS*, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Collections.Specialized;
using System.Globalization;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Mvc;
using System.Web.Routing;
using HealthVaultProviderManagementPortal.Helpers;
using Microsoft.Health;
using Microsoft.Health.Platform.Entities.V3;
using Microsoft.Health.Platform.Entities.V3.ActionPlans;
using Microsoft.Health.Platform.Entities.V3.Enums;
using Microsoft.Health.Platform.Entities.V3.Responses;
using Microsoft.Health.Rest;
using Microsoft.Health.Web;
using Microsoft.Health.Web.Mvc;
using Newtonsoft.Json;

namespace HealthVaultProviderManagementPortal.Controllers
{
    /// <summary>
    /// Controller for managing patients' action plans
    /// </summary>
    [RequireSignIn]
    public class ActionPlanController : Controller
    {
        private string basePlanRestUrl = "v3/actionplans/";
        private string baseTaskRestUrl = "v3/actionplantasks/";

        #region Controller Actions
        public ActionResult Index()
        {
            return View();
        }

        /// <summary>
        /// Get the list of plans for a user.
        /// </summary>
        [HttpGet]
        public ActionResult Plans(Guid? personId = null, Guid? recordId = null)
        {
            var response = GetPlans(personId, recordId);            
            return HandleRestResponse<ActionPlansResponse<ActionPlanInstance>>(response, HttpStatusCode.OK);
        }

        /// <summary>
        /// Create a sample plan for a user.
        /// </summary>
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult CreatePlan(Guid? personId = null, Guid? recordId = null)
        {
            var plan = CreateDefaultActionPlan();
            var response = CreatePlan(plan, personId, recordId);
            return HandleRestResponse(response, HttpStatusCode.Created, personId, recordId);
        }

        /// <summary>
        /// Get a plan for a user.
        /// </summary>
        [HttpGet]
        public ActionResult Plan(Guid id, Guid? personId = null, Guid? recordId = null)
        {
            var response = GetPlan(id, personId, recordId);
            return HandleRestResponse<ActionPlanInstance>(response, HttpStatusCode.OK);
        }

        /// <summary>
        /// Edit a plan for a user.
        /// </summary>
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Plan(Guid id, ActionPlanInstance plan, Guid? personId = null, Guid? recordId = null)
        {
            var response = PatchPlan(plan, personId, recordId);
            return HandleRestResponse(response, HttpStatusCode.OK, personId, recordId);
        }

        /// <summary>
        /// Delete a plan for a user.
        /// </summary>
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult RemovePlan(Guid id, Guid? personId = null, Guid? recordId = null)
        {
            var response = DeletePlan(id, personId, recordId);
            return HandleRestResponse(response, HttpStatusCode.NoContent, personId, recordId);
        }

        /// <summary>
        /// Delete an objective for a user.
        /// </summary>
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult RemoveObjective(Guid planId, Guid? objectiveId, Guid? personId = null, Guid? recordId = null)
        {
            var response = DeleteObjective(planId, objectiveId.Value, personId, recordId);
            return HandleRestResponse(response, HttpStatusCode.NoContent, personId, recordId, "Plan", new RouteValueDictionary { { "id", planId } });
        }

        /// <summary>
        /// Create a sample task for a user.
        /// </summary>
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult CreateScheduledTask(Guid planId, Guid? objectiveId, Guid? personId = null, Guid? recordId = null)
        {
            var task = CreateDefaultScheduledActionPlanTask(objectiveId.Value, planId);
            var response = CreateTask(task, personId, recordId);
            return HandleRestResponse(response, HttpStatusCode.Created, personId, recordId, "Plan", new RouteValueDictionary { { "id", planId } });
        }

        /// <summary>
        /// Create a sample task for a user.
        /// </summary>
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult CreateFrequencyTask(Guid planId, Guid? objectiveId, Guid? personId = null, Guid? recordId = null)
        {
            var task = CreateDefaultFrequencyActionPlanTask(objectiveId.Value, planId);
            var response = CreateTask(task, personId, recordId);
            return HandleRestResponse(response, HttpStatusCode.Created, personId, recordId, "Plan", new RouteValueDictionary { { "id", planId } });
        }

        /// <summary>
        /// Get a task for a user.
        /// </summary>
        [HttpGet]
        public ActionResult Task(Guid? id, Guid? planId, Guid? objectiveId, Guid? personId = null, Guid? recordId = null)
        {
            if (id.HasValue)
            {
                var response = GetTask(id.Value, personId, recordId);
                return HandleRestResponse<ActionPlanTaskInstance>(response, HttpStatusCode.OK);
            }

            var task = new ActionPlanTaskInstance();

            if (planId.HasValue)
            {
                task.AssociatedPlanId = planId.Value;
            }

            if (objectiveId.HasValue)
            {
                task.AssociatedObjectiveIds = new Collection<Guid> { objectiveId.Value };
            }

            return View(task);
        }

        /// <summary>
        /// Edit a task for a user.
        /// </summary>
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Task(Guid? id, ActionPlanTaskInstance task, Guid? personId = null, Guid? recordId = null)
        {
            HealthServiceRestResponseData response;

            if (id.HasValue && id.Value != Guid.Empty)
            {
                response = PatchTask(task, personId, recordId);
            }
            else
            {
                task.TrackingPolicy = new ActionPlanTrackingPolicy
                {
                    IsAutoTrackable = false
                };

                response = CreateTask(task, personId, recordId);
            }

            return HandleRestResponse(response, HttpStatusCode.OK, personId, recordId, "Plan", new RouteValueDictionary { { "id", task.AssociatedPlanId } });
        }

        /// <summary>
        /// Delete a task for a user.
        /// </summary>
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult RemoveTask(Guid planId, Guid id, Guid? personId = null, Guid? recordId = null)
        {
            var response = DeleteTask(id, personId, recordId);
            return HandleRestResponse(response, HttpStatusCode.NoContent, personId, recordId, "Plan", new RouteValueDictionary { { "id", planId } });
        }

        /// <summary>
        /// Get plan adherence for a user.
        /// </summary>
        [HttpGet]
        public ActionResult Adherence(Guid id, Guid? personId = null, Guid? recordId = null)
        {
            var now = DateTimeOffset.UtcNow;
            var response = GetPlanAdherence(id, now.AddDays(-14), now, personId, recordId);
            return HandleRestResponse<ActionPlanAdherenceSummary>(response, HttpStatusCode.OK);
        }

        /// <summary>
        /// Get a task for a user.
        /// </summary>
        [HttpGet]
        public ActionResult ValidateTracking(Guid id, Guid planId, Guid? personId = null, Guid? recordId = null)
        {
            return View("TrackingValidationEntry", new ActionPlanTaskInstance()
            {
                Id = id,
                AssociatedPlanId = planId
            });
        }

        /// <summary>
        /// Edit a task for a user.
        /// </summary>
        [HttpPost]
        [ValidateInput(false)]
        [ValidateAntiForgeryToken]
        public ActionResult ValidateTracking(Guid id, string thing, Guid? personId = null, Guid? recordId = null)
        {
            var taskResponse = GetTask(id, personId, recordId);
            if (taskResponse.StatusCode != HttpStatusCode.OK)
            {
                return View("RestError", taskResponse);
            }

            var task = JsonConvert.DeserializeObject<ActionPlanTask>(taskResponse.ResponseBody);

            var trackingValidation = new TrackingValidation
            {
                ActionPlanTask = task,
                XmlThingDocument = thing
            };

            var response = ValidateTaskAutoTracking(trackingValidation);
            return HandleRestResponse<ActionPlanTaskTrackingResponse<ActionPlanTaskTracking>>(response, HttpStatusCode.OK);
        }

        /// <summary>
        /// Get users that have authorized this application
        /// </summary>
        [HttpGet]
        public ActionResult Users()
        {
            var response = GetAuthorizedPeople();
            return View(response);
        }

        #endregion

        #region Helpers

        /// <summary>
        /// Handles the rest response. If it is the expected status code, it redirects to the given action
        /// </summary>
        /// <param name="response">The response.</param>
        /// <param name="expectedStatusCode">The expected status code.</param>
        /// <param name="personId">The person identifier.</param>
        /// <param name="recordId">The record identifier.</param>
        /// <param name="action">The action.</param>
        /// <param name="routeValues">The route values.</param>
        private ActionResult HandleRestResponse(HealthServiceRestResponseData response, HttpStatusCode expectedStatusCode, Guid? personId, Guid? recordId, string action = "Plans", RouteValueDictionary routeValues = null)
        {
            if (response.StatusCode != expectedStatusCode)
            {
                return View("RestError", response);
            }

            if (personId.HasValue && recordId.HasValue)
            {
                if (routeValues == null)
                {
                    routeValues = new RouteValueDictionary();
                }

                routeValues.Add("personId", personId);
                routeValues.Add("recordId", recordId);
            }

            return RedirectToAction(action, routeValues);
        }

        /// <summary>
        /// Handles the rest response. If it is the expected status code, it deserializes the view model and loads the view.
        /// </summary>
        /// <typeparam name="T">The view model type</typeparam>
        /// <param name="response">The response.</param>
        /// <param name="expectedStatusCode">The expected status code.</param>
        private ActionResult HandleRestResponse<T>(HealthServiceRestResponseData response, HttpStatusCode expectedStatusCode)
        {
            if (response.StatusCode != expectedStatusCode)
            {
                return View("RestError", response);
            }

            var model = JsonConvert.DeserializeObject<T>(response.ResponseBody);
            return View(model);
        }

        /// <summary>
        /// Creates a sample action plan object.
        /// </summary>
        private ActionPlan CreateDefaultActionPlan()
        {
            var plan = new ActionPlan();
            var objective = CreateDefaultActionPlanObjective();

            // Use this if you want to create the task with the plan in one call.
            // You can also create tasks in a separate call after the action plan is created.
            var scheduledTask = CreateDefaultScheduledActionPlanTask(objective.Id);
            var frequencyTask = CreateDefaultFrequencyActionPlanTask(objective.Id);

            plan.Name = "Sleep better";
            plan.Description = "Improve the quantity and quality of your sleep.";
            plan.ImageUrl = new Uri("https://img-prod-cms-rt-microsoft-com.akamaized.net/cms/api/am/imageFileData/RE10omP?ver=59cf");
            plan.ThumbnailImageUrl = new Uri("https://img-prod-cms-rt-microsoft-com.akamaized.net/cms/api/am/imageFileData/RE10omP?ver=59cf");
            plan.Category = ActionPlanCategory.Sleep;
            plan.Objectives = new Collection<Objective> { objective };
            plan.AssociatedTasks = new Collection<ActionPlanTask> { scheduledTask, frequencyTask };

            return plan;
        }

        /// <summary>
        /// Creates a sample action plan objective.
        /// </summary>
        private Objective CreateDefaultActionPlanObjective()
        {
            var objective = new Objective
            {
                Id = Guid.NewGuid(),
                Name = "Get more sleep",
                Description = "Work on habits that help you maximize how much you sleep you get.",
                State = ActionPlanObjectiveStatus.Active,
                OutcomeName = "Minutes to fall asleep/night",
                OutcomeType = ActionPlanOutcomeType.MinutesToFallAsleepPerNight
            };

            return objective;
        }

        /// <summary>
        /// Creates a sample schedule based task associated with the specified objective.
        /// </summary>
        private ActionPlanTask CreateDefaultScheduledActionPlanTask(Guid objectiveId, Guid planId = default(Guid))
        {
            var task = new ActionPlanTask
            {
                Name = "Time to wake up",
                ShortDescription = "Set a consistent wake time to help regulate your body's internal clock.",
                LongDescription = "Studies show that waking up at a consistent time every day, even on weekends, is one of the best ways to ensure a good night's sleep.",
                ImageUrl = new Uri("https://img-prod-cms-rt-microsoft-com.akamaized.net/cms/api/am/imageFileData/RE1rXx2?ver=d68e"),
                ThumbnailImageUrl = new Uri("https://img-prod-cms-rt-microsoft-com.akamaized.net/cms/api/am/imageFileData/RE1s2KS?ver=0ad8"),
                TaskType = ActionPlanTaskType.Other,
                SignupName = "Set a consistent wake time",
                AssociatedObjectiveIds = new Collection<Guid> { objectiveId },
                AssociatedPlanId = planId, // Only needs to be set if adding as task after the plan
                TrackingPolicy = new ActionPlanTrackingPolicy
                {
                    IsAutoTrackable = false
                },
                CompletionType = ActionPlanTaskCompletionType.Scheduled,
                ScheduledTaskCompletionMetrics = new ActionPlanScheduledTaskCompletionMetrics
                {
                    ReminderState = ActionPlanReminderState.Off,
                    ScheduledDays = new Collection<ActionPlanScheduleDay> { ActionPlanScheduleDay.Everyday },
                    ScheduledTime = new Time()
                    {
                        Hours = 6,
                        Minutes = 30
                    }
                },
            };

            return task;
        }

        /// <summary>
        /// Creates a sample frequency based task associated with the specified objective.
        /// </summary>
        private ActionPlanTask CreateDefaultFrequencyActionPlanTask(Guid objectiveId, Guid planId = default(Guid))
        {
            var task = new ActionPlanTask
            {
                Name = "Measure your blood pressure",
                ShortDescription = "Measure your blood pressure - the goal is to have your systolic between 80-120 and diastolic between 60-80 mmHg",
                LongDescription = "Measure your blood pressure - the goal is to have your systolic between 80-120 and diastolic between 60-80 mmHg",
                ImageUrl = new Uri("https://img-prod-cms-rt-microsoft-com.akamaized.net/cms/api/am/imageFileData/RE1rXx2?ver=d68e"),
                ThumbnailImageUrl = new Uri("https://img-prod-cms-rt-microsoft-com.akamaized.net/cms/api/am/imageFileData/RE1s2KS?ver=0ad8"),
                TaskType = ActionPlanTaskType.BloodPressure,
                SignupName = "Measure your blood pressure",
                AssociatedObjectiveIds = new Collection<Guid> { objectiveId },
                AssociatedPlanId = planId, // Only needs to be set if adding as task after the plan
                TrackingPolicy = new ActionPlanTrackingPolicy
                {
                    IsAutoTrackable = true,
                    OccurrenceMetrics = new ActionPlanTaskOccurrenceMetrics
                    {
                        EvaluateTargets = false
                    },
                    TargetEvents = new Collection<ActionPlanTaskTargetEvent>
                    {
                        new ActionPlanTaskTargetEvent
                        {
                            ElementXPath = "thing/data-xml/blood-pressure"
                        }
                    }
                },
                CompletionType = ActionPlanTaskCompletionType.Frequency,
                FrequencyTaskCompletionMetrics = new ActionPlanFrequencyTaskCompletionMetrics()
                {
                    ReminderState = ActionPlanReminderState.Off,
                    ScheduledDays = new Collection<ActionPlanScheduleDay> { ActionPlanScheduleDay.Everyday },
                    OccurrenceCount = 1,
                    WindowType = ActionPlanScheduleRecurrenceType.Daily
                },
            };

            return task;
        }

        #endregion

        #region Data Access Wrappers

        /// <summary>
        /// Call the HV REST API to add the action plan to a user's HealthVault record.
        /// Assigns an action plan to a user who is not signed in ("offline" scenario) if both personId and recordId are provided.
        /// Otherwise, this assigns the action plan to the user who is actively signed into the application ("online" scenario).
        /// See Getting Started doc for more information on offline scenarios.
        /// </summary>
        private HealthServiceRestResponseData CreatePlan(ActionPlan plan, Guid? personId, Guid? recordId)
        {
            return HealthServiceRestHelper.CallHealthServiceRest(
                personId,
                recordId,
                User.PersonInfo(),
                HttpMethod.Post.ToString(),
                basePlanRestUrl,
                null,
                JsonConvert.SerializeObject(plan));
        }

        /// <summary>
        /// Call the HV REST API to partially edit the action plan in a user's HealthVault record.
        /// Edits an action plan of a user who is not signed in ("offline" scenario) if both personId and recordId are provided.
        /// Otherwise, this edits the action plan of the user who is actively signed into the application ("online" scenario).
        /// See Getting Started doc for more information on offline scenarios.
        /// </summary>
        private HealthServiceRestResponseData PatchPlan(ActionPlanInstance plan, Guid? personId, Guid? recordId)
        {
            return HealthServiceRestHelper.CallHealthServiceRest(
                personId,
                recordId,
                User.PersonInfo(),
                "PATCH",
                basePlanRestUrl,
                null,
                JsonConvert.SerializeObject(plan));
        }

        /// <summary>
        /// Call the HV REST API to get the list of plans the user is currently assigned.
        /// Gets the action plans of a user who is not signed in ("offline" scenario) if both personId and recordId are provided.
        /// Otherwise, this gets the action plans of the user who is actively signed into the application ("online" scenario).
        /// See Getting Started doc for more information on offline scenarios.
        /// </summary>
        private HealthServiceRestResponseData GetPlans(Guid? personId, Guid? recordId)
        {
            return HealthServiceRestHelper.CallHealthServiceRest(
                personId,
                recordId,
                User.PersonInfo(),
                HttpMethod.Get.ToString(),
                basePlanRestUrl);
        }

        /// <summary>
        /// Call the HV REST API to get the a plan for the user.
        /// Gets an action plan of a user who is not signed in ("offline" scenario) if both personId and recordId are provided.
        /// Otherwise, this gets an action plan of the user who is actively signed into the application ("online" scenario).
        /// See Getting Started doc for more information on offline scenarios.
        /// </summary>
        private HealthServiceRestResponseData GetPlan(Guid id, Guid? personId, Guid? recordId)
        {
            return HealthServiceRestHelper.CallHealthServiceRest(
                personId,
                recordId,
                User.PersonInfo(),
                HttpMethod.Get.ToString(),
                basePlanRestUrl + id);
        }

        /// <summary>
        /// Call the HV REST API to delete a plan for the user.
        /// Deletes an action plan of a user who is not signed in ("offline" scenario) if both personId and recordId are provided.
        /// Otherwise, this deletes an action plan of the user who is actively signed into the application ("online" scenario).
        /// See Getting Started doc for more information on offline scenarios.
        /// </summary>
        private HealthServiceRestResponseData DeletePlan(Guid id, Guid? personId, Guid? recordId)
        {
            return HealthServiceRestHelper.CallHealthServiceRest(
                personId,
                recordId,
                User.PersonInfo(),
                HttpMethod.Delete.ToString(),
                basePlanRestUrl + id);
        }

        /// <summary>
        /// Call the HV REST API to delete an objective for the user.
        /// Deletes an action plan objective of a user who is not signed in ("offline" scenario) if both personId and recordId are provided.
        /// Otherwise, this deletes an action plan objective of the user who is actively signed into the application ("online" scenario).
        /// See Getting Started doc for more information on offline scenarios.
        /// </summary>
        private HealthServiceRestResponseData DeleteObjective(Guid planId, Guid id, Guid? personId, Guid? recordId)
        {
            return HealthServiceRestHelper.CallHealthServiceRest(
                personId,
                recordId,
                User.PersonInfo(),
                HttpMethod.Delete.ToString(),
                basePlanRestUrl + planId + "/objectives/" + id);
        }

        /// <summary>
        /// Call the HV REST API to add the action plan task to a user's HealthVault record.
        /// Assigns an action plan task to a user who is not signed in ("offline" scenario) if both personId and recordId are provided.
        /// Otherwise, this assigns the action plan task to the user who is actively signed into the application ("online" scenario).
        /// See Getting Started doc for more information on offline scenarios.
        /// </summary>
        private HealthServiceRestResponseData CreateTask(ActionPlanTask task, Guid? personId, Guid? recordId)
        {
            return HealthServiceRestHelper.CallHealthServiceRest(
                personId,
                recordId,
                User.PersonInfo(),
                HttpMethod.Post.ToString(),
                baseTaskRestUrl,
                null,
                JsonConvert.SerializeObject(task));
        }

        /// <summary>
        /// Call the HV REST API to get the a task for the user.
        /// Gets an action plan task of a user who is not signed in ("offline" scenario) if both personId and recordId are provided.
        /// Otherwise, this gets an action plan task of the user who is actively signed into the application ("online" scenario).
        /// See Getting Started doc for more information on offline scenarios.
        /// </summary>
        private HealthServiceRestResponseData GetTask(Guid id, Guid? personId, Guid? recordId)
        {
            return HealthServiceRestHelper.CallHealthServiceRest(
                personId,
                recordId,
                User.PersonInfo(),
                HttpMethod.Get.ToString(),
                baseTaskRestUrl + id);
        }

        /// <summary>
        /// Call the HV REST API to partially edit the action plan task in a user's HealthVault record.
        /// Edits an action plan task of a user who is not signed in ("offline" scenario) if both personId and recordId are provided.
        /// Otherwise, this edits the action plan task of the user who is actively signed into the application ("online" scenario).
        /// See Getting Started doc for more information on offline scenarios.
        /// </summary>
        private HealthServiceRestResponseData PatchTask(ActionPlanTaskInstance task, Guid? personId, Guid? recordId)
        {
            return HealthServiceRestHelper.CallHealthServiceRest(
                personId,
                recordId,
                User.PersonInfo(),
                "PATCH",
                baseTaskRestUrl,
                null,
                JsonConvert.SerializeObject(task));
        }

        /// <summary>
        /// Call the HV REST API to delete a task for the user.
        /// Deletes an action plan task of a user who is not signed in ("offline" scenario) if both personId and recordId are provided.
        /// Otherwise, this deletes an action plan task of the user who is actively signed into the application ("online" scenario).
        /// See Getting Started doc for more information on offline scenarios.
        /// </summary>
        private HealthServiceRestResponseData DeleteTask(Guid id, Guid? personId, Guid? recordId)
        {
            return HealthServiceRestHelper.CallHealthServiceRest(
                personId,
                recordId,
                User.PersonInfo(),
                HttpMethod.Delete.ToString(),
                baseTaskRestUrl + id);
        }

        /// <summary>
        /// Call the HV REST API to check how auto tracking matches a task against a HealthVault XML thing.
        /// As this API doesn't actually access HealthVault (all data is being passed in), we've only done this in an online manner.
        /// </summary>
        private HealthServiceRestResponseData ValidateTaskAutoTracking(TrackingValidation trackingValidation)
        {
            return HealthServiceRestHelper.CallHealthServiceRest(
                null,
                null,
                User.PersonInfo(),
                HttpMethod.Post.ToString(),
                baseTaskRestUrl + "ValidateTracking",
                null,
                JsonConvert.SerializeObject(trackingValidation));
        }

        /// <summary>
        /// Gets a list of people who have authorized this application to access their data.
        /// </summary>
        private List<PersonInfo> GetAuthorizedPeople()
        {
            HealthServiceRestHelper.CheckOfflineAuthorization(User.PersonInfo());

            var connection = new OfflineWebApplicationConnection(
                HealthWebApplicationConfiguration.Current.ApplicationId,
                HealthWebApplicationConfiguration.Current.HealthVaultMethodUrl,
                Guid.Empty);

            // Authenticate with HealthVault using the certificate generated above
            connection.Authenticate();

            // Iterate through all authorized users
            var people = connection.GetAuthorizedPeople().ToList();

            return people;
        }

        /// <summary>
        /// Call the HV REST API to get the plan adherence for the user.
        /// Gets the adherence of a user who is not signed in ("offline" scenario) if both personId and recordId are provided.
        /// Otherwise, this gets action plan adherence of the user who is actively signed into the application ("online" scenario).
        /// See Getting Started doc for more information on offline scenarios.
        /// </summary>
        private HealthServiceRestResponseData GetPlanAdherence(Guid id, DateTimeOffset startTime, DateTimeOffset endTime, Guid? personId, Guid? recordId)
        {
            var queryParameters = new NameValueCollection
            {
                {nameof(startTime), startTime.ToString("o", CultureInfo.InvariantCulture)},
                {nameof(endTime), endTime.ToString("o", CultureInfo.InvariantCulture)}
            };

            return HealthServiceRestHelper.CallHealthServiceRest(
                personId,
                recordId,
                User.PersonInfo(),
                HttpMethod.Get.ToString(),
                basePlanRestUrl + id + "/Adherence",
                queryParameters);
        }

        #endregion
        
    }
}