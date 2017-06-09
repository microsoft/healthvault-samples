// Copyright (c) Microsoft Corporation.  All rights reserved.
// MIT License
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the ""Software""), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED *AS IS*, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

using System;
using System.Linq;
using System.Threading.Tasks;
using System.Web.Mvc;
using Microsoft.HealthVault.ItemTypes;
using Microsoft.HealthVault.Record;
using Microsoft.HealthVault.Web.Attributes;
using NodaTime;
using static HealthVaultProviderManagementPortal.Helpers.RestClientFactory;

namespace HealthVaultProviderManagementPortal.Controllers
{
    /// <summary>
    /// Controller for viewing and updating health measurements stored in HealthVault.
    /// </summary>
    [RequireSignIn]
    public class HealthDataController : Controller
    {
        [HttpGet]
        public async Task<ActionResult> Index(Guid personId, Guid? recordId)
        {
            var connection = await GetConnectionAsync(personId);

            var record = await connection.CreatePersonClient().GetPersonInfoAsync();
            var thingClient = connection.CreateThingClient();

            recordId = recordId ?? record.GetSelfRecord().Id;

            var weights = await thingClient.GetThingsAsync<Weight>(recordId.GetValueOrDefault());
            if (weights.Count > 0)
            {
                return View(weights);
            }

            return View();
        }

        [HttpPost]
        public async Task<ActionResult> Index(Guid personId, Guid? recordId, double weight)
        {
            var item = new Weight(
                new HealthServiceDateTime(LocalDateTime.FromDateTime(DateTime.Now)),
                new WeightValue(weight)
                );

            var connection = await GetConnectionAsync(personId);
            var record = await connection.CreatePersonClient().GetPersonInfoAsync();

            var thingClient = connection.CreateThingClient();

            recordId = recordId ?? record.GetSelfRecord().Id;
            await thingClient.CreateNewThingsAsync(recordId.GetValueOrDefault(), new[] { item });

            return RedirectToAction("Index", new { personId, recordId });
        }
    }
}