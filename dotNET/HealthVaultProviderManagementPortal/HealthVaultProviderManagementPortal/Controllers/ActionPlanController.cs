// Copyright (c) Microsoft Corporation.  All rights reserved. 
// MIT License
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the ""Software""), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED *AS IS*, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

using System;
using System.Collections.ObjectModel;
using System.Net;
using System.Web.Mvc;
using System.Web.Routing;
using Microsoft.Health.Platform.Entities.V3;
using Microsoft.Health.Platform.Entities.V3.ActionPlans;
using Microsoft.Health.Platform.Entities.V3.Enums;
using Microsoft.Health.Platform.Entities.V3.Responses;
using Microsoft.Health.Rest;
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
        public ActionResult Index()
        {
            var response = GetPlans();
            return HandleRestResponse<ActionPlansResponse<ActionPlanInstance>>(response, HttpStatusCode.OK);
        }

        /// <summary>
        /// Create a sample plan for the signed-in user.
        /// </summary>
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult CreatePlan()
        {
            var plan = CreateDefaultActionPlan();
            var response = CreatePlan(plan);
            return HandleRestResponse(response, HttpStatusCode.Created);
        }

        /// <summary>
        /// Get a plan for the signed-in user.
        /// </summary>
        [HttpGet]
        public ActionResult EditPlan(string id)
        {
            var response = GetPlan(id);
            return HandleRestResponse<ActionPlanInstance>(response, HttpStatusCode.OK);
        }

        /// <summary>
        /// Edit a plan for the signed-in user.
        /// </summary>
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult EditPlan(string id, ActionPlanInstance plan)
        {
            var response = PatchPlan(plan);
            return HandleRestResponse(response, HttpStatusCode.OK);
        }

        /// <summary>
        /// Delete a plan for the signed-in user.
        /// </summary>
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult RemovePlan(string id)
        {
            var response = DeletePlan(id);
            return HandleRestResponse(response, HttpStatusCode.NoContent);
        }

        /// <summary>
        /// Delete an objective for the signed-in user.
        /// </summary>
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult RemoveObjective(string planId, string id)
        {
            var response = DeleteObjective(planId, id);
            return HandleRestResponse(response, HttpStatusCode.NoContent, "EditPlan", new { id = planId });
        }

        /// <summary>
        /// Create a sample task for the signed-in user.
        /// </summary>
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult CreateScheduledTask(Guid planId, Guid objectiveId)
        {
            var task = CreateDefaultScheduledActionPlanTask(objectiveId, planId);
            var response = CreateTask(task);
            return HandleRestResponse(response, HttpStatusCode.Created, "EditPlan", new { id = planId });
        }

        /// <summary>
        /// Create a sample task for the signed-in user.
        /// </summary>
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult CreateFrequencyTask(Guid planId, Guid objectiveId)
        {
            var task = CreateDefaultFrequencyActionPlanTask(objectiveId, planId);
            var response = CreateTask(task);
            return HandleRestResponse(response, HttpStatusCode.Created, "EditPlan", new { id = planId });
        }

        /// <summary>
        /// Get a task for the signed-in user.
        /// </summary>
        [HttpGet]
        public ActionResult EditTask(string id)
        {
            var response = GetTask(id);
            return HandleRestResponse<ActionPlanTaskInstance>(response, HttpStatusCode.OK);
        }

        /// <summary>
        /// Edit a task for the signed-in user.
        /// </summary>
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult EditTask(string id, ActionPlanTaskInstance task)
        {
            var response = PatchTask(task);
            return HandleRestResponse(response, HttpStatusCode.OK, "EditPlan", new { id = task.AssociatedPlanId });
        }

        /// <summary>
        /// Delete a task for the signed-in user.
        /// </summary>
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult RemoveTask(string planId, string id)
        {
            var response = DeleteTask(id);
            return HandleRestResponse(response, HttpStatusCode.NoContent, "EditPlan", new { id = planId });
        }

        private ActionResult HandleRestResponse(HealthServiceRestResponseData response, HttpStatusCode expectedStatusCode, string action = "Index", object routeValues = null)
        {
            if (response.StatusCode == expectedStatusCode)
            {
                return RedirectToAction(action, routeValues);
            }

            return View("RestError", response);
        }

        private ActionResult HandleRestResponse<T>(HealthServiceRestResponseData response, HttpStatusCode expectedStatusCode)
        {
            if (response.StatusCode == expectedStatusCode)
            {
                var model = JsonConvert.DeserializeObject<T>(response.ResponseBody);
                return View(model);
            }

            return View("RestError", response);
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
            plan.OrganizationId = "CONTOSO";
            plan.OrganizationName = "Contoso";
            plan.OrganizationLogoUrl = new Uri("https://www.example.com");
            plan.OrganizationLongFormImageUrl = new Uri("https://www.example.com");
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
                OrganizationId = "CONTOSO",
                OrganizationName = "Contoso",
                TaskType = ActionPlanTaskType.Unknown,
                SignupName = "Set a consistent wake time",
                AssociatedObjectiveIds = new Collection<Guid> { objectiveId },
                AssociatedPlanId = planId, // Only needs to be set if adding as task after the plan
                TrackingPolicy = new ActionPlanTrackingPolicy(),
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
                }
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
                Name = "Start my pre-sleep ritual",
                ShortDescription = "Develop a short pre-sleep ritual to break the connection between the day's stress and bedtime.",
                LongDescription = "Develop a 10-minute pre-sleep ritual to break the connection between the day's stress and bedtime.",
                ImageUrl = new Uri("https://img-prod-cms-rt-microsoft-com.akamaized.net/cms/api/am/imageFileData/RE1rXx2?ver=d68e"),
                ThumbnailImageUrl = new Uri("https://img-prod-cms-rt-microsoft-com.akamaized.net/cms/api/am/imageFileData/RE1s2KS?ver=0ad8"),
                OrganizationId = "CONTOSO",
                OrganizationName = "Contoso",
                TaskType = ActionPlanTaskType.Unknown,
                SignupName = "Establish a relaxing bedtime ritual",
                AssociatedObjectiveIds = new Collection<Guid> { objectiveId },
                AssociatedPlanId = planId, // Only needs to be set if adding as task after the plan
                TrackingPolicy = new ActionPlanTrackingPolicy(),
                CompletionType = ActionPlanTaskCompletionType.Frequency,
                FrequencyTaskCompletionMetrics = new ActionPlanFrequencyTaskCompletionMetrics()
                {
                    ReminderState = ActionPlanReminderState.Off,
                    ScheduledDays = new Collection<ActionPlanScheduleDay> { ActionPlanScheduleDay.Everyday },
                    OccurrenceCount = 1,
                    WindowType = ActionPlanScheduleRecurrenceType.Daily
                }
            };

            return task;
        }

        /// <summary>
        /// Call the HV REST API to add the action plan to a user's HealthVault record.
        /// Currently this assigns the action plan to the user who is actively signed into the application ("online" scenario).
        /// TODO: add example of a provider assigning the action plan to a patient who is not signed in ("offline" scenario).
        /// See Getting Started doc for more information on offline scenarios.
        /// </summary>
        private HealthServiceRestResponseData CreatePlan(ActionPlan plan)
        {
            // 2. Using the HealthVault SDK, make a HTTP POST call to create the action plan.
            // The root URL comes from the web.config (RestHealthServiceUrl).
            var request = new HealthServiceRestRequest(
                User.PersonInfo().Connection,
                "POST",
                "v3/actionplans",
                null,
                JsonConvert.SerializeObject(plan));

            // Person and record ID identify the patient who is being assigned the plan.
            request.RecordId = User.PersonInfo().SelectedRecord.Id;
            request.Execute();

            return request.Response;
        }

        /// <summary>
        /// Call the HV REST API to partially edit the action plan in a user's HealthVault record.
        /// Currently this edits the action plan of the user who is actively signed into the application ("online" scenario).
        /// TODO: add example of a provider assigning the action plan to a patient who is not signed in ("offline" scenario).
        /// See Getting Started doc for more information on offline scenarios.
        /// </summary>
        private HealthServiceRestResponseData PatchPlan(ActionPlanInstance plan)
        {
            // 2. Using the HealthVault SDK, make a HTTP POST call to partially edit the action plan.
            // The root URL comes from the web.config (RestHealthServiceUrl).
            var request = new HealthServiceRestRequest(
                User.PersonInfo().Connection,
                "PATCH",
                "v3/actionplans",
                null,
                JsonConvert.SerializeObject(plan));

            // Person and record ID identify the patient who is being assigned the plan.
            request.RecordId = User.PersonInfo().SelectedRecord.Id;
            request.Execute();

            return request.Response;
        }

        /// <summary>
        /// Call the HV REST API to get the list of plans the user is currently assigned.
        /// Currently this gets the action plans of the user who is actively signed into the application ("online" scenario).
        /// TODO: add example of a provider getting the action plans of a patient who is not signed in ("offline" scenario).
        /// See Getting Started doc for more information on offline scenarios.
        /// </summary>
        private HealthServiceRestResponseData GetPlans()
        {
            // 2. Using the HealthVault SDK, make a HTTP GET call to get the action plans.
            // The root URL comes from the web.config (RestHealthServiceUrl).
            var request = new HealthServiceRestRequest(
                User.PersonInfo().Connection,
                "GET",
                "v3/actionplans");

            // Person and record ID identify the patient for whom to retrieve the plans.
            request.RecordId = User.PersonInfo().SelectedRecord.Id;
            request.Execute();

            return request.Response;
        }

        /// <summary>
        /// Call the HV REST API to get the a plan for the user.
        /// Currently this gets an action plan of the user who is actively signed into the application ("online" scenario).
        /// TODO: add example of a provider getting an action plan of a patient who is not signed in ("offline" scenario).
        /// See Getting Started doc for more information on offline scenarios.
        /// </summary>
        private HealthServiceRestResponseData GetPlan(string id)
        {
            // 2. Using the HealthVault SDK, make a HTTP GET call to get the action plan.
            // The root URL comes from the web.config (RestHealthServiceUrl).
            var request = new HealthServiceRestRequest(
                User.PersonInfo().Connection,
                "GET",
                "v3/actionplans/" + id);

            // Person and record ID identify the patient for whom to retrieve the plan.
            request.RecordId = User.PersonInfo().SelectedRecord.Id;
            request.Execute();

            return request.Response;
        }

        /// <summary>
        /// Call the HV REST API to delete a plan for the user.
        /// Currently this delete an action plan of the user who is actively signed into the application ("online" scenario).
        /// TODO: add example of a provider deleting an action plan of a patient who is not signed in ("offline" scenario).
        /// See Getting Started doc for more information on offline scenarios.
        /// </summary>
        private HealthServiceRestResponseData DeletePlan(string id)
        {
            // 2. Using the HealthVault SDK, make a HTTP DELETE call to delete the action plan.
            // The root URL comes from the web.config (RestHealthServiceUrl).
            var request = new HealthServiceRestRequest(
                User.PersonInfo().Connection,
                "DELETE",
                "v3/actionplans/" + id);

            // Person and record ID identify the patient for whom to delete the plan.
            request.RecordId = User.PersonInfo().SelectedRecord.Id;
            request.Execute();

            return request.Response;
        }

        /// <summary>
        /// Call the HV REST API to delete an objective for the user.
        /// Currently this delete an action plan objective of the user who is actively signed into the application ("online" scenario).
        /// TODO: add example of a provider deleting an action plan objective of a patient who is not signed in ("offline" scenario).
        /// See Getting Started doc for more information on offline scenarios.
        /// </summary>
        private HealthServiceRestResponseData DeleteObjective(string planId, string id)
        {
            // 2. Using the HealthVault SDK, make a HTTP DELETE call to delete the action plan objective.
            // The root URL comes from the web.config (RestHealthServiceUrl).
            var request = new HealthServiceRestRequest(
                User.PersonInfo().Connection,
                "DELETE",
                "v3/actionplans/" + planId + "/objectives/" + id);

            // Person and record ID identify the patient for whom to delete the objective.
            request.RecordId = User.PersonInfo().SelectedRecord.Id;
            request.Execute();

            return request.Response;
        }

        /// <summary>
        /// Call the HV REST API to add the action plan task to a user's HealthVault record.
        /// Currently this assigns the action plan task to the user who is actively signed into the application ("online" scenario).
        /// TODO: add example of a provider assigning the action plan task to a patient who is not signed in ("offline" scenario).
        /// See Getting Started doc for more information on offline scenarios.
        /// </summary>
        private HealthServiceRestResponseData CreateTask(ActionPlanTask task)
        {
            // 2. Using the HealthVault SDK, make a HTTP POST call to create the action plan task.
            // The root URL comes from the web.config (RestHealthServiceUrl).
            var request = new HealthServiceRestRequest(
                User.PersonInfo().Connection,
                "POST",
                "v3/actionplantasks",
                null,
                JsonConvert.SerializeObject(task));

            // Person and record ID identify the patient who is being assigned the task.
            request.RecordId = User.PersonInfo().SelectedRecord.Id;
            request.Execute();

            return request.Response;
        }

        /// <summary>
        /// Call the HV REST API to get the a task for the user.
        /// Currently this gets an action plan task of the user who is actively signed into the application ("online" scenario).
        /// TODO: add example of a provider getting an action plan task of a patient who is not signed in ("offline" scenario).
        /// See Getting Started doc for more information on offline scenarios.
        /// </summary>
        private HealthServiceRestResponseData GetTask(string id)
        {
            // 2. Using the HealthVault SDK, make a HTTP GET call to get the action plan task.
            // The root URL comes from the web.config (RestHealthServiceUrl).
            var request = new HealthServiceRestRequest(
                User.PersonInfo().Connection,
                "GET",
                "v3/actionplantasks/" + id);

            // Person and record ID identify the patient for whom to retrieve the task.
            request.RecordId = User.PersonInfo().SelectedRecord.Id;
            request.Execute();

            return request.Response;
        }

        /// <summary>
        /// Call the HV REST API to partially edit the action plan task in a user's HealthVault record.
        /// Currently this edits the action plan task of the user who is actively signed into the application ("online" scenario).
        /// TODO: add example of a provider assigning the action plan task to a patient who is not signed in ("offline" scenario).
        /// See Getting Started doc for more information on offline scenarios.
        /// </summary>
        private HealthServiceRestResponseData PatchTask(ActionPlanTaskInstance task)
        {
            // 2. Using the HealthVault SDK, make a HTTP POST call to partially edit the action plan task.
            // The root URL comes from the web.config (RestHealthServiceUrl).
            var request = new HealthServiceRestRequest(
                User.PersonInfo().Connection,
                "PATCH",
                "v3/actionplantasks",
                null,
                JsonConvert.SerializeObject(task));

            // Person and record ID identify the patient who is being assigned the task.
            request.RecordId = User.PersonInfo().SelectedRecord.Id;
            request.Execute();

            return request.Response;
        }

        /// <summary>
        /// Call the HV REST API to delete a task for the user.
        /// Currently this delete an action plan task of the user who is actively signed into the application ("online" scenario).
        /// TODO: add example of a provider deleting an action plan task of a patient who is not signed in ("offline" scenario).
        /// See Getting Started doc for more information on offline scenarios.
        /// </summary>
        private HealthServiceRestResponseData DeleteTask(string id)
        {
            // 2. Using the HealthVault SDK, make a HTTP DELETE call to delete the action plan task.
            // The root URL comes from the web.config (RestHealthServiceUrl).
            var request = new HealthServiceRestRequest(
                User.PersonInfo().Connection,
                "DELETE",
                "v3/actionplantasks/" + id);

            // Person and record ID identify the patient for whom to delete the task.
            request.RecordId = User.PersonInfo().SelectedRecord.Id;
            request.Execute();

            return request.Response;
        }
    }
}