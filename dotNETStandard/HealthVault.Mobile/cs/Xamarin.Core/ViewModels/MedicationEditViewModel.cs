using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Threading.Tasks;
using System.Windows.Input;
using HealthVault.Sample.Xamarin.Core.Services;
using Microsoft.HealthVault.Clients;
using Microsoft.HealthVault.ItemTypes;
using Microsoft.HealthVault.Vocabulary;
using Xamarin.Forms;

namespace HealthVault.Sample.Xamarin.Core.ViewModels
{
    public class MedicationEditViewModel : ViewModel
    {
        public MedicationEditViewModel(
            Medication medication,
            IList<VocabularyItem> ingredientChoices,
            IThingClient thingClient,
            Guid recordId, 
            INavigationService navigationService)
            : base(navigationService)
        {
            DosageType = medication.Dose?.Display ?? "";
            Strength = medication.Strength?.Display ?? "";
            ReasonForTaking = medication.Indication?.Text ?? "";
            DateStarted = DataTypeFormatter.ApproximateDateTimeToDateTime(medication.DateStarted);
            SaveCommand = new Command(async () => await SaveAsync(medication, thingClient, recordId));

            this.IngredientChoices = ingredientChoices;

            if (medication.Name.Count > 0)
            {
                Name = this.IngredientChoices.FirstOrDefault(c => c.Value == medication.Name[0]?.Value);
            }
        }

        public IList<VocabularyItem> IngredientChoices { get; }

        private VocabularyItem name;
        public VocabularyItem Name
        {
            get { return this.name; }

            set
            {
                this.name = value;
                this.OnPropertyChanged();
            }
        }

        public string DosageType { get; set; }
        public string Strength { get; set; }
        public string TreatmentProvider { get; set; }
        public string ReasonForTaking { get; set; }
        public DateTime DateStarted { get; set; }

        public ICommand SaveCommand { get; }

        private async Task SaveAsync(Medication medication, IThingClient thingClient, Guid recordId)
        {
            UpdateMedication(medication);
            await thingClient.UpdateThingsAsync(recordId, new Collection<Medication>() { medication });

            await NavigationService.NavigateBackAsync();
        }

        private void UpdateMedication(Medication medication)
        {
            if (this.Name != null)
            {
                medication.Name = new CodableValue(this.Name.DisplayText, this.Name);
            }
            bool empty = string.IsNullOrWhiteSpace(DosageType) && medication.Dose == null;
            if (!empty)
            {
                medication.Dose = new GeneralMeasurement(DosageType);
            }

            empty = string.IsNullOrWhiteSpace(Strength) && medication.Strength == null;
            if (!empty)
            {
                medication.Strength = new GeneralMeasurement(Strength);
            }

            empty = string.IsNullOrWhiteSpace(ReasonForTaking) && medication.Indication == null;
            if (!empty)
            {
                medication.Indication = new CodableValue(ReasonForTaking);
            }

            var inputDateEmpty = DateStarted == DataTypeFormatter.EmptyDate;
            empty = inputDateEmpty && medication.DateStarted == null;
            if (!empty)
            {
                medication.DateStarted = new ApproximateDateTime(DateStarted);
            }
        }
    }
}