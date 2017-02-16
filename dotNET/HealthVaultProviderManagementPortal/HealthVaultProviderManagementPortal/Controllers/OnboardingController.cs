// Copyright (c) Microsoft Corporation.  All rights reserved. 
// MIT License
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the ""Software""), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED *AS IS*, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

using System;
using System.Web.Mvc;
using System.Net;

using Microsoft.Health.Rest;
using Microsoft.Health.Web;
using Newtonsoft.Json;
using HealthVaultProviderManagementPortal.Models.Onboarding;

namespace HealthVaultProviderManagementPortal.Controllers
{
    /// <summary>
    /// Controller for creating and sending invitations to remote patients
    /// </summary>
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
        public ActionResult CreateInvite(OnboardingRequest onboardingRequest)
        {
            var response = GenerateInviteCode(onboardingRequest);
            if (response.StatusCode == HttpStatusCode.OK)
            {
                var model = JsonConvert.DeserializeObject<OnboardingResponse>(response.ResponseBody);
                return View("InviteSuccess", model);
            }
            else
            {
                return View("RestError", response);
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
            onboardingRequest.Email = "john@contoso.com";
            onboardingRequest.Birthday = new DateTime(1989, 8, 11);

            // This is a workaround for bug#48405. TODO: Remove once S61 is available.
            onboardingRequest.Height = 155; //In cm
            onboardingRequest.Weight = 50000; //In g

            // 1a. Specify a patient/provider secret question & answer to validate the identity of the invitee
            onboardingRequest.SecretQuestion = "What color is the sky?";
            onboardingRequest.SecretAnswer = "The sky is blue";  // Must be at least six characters

            return onboardingRequest;
        }

        /// <summary>
        /// Call the HV REST API to generate the invitation code.
        /// </summary>
        /// <param name="onboardingRequest"></param>
        private static HealthServiceRestResponseData GenerateInviteCode(OnboardingRequest onboardingRequest)
        {
            // 2. Using the HealthVault SDK, make a HTTP POST call to get an invitation code for participant.
            // The root URL comes from the web.config (RestHealthServiceUrl).
            var request = new HealthServiceRestRequest(
                WebApplicationUtilities.ApplicationConnection,
                "POST",
                "v3/onboarding/generateinvitecode",
                null,
                JsonConvert.SerializeObject(onboardingRequest));

            request.Execute();

            return request.Response;
        }
    }
}