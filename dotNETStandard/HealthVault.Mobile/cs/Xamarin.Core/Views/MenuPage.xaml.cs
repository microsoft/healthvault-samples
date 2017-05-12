using Xamarin.Forms;
using Xamarin.Forms.Xaml;

namespace HealthVault.Sample.Xamarin.Core.Views
{
    [XamlCompilation(XamlCompilationOptions.Compile)]
    public partial class MenuPage : ContentPage
    {
        public MenuPage()
        {
            InitializeComponent();
        }

        private void ListView_OnItemTapped(object sender, ItemTappedEventArgs e)
        {
            // Prevents a menu item from showing as "selected"
            ((ListView)sender).SelectedItem = null;
        }
    }
}
