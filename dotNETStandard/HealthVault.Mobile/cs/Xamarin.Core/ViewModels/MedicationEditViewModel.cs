using System.Threading.Tasks;
using System.Windows.Input;
using HealthVault.Sample.Xamarin.Core.Services;
using Xamarin.Forms;

namespace HealthVault.Sample.Xamarin.Core.ViewModels
{
    public class MedicationEditViewModel : ViewModel
    {
        public string Name { get; set; }
        public string DosageType { get; set; }
        public string Strength { get; set; }
        public string TreatmentProvider { get; set; }
        public string ReasonForTaking { get; set; }
        public string DateStarted { get; set; }

        public ICommand SaveCommand { get; }

        public MedicationEditViewModel(INavigationService navigationService,
            IPlatformResourceProvider resourceProvider) : base(navigationService, resourceProvider)
        {
            SaveCommand = new Command(async () => await SaveAsync());
        }

        private async Task SaveAsync()
        {
        }
    }
}