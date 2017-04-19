using System;
using Android.App;
using Android.Content.PM;
using Android.OS;
using Microsoft.HealthVault.Client;
using Microsoft.HealthVault.Configuration;

namespace HealthVault.Sample.Xamarin.Android
{
    [Activity(Label = "Xamarin", Icon = "@drawable/icon", Theme = "@style/MainTheme", MainLauncher = true, ConfigurationChanges = ConfigChanges.ScreenSize | ConfigChanges.Orientation)]
    public class MainActivity : global::Xamarin.Forms.Platform.Android.FormsAppCompatActivity
    {
        protected override void OnCreate(Bundle bundle)
        {
            TabLayoutResource = Resource.Layout.Tabbar;
            ToolbarResource = Resource.Layout.Toolbar;

            base.OnCreate(bundle);

            global::Xamarin.Forms.Forms.Init(this, bundle);
            var connection = HealthVaultConnectionFactory.Current.GetOrCreateSodaConnection(GetAppAuthConfiguration());
            LoadApplication(new App(connection));
        }

        private static HealthVaultConfiguration GetAppAuthConfiguration()
        {
            var appAuthConfiguration = new HealthVaultConfiguration
            {
                HealthVaultShellUrl = new Uri("https://account.healthvault-ppe.com/"),
                HealthVaultUrl = new Uri("https://platform.healthvault-ppe.com/platform/"),
                MasterApplicationId = Guid.Parse("<YOUR-APP-ID>"),
            };
            return appAuthConfiguration;
        }
    }
}

