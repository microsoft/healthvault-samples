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
using System.Threading.Tasks;
using HealthVaultProviderManagementPortal.Helpers;
using HealthVaultProviderManagementPortal.Models;
using HealthVaultProviderManagementPortal.Models.Enums;
using Microsoft.HealthVault.RestApi.Generated;
using Microsoft.HealthVault.RestApi.Generated.Models;
using Microsoft.HealthVault.Web.Attributes;
using static HealthVaultProviderManagementPortal.Helpers.RestClientFactory;

namespace HealthVaultProviderManagementPortal.Controllers
{
    /// <summary>
    /// Controller for creating and sending invitations to remote patients
    /// </summary>
    [RequireSignIn]
    public class GoalsController : Controller
    {
        /// <summary>
        /// Gets a list of goals
        /// </summary>
        public async Task<ActionResult> Index(Guid personId, Guid recordId)
        {
            var goalsTask = ExecuteMicrosoftHealthVaultRestApiAsync(api => api.Goals.GetActiveAsync(), personId, recordId);
            var goalRecommendationsTask = ExecuteMicrosoftHealthVaultRestApiAsync(api => api.GoalRecommendations.GetAsync(), personId, recordId);

            await Task.WhenAll(goalsTask, goalRecommendationsTask);

            var model = new GoalsModel
            {
                Goals = goalsTask.Result.Goals,
                GoalRecomendations = goalRecommendationsTask.Result.GoalRecommendations
            };

            return View(model);
        }

        /// <summary>
        /// Get a goal for the logged in user
        /// </summary>
        [HttpGet]
        public async Task<ActionResult> Goal(Guid? id, Guid personId, Guid recordId)
        {
            if (id.HasValue && id.Value != Guid.Empty)
            {
                var response = await ExecuteMicrosoftHealthVaultRestApiAsync(api => api.Goals.GetByIdAsync(id.ToString()), personId, recordId);
                return View(response);
            }

            var goal = new Goal();
            return View(goal);
        }

        /// <summary>
        /// Update a goal for the logged in user
        /// </summary>
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> Goal(Guid? id, Goal goal, Guid personId, Guid recordId)
        {
            if (goal?.RecurrenceMetrics?.OccurrenceCount == null && goal?.RecurrenceMetrics?.WindowType == GoalRecurrenceType.Unknown.ToString())
            {
                goal.RecurrenceMetrics = null;
            }

            var goalWrapper = new GoalsWrapper
            {
                Goals = new Collection<Goal> { goal }
            };

            if (id.HasValue && id.Value != Guid.Empty)
            {
                await ExecuteMicrosoftHealthVaultRestApiAsync(api => api.Goals.UpdateAsync(goalWrapper), personId, recordId);
            }
            else
            {
                await ExecuteMicrosoftHealthVaultRestApiAsync(api => api.Goals.CreateAsync(goalWrapper), personId, recordId);
            }
            
            return RedirectToAction("Index", new { personId = personId, recordId = recordId });
        }

        /// <summary>
        /// Create a goal for the logged in user
        /// </summary>
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> CreateGoal(Guid personId, Guid recordId)
        {
            var goalWrapper = new GoalsWrapper
            {
                Goals = new Collection<Goal> { Builder.CreateDefaultGoal() }
            };

            await ExecuteMicrosoftHealthVaultRestApiAsync(api => api.Goals.CreateAsync(goalWrapper), personId, recordId);
            return RedirectToAction("Index", new { personId = personId, recordId = recordId });
        }

        /// <summary>
        /// Delete a goal for the logged in user
        /// </summary>
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> RemoveGoal(Guid id, Guid personId, Guid recordId)
        {
            await ExecuteMicrosoftHealthVaultRestApiAsync(api => api.Goals.DeleteAsync(id.ToString()), personId, recordId);
            return RedirectToAction("Index", new { personId = personId, recordId = recordId });
        }

        /// <summary>
        /// Get a blank goal recommendation page for the user to fill out
        /// </summary>
        [HttpGet]
        public ActionResult GoalRecommendation()
        {
            var recommendation = new GoalRecommendation
            {
                AssociatedGoal = new Goal()
            };
            return View(recommendation);
        }

        /// <summary>
        /// Create a goal recommendation for the logged in user
        /// </summary>
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> GoalRecommendation(GoalRecommendation recommendation, Guid personId, Guid recordId)
        {
            if (recommendation?.AssociatedGoal?.RecurrenceMetrics?.OccurrenceCount == null && recommendation?.AssociatedGoal?.RecurrenceMetrics?.WindowType == GoalRecurrenceType.Unknown.ToString())
            {
                recommendation.AssociatedGoal.RecurrenceMetrics = null;
            }
            await ExecuteMicrosoftHealthVaultRestApiAsync(api => api.GoalRecommendations.CreateAsync(recommendation), personId, recordId);
            return RedirectToAction("Index", new { personId = personId, recordId = recordId });
        }

        /// <summary>
        /// Delete a goal recommendation for the logged in user
        /// </summary>
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> RemoveGoalRecommendation(string id, Guid personId, Guid recordId)
        {
            await ExecuteMicrosoftHealthVaultRestApiAsync(api => api.GoalRecommendations.DeleteAsync(id), personId, recordId);
            return RedirectToAction("Index", new { personId = personId, recordId = recordId });
        }
    }
}