using System;
using System.Collections.Generic;
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
    public class WeightViewModel : ViewModel
    {
        private readonly IHealthVaultConnection _connection;
        public const double KgToLbsFactor = 2.20462;

        public WeightViewModel(
            IHealthVaultConnection connection,
            INavigationService navigationService) : base(navigationService)
        {
            _connection = connection;
            AddCommand = new Command(async () => await GoToAddWeightPageAsync());

            LoadState = LoadState.Loading;
        }

        private void RefreshPage(IEnumerable<Weight> weights)
        {
            List<Weight> weightList = weights.ToList();
            WeightValue weightValue = weightList.FirstOrDefault()?.Value;
            if (weightValue != null)
            {
                double pounds = weightValue.Kilograms * KgToLbsFactor;
                LastWeightValue = pounds.ToString("N0");
                LastWeightUnit = "lbs";
            }
            else
            {
                LastWeightValue = string.Empty;
                LastWeightUnit = string.Empty;
            }

            HistoricWeightValues = weightList.Skip(1).Select(w => new WeightViewRow(w)).ToList();
        }

        public override async Task OnNavigateToAsync()
        {
            await LoadAsync(async () =>
            {
                await RefreshAsync();
                await base.OnNavigateToAsync();
            });
        }

        public override async Task OnNavigateBackAsync()
        {
            await LoadAsync(async () =>
            {
                await RefreshAsync();
                await base.OnNavigateBackAsync();
            });
        }

        private async Task RefreshAsync()
        {
            var person = await _connection.GetPersonInfoAsync();
            IThingClient thingClient = _connection.CreateThingClient();
            HealthRecordInfo record = person.SelectedRecord;
            IReadOnlyCollection<Weight> items = await thingClient.GetThingsAsync<Weight>(record.Id);
            RefreshPage(items);
        }

        private IEnumerable<WeightViewRow> _historicWeightValues;

        public IEnumerable<WeightViewRow> HistoricWeightValues
        {
            get { return _historicWeightValues; }

            set
            {
                _historicWeightValues = value;
                OnPropertyChanged();
            }
        }

        public ICommand AddCommand { get; }

        private string _lastWeightValue;

        public string LastWeightValue
        {
            get { return _lastWeightValue; }

            set
            {
                _lastWeightValue = value;
                OnPropertyChanged();
            }
        }

        private string _lastWeightUnit;

        public string LastWeightUnit
        {
            get { return _lastWeightUnit; }

            set
            {
                _lastWeightUnit = value;
                OnPropertyChanged();
            }
        }

        private async Task GoToAddWeightPageAsync()
        {
            var viewModel = new WeightAddViewModel(_connection, NavigationService);

            var medicationsMainPage = new WeightAddPage
            {
                BindingContext = viewModel,
            };

            await NavigationService.NavigateAsync(medicationsMainPage);
        }
    }
}
