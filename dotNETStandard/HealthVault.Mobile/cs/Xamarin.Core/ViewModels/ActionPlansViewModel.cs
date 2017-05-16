using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Input;
using HealthVault.Sample.Xamarin.Core.Models;
using HealthVault.Sample.Xamarin.Core.Services;
using HealthVault.Sample.Xamarin.Core.Views;
using Microsoft.HealthVault.Client;
using Microsoft.HealthVault.Clients;
using Microsoft.HealthVault.Person;
using Microsoft.HealthVault.RestApi;
using Microsoft.HealthVault.RestApi.Generated;
using Microsoft.HealthVault.RestApi.Generated.Models;
using Xamarin.Forms;

namespace HealthVault.Sample.Xamarin.Core.ViewModels
{
    public class ActionPlansViewModel : ViewModel
    {
        private readonly IHealthVaultSodaConnection connection;

        public ActionPlansViewModel(
            IHealthVaultSodaConnection connection,
            INavigationService navigationService) 
            : base(navigationService)
        {
            this.connection = connection;

            this.ItemSelectedCommand = new Command<ActionPlanInstance>(async o => await this.GoToActionPlanDetailsPageAsync(o));
        }

        private IEnumerable<ActionPlanInstance> plans;

        public IEnumerable<ActionPlanInstance> Plans
        {
            get { return this.plans; }

            set
            {
                this.plans = value;
                this.OnPropertyChanged();
            }
        }

        public ICommand ItemSelectedCommand { get; }

        public override async Task OnNavigateToAsync()
        {
            await this.LoadAsync(async () =>
            {
                PersonInfo personInfo = await this.connection.GetPersonInfoAsync();

                IMicrosoftHealthVaultRestApi restApi = this.connection.CreateMicrosoftHealthVaultRestApi(personInfo.SelectedRecord.Id);
                var response = await restApi.GetActionPlansAsync();

                this.Plans = response.Plans.Where(p => p.Status == "Recommended" || p.Status == "InProgress");

                await base.OnNavigateToAsync();
            });
        }

        private async Task GoToActionPlanDetailsPageAsync(ActionPlanInstance actionPlan)
        {
            var actionPlanDetailsPage = new ActionPlanDetailsPage
            {
                BindingContext = new ActionPlanDetailsViewModel(actionPlan, this.connection, this.NavigationService),
            };
            await this.NavigationService.NavigateAsync(actionPlanDetailsPage);
        }
    }
}
