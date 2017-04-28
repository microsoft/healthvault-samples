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
                RaisePropertyChanged(() => CurrentMedications);
            }
        }

        public ObservableCollection<MedicationsSummaryViewRow> PastMedications
        {
            get => pastMedications;
            private set
            {
                pastMedications = value;
                RaisePropertyChanged(() => PastMedications);
            }
        }

        public ICommand ItemSelectedCommand { get; }

        public MedicationsMainViewModel(
            IEnumerable<Medication> items, 
            IThingClient thingClient,
            Guid recordId,
            INavigationService navigationService, 
            IPlatformResourceProvider resourceProvider) : base(navigationService, resourceProvider)
        {
            this.thingClient = thingClient;
            this.recordId = recordId;

            ItemSelectedCommand = new Command<MedicationsSummaryViewRow>(async o => await GoToMedicationsSummaryPageAsync(o.Medication));

            UpdateDisplay(items);
        }

        public override async Task OnNavigateBack()
        {
            IReadOnlyCollection<Medication> items = await thingClient.GetThingsAsync<Medication>(recordId);
            UpdateDisplay(items);
            await base.OnNavigateBack();
        }

        private void UpdateDisplay(IEnumerable<Medication> items)
        {
            CurrentMedications = new ObservableCollection<MedicationsSummaryViewRow>();
            PastMedications = new ObservableCollection<MedicationsSummaryViewRow>();

            foreach (Medication medication in items)
            {
                var summaryViewRow = new MedicationsSummaryViewRow(medication, ResourceProvider.DisclosureIcon);
                if (medication.DateDiscontinued == null)
                {
                    CurrentMedications.Add(summaryViewRow);
                }
                else
                {
                    PastMedications.Add(summaryViewRow);
                }
            }
        }

        private async Task GoToMedicationsSummaryPageAsync(Medication medication)
        {
            var medicationsMainPage = new MedicationsSummaryPage()
            {
                BindingContext = new MedicationsSummaryViewModel(medication, thingClient, recordId, NavigationService, ResourceProvider),
            };
            await NavigationService.NavigateAsync(medicationsMainPage);
        }
    }
}