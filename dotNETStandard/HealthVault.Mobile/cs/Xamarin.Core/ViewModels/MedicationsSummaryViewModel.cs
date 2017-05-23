using System;
using System.Collections.ObjectModel;
using System.Threading.Tasks;
using System.Windows.Input;
using HealthVault.Sample.Xamarin.Core.Services;
using HealthVault.Sample.Xamarin.Core.Views;
using Microsoft.HealthVault.Clients;
using Microsoft.HealthVault.Connection;
using Microsoft.HealthVault.ItemTypes;
using Microsoft.HealthVault.Person;
using Xamarin.Forms;

namespace HealthVault.Sample.Xamarin.Core.ViewModels
{
    public class MedicationsSummaryViewModel : ViewModel
    {
        private readonly IHealthVaultConnection _connection;

        private Medication _medication;
        private ObservableCollection<MedicationItemViewRow> _items;

        public ObservableCollection<MedicationItemViewRow> Items
        {
            get { return _items; }

            private set
            {
                _items = value;
                OnPropertyChanged();
            }
        }

        public ICommand EditCommand { get; }

        public MedicationsSummaryViewModel(
            Medication medication,
            IHealthVaultConnection connection,
            INavigationService navigationService) : base(navigationService)
        {
            _connection = connection;
            _medication = medication;
            EditCommand = new Command(async () => await GoToEditAsync());

            UpdateDisplay();
        }

        public override async Task OnNavigateBackAsync()
        {
            await LoadAsync(async () =>
            {
                IThingClient thingClient = _connection.CreateThingClient();
                PersonInfo personInfo = await _connection.GetPersonInfoAsync();

                _medication = await thingClient.GetThingAsync<Medication>(personInfo.SelectedRecord.Id, _medication.Key.Id);

                UpdateDisplay();
                await base.OnNavigateBackAsync();
            });
        }

        private void UpdateDisplay()
        {
            Items = new ObservableCollection<MedicationItemViewRow>
            {
                new MedicationItemViewRow
                {
                    Title = StringResource.Name,
                    Value = _medication.Name?.Text ?? ""
                },
                new MedicationItemViewRow
                {
                    Title = StringResource.Strength,
                    Value = _medication.Strength?.Display ?? ""
                },
                new MedicationItemViewRow()
                {
                    Title = StringResource.Dosage,
                    Value = _medication.Dose?.Display ?? ""
                },
                new MedicationItemViewRow()
                {
                    Title = StringResource.HowOftenTaken,
                    Value = _medication.Frequency?.Display ?? ""
                },
                new MedicationItemViewRow()
                {
                    Title = StringResource.HowTaken,
                    Value = _medication.Route?.Text ?? ""
                },
                new MedicationItemViewRow()
                {
                    Title = StringResource.ReasonForTaking,
                    Value = _medication.Indication?.Text ?? ""
                },
                new MedicationItemViewRow()
                {
                    Title = StringResource.DateStarted,
                    Value = DataTypeFormatter.ApproximateDateTimeToString(_medication.DateStarted)
                },
            };
        }

        private async Task GoToEditAsync()
        {
            var viewModel = new MedicationEditViewModel(_medication, _connection, NavigationService);

            var medicationsMainPage = new MedicationEditPage
            {
                BindingContext = viewModel,
            };
            await NavigationService.NavigateAsync(medicationsMainPage);
        }
    }

    public class MedicationItemViewRow
    {
        public string Title { get; set; }
        public string Value { get; set; }
    }
}