using Microsoft.HealthVault.ItemTypes;

namespace HealthVault.Sample.Xamarin.Core.ViewModels.ViewRows
{
    public class MedicationsSummaryViewRow
    {
        public MedicationsSummaryViewRow(Medication medication)
        {
            Medication = medication;

            Text = medication.Name?.Text ?? "";
            Detail = DataTypeFormatter.FormatMedicationDetail(medication.Strength, medication.Dose);
            Note = medication.CommonData?.Note ?? "";
        }

        public Medication Medication { get; }

        public string Text { get; }
        public string Detail { get; }
        public string Note { get; }

        public override string ToString() => Text;
    }
}