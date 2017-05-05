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
            get => currentMedications;
            private set
            {
                currentMedications = value;
                this.OnPropertyChanged();
            }
        }

        public ObservableCollection<MedicationsSummaryViewRow> PastMedications
        {
            get => pastMedications;
            private set
            {
                pastMedications = value;
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

            ItemSelectedCommand = new Command<MedicationsSummaryViewRow>(async o => await GoToMedicationsSummaryPageAsync(o.Medication));

            UpdateDisplay(items);
        }

        public override async Task OnNavigateBackAsync()
        {
            IReadOnlyCollection<Medication> items = await thingClient.GetThingsAsync<Medication>(recordId);
            UpdateDisplay(items);
            await base.OnNavigateBackAsync();
        }

        private void UpdateDisplay(IEnumerable<Medication> items)
        {
            var current = new ObservableCollection<MedicationsSummaryViewRow>();
            var past = new ObservableCollection<MedicationsSummaryViewRow>();

            foreach (Medication medication in items)
            {
                var summaryViewRow = new MedicationsSummaryViewRow(medication);
                if (medication.DateDiscontinued == null)
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
                BindingContext = new MedicationsSummaryViewModel(medication, thingClient, recordId, NavigationService),
            };
            await NavigationService.NavigateAsync(medicationsMainPage);
        }
    }
}