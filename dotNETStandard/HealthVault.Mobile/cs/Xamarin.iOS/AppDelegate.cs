﻿using Foundation;
using HealthVault.Sample.Xamarin.Core.Configuration;
using Microsoft.HealthVault.Client;
using UIKit;
using App = HealthVault.Sample.Xamarin.Core.App;

namespace Xamarin.iOS
{
    // The UIApplicationDelegate for the application. This class is responsible for launching the 
    // User Interface of the application, as well as listening (and optionally responding) to 
    // application events from iOS.
    [Register("AppDelegate")]
    public partial class AppDelegate : global::Xamarin.Forms.Platform.iOS.FormsApplicationDelegate
    {
        //
        // This method is invoked when the application has loaded and is ready to run. In this 
        // method you should instantiate the window, load the UI into it and then make the window
        // visible.
        //
        // You have 17 seconds to return from this method, or iOS will terminate your application.
        //
        public override bool FinishedLaunching(UIApplication app, NSDictionary options)
        {
            Forms.Forms.Init();

            var connection = HealthVaultConnectionFactory.Current.GetOrCreateSodaConnection(DefaultConfiguration.GetPpeDefaultConfiguration());
            LoadApplication(new App(connection, new PlatformResourceProvider()));

            return base.FinishedLaunching(app, options);
        }

        // TODO: Move to config
    }
}