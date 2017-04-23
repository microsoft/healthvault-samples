using HealthVaultMobileSample.UWP.Helpers;
using Microsoft.HealthVault.RestApi.Generated.Models;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Runtime.InteropServices.WindowsRuntime;
using System.Threading.Tasks;
using Windows.Foundation;
using Windows.Foundation.Collections;
using Windows.UI.Xaml;
using Windows.UI.Xaml.Controls;
using Windows.UI.Xaml.Controls.Primitives;
using Windows.UI.Xaml.Data;
using Windows.UI.Xaml.Input;
using Windows.UI.Xaml.Media;
using Windows.UI.Xaml.Navigation;

// The Blank Page item template is documented at https://go.microsoft.com/fwlink/?LinkId=234238

namespace HealthVaultMobileSample.UWP.Views.ActionPlans
{
    /// <summary>
    /// An empty page that can be used on its own or navigated to within a Frame.
    /// </summary>
    public sealed partial class ActionPlanDetailsPage : HealthVaultBasePage
    {
        public ActionPlanInstance Context { get; set; }

        public ActionPlanDetailsPage()
        {
            this.InitializeComponent();
        }

        public override async Task Initialize(NavigationParams navParams)
        {
            this.Context = navParams.Context as ActionPlanInstance;

            OnPropertyChanged("Context");
        }
    }
}
