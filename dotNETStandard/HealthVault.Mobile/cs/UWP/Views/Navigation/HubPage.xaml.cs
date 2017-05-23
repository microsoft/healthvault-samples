using System;
using System.Threading.Tasks;
using HealthVaultMobileSample.UWP.Helpers;
using Microsoft.HealthVault.Clients;
using Microsoft.HealthVault.Connection;
using Microsoft.HealthVault.Record;
using Windows.UI.Core;
using Windows.UI.Xaml.Input;
using Windows.UI.Xaml.Navigation;

// The Blank Page item template is documented at https://go.microsoft.com/fwlink/?LinkId=234238

namespace HealthVaultMobileSample.UWP.Views.Navigation
{
    /// <summary>
    /// An empty page that can be used on its own or navigated to within a Frame.
    /// </summary>
    public sealed partial class HubPage : HealthVaultBasePage
    {
        private IHealthVaultConnection _connection;

        public string ImageSource { get; private set; }

        public string PersonName { get; set; }

        public HubPage()
        {
            InitializeComponent();
        }

        public override async Task Initialize(NavigationParams navParams)
        {
            _connection = navParams.Connection;
            HealthRecordInfo recordInfo = (await _connection.GetPersonInfoAsync()).SelectedRecord;
            IThingClient thingClient = _connection.CreateThingClient();

            //Set person name for UX
            PersonName = recordInfo.Name;
            OnPropertyChanged("PersonName");

            //Configure navigation frame for the app
            ContentFrame.Navigated += ContentFrame_Navigated;
            SystemNavigationManager.GetForCurrentView().BackRequested += HubPage_BackRequested;

            ContentFrame.Navigate(typeof(NavigationPage), new NavigationParams() { Connection = _connection });
        }

        #region Navigation

        private void HubPage_BackRequested(object sender, BackRequestedEventArgs e)
        {
            if (ContentFrame.CanGoBack)
            {
                e.Handled = true;
                ContentFrame.GoBack();
            }
        }

        private void ContentFrame_Navigated(object sender, NavigationEventArgs e)
        {
            SystemNavigationManager.GetForCurrentView().AppViewBackButtonVisibility =
                ContentFrame.CanGoBack ? AppViewBackButtonVisibility.Visible : AppViewBackButtonVisibility.Collapsed;
        }

        #endregion

        private void Home_Tapped(object sender, TappedRoutedEventArgs e)
        {
            ContentFrame.Navigate(typeof(NavigationPage), new NavigationParams() { Connection = _connection });
        }
    }
}
