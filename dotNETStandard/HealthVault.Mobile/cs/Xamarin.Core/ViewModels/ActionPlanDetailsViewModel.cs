using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Input;
using HealthVault.Sample.Xamarin.Core.Services;
using HealthVault.Sample.Xamarin.Core.ViewModels.ViewRows;
using HealthVault.Sample.Xamarin.Core.Views;
using Microsoft.HealthVault.Client;
using Microsoft.HealthVault.Person;
using Microsoft.HealthVault.RestApi.Generated.Models;
using Xamarin.Forms;

namespace HealthVault.Sample.Xamarin.Core.ViewModels
{
    public class ActionPlanDetailsViewModel : ViewModel
    {
        private readonly IHealthVaultSodaConnection connection;

        public ActionPlanDetailsViewModel(ActionPlanInstance actionPlanInstance, IHealthVaultSodaConnection connection, INavigationService navigationService)
            : base(navigationService)
        {
            this.connection = connection;
            this.ItemSelectedCommand = new Command<ActionPlanTaskInstance>(async o => await this.HandleTaskSelectedAsync(o));

            this.Plan = actionPlanInstance;
        }

        public ICommand ItemSelectedCommand { get; }

        public ActionPlanInstance Plan { get; }

        private async Task HandleTaskSelectedAsync(ActionPlanTaskInstance task)
        {
            if (task.TrackingPolicy.IsAutoTrackable == true)
            {
                var xpath = task.TrackingPolicy.TargetEvents.FirstOrDefault().ElementXPath;
                if (xpath.Contains("thing/data-xml/weight"))
                {
                    var weightAddPage = new WeightAddPage
                    {
                        BindingContext = new WeightAddViewModel(this.connection, this.NavigationService),
                    };
                    await this.NavigationService.NavigateAsync(weightAddPage);
                }
            }
        }
    }
}
