// Copyright (c) Microsoft Corporation.  All rights reserved.
// MIT License
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the ""Software""), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED *AS IS*, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

using System;
using System.Collections.Generic;
using Microsoft.Health;
using Microsoft.Health.Package;
using Microsoft.Health.Web;

namespace HVAppCode
{
    public class HealthVaultDOPU
    {
        public static string AllocatePackageId(OfflineWebApplicationConnection connection)
        {
            return (ConnectPackage.AllocatePackageId(connection));
        }

        public static string DropOffToPatient(OfflineWebApplicationConnection connection,
                                              string fromName,
                                              string localPatientId,
                                              string secretQuestion,
                                              string secretAnswer,
                                              ref List<HealthRecordItem> newItems)
        {
            ConnectPackageCreationParameters parameters = new ConnectPackageCreationParameters(connection,
                                                                fromName,
                                                                secretQuestion,
                                                                secretAnswer,
                                                                localPatientId);

            String secretCode = ConnectPackage.Create(parameters, newItems);
            return (secretCode);
        }

        public static string DropOffToPackage(OfflineWebApplicationConnection connection,
                                              string dopuPackageId,
                                              string fromName,
                                              string localPatientId,
                                              string secretQuestion,
                                              string secretAnswer,
                                              ref List<HealthRecordItem> newItems)
        {
            ConnectPackageCreationParameters parameters = new ConnectPackageCreationParameters(connection,
                                                                dopuPackageId,
                                                                fromName,
                                                                secretQuestion,
                                                                secretAnswer,
                                                                localPatientId);

            String secretCode = ConnectPackage.Create(parameters, newItems);
            return (secretCode);
        }

        public static void DeletePendingForPackageId(OfflineWebApplicationConnection connection, string packageId)
        {
            ConnectPackage.DeletePendingForIdentityCode(connection, packageId);
        }

        public static void DeletePendingForPatientId(OfflineWebApplicationConnection connection, string PatientId)
        {
            ConnectPackage.DeletePending(connection, PatientId);
        }
    }
}  // HVAppCode