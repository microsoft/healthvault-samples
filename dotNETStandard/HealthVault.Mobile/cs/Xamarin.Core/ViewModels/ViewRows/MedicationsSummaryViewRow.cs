using System;
using Microsoft.HealthVault.ItemTypes;

namespace HealthVault.Sample.Xamarin.Core.ViewModels.ViewRows
{
    public class MedicationsSummaryViewRow
    {
        public MedicationsSummaryViewRow(Medication medication)
        {
            this.Medication = medication;

            this.Text = medication.Name?.Text ?? "";
            this.Detail = DataTypeFormatter.FormatMedicationDetail(medication.Strength, medication.Dose);

            string note = medication.CommonData?.Note;
            if (note != null)
            {
                this.Note = note;
            }
            else
            {
                DateTimeOffset now = DateTimeOffset.Now;
                ApproximateDate today = new ApproximateDate(now.Year, now.Month, now.Day);

                ApproximateDate approximateDateStarted = medication.DateStarted.ApproximateDate;
                this.Note = string.Format(
                    StringResource.PrescribedDateFormat,
                    FormatApproximateDate(approximateDateStarted));

                ApproximateDate approximateDateEnded = medication.DateDiscontinued.ApproximateDate;
                if (approximateDateEnded < today)
                {
                    this.Note += ", " + String.Format(StringResource.ExpiredDateFormat, FormatApproximateDate(approximateDateStarted));
                }
            }
        }

        public Medication Medication { get; }

        public string Text { get; }
        public string Detail { get; }
        public string Note { get; }

        public override string ToString() => Text;

        private static string FormatApproximateDate(ApproximateDate date)
        {
            return date.Month + "/" + date.Day + "/" + date.Year;
        }
    }
}