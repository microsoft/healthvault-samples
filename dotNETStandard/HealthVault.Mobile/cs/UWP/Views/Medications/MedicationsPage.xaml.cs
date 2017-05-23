using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using HealthVaultMobileSample.UWP.Helpers;
using Microsoft.HealthVault.Clients;
using Microsoft.HealthVault.Connection;
using Microsoft.HealthVault.ItemTypes;
using Microsoft.HealthVault.Record;
using Windows.ApplicationModel.Resources;
using Windows.UI.Xaml.Controls;

// The Blank Page item template is documented at https://go.microsoft.com/fwlink/?LinkId=234238

namespace HealthVaultMobileSample.UWP.Views.Medications
{
    /// <summary>
    /// An empty page that can be used on its own or navigated to within a Frame.
    /// </summary>
    public sealed partial class MedicationsPage : HealthVaultBasePage
    {
        private IHealthVaultConnection _connection;
        public IEnumerable<IGrouping<string, Medication>> Groups { get; set; }

        public MedicationsPage()
        {
            InitializeComponent();
        }

        public override async Task Initialize(NavigationParams navParams)
        {
            _connection = navParams.Connection;

            HealthRecordInfo recordInfo = (await _connection.GetPersonInfoAsync()).SelectedRecord;
            IThingClient thingClient = _connection.CreateThingClient();

            var items = await thingClient.GetThingsAsync<Medication>(recordInfo.Id);

            ResourceLoader loader = new ResourceLoader();

            // Use LINQ to group the medications into current and past groups based on the DateDiscontinued
            Groups = from item in items
                          group item by (item.DateDiscontinued == null ? loader.GetString("CurrentMedications") : loader.GetString("PastMedications")) into g
                          select g;

            OnPropertyChanged("Groups");

            return;
        }

        private void ListView_ItemClick(object sender, ItemClickEventArgs e)
        {
            NavigationParams navParams = new NavigationParams()
            {
                Connection = _connection,
                Context = e.ClickedItem
            };

            Frame.Navigate(typeof(MedicationDetailsPage), navParams);
        }
    }
}
