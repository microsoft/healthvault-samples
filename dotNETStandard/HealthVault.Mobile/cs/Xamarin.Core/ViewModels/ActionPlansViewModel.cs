using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Windows.Input;
using HealthVault.Sample.Xamarin.Core.Services;
using HealthVault.Sample.Xamarin.Core.Views;
using Microsoft.HealthVault.Client;
using Microsoft.HealthVault.Person;
using Microsoft.HealthVault.RestApi;
using Microsoft.HealthVault.RestApi.Generated;
using Microsoft.HealthVault.RestApi.Generated.Models;
using Xamarin.Forms;

namespace HealthVault.Sample.Xamarin.Core.ViewModels
{
    public class ActionPlansViewModel : ViewModel
    {
        private readonly IHealthVaultSodaConnection _connection;

        public ActionPlansViewModel(
            IHealthVaultSodaConnection connection,
            INavigationService navigationService)
            : base(navigationService)
        {
            _connection = connection;

            ItemSelectedCommand = new Command<ActionPlanInstanceV2>(async o => await GoToActionPlanDetailsPageAsync(o));
        }

        private IEnumerable<ActionPlanInstanceV2> _plans;

        public IEnumerable<ActionPlanInstanceV2> Plans
        {
            get { return _plans; }

            set
            {
                _plans = value;
                OnPropertyChanged();
            }
        }

        public ICommand ItemSelectedCommand { get; }

        public override async Task OnNavigateToAsync()
        {
            await LoadAsync(async () =>
            {
                PersonInfo personInfo = await _connection.GetPersonInfoAsync();

                IMicrosoftHealthVaultRestApi restApi = _connection.CreateMicrosoftHealthVaultRestApi(personInfo.SelectedRecord.Id);
                var response = await restApi.ActionPlans.GetAsync();

                Plans = response.Plans.Where(p => p.Status == "Recommended" || p.Status == "InProgress");

                await base.OnNavigateToAsync();
            });
        }

        private async Task GoToActionPlanDetailsPageAsync(ActionPlanInstanceV2 actionPlan)
        {
            var actionPlanDetailsPage = new ActionPlanDetailsPage
            {
                BindingContext = new ActionPlanDetailsViewModel(actionPlan, _connection, NavigationService),
            };
            await NavigationService.NavigateAsync(actionPlanDetailsPage);
        }
    }
}
