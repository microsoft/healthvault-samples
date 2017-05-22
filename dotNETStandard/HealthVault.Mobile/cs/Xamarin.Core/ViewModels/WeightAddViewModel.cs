using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Input;
using HealthVault.Sample.Xamarin.Core.Services;
using Microsoft.HealthVault.Clients;
using Microsoft.HealthVault.Connection;
using Microsoft.HealthVault.ItemTypes;
using Microsoft.HealthVault.Record;
using Xamarin.Forms;

namespace HealthVault.Sample.Xamarin.Core.ViewModels
{
    public class WeightAddViewModel : ViewModel
    {
        private readonly IHealthVaultConnection connection;

        public WeightAddViewModel(
            IHealthVaultConnection connection,
            INavigationService navigationService) : base(navigationService)
        {
            this.connection = connection;
            this.AddCommand = new Command(async () => await this.AddWeightAsync());
        }

        private string weightValue;

        public string WeightValue
        {
            get { return this.weightValue; }

            set
            {
                this.weightValue = value;
                this.OnPropertyChanged();
            }
        }

        private int unitsPickerIndex;

        public int UnitsPickerIndex
        {
            get { return this.unitsPickerIndex; }

            set
            {
                this.unitsPickerIndex = value;
                this.OnPropertyChanged();
            }
        }

        public ICommand AddCommand { get; }

        private async Task AddWeightAsync()
        {
            try
            {
                bool isMetric = this.UnitsPickerIndex == 1;
                double weightNumber;
                if (!double.TryParse(this.WeightValue, out weightNumber))
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
                    new HealthServiceDateTime(DateTime.Now),
                    new WeightValue(kilograms, new DisplayValue(weightNumber, isMetric ? "kg" : "lbs"))));

                IThingClient thingClient = this.connection.CreateThingClient();
                var person = await this.connection.GetPersonInfoAsync();
                await thingClient.CreateNewThingsAsync<Weight>(person.SelectedRecord.Id, weightList);

                await this.NavigationService.NavigateBackAsync();
            }
            catch (Exception exception)
            {
                await this.DisplayAlertAsync(StringResource.ErrorDialogTitle, exception.ToString());
            }
        }
    }
}
