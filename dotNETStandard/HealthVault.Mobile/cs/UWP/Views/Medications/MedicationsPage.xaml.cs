using HealthVaultMobileSample.UWP.Helpers;
using Microsoft.HealthVault.Clients;
using Microsoft.HealthVault.Connection;
using Microsoft.HealthVault.ItemTypes;
using Microsoft.HealthVault.Record;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Runtime.InteropServices.WindowsRuntime;
using System.Threading.Tasks;
using Windows.ApplicationModel.Resources;
using Windows.Foundation;
using Windows.Foundation.Collections;
using Windows.UI.Xaml;
using Windows.UI.Xaml.Controls;
using Windows.UI.Xaml.Controls.Primitives;
using Windows.UI.Xaml.Data;
using Windows.UI.Xaml.Input;
using Windows.UI.Xaml.Media;
using Windows.UI.Xaml.Navigation;

// The Blank Page item template is documented at https://go.microsoft.com/fwlink/?LinkId=234238

namespace HealthVaultMobileSample.UWP.Views.Medications
{
    /// <summary>
    /// An empty page that can be used on its own or navigated to within a Frame.
    /// </summary>
    public sealed partial class MedicationsPage : HealthVaultBasePage
    {
        private IHealthVaultConnection connection;
        public IEnumerable<IGrouping<string, Medication>> Groups { get; set; }

        public MedicationsPage()
        {
            this.InitializeComponent();
        }

        public override async Task Initialize(NavigationParams navParams)
        {
            this.connection = navParams.Connection;

            HealthRecordInfo recordInfo = (await connection.GetPersonInfoAsync()).SelectedRecord;
            IThingClient thingClient = connection.CreateThingClient();

            var items = await thingClient.GetThingsAsync<Medication>(recordInfo.Id);

            ResourceLoader loader = new ResourceLoader();

            // Use LINQ to group the medications into current and past groups based on the DateDiscontinued
            this.Groups = from item in items
                         group item by (item.DateDiscontinued == null ? loader.GetString("CurrentMedications") : loader.GetString("PastMedications")) into g
                         select g;

            OnPropertyChanged("Groups");

            return;
        }


        private void ListView_ItemClick(object sender, ItemClickEventArgs e)
        {
            NavigationParams navParams = new NavigationParams()
            {
                Connection = connection,
                Context = e.ClickedItem
            };

            this.Frame.Navigate(typeof(MedicationDetailsPage), navParams);
        }
    }
}
