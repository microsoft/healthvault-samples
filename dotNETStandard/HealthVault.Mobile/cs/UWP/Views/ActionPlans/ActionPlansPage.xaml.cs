using HealthVaultMobileSample.UWP.Views;
using Microsoft.HealthVault.Connection;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Runtime.InteropServices.WindowsRuntime;
using System.Threading.Tasks;
using Windows.Foundation;
using Windows.Foundation.Collections;
using Windows.UI.Xaml;
using Windows.UI.Xaml.Controls;
using Windows.UI.Xaml.Controls.Primitives;
using Windows.UI.Xaml.Data;
using Windows.UI.Xaml.Input;
using Windows.UI.Xaml.Media;
using Windows.UI.Xaml.Navigation;
using Microsoft.HealthVault.RestApi;
using Windows.Data.Xml.Dom;
using Microsoft.HealthVault.RestApi.Generated.Models;
using Microsoft.HealthVault.RestApi.Generated;
using Windows.UI.Popups;
using HealthVaultMobileSample.UWP.Helpers;
using Microsoft.HealthVault.ItemTypes;
using System.Net.Http;
using Microsoft.HealthVault.Thing;

// The Blank Page item template is documented at https://go.microsoft.com/fwlink/?LinkId=234238

namespace HealthVaultMobileSample.UWP.Views.ActionPlans
{
    /// <summary>
    /// An empty page that can be used on its own or navigated to within a Frame.
    /// </summary>
    public sealed partial class ActionPlansPage : HealthVaultBasePage
    {
        public IEnumerable<ActionPlanInstance> Plans { get; set; }
        private IHealthVaultConnection connection;


        public ActionPlansPage()
        {
            this.InitializeComponent();
        }

        public override async Task Initialize(NavigationParams navParams)
        {
            this.connection = navParams.Connection;

            Guid recordId = (await this.connection.GetPersonInfoAsync()).SelectedRecord.Id;
            var restClient = this.connection.CreateMicrosoftHealthVaultRestApi(recordId);

            try
            {
                var response = await restClient.GetActionPlansAsync();

                //Filter to only recommended or InProgress plans
                this.Plans = from p in response.Plans
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
            this.Frame.Navigate(typeof(ActionPlanDetailsPage), new NavigationParams() { Connection = this.connection, Context = e.ClickedItem });
        }
    }
}
