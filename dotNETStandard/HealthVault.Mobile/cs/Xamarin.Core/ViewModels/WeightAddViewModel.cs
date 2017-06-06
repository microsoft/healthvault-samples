using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using System.Windows.Input;
using HealthVault.Sample.Xamarin.Core.Services;
using Microsoft.HealthVault.Clients;
using Microsoft.HealthVault.Connection;
using Microsoft.HealthVault.ItemTypes;
using NodaTime;
using Xamarin.Forms;

namespace HealthVault.Sample.Xamarin.Core.ViewModels
{
    public class WeightAddViewModel : ViewModel
    {
        private readonly IHealthVaultConnection _connection;

        public WeightAddViewModel(
            IHealthVaultConnection connection,
            INavigationService navigationService) : base(navigationService)
        {
            _connection = connection;
            AddCommand = new Command(async () => await AddWeightAsync());
        }

        private string _weightValue;

        public string WeightValue
        {
            get { return _weightValue; }

            set
            {
                _weightValue = value;
                OnPropertyChanged();
            }
        }

        private int _unitsPickerIndex;

        public int UnitsPickerIndex
        {
            get { return _unitsPickerIndex; }

            set
            {
                _unitsPickerIndex = value;
                OnPropertyChanged();
            }
        }

        public ICommand AddCommand { get; }

        private async Task AddWeightAsync()
        {
            try
            {
                bool isMetric = UnitsPickerIndex == 1;
                double weightNumber;
                if (!double.TryParse(WeightValue, out weightNumber))
                {
                    return;
                }

                double kilograms;
                if (isMetric)
                {
                    kilograms = weightNumber;
                }
                else
                {
                    kilograms = weightNumber / WeightViewModel.KgToLbsFactor;
                }

                List<Weight> weightList = new List<Weight>();
                weightList.Add(new Weight(
                    new HealthServiceDateTime(SystemClock.Instance.GetCurrentInstant().InZone(DateTimeZoneProviders.Tzdb.GetSystemDefault()).LocalDateTime),
                    new WeightValue(kilograms, new DisplayValue(weightNumber, isMetric ? "kg" : "lbs"))));

                IThingClient thingClient = _connection.CreateThingClient();
                var person = await _connection.GetPersonInfoAsync();
                await thingClient.CreateNewThingsAsync<Weight>(person.SelectedRecord.Id, weightList);

                await NavigationService.NavigateBackAsync();
            }
            catch (Exception exception)
            {
                await DisplayAlertAsync(StringResource.ErrorDialogTitle, exception.ToString());
            }
        }
    }
}
