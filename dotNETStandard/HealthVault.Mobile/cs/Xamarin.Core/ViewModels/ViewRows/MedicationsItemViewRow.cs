namespace HealthVault.Sample.Xamarin.Core.ViewModels.ViewRows
{
    public class MedicationsItemViewRow
    {
        public string Text { get; set; }
        public string Detail { get; set; }
        public string Note { get; set; }
        public string DisclosureImagePath { get; set; }

        public override string ToString() => Text;
    }
}