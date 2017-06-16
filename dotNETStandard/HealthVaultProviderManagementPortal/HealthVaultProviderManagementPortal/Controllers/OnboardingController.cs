// Copyright (c) Microsoft Corporation.  All rights reserved.
// MIT License
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the ""Software""), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED *AS IS*, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

using System;
using System.Web.Mvc;
using System.Threading.Tasks;
using Microsoft.HealthVault.Exceptions;
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
    public class OnboardingController : Controller
    {
        /// <summary>
        /// Form to create an invitation for a remote patient to participate in your program
        /// </summary>
        public ActionResult Index()
        {
            var onboardingRequest = CreateDefaultOnboardingRequest();
            return View(onboardingRequest);
        }

        /// <summary>
        /// Performs the request to generate the invitation for the patient.
        /// Returns a view with either the invite code and URL to send the patient if the call succeeded,
        /// or the error response if the call failed.
        /// </summary>
        /// <param name="onboardingRequest">The request to upload.</param>
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> CreateInvite(OnboardingRequest onboardingRequest)
        {
            try
            {
                var client = await CreateMicrosoftHealthVaultRestApiAsync();
                var response = await client.Onboarding.GenerateInviteCodeAsync(onboardingRequest);
                return View("InviteSuccess", response);
            }
            catch (HealthVaultException ex)
            {
                return View("RestError", ex.Message);
            }
        }

        /// <summary>
        /// Creates a sample onboarding request.
        /// </summary>
        /// <returns></returns>
        private OnboardingRequest CreateDefaultOnboardingRequest()
        {
            // 1. Create the onboarding request with participant information
            var onboardingRequest = new OnboardingRequest();

            onboardingRequest.FirstName = "John";
            onboardingRequest.LastName = "Doe";
            onboardingRequest.FriendlyName = "John";
            onboardingRequest.ApplicationPatientId = "johndoe-" + Guid.NewGuid();  // Must be unique
            onboardingRequest.Birthday = new DateTime(1955, 10, 28);

            // This is a workaround for bug#48405. TODO: Remove once S61 is available.
            onboardingRequest.Height = 155; //In cm
            onboardingRequest.Weight = 50000; //In g

            // 1a. Specify a patient/provider secret question & answer to validate the identity of the invitee
            onboardingRequest.SecretQuestion = "What color is the sky?";
            onboardingRequest.SecretAnswer = "The sky is blue";  // Must be at least six characters

            return onboardingRequest;
        }
    }
}