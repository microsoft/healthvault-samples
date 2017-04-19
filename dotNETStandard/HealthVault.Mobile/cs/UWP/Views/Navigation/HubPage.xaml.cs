using Microsoft.HealthVault.Client;
using Microsoft.HealthVault.Clients;
using Microsoft.HealthVault.Connection;
using Microsoft.HealthVault.ItemTypes;
using Microsoft.HealthVault.Record;
using Microsoft.HealthVault.Thing;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.IO;
using System.Linq;
using System.Runtime.InteropServices.WindowsRuntime;
using System.Threading.Tasks;
using Windows.Foundation;
using Windows.Foundation.Collections;
using Windows.UI.Core;
using Windows.UI.Xaml;
using Windows.UI.Xaml.Controls;
using Windows.UI.Xaml.Controls.Primitives;
using Windows.UI.Xaml.Data;
using Windows.UI.Xaml.Input;
using Windows.UI.Xaml.Media;
using Windows.UI.Xaml.Media.Imaging;
using Windows.UI.Xaml.Navigation;

// The Blank Page item template is documented at https://go.microsoft.com/fwlink/?LinkId=234238

namespace HealthVaultMobileSample.UWP.Views.Navigation
{
    /// <summary>
    /// An empty page that can be used on its own or navigated to within a Frame.
    /// </summary>
    public sealed partial class HubPage : HealthVaultBasePage
    {
        private IHealthVaultConnection connection;

        public string ImageSource { get; private set; }

        public string PersonName { get; set; }

        public HubPage()
        {
            this.InitializeComponent();
        }

        public override async Task Initialize(IHealthVaultConnection connection)
        {
            this.connection = connection; 
            HealthRecordInfo recordInfo = (await this.connection.GetPersonInfoAsync()).SelectedRecord;
            IThingClient thingClient = connection.CreateThingClient();

            //Set person name for UX
            this.PersonName = recordInfo.Name;
            OnPropertyChanged("PersonName");

            //Configure navigation frame for the app
            this.ContentFrame.Navigated += ContentFrame_Navigated;
            SystemNavigationManager.GetForCurrentView().BackRequested += HubPage_BackRequested;

            this.ContentFrame.Navigate(typeof(NavigationPage), this.connection);
        }

        #region Navigation
        private void HubPage_BackRequested(object sender, BackRequestedEventArgs e)
        {
            if (this.ContentFrame.CanGoBack)
            {
                e.Handled = true;
                this.ContentFrame.GoBack();
            }
        }

        private void ContentFrame_Navigated(object sender, NavigationEventArgs e)
        {
            SystemNavigationManager.GetForCurrentView().AppViewBackButtonVisibility =
                this.ContentFrame.CanGoBack ? AppViewBackButtonVisibility.Visible : AppViewBackButtonVisibility.Collapsed;
        }
        #endregion


        private void Home_Tapped(object sender, TappedRoutedEventArgs e)
        {
            this.ContentFrame.Navigate(typeof(NavigationPage), this.connection);
        }
    }
}
 