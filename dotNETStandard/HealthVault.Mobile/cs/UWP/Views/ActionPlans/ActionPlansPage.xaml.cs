using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using HealthVaultMobileSample.UWP.Helpers;
using Microsoft.HealthVault.Connection;
using Microsoft.HealthVault.RestApi;
using Microsoft.HealthVault.RestApi.Generated;
using Microsoft.HealthVault.RestApi.Generated.Models;
using Windows.UI.Popups;
using Windows.UI.Xaml.Controls;

// The Blank Page item template is documented at https://go.microsoft.com/fwlink/?LinkId=234238

namespace HealthVaultMobileSample.UWP.Views.ActionPlans
{
    /// <summary>
    /// An empty page that can be used on its own or navigated to within a Frame.
    /// </summary>
    public sealed partial class ActionPlansPage : HealthVaultBasePage
    {
        public IEnumerable<ActionPlanInstanceV2> Plans { get; set; }
        private IHealthVaultConnection _connection;

        public ActionPlansPage()
        {
            InitializeComponent();
        }

        public override async Task Initialize(NavigationParams navParams)
        {
            _connection = navParams.Connection;

            Guid recordId = (await _connection.GetPersonInfoAsync()).SelectedRecord.Id;
            var restClient = _connection.CreateMicrosoftHealthVaultRestApi(recordId);

            try
            {
                var response = await restClient.ActionPlans.GetAsync();

                //Filter to only recommended or InProgress plans
                Plans = from p in response.Plans
                             where p.Status == "Recommended" || p.Status == "InProgress"
                             select p;

                OnPropertyChanged("Plans");
            }
            catch (Microsoft.Rest.RestException e)
            {
                MessageDialog md = new MessageDialog(e.Message);
                await md.ShowAsync();
            }
        }

        private void ListView_ItemClick(object sender, ItemClickEventArgs e)
        {
            Frame.Navigate(typeof(ActionPlanDetailsPage), new NavigationParams() { Connection = _connection, Context = e.ClickedItem });
        }
    }
}
