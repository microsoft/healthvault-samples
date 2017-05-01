using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Runtime.InteropServices.WindowsRuntime;
using Windows.Foundation;
using Windows.Foundation.Collections;
using Windows.UI.Xaml;
using Windows.UI.Xaml.Controls;
using Windows.UI.Xaml.Controls.Primitives;
using Windows.UI.Xaml.Data;
using Windows.UI.Xaml.Input;
using Windows.UI.Xaml.Media;
using Windows.UI.Xaml.Navigation;
using Microsoft.HealthVault.Connection;
using Microsoft.HealthVault.Client;
using System.ComponentModel;
using Microsoft.HealthVault.Configuration;
using Windows.Data.Xml.Dom;
using System.Threading.Tasks;
using HealthVaultMobileSample.UWP.Helpers;

// The Blank Page item template is documented at https://go.microsoft.com/fwlink/?LinkId=402352&clcid=0x409

namespace HealthVaultMobileSample.UWP.Views.Login
{
    /// <summary>
    /// A splash page which triggers the display of the HealthVault authentication experience. 
    /// 
    /// TODO: refactor to make login user-initiated once we complete Connection API changes. 
    /// </summary>
    public sealed partial class LoginPage : Page
    {
        public IHealthVaultConnection connection { get; set; }
        public LoginPage()
        {
            this.InitializeComponent();
        }

        protected override void OnNavigatedTo(NavigationEventArgs e)
        {
            base.OnNavigatedTo(e);

            ExecuteLogin();
        }

        private async void ExecuteLogin()
        {
            this.connection = HealthVaultConnectionFactory.Current.GetOrCreateSodaConnection(await GetHealthVaultConfiguration());

            await this.connection.AuthenticateAsync();

            ((Frame)Window.Current.Content).Navigate(typeof(Views.Navigation.HubPage), new NavigationParams() { Connection = this.connection });
        }

        private static async Task<HealthVaultConfiguration> GetHealthVaultConfiguration()
        {
            XmlDocument document = await XmlDocument.LoadFromFileAsync(await Windows.ApplicationModel.Package.Current.InstalledLocation.GetFileAsync("app.config"));

            return new HealthVaultConfiguration
            {
                MasterApplicationId = Guid.Parse(document.SelectSingleNode("/configuration/appSettings/add[@key='ApplicationId']").Attributes.GetNamedItem("value").InnerText),
                DefaultHealthVaultShellUrl = new Uri(document.SelectSingleNode("/configuration/appSettings/add[@key='ShellUrl']").Attributes.GetNamedItem("value").InnerText),
                DefaultHealthVaultUrl = new Uri(document.SelectSingleNode("/configuration/appSettings/add[@key='HealthServiceUrl']").Attributes.GetNamedItem("value").InnerText),
                RestHealthVaultUrl = new Uri(document.SelectSingleNode("/configuration/appSettings/add[@key='RestHealthServiceUrl']").Attributes.GetNamedItem("value").InnerText),
            };
        }

        private void Login_Click(object sender, RoutedEventArgs e)
        {
            ExecuteLogin();
        }
    }
}
