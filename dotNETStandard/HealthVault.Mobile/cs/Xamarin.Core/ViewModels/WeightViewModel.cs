using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Threading.Tasks;
using System.Windows.Input;
using HealthVault.Sample.Xamarin.Core.Models;
using HealthVault.Sample.Xamarin.Core.Services;
using HealthVault.Sample.Xamarin.Core.ViewModels.ViewRows;
using HealthVault.Sample.Xamarin.Core.Views;
using Microsoft.HealthVault.Clients;
using Microsoft.HealthVault.Connection;
using Microsoft.HealthVault.ItemTypes;
using Microsoft.HealthVault.Record;
using Xamarin.Forms;

namespace HealthVault.Sample.Xamarin.Core.ViewModels
{
    public class WeightViewModel: ViewModel
    {
        private readonly IHealthVaultConnection connection;
        public const double KgToLbsFactor = 2.20462;

        public WeightViewModel(
            IHealthVaultConnection connection,
            INavigationService navigationService) : base(navigationService)
        {
            this.connection = connection;
            this.AddCommand = new Command(async () => await this.GoToAddWeightPageAsync());

            this.LoadState = LoadState.Loading;
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

        public override async Task OnNavigateToAsync()
        {
            await this.LoadAsync(async () =>
            {
                await this.RefreshAsync();
                await base.OnNavigateToAsync();
            });
        }

        public override async Task OnNavigateBackAsync()
        {
            await this.LoadAsync(async () =>
            {
                await this.RefreshAsync();
                await base.OnNavigateBackAsync();
            });
        }

        private async Task RefreshAsync()
        {
            var person = await this.connection.GetPersonInfoAsync();
            IThingClient thingClient = this.connection.CreateThingClient();
            HealthRecordInfo record = person.SelectedRecord;
            IReadOnlyCollection<Weight> items = await thingClient.GetThingsAsync<Weight>(record.Id);
            this.RefreshPage(items);
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

        private async Task GoToAddWeightPageAsync()
        {
            var viewModel = new WeightAddViewModel(this.connection, this.NavigationService);

            var medicationsMainPage = new WeightAddPage
            {
                BindingContext = viewModel,
            };

            await this.NavigationService.NavigateAsync(medicationsMainPage);
        }
    }
}
