// Copyright (c) Microsoft Corporation.  All rights reserved.
// MIT License
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the ""Software""), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED *AS IS*, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

using System;
using System.Configuration;
using System.Threading.Tasks;
using Microsoft.HealthVault.Connection;
using Microsoft.HealthVault.RestApi;
using Microsoft.HealthVault.RestApi.Generated;
using Microsoft.HealthVault.Web;

namespace HealthVaultProviderManagementPortal.Helpers
{
    public static class RestClientFactory
    {
        public static async Task<IHealthVaultConnection> GetConnectionAsync(Guid? personId = null)
        {
            IHealthVaultConnection connection;
            if (personId.HasValue)
            {
                connection = await WebHealthVaultFactory.CreateOfflineConnectionAsync(personId.Value.ToString());
            }
            else
            {
                connection = await WebHealthVaultFactory.CreateWebConnectionAsync();
            }
            await connection.AuthenticateAsync();
            return connection;
        }

        public static async Task<IMicrosoftHealthVaultRestApi> CreateMicrosoftHealthVaultRestApiAsync(Guid? personId = null, Guid? recordId = null)
        {
            var connection = await GetConnectionAsync(personId);

            if (!recordId.HasValue)
            {
                var personInfo = await connection.GetPersonInfoAsync();
                recordId = personInfo.GetSelfRecord().Id;
            }

            return connection.CreateMicrosoftHealthVaultRestApi(recordId.Value);
        }

        public static async Task<T> ExecuteMicrosoftHealthVaultRestApiAsync<T>(Func<IMicrosoftHealthVaultRestApi, Task<T>> restApiDelegate, Guid personId, Guid recordId)
        {
            var restApi = await CreateMicrosoftHealthVaultRestApiAsync(personId, recordId);
            return await restApiDelegate(restApi);
        }
    }
}