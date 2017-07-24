using System;
using System.Linq;
using System.Threading.Tasks;
using System.Windows.Input;
using HealthVault.Sample.Xamarin.Core.Services;
using HealthVault.Sample.Xamarin.Core.Views;
using Microsoft.HealthVault.Client;
using Microsoft.HealthVault.RestApi.Generated.Models;
using Xamarin.Forms;

namespace HealthVault.Sample.Xamarin.Core.ViewModels
{
    public class ActionPlanDetailsViewModel : ViewModel
    {
        private readonly IHealthVaultSodaConnection _connection;

        public ActionPlanDetailsViewModel(ActionPlanInstanceV2 actionPlanInstance, IHealthVaultSodaConnection connection, INavigationService navigationService)
            : base(navigationService)
        {
            _connection = connection;
            ItemSelectedCommand = new Command<ActionPlanTaskInstanceV2>(async o => await HandleTaskSelectedAsync(o));

            Plan = actionPlanInstance;
        }

        public ICommand ItemSelectedCommand { get; }

        public ActionPlanInstanceV2 Plan { get; }

        private async Task HandleTaskSelectedAsync(ActionPlanTaskInstanceV2 task)
        {
            if (task.TrackingPolicy.IsAutoTrackable == true)
            {
                var xpath = task.TrackingPolicy.TargetEvents.FirstOrDefault().ElementXPath;
                if (xpath.Contains("thing/data-xml/weight"))
                {
                    var weightAddPage = new WeightAddPage
                    {
                        BindingContext = new WeightAddViewModel(_connection, NavigationService),
                    };
                    await NavigationService.NavigateAsync(weightAddPage);
                }
            }
        }
    }
}
