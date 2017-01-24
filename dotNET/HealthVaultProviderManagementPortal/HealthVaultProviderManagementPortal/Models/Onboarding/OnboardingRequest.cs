// Copyright (c) Microsoft Corporation.  All rights reserved. 
// MIT License
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the ""Software""), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED *AS IS*, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

using System;
using System.Collections.ObjectModel;

namespace HealthVaultProviderManagementPortal.Models.Onboarding
{
    /// <summary>
    /// The content passed from a client during the onboarding process
    /// </summary>
    public class OnboardingRequest
    {
        public OnboardingRequest()
        {
            // ActionPlanTemplateIds is currently required but is being deprecated
            ActionPlanTemplateIds = new Collection<string>() { "test" };
            Conditions = new Collection<string>();
        }

        /// <summary>
        /// Gets sets the friendly name
        /// </summary>
        public string FriendlyName { get; set; }

        /// <summary>
        /// Gets sets ApplicationPatientId
        /// </summary>
        public string ApplicationPatientId { get; set; }

        /// <summary>
        /// REQUIRED: Gets or sets the user's secret question
        /// </summary>
        public string SecretQuestion { get; set; }

        /// <summary>
        /// Gets or sets the user's secret answer. Must be at least six characters.
        /// </summary>
        public string SecretAnswer { get; set; }

        /// <summary>
        /// Gets or sets the user's first name.
        /// </summary>
        public string FirstName { get; set; }

        /// <summary>
        /// Gets or sets the user's last name.
        /// </summary>
        public string LastName { get; set; }

        /// <summary>
        /// Gets or sets the user's email address
        /// </summary>
        public string Email { get; set; }

        /// <summary>
        /// Gets and sets the user zip code/postal code
        /// </summary>
        public string ZipCode { get; set; }

        /// <summary>
        /// Gets and sets the user's state
        /// </summary>
        public string State { get; set; }

        /// <summary>
        /// Gets and sets the user's country/region
        /// </summary>
        public string Country { get; set; }

        /// <summary>
        /// Gets and sets the user's birthday
        /// </summary>
        public DateTime Birthday { get; set; }

        /// <summary>
        /// Gets and sets the user gender
        /// </summary>
        public Gender Gender { get; set; }

        /// <summary>
        /// Gets and sets the user's weight in grams
        /// </summary>
        public int Weight { get; set; }

        /// <summary>
        /// Gets and sets the user's height in centimeters
        /// </summary>
        public int Height { get; set; }

        /// <summary>
        /// Gets or sets the list of action plan template ids to which the user 
        /// will be assigned upon account creation
        /// </summary>
        public Collection<string> ActionPlanTemplateIds { get; set; }

        /// <summary>
        /// Gets or sets the list of health conditions that will be displayed to the user during consent collection
        /// </summary>
        public Collection<string> Conditions { get; set; }
    }
}