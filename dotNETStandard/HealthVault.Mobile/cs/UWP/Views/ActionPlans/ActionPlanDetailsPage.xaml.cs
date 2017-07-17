using HealthVaultMobileSample.UWP.Helpers;
using System;
using Windows.UI.Xaml.Controls;
using Microsoft.HealthVault.Connection;
using Microsoft.HealthVault.RestApi.Generated.Models;
using System.Threading.Tasks;
using System.Linq;

// The Blank Page item template is documented at https://go.microsoft.com/fwlink/?LinkId=234238

namespace HealthVaultMobileSample.UWP.Views.ActionPlans
{
    /// <summary>
    /// An empty page that can be used on its own or navigated to within a Frame.
    /// </summary>
    public sealed partial class ActionPlanDetailsPage : HealthVaultBasePage
    {
        private IHealthVaultConnection _connection;
        public ActionPlanInstanceV2 Context { get; set; }

        public ActionPlanDetailsPage()
        {
            InitializeComponent();
        }

        public override async Task Initialize(NavigationParams navParams)
        {
            _connection = navParams.Connection as IHealthVaultConnection;
            Context = navParams.Context as ActionPlanInstanceV2;

            OnPropertyChanged("Context");
        }

        private void ListView_ItemClick(object sender, ItemClickEventArgs e)
        {
            var task = e.ClickedItem as ActionPlanTaskInstanceV2;
            if (task.TrackingPolicy.IsAutoTrackable == true)
            {
                var xpath = task.TrackingPolicy.TargetEvents.FirstOrDefault().ElementXPath;
                if (xpath.Contains("thing/data-xml/weight"))
                {
                    Frame.Navigate(typeof(Views.Weights.WeightPage),
                        new NavigationParams()
                        {
                            Connection = _connection
                        });
                }
            }
        }
    }
}
