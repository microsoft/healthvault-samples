// Copyright (c) Microsoft Corporation.  All rights reserved.
// MIT License
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the ""Software""), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED *AS IS*, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

using System;
using System.Collections.ObjectModel;
using System.Web.Mvc;
using System.Net;
using System.Net.Http;
using HealthVaultProviderManagementPortal.Helpers;
using Microsoft.Health.Platform.Entities.V3.Enums;
using Microsoft.Health.Rest;
using Newtonsoft.Json;
using Microsoft.Health.Platform.Entities.V3.Goals;
using Microsoft.Health.Platform.Entities.V3.Responses;
using Microsoft.Health.Web.Mvc;

namespace HealthVaultProviderManagementPortal.Controllers
{
    /// <summary>
    /// Controller for creating and sending invitations to remote patients
    /// </summary>
    [RequireSignIn]
    public class GoalsController : Controller
    {
        private string _baseRestUrl = "v3/goals/";

        /// <summary>
        /// Gets a list of goals
        /// </summary>
        public ActionResult Index()
        {
            var response = GetGoals();
            if (response.StatusCode == HttpStatusCode.OK)
            {
                var model = JsonConvert.DeserializeObject<GoalsResponse<Goal>>(response.ResponseBody);
                return View(model);
            }
            else
            {
                return View("RestError", response);
            }
        }

        /// <summary>
        /// Get a goal for the logged in user
        /// </summary>
        [HttpGet]
        public ActionResult Goal(Guid id)
        {
            var response = GetGoal(id);
            if (response.StatusCode == HttpStatusCode.OK)
            {
                var model = JsonConvert.DeserializeObject<Goal>(response.ResponseBody);
                return View(model);
            }
            else
            {
                return View("RestError", response);
            }
        }

        /// <summary>
        /// Update a goal for the logged in user
        /// </summary>
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Goal(Goal goal)
        {
            if (goal?.RecurrenceMetrics?.OccurrenceCount == null && goal?.RecurrenceMetrics?.WindowType == GoalRecurrenceType.Unknown)
            {
                goal.RecurrenceMetrics = null;
            }

            var goalWrapper = new GoalsWrapper
            {
                Goals = new Collection<Goal> { goal }
            };

            var response = UpdateGoals(goalWrapper);
            if (response.StatusCode == HttpStatusCode.OK)
            {
                return RedirectToAction("Index");
            }
            else
            {
                return View("RestError", response);
            }
        }

        /// <summary>
        /// Create a goal for the logged in user
        /// </summary>
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult CreateGoal()
        {
            var goal = CreateDefaultGoal();
            var goalWrapper = new GoalsWrapper
            {
                Goals = new Collection<Goal> { goal }
            };
            var response = CreateGoals(goalWrapper);
            if (response.StatusCode == HttpStatusCode.Created)
            {
                return RedirectToAction("Index");
            }
            else
            {
                return View("RestError", response);
            }
        }

        /// <summary>
        /// Delete a goal for the logged in user
        /// </summary>
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult RemoveGoal(Guid id)
        {
            var response = DeleteGoal(id);
            if (response.StatusCode == HttpStatusCode.NoContent)
            {
                return RedirectToAction("Index");
            }
            else
            {
                return View("RestError", response);
            }
        }

        /// <summary>
        /// Creates a sample goal object.
        /// </summary>
        private static Goal CreateDefaultGoal()
        {
            return new Goal
            {
                Name = "Steps",
                Description = "This is a test steps goal",
                GoalType = GoalType.Steps,
                Range = new GoalRange
                {
                    Minimum = 5000,
                    Units = GoalRangeUnit.Count
                },
                RecurrenceMetrics = new GoalRecurrenceMetrics
                {
                    OccurrenceCount = 1,
                    WindowType = GoalRecurrenceType.Daily
                }
            };
        }

        /// <summary>
        /// Call the HV REST API to get a list of goals in a user's HealthVault record.
        /// This gets goals of the user who is actively signed into the application ("online" scenario).
        /// </summary>
        private HealthServiceRestResponseData GetGoals()
        {
            return HealthServiceRestHelper.CallHeathServiceRestOnline(
               User.PersonInfo(),
               HttpMethod.Get.ToString(),
               _baseRestUrl);
        }

        /// <summary>
        /// Call the HV REST API to get a goal in a user's HealthVault record.
        /// This gets a goal of the user who is actively signed into the application ("online" scenario).
        /// </summary>
        private HealthServiceRestResponseData GetGoal(Guid id)
        {
            return HealthServiceRestHelper.CallHeathServiceRestOnline(
                User.PersonInfo(),
                HttpMethod.Get.ToString(),
                _baseRestUrl + id);
        }

        /// <summary>
        /// Call the HV REST API to create goals in a user's HealthVault record.
        /// This creates goals for the user who is actively signed into the application ("online" scenario).
        /// </summary>
        private HealthServiceRestResponseData CreateGoals(GoalsWrapper goals)
        {
            return HealthServiceRestHelper.CallHeathServiceRestOnline(
                User.PersonInfo(),
                HttpMethod.Post.ToString(),
                _baseRestUrl,
                requestBody: JsonConvert.SerializeObject(goals));
        }

        /// <summary>
        /// Call the HV REST API to update goals in a user's HealthVault record.
        /// This updates goals for the user who is actively signed into the application ("online" scenario).
        /// </summary>
        private HealthServiceRestResponseData UpdateGoals(GoalsWrapper goals)
        {
            return HealthServiceRestHelper.CallHeathServiceRestOnline(
                User.PersonInfo(),
                "PATCH",
                _baseRestUrl,
                requestBody: JsonConvert.SerializeObject(goals));
        }

        /// <summary>
        /// Call the HV REST API to delete a goal in a user's HealthVault record.
        /// This deletes a goal of the user who is actively signed into the application ("online" scenario).
        /// </summary>
        private HealthServiceRestResponseData DeleteGoal(Guid id)
        {
            return HealthServiceRestHelper.CallHeathServiceRestOnline(
                User.PersonInfo(),
                HttpMethod.Delete.ToString(),
                _baseRestUrl + id);
        }
    }
}