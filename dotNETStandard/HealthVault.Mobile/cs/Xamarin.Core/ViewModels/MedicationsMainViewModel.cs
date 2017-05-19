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
using Microsoft.HealthVault.Vocabulary;
using Xamarin.Forms;

namespace HealthVault.Sample.Xamarin.Core.ViewModels
{
    public class MedicationsMainViewModel : ViewModel
    {
        private readonly IHealthVaultConnection connection;

        private ObservableCollection<MedicationsSummaryViewRow> currentMedications;
        private ObservableCollection<MedicationsSummaryViewRow> pastMedications;

        public MedicationsMainViewModel(
            IHealthVaultConnection connection,
            INavigationService navigationService) : base(navigationService)
        {
            this.connection = connection;

            this.ItemSelectedCommand = new Command<MedicationsSummaryViewRow>(async o => await this.GoToMedicationsSummaryPageAsync(o.Medication));

            this.LoadState = LoadState.Loading;
        }

        public override async Task OnNavigateToAsync()
        {
            await this.LoadAsync(async () =>
            {
                var person = await this.connection.GetPersonInfoAsync();
                IThingClient thingClient = this.connection.CreateThingClient();
                HealthRecordInfo record = person.SelectedRecord;
                IReadOnlyCollection<Medication> items = await thingClient.GetThingsAsync<Medication>(record.Id);
                this.UpdateDisplay(items);

                await base.OnNavigateToAsync();
            });
        }

        public ObservableCollection<MedicationsSummaryViewRow> CurrentMedications
        {
            get { return this.currentMedications; }

            private set
            {
                this.currentMedications = value;
                this.OnPropertyChanged();
            }
        }

        public ObservableCollection<MedicationsSummaryViewRow> PastMedications
        {
            get { return this.pastMedications; }

            private set
            {
                this.pastMedications = value;
                this.OnPropertyChanged();
            }
        }

        public ICommand ItemSelectedCommand { get; }

        public override async Task OnNavigateBackAsync()
        {
            var person = await this.connection.GetPersonInfoAsync();
            IThingClient thingClient = this.connection.CreateThingClient();
            HealthRecordInfo record = person.SelectedRecord;
            IReadOnlyCollection<Medication> items = await thingClient.GetThingsAsync<Medication>(record.Id);
            this.UpdateDisplay(items);
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

            this.CurrentMedications = current;
            this.PastMedications = past;
        }

        private async Task GoToMedicationsSummaryPageAsync(Medication medication)
        {
            var medicationsMainPage = new MedicationsSummaryPage()
            {
                BindingContext = new MedicationsSummaryViewModel(medication, this.connection, this.NavigationService),
            };
            await this.NavigationService.NavigateAsync(medicationsMainPage);
        }
    }
}