// Copyright (c) Microsoft Corporation.  All rights reserved.
// MIT License
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the ""Software""), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED *AS IS*, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

using System;
using System.Collections.Generic;
using System.Configuration;
using System.Windows.Forms;
using Microsoft.Health;
using Microsoft.Health.ItemTypes;

namespace HVClientSample
{
    /// <summary>
    /// HVClient
    /// Contains sample code for provisioning a client application, creating
    /// a connection and how to retrieve data from HealthVault
    /// </summary>
    internal class HVClient
    {
        #region Constructors and initialization

        /// <summary>
        /// Constructor
        /// </summary>
        public HVClient()
        {
            Initialize();
        }

        /// <summary>
        /// Initializes the variables required for HVClient.
        /// </summary>
        private void Initialize()
        {
            // Read the master application id from config file
            // Master application should have been pre-created in HealthVault
            // In HealthVault pre-production environment, the master application
            // should have been created using Application Configuration Center
            _masterApplicationId = new Guid(ConfigurationSettings.AppSettings["ApplicationId"]);

            _isProvisioned = Properties.Settings.Default.IsProvisioned;

            if (_isProvisioned)
            {
                // Read the app, person, and record ID, along
                // with the instance ID if that app has already
                // been provisioned
                _applicationId = Properties.Settings.Default.ApplicationId;
                _personId = Properties.Settings.Default.PersonId;
                _recordId = Properties.Settings.Default.RecordGuid;

                string serviceInstanceId = Properties.Settings.Default.ServiceInstanceId;
                _serviceInstance = ServiceInfo.Current.ServiceInstances[serviceInstanceId];

                _healthClientApplication = HealthClientApplication.Create(_applicationId, _masterApplicationId, _serviceInstance);
            }
        }

        #endregion

        #region Public Properties

        public HealthClientApplication HealthClientApplication
        {
            get
            {
                return _healthClientApplication;
            }
        }

        public HealthServiceInstance ServiceInstance
        {
            get
            {
                return _serviceInstance;
            }
        }

        public Guid PersonId
        {
            get
            {
                return _personId;
            }
        }

        public Guid RecordId
        {
            get
            {
                return _recordId;
            }
        }

        public bool IsProvisioned
        {
            get
            {
                return _isProvisioned;
            }
        }

        #endregion

        #region Public Methods

        /// <summary>
        /// Provisions the application.
        /// If application does not exist, it launches the application
        /// creation process.
        /// </summary>
        public void ProvisionApplication()
        {
            // generate a GUID that will be used for the application creation.
            _applicationId = Guid.NewGuid();

            HealthClientApplication client = HealthClientApplication.Create(_applicationId, _masterApplicationId);
            client.StartApplicationCreationProcess();

            // launch dialog box to wait
            MessageBox.Show("After completing application setup in browser, click OK");

            // check if the app is provisioned now
            HealthServiceInstance instance = FindProvisionedServiceInstance();

            if (instance == null)
            {
                MessageBox.Show("The application setup in your browser did not complete.");
                return;
            }

            _serviceInstance = instance;
            _healthClientApplication = client;

            // the app was provisioned
            _healthClientApplication = HealthClientApplication.Create(
                _applicationId,
                _masterApplicationId,
                _serviceInstance);

            // Get list of authorized people
            ApplicationConnection connection = HealthClientApplication.ApplicationConnection;
            List<PersonInfo> authorizedPeople = new List<PersonInfo>(connection.GetAuthorizedPeople());

            if (authorizedPeople.Count == 0)
            {
                MessageBox.Show("No records were authorized.  Application setup process did not complete.");
                return;
            }

            // save person ID, record ID, and service instance ID
            // assumption is the first person is the current person ID and there is only
            // one recordid for the person. For more persons and records, a selection
            // UI would need to be shown
            PersonInfo personInfo = authorizedPeople[0];

            _personId = personInfo.PersonId;
            _recordId = personInfo.SelectedRecord.Id;
            _isProvisioned = true;

            SaveUserSettings();

            MessageBox.Show("Application + " + _applicationId + " is now provisioned");
        }

        /// <summary>
        /// Finds the instance of the HealthVault web-service
        /// where the child application has been provisioned.
        /// </summary>
        private HealthServiceInstance FindProvisionedServiceInstance()
        {
            foreach (var instance in ServiceInfo.Current.ServiceInstances.Values)
            {
                var client = HealthClientApplication.Create(
                    _applicationId, _masterApplicationId, instance.ShellUrl, instance.HealthServiceUrl);

                ApplicationInfo appInfo = client.GetApplicationInfo();

                if (appInfo != null)
                {
                    return instance;
                }
            }

            return null;
        }

        public void DeProvision()
        {
            Guid tempPersonId = _personId;
            Guid tempRecordId = _recordId;

            // first reset local state so
            // that even if things fail after this
            // the next app launch will have fresh state
            _isProvisioned = false;
            _personId = Guid.Empty;
            _recordId = Guid.Empty;
            _applicationId = Guid.Empty;
            SaveUserSettings();

            // attempt to remove authorization of application from server
            HealthClientAuthorizedConnection connection =
                HealthClientApplication.CreateAuthorizedConnection(tempPersonId);

            HealthRecordAccessor accessor = new HealthRecordAccessor(connection, tempRecordId);
            accessor.RemoveApplicationAuthorization();

            // delete the local certificate
            _healthClientApplication.DeleteCertificate();

            _healthClientApplication = null;
        }

        /// <summary>
        /// Creates a connection to HealthVault and obtains weight data
        /// </summary>
        /// <returns></returns>
        public HealthRecordItemCollection GetWeightFromHealthVault()
        {
            if (!_isProvisioned)
            {
                MessageBox.Show("Please provision application first");
                return null;
            }

            HealthClientAuthorizedConnection connection =
                HealthClientApplication.CreateAuthorizedConnection(PersonId);

            HealthRecordAccessor accessor = new HealthRecordAccessor(connection, RecordId);

            HealthRecordSearcher searcher = accessor.CreateSearcher();
            HealthRecordFilter filter = new HealthRecordFilter(Weight.TypeId);
            searcher.Filters.Add(filter);
            HealthRecordItemCollection items = searcher.GetMatchingItems()[0];
            return items;
        }

        /// <summary>
        /// Creates a connection to HealthVault and sets weight data
        /// </summary>
        /// <param name="weightValue"></param>
        public void SetWeightOnHealthVault(double weightValue)
        {
            if (!_isProvisioned)
            {
                MessageBox.Show("Please provision application first");
                return;
            }

            HealthClientAuthorizedConnection connection =
                HealthClientApplication.CreateAuthorizedConnection(PersonId);

            HealthRecordAccessor accessor = new HealthRecordAccessor(connection, RecordId);
            Weight weight = new Weight();
            weight.Value = new WeightValue(weightValue);
            accessor.NewItem(weight);
        }

        #endregion

        #region Private methods

        private void SaveUserSettings()
        {
            Properties.Settings.Default.PersonId = _personId;
            Properties.Settings.Default.RecordGuid = _recordId;
            Properties.Settings.Default.IsProvisioned = _isProvisioned;
            Properties.Settings.Default.ApplicationId = _applicationId;
            Properties.Settings.Default.ServiceInstanceId = _serviceInstance.Id;
            Properties.Settings.Default.Save();
        }

        #endregion

        #region private vars

        private Guid _applicationId;
        private Guid _masterApplicationId;
        private Guid _personId;
        private Guid _recordId;
        private HealthServiceInstance _serviceInstance;
        private bool _isProvisioned;

        private HealthClientApplication _healthClientApplication;

        #endregion
    }
}