using System;
using System.Collections.Generic;
using System.Security.Cryptography.X509Certificates;
using System.Linq;
using System.Web;
using Microsoft.Health;
using Microsoft.Health.Package;
using Microsoft.Health.Web;
using Microsoft.Health.Web.Authentication;


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