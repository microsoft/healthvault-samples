using System;
using System.ComponentModel;
using System.Threading.Tasks;
using HealthVaultMobileSample.UWP.Helpers;
using Windows.UI.Xaml.Controls;
using Windows.UI.Xaml.Navigation;

// The Blank Page item template is documented at https://go.microsoft.com/fwlink/?LinkId=234238

namespace HealthVaultMobileSample.UWP.Views
{
    /// <summary>
    /// An empty page that can be used on its own or navigated to within a Frame.
    /// </summary>
    public abstract partial class HealthVaultBasePage : Page, INotifyPropertyChanged
    {
        public HealthVaultBasePage()
        {
            InitializeComponent();
        }

        protected async override void OnNavigatedTo(NavigationEventArgs e)
        {
            base.OnNavigatedTo(e);

            await Initialize(e.Parameter as NavigationParams);
        }

        public event PropertyChangedEventHandler PropertyChanged;

        protected void OnPropertyChanged(string propertyName)
        {
            if (PropertyChanged != null)
            {
                PropertyChanged(this, new PropertyChangedEventArgs(propertyName));
            }
        }

        public abstract Task Initialize(NavigationParams navParams);
    }
}
