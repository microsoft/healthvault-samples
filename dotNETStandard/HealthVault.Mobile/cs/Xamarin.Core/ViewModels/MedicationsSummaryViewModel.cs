using System;
using System.Collections.ObjectModel;
using System.Threading.Tasks;
using System.Windows.Input;
using HealthVault.Sample.Xamarin.Core.Services;
using HealthVault.Sample.Xamarin.Core.Views;
using Microsoft.HealthVault.Clients;
using Microsoft.HealthVault.ItemTypes;
using Xamarin.Forms;

namespace HealthVault.Sample.Xamarin.Core.ViewModels
{
    public class MedicationsSummaryViewModel : ViewModel
    {
        private readonly IThingClient thingClient;
        private readonly Guid recordId;

        private Medication medication;

        private ObservableCollection<MedicationItemViewRow> items;

        public ObservableCollection<MedicationItemViewRow> Items
        {
            get { return this.items; }
                
            private set
            {
                this.items = value;
                this.OnPropertyChanged();
            }
        }

        public ICommand EditCommand { get; }

        public MedicationsSummaryViewModel(
            Medication medication,
            IThingClient thingClient,
            Guid recordId,
            INavigationService navigationService) : base(navigationService)
        {
            this.medication = medication;
            this.thingClient = thingClient;
            this.recordId = recordId;
            EditCommand = new Command(async () => await GoToEditAsync(thingClient, recordId));

            UpdateDisplay();
        }

        public override async Task OnNavigateBackAsync()
        {
            this.IsBusy = true;
            try
            {
                this.medication = await this.thingClient.GetThingAsync<Medication>(this.recordId, this.medication.Key.Id);

                this.UpdateDisplay();
                await base.OnNavigateBackAsync();
            }
            finally
            {
                this.IsBusy = false;
            }
        }

        private void UpdateDisplay()
        {
            Items = new ObservableCollection<MedicationItemViewRow>
            {
                new MedicationItemViewRow
                {
                    Title = StringResource.Name,
                    Value = medication.Name?.Text ?? ""
                },
                new MedicationItemViewRow
                {
                    Title = StringResource.Strength,
                    Value = medication.Strength?.Display ?? ""
                },
                new MedicationItemViewRow()
                {
                    Title = StringResource.Dosage,
                    Value = medication.Dose?.Display ?? ""
                },
                new MedicationItemViewRow()
                {
                    Title = StringResource.HowOftenTaken,
                    Value = medication.Frequency?.Display ?? ""
                },
                new MedicationItemViewRow()
                {
                    Title = StringResource.HowTaken,
                    Value = medication.Route?.Text ?? ""
                },
                new MedicationItemViewRow()
                {
                    Title = StringResource.ReasonForTaking,
                    Value = medication.Indication?.Text ?? ""
                },
                new MedicationItemViewRow()
                {
                    Title = StringResource.DateStarted,
                    Value = DataTypeFormatter.ApproximateDateTimeToString(medication.DateStarted)
                },
            };
        }

        private async Task GoToEditAsync(IThingClient thingClient, Guid recordId)
        {
            var viewModel = new MedicationEditViewModel(medication, thingClient, recordId, this.NavigationService);

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