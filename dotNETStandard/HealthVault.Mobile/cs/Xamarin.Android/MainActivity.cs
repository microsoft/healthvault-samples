using Android.App;
using Android.Content.PM;
using Android.OS;
using HealthVault.Sample.Xamarin.Core;
using HealthVault.Sample.Xamarin.Core.Configuration;
using Microsoft.HealthVault.Client;

namespace HealthVault.Sample.Xamarin.Android
{
    [Activity(Label = "HealthVault Xamarin Forms Sample", Icon = "@drawable/icon", Theme = "@style/MainTheme", MainLauncher = true, ConfigurationChanges = ConfigChanges.ScreenSize | ConfigChanges.Orientation)]
    public class MainActivity : global::Xamarin.Forms.Platform.Android.FormsAppCompatActivity
    {
        protected override void OnCreate(Bundle bundle)
        {
            TabLayoutResource = Resource.Layout.Tabbar;
            ToolbarResource = Resource.Layout.Toolbar;

            base.OnCreate(bundle);

            global::Xamarin.Forms.Forms.Init(this, bundle);
            LoadApplication(new App());
        }
    }
}
