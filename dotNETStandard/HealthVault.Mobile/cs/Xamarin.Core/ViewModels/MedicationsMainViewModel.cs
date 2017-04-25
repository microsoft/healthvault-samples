using System.Collections.ObjectModel;
using System.Threading.Tasks;
using System.Windows.Input;
using HealthVault.Sample.Xamarin.Core.Services;
using HealthVault.Sample.Xamarin.Core.ViewModels.ViewRows;
using Xamarin.Forms;

namespace HealthVault.Sample.Xamarin.Core.ViewModels
{
    public class MedicationsMainViewModel : ViewModel
    {
        public ObservableCollection<MedicationsItemViewRow> CurrentMedications { get; }
        public ObservableCollection<MedicationsItemViewRow> PastMedications { get; }

        public ICommand ItemSelectedCommand { get; }

        public MedicationsMainViewModel(
            INavigationService navigationService, 
            IPlatformResourceProvider resourceProvider) : base(navigationService, resourceProvider)
        {
            ItemSelectedCommand = new Command<MedicationsItemViewRow>(async o => await GoToPage(o));

            CurrentMedications = new ObservableCollection<MedicationsItemViewRow>(new[]
            {
                new MedicationsItemViewRow { Text = "Baboon", Detail = "Africa & Asia", Note = "My note", DisclosureImagePath = resourceProvider.DisclosureIcon},
                new MedicationsItemViewRow { Text = "Capuchin Monkey", Detail = "Central & South America", Note = "My note" , DisclosureImagePath = resourceProvider.DisclosureIcon},
            });

            PastMedications = new ObservableCollection<MedicationsItemViewRow>(new[]
            {
                new MedicationsItemViewRow { Text = "Aripiprazole", Detail = "Africa & Asia", Note = "My note", DisclosureImagePath = resourceProvider.DisclosureIcon},
            });
        }

        private async Task GoToPage(MedicationsItemViewRow obj)
        {
        }
    }
}