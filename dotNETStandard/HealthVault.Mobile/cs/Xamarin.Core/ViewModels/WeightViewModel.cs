using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Threading.Tasks;
using System.Windows.Input;
using HealthVault.Sample.Xamarin.Core.Services;
using HealthVault.Sample.Xamarin.Core.ViewModels.ViewRows;
using HealthVault.Sample.Xamarin.Core.Views;
using Microsoft.HealthVault.Clients;
using Microsoft.HealthVault.ItemTypes;
using Xamarin.Forms;

namespace HealthVault.Sample.Xamarin.Core.ViewModels
{
    public class WeightViewModel: ViewModel
    {
        public const double KgToLbsFactor = 2.20462;

        private readonly IThingClient thingClient;
        private readonly Guid recordId;

        public WeightViewModel(
            IEnumerable<Weight> weights,
            IThingClient thingClient,
            Guid recordId,
            INavigationService navigationService) : base(navigationService)
        {
            this.thingClient = thingClient;
            this.recordId = recordId;
            this.AddCommand = new Command(async () => await this.GoToAddWeightPageAsync(thingClient, recordId));

            this.RefreshPage(weights);
        }

        private void RefreshPage(IEnumerable<Weight> weights)
        {
            List<Weight> weightList = weights.ToList();
            WeightValue weightValue = weightList.FirstOrDefault()?.Value;
            if (weightValue != null)
            {
                double pounds = weightValue.Kilograms * KgToLbsFactor;
                this.LastWeightValue = pounds.ToString("N0");
                this.LastWeightUnit = "lbs";
            }
            else
            {
                this.LastWeightValue = string.Empty;
                this.LastWeightUnit = string.Empty;
            }

            this.HistoricWeightValues = weightList.Skip(1).Select(w => new WeightViewRow(w)).ToList();
        }

        public override async Task OnNavigateBackAsync()
        {
            this.IsBusy = true;

            try
            {
                IReadOnlyCollection<Weight> items = await this.thingClient.GetThingsAsync<Weight>(this.recordId);
                this.RefreshPage(items);

                await base.OnNavigateBackAsync();
            }
            finally
            {
                this.IsBusy = false;
            }
        }

        private IEnumerable<WeightViewRow> historicWeightValues;

        public IEnumerable<WeightViewRow> HistoricWeightValues
        {
            get { return this.historicWeightValues; }

            set
            {
                this.historicWeightValues = value;
                this.OnPropertyChanged();
            }
        }

        public ICommand AddCommand { get; }

        private string lastWeightValue;

        public string LastWeightValue
        {
            get { return this.lastWeightValue; }

            set
            {
                this.lastWeightValue = value;
                this.OnPropertyChanged();
            }
        }

        private string lastWeightUnit;

        public string LastWeightUnit
        {
            get { return this.lastWeightUnit; }

            set
            {
                this.lastWeightUnit = value;
                this.OnPropertyChanged();
            }
        }

        private async Task GoToAddWeightPageAsync(IThingClient thingClient, Guid recordId)
        {
            var viewModel = new WeightAddViewModel(thingClient, recordId, this.NavigationService);

            var medicationsMainPage = new WeightAddPage
            {
                BindingContext = viewModel,
            };

            await this.NavigationService.NavigateAsync(medicationsMainPage);
        }
    }
}
