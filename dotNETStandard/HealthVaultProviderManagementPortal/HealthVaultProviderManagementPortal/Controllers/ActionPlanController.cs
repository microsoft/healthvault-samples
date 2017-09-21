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
using System.Linq;
using System.Net;
using System.Threading.Tasks;
using System.Web;
using System.Web.Mvc;
using HealthVaultProviderManagementPortal.Helpers;
using Microsoft.HealthVault.Person;
using Microsoft.HealthVault.RestApi.Generated;
using Microsoft.HealthVault.RestApi.Generated.Models;
using Microsoft.HealthVault.Web.Attributes;
using static HealthVaultProviderManagementPortal.Helpers.RestClientFactory;

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
            return View();
        }

        /// <summary>
        /// Get the list of plans for a user.
        /// </summary>
        [HttpGet]
        public async Task<ActionResult> Plans(Guid personId, Guid recordId)
        {
            var response = await ExecuteMicrosoftHealthVaultRestApiAsync(api => api.ActionPlans.GetAsync(), personId, recordId);
            return View(response);
        }

        /// <summary>
        /// Create a sample sleep plan for a user.
        /// </summary>
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> CreateSleepPlan(Guid personId, Guid recordId)
        {
            var plan = Builder.CreateSleepActionPlan();
            await ExecuteMicrosoftHealthVaultRestApiAsync(api => api.ActionPlans.CreateAsync(plan), personId, recordId);
            return RedirectToRoutePlans(personId, recordId);
        }

        /// <summary>
        /// Create a sample weight plan for a user.
        /// </summary>
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> CreateWeightPlan(Guid personId, Guid recordId)
        {
            var plan = Builder.CreateWeightActionPlan();
            await ExecuteMicrosoftHealthVaultRestApiAsync(api => api.ActionPlans.CreateAsync(plan), personId, recordId);
            return RedirectToRoutePlans(personId, recordId);
        }

        /// <summary>
        /// Get a plan for a user.
        /// </summary>
        [HttpGet]
        public async Task<ActionResult> Plan(Guid id, Guid personId, Guid recordId)
        {
            var response = await ExecuteMicrosoftHealthVaultRestApiAsync(api => api.ActionPlans.GetByIdAsync(id), personId, recordId);
            return View(response);
        }

        /// <summary>
        /// Edit a plan for a user.
        /// </summary>
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> Plan(Guid id, ActionPlanInstance plan, Guid personId, Guid recordId)
        {
            await ExecuteMicrosoftHealthVaultRestApiAsync(api => api.ActionPlans.UpdateAsync(plan), personId, recordId);
            return RedirectToAction("Plan", new { id, personId, recordId });
        }

        /// <summary>
        /// Delete a plan for a user.
        /// </summary>
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> RemovePlan(Guid id, Guid personId, Guid recordId)
        {
            await ExecuteMicrosoftHealthVaultRestApiAsync(api =>
                api.ActionPlans.DeleteAsync(id), personId, recordId);

            return RedirectToRoutePlans(personId, recordId);
        }

        /// <summary>
        /// Delete an objective for a user.
        /// </summary>
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> RemoveObjective(Guid planId, Guid objectiveId, Guid personId, Guid recordId)
        {
            await ExecuteMicrosoftHealthVaultRestApiAsync(api =>
                api.ActionPlanObjectives.DeleteAsync(planId, objectiveId), personId, recordId);

            return RedirectToAction("Plan", new { id = planId, personId, recordId });
        }

        /// <summary>
        /// Create a sample task for a user.
        /// </summary>
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> CreateScheduledTask(Guid planId, Guid objectiveId, Guid personId, Guid recordId)
        {
            await ExecuteMicrosoftHealthVaultRestApiAsync(api =>
                api.ActionPlanTasks.CreateAsync(Builder.CreateSleepScheduledActionPlanTask(objectiveId, planId)), personId, recordId);

            return RedirectToAction("Plan", new { id = planId, personId, recordId });
        }

        /// <summary>
        /// Create a sample task for a user.
        /// </summary>
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> CreateFrequencyTask(Guid planId, Guid objectiveId, Guid personId, Guid recordId)
        {
            await ExecuteMicrosoftHealthVaultRestApiAsync(api =>
                api.ActionPlanTasks.CreateAsync(Builder.CreateSleepFrequencyActionPlanTask(objectiveId, planId)), personId, recordId);

            return RedirectToAction("Plan", new { id = planId, personId, recordId });
        }

        /// <summary>
        /// Get a task for a user.
        /// </summary>
        [HttpGet]
        public async Task<ActionResult> Task(Guid? id, Guid? planId, Guid? objectiveId, Guid personId, Guid recordId)
        {
            if (id.HasValue)
            {
                var response = await ExecuteMicrosoftHealthVaultRestApiAsync(api => api.ActionPlanTasks.GetByIdAsync(id.Value), personId, recordId);
                return View(response);
            }

            var task = new ActionPlanTaskInstance();

            if (planId.HasValue)
            {
                task.AssociatedPlanId = planId.Value;
            }

            if (objectiveId.HasValue)
            {
                task.AssociatedObjectiveIds = new Collection<Guid?> { objectiveId.Value };
            }

            return View(task);
        }

        /// <summary>
        /// Edit a task for a user.
        /// </summary>
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> Task(Guid? id, ActionPlanTaskInstance task, Guid personId, Guid recordId)
        {
            if (id.HasValue && id.Value != Guid.Empty)
            {
                await ExecuteMicrosoftHealthVaultRestApiAsync(api => api.ActionPlanTasks.UpdateAsync(task), personId, recordId);
            }
            else
            {
                task.TrackingPolicy = new ActionPlanTrackingPolicy
                {
                    IsAutoTrackable = false
                };

                await ExecuteMicrosoftHealthVaultRestApiAsync(api => api.ActionPlanTasks.CreateAsync(task.AsActionPlanTaskV2()), personId, recordId);
            }

            return RedirectToAction("Plan", new { id = task.AssociatedPlanId, personId, recordId });
        }

        /// <summary>
        /// Delete a task for a user.
        /// </summary>
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> RemoveTask(Guid planId, Guid id, Guid personId, Guid recordId)
        {
            await ExecuteMicrosoftHealthVaultRestApiAsync(api => api.ActionPlanTasks.DeleteAsync(id), personId, recordId);
            return RedirectToAction("Plan", new { id = planId, personId, recordId });
        }

        /// <summary>
        /// Get plan adherence for a user.
        /// </summary>
        [HttpGet]
        public async Task<ActionResult> Adherence(Guid id, Guid personId, Guid recordId)
        {
            var now = DateTime.UtcNow;
            var response = await ExecuteMicrosoftHealthVaultRestApiAsync(api => api.ActionPlans.GetAdherenceAsync(now.AddDays(-14), now.AddDays(1), id), personId, recordId);
            return View(response);
        }

        /// <summary>
        /// Get a task for a user.
        /// </summary>
        [HttpGet]
        public async Task<ActionResult> ValidateTracking(Guid id, Guid planId, Guid personId, Guid recordId)
        {
            var response = await ExecuteMicrosoftHealthVaultRestApiAsync(api => api.ActionPlanTasks.GetByIdAsync(id), personId, recordId);
            return View("TrackingValidationEntry", response);
        }

        /// <summary>
        /// Edit a task for a user.
        /// </summary>
        [HttpPost]
        [ValidateInput(false)]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> ValidateTracking(Guid id, string trackingPolicy, string thing, Guid personId, Guid recordId)
        {
            var restApi = await CreateMicrosoftHealthVaultRestApiAsync(personId, recordId);
            var taskInstance = await restApi.ActionPlanTasks.GetByIdAsync(id);

            if (!string.IsNullOrWhiteSpace(trackingPolicy))
            {
                taskInstance.TrackingPolicy = trackingPolicy.AsActionPlanTrackingPolicy();
            }

            var trackingValidation = new TrackingValidation
            {
                ActionPlanTask = taskInstance?.AsActionPlanTaskV2(),
                XmlThingDocument = thing
            };

            var response = await restApi.ActionPlanTasks.ValidateTrackingAsync(trackingValidation);

            return View(response);
        }

        /// <summary>
        /// Get users that have authorized this application
        /// </summary>
        [HttpGet]
        public async Task<ActionResult> Users()
        {
            var response = await GetAuthorizedPeople();
            return View(response);
        }

        private async Task<ICollection<PersonInfo>> GetAuthorizedPeople()
        {
            var personClient = (await GetConnectionAsync()).CreatePersonClient();
            return (await personClient.GetAuthorizedPeopleAsync()).ToArray();
        }

        private RedirectToRouteResult RedirectToRoutePlans(Guid personId, Guid recordId)
        {
            return RedirectToAction("Plans", new { personId, recordId });
        }
    }
}