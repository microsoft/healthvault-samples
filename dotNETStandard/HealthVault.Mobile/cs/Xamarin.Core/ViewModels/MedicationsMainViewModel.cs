using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
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
    public class MedicationsMainViewModel : ViewModel
    {
        private readonly IHealthVaultConnection _connection;

        private ObservableCollection<MedicationsSummaryViewRow> _currentMedications;
        private ObservableCollection<MedicationsSummaryViewRow> _pastMedications;

        public MedicationsMainViewModel(
            IHealthVaultConnection connection,
            INavigationService navigationService) : base(navigationService)
        {
            _connection = connection;

            ItemSelectedCommand = new Command<MedicationsSummaryViewRow>(async o => await GoToMedicationsSummaryPageAsync(o.Medication));

            LoadState = LoadState.Loading;
        }

        public override async Task OnNavigateToAsync()
        {
            await LoadAsync(async () =>
            {
                var person = await _connection.GetPersonInfoAsync();
                IThingClient thingClient = _connection.CreateThingClient();
                HealthRecordInfo record = person.SelectedRecord;
                IReadOnlyCollection<Medication> items = await thingClient.GetThingsAsync<Medication>(record.Id);
                UpdateDisplay(items);

                await base.OnNavigateToAsync();
            });
        }

        public ObservableCollection<MedicationsSummaryViewRow> CurrentMedications
        {
            get { return _currentMedications; }

            private set
            {
                _currentMedications = value;
                OnPropertyChanged();
            }
        }

        public ObservableCollection<MedicationsSummaryViewRow> PastMedications
        {
            get { return _pastMedications; }

            private set
            {
                _pastMedications = value;
                OnPropertyChanged();
            }
        }

        public ICommand ItemSelectedCommand { get; }

        public override async Task OnNavigateBackAsync()
        {
            var person = await _connection.GetPersonInfoAsync();
            IThingClient thingClient = _connection.CreateThingClient();
            HealthRecordInfo record = person.SelectedRecord;
            IReadOnlyCollection<Medication> items = await thingClient.GetThingsAsync<Medication>(record.Id);
            UpdateDisplay(items);
            await base.OnNavigateBackAsync();
        }

        private void UpdateDisplay(IEnumerable<Medication> items)
        {
            var current = new ObservableCollection<MedicationsSummaryViewRow>();
            var past = new ObservableCollection<MedicationsSummaryViewRow>();

            foreach (Medication medication in items)
            {
                DateTimeOffset now = DateTimeOffset.Now;
                ApproximateDate today = new ApproximateDate(now.Year, now.Month, now.Day);

                var summaryViewRow = new MedicationsSummaryViewRow(medication);
                if (medication.DateDiscontinued == null || !(medication.DateDiscontinued.ApproximateDate < today))
                {
                    current.Add(summaryViewRow);
                }
                else
                {
                    past.Add(summaryViewRow);
                }
            }

            CurrentMedications = current;
            PastMedications = past;
        }

        private async Task GoToMedicationsSummaryPageAsync(Medication medication)
        {
            var medicationsMainPage = new MedicationsSummaryPage()
            {
                BindingContext = new MedicationsSummaryViewModel(medication, _connection, NavigationService),
            };
            await NavigationService.NavigateAsync(medicationsMainPage);
        }
    }
}