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
    public class MedicationsMainViewModel : ViewModel
    {
        private readonly IThingClient thingClient;
        private readonly Guid recordId;
        private ObservableCollection<MedicationsSummaryViewRow> currentMedications;
        private ObservableCollection<MedicationsSummaryViewRow> pastMedications;

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

        public MedicationsMainViewModel(
            IEnumerable<Medication> items, 
            IThingClient thingClient,
            Guid recordId,
            INavigationService navigationService) : base(navigationService)
        {
            this.thingClient = thingClient;
            this.recordId = recordId;

            this.ItemSelectedCommand = new Command<MedicationsSummaryViewRow>(async o => await this.GoToMedicationsSummaryPageAsync(o.Medication));

            this.UpdateDisplay(items);
        }

        public override async Task OnNavigateBackAsync()
        {
            IReadOnlyCollection<Medication> items = await this.thingClient.GetThingsAsync<Medication>(this.recordId);
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
                BindingContext = new MedicationsSummaryViewModel(medication, this.thingClient, this.recordId, this.NavigationService),
            };
            await this.NavigationService.NavigateAsync(medicationsMainPage);
        }
    }
}