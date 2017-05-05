using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HealthVault.Sample.Xamarin.Core.Services;
using Microsoft.HealthVault.Client;
using Microsoft.HealthVault.Clients;
using Microsoft.HealthVault.Person;
using Microsoft.HealthVault.RestApi;
using Microsoft.HealthVault.RestApi.Generated;
using Microsoft.HealthVault.RestApi.Generated.Models;

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

        public override async Task OnNavigateToAsync()
        {
            this.IsBusy = true;

            try
            {
                PersonInfo personInfo = await this.connection.GetPersonInfoAsync();

                IMicrosoftHealthVaultRestApi restApi = this.connection.CreateMicrosoftHealthVaultRestApi(personInfo.SelectedRecord.Id);
                var response = await restApi.GetActionPlansAsync();

                this.Plans = response.Plans.Where(p => p.Status == "Recommended" || p.Status == "InProgress");

                await base.OnNavigateToAsync();
            }
            finally
            {
                this.IsBusy = false;
            }
        }
    }
}
