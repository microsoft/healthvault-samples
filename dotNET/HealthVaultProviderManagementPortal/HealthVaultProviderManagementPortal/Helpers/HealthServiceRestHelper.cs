// Copyright (c) Microsoft Corporation.  All rights reserved. 
// MIT License
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the ""Software""), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED *AS IS*, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

using System;
using System.Collections.Specialized;
using System.Configuration;
using System.Linq;
using Microsoft.Health;
using Microsoft.Health.Rest;
using Microsoft.Health.Web;

namespace HealthVaultProviderManagementPortal.Helpers
{
    public static class HealthServiceRestHelper
    {
        /// <summary>
        /// Calls the Health REST service. 
        /// Abstracts away whether it's an online or offline call, depending on whether person and record IDs are passed in.
        /// </summary>
        public static HealthServiceRestResponseData CallHeathServiceRest(Guid? personId, Guid? recordId, PersonInfo loggedInPersonInfo, string httpVerb, string path, NameValueCollection queryStringParameters = null, string requestBody = null, NameValueCollection optionalHeaders = null)
        {
            return personId.HasValue && recordId.HasValue
                    ? CallHeathServiceRestOffline(personId.Value, recordId.Value, loggedInPersonInfo, httpVerb, path, queryStringParameters, requestBody, optionalHeaders)
                    : CallHeathServiceRestOnline(loggedInPersonInfo, httpVerb, path, queryStringParameters, requestBody, optionalHeaders);
        }

        /// <summary>
        /// Makes a call to the Health REST service to edit data for the logged in user.
        /// This is the type of call that an interactive patient application would use.
        /// </summary>
        public static HealthServiceRestResponseData CallHeathServiceRestOnline(PersonInfo loggedInPersonInfo, string httpVerb, string path, NameValueCollection queryStringParameters = null, string requestBody = null, NameValueCollection optionalHeaders = null)
        {
            // Using the HealthVault SDK, make a HTTP call.
            // The root URL comes from the web.config (RestHealthServiceUrl).
            var request = new HealthServiceRestRequest(
                loggedInPersonInfo.Connection,
                httpVerb,
                path,
                queryStringParameters,
                requestBody,
                optionalHeaders: optionalHeaders)
            {
                // Person and record ID identify the patient for whom to retrieve the plan.
                RecordId = loggedInPersonInfo.SelectedRecord.Id
            };

            request.Execute();

            return request.Response;
        }

        /// <summary>
        /// Makes a call to the Health REST service to edit another user who has authorized this application.
        /// This is the type of call that a hospital would make on the behalf of a patient.
        /// </summary>
        public static HealthServiceRestResponseData CallHeathServiceRestOffline(Guid personId, Guid recordId, PersonInfo loggedInPersonInfo, string httpVerb, string path, NameValueCollection queryStringParameters = null, string requestBody = null, NameValueCollection optionalHeaders = null)
        {
            CheckOfflineAuthorization(loggedInPersonInfo);

            // Person and record ID identify the patient for whom to retrieve the plans.
            var connection = new OfflineWebApplicationConnection(
                HealthWebApplicationConfiguration.Current.ApplicationId,
                HealthWebApplicationConfiguration.Current.HealthVaultMethodUrl,
                personId);

            // Authenticate with HealthVault using the connection generated above
            connection.Authenticate();

            // Using the HealthVault SDK, make a HTTP call.
            // The root URL comes from the web.config (RestHealthServiceUrl).
            var request = new HealthServiceRestRequest(
                connection,
                httpVerb,
                path,
                queryStringParameters,
                requestBody,
                optionalHeaders: optionalHeaders)
            {
                // Person and record ID identify the patient for whom to retrieve the plans.
                RecordId = recordId
            };

            request.Execute();

            return request.Response;
        }

        /// <summary>
        /// Checks that the logged in user is authorized to edit other users data
        /// If the config setting is empty, all users will be able to do this.
        /// </summary>
        public static void CheckOfflineAuthorization(PersonInfo loggedInPersonInfo)
        {
            var loggedInPersonId = loggedInPersonInfo?.PersonId;
            if (!loggedInPersonId.HasValue)
            {
                throw new UnauthorizedAccessException();
            }

            var authorizedPersonIds = ConfigurationManager.AppSettings["OfflineAuthorizedPersonIDs"];
            if (!string.IsNullOrWhiteSpace(authorizedPersonIds))
            {
                var personIds = authorizedPersonIds.Split(',');
                if (!personIds.Contains(loggedInPersonId.Value.ToString(), StringComparer.OrdinalIgnoreCase))
                {
                    throw new UnauthorizedAccessException();
                }
            }
        }
    }
}