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
        public async Task<ActionResult> Index(Guid? personId = null, Guid? recordId = null)
        {
            var response = await ExecuteMicrosoftHealthVaultRestApiAsync(api => api.GetGoalsAsync(), personId, recordId);
            return this.View(response);
        }

        /// <summary>
        /// Get a goal for the logged in user
        /// </summary>
        [HttpGet]
        public async Task<ActionResult> Goal(Guid id)
        {
            var response = await ExecuteMicrosoftHealthVaultRestApiAsync(api => api.GetGoalByIdAsync(id.ToString()));
            return this.View(response);
        }

        /// <summary>
        /// Update a goal for the logged in user
        /// </summary>
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> Goal(Goal goal)
        {
            if (goal?.RecurrenceMetrics?.OccurrenceCount == null && goal?.RecurrenceMetrics?.WindowType == GoalRecurrenceType.Unknown.ToString())
            {
                goal.RecurrenceMetrics = null;
            }

            var goalWrapper = new GoalsWrapper
            {
                Goals = new Collection<Goal> { goal }
            };

            await ExecuteMicrosoftHealthVaultRestApiAsync(api => api.PatchGoalsAsync(goalWrapper));
            return RedirectToAction("Index");
            
        }

        /// <summary>
        /// Create a goal for the logged in user
        /// </summary>
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> CreateGoal()
        {
            var goalWrapper = new GoalsWrapper
            {
                Goals = new Collection<Goal> { Builder.CreateDefaultGoal() }
            };

            await ExecuteMicrosoftHealthVaultRestApiAsync(api => api.CreateGoalsAsync(goalWrapper));
            return RedirectToAction("Index");
        }

        /// <summary>
        /// Delete a goal for the logged in user
        /// </summary>
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> RemoveGoal(Guid id)
        {
            await ExecuteMicrosoftHealthVaultRestApiAsync(api => api.DeleteGoalAsync(id.ToString()));
            return RedirectToAction("Index");
        }
    }
}