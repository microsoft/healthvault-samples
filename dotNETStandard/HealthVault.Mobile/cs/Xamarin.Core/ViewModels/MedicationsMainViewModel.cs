using System;
using System.Collections.ObjectModel;
using System.Threading.Tasks;
using System.Windows.Input;
using HealthVault.Sample.Xamarin.Core.Services;
using HealthVault.Sample.Xamarin.Core.ViewModels.ViewRows;
using HealthVault.Sample.Xamarin.Core.Views;
using Xamarin.Forms;

namespace HealthVault.Sample.Xamarin.Core.ViewModels
{
    public class MedicationsMainViewModel : ViewModel
    {
        public ObservableCollection<MedicationsSummaryViewRow> CurrentMedications { get; }
        public ObservableCollection<MedicationsSummaryViewRow> PastMedications { get; }

        public ICommand ItemSelectedCommand { get; }

        public MedicationsMainViewModel(
            INavigationService navigationService, 
            IPlatformResourceProvider resourceProvider) : base(navigationService, resourceProvider)
        {
            ItemSelectedCommand = new Command<MedicationsSummaryViewRow>(async o => await GoToPageAsync(o));

            CurrentMedications = new ObservableCollection<MedicationsSummaryViewRow>(new[]
            {
                new MedicationsSummaryViewRow { Text = "Baboon", Detail = "Africa & Asia", Note = "My note", DisclosureImagePath = resourceProvider.DisclosureIcon},
                new MedicationsSummaryViewRow { Text = "Capuchin Monkey", Detail = "Central & South America", Note = "My note" , DisclosureImagePath = resourceProvider.DisclosureIcon},
            });

            PastMedications = new ObservableCollection<MedicationsSummaryViewRow>(new[]
            {
                new MedicationsSummaryViewRow { Text = "Aripiprazole", Detail = "Africa & Asia", Note = "My note", DisclosureImagePath = resourceProvider.DisclosureIcon},
            });
        }

        private async Task GoToPageAsync(MedicationsSummaryViewRow obj)
        {
            var medicationsMainPage = new MedicationPage()
            {
                BindingContext = new MedicationViewModel(NavigationService, ResourceProvider),
            };
            await NavigationService.NavigateAsync(medicationsMainPage);
        }
    }
}