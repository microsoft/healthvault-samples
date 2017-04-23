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
using HealthVaultMobileSample.UWP.Views;
using System.Collections.ObjectModel;
using System.ComponentModel;
using Microsoft.HealthVault.Client;
using Windows.ApplicationModel.Resources;
using Microsoft.HealthVault.Connection;
using Windows.UI.Core;
using HealthVaultMobileSample.UWP.Helpers;

// The Blank Page item template is documented at https://go.microsoft.com/fwlink/?LinkId=234238

namespace HealthVaultMobileSample.UWP.Views.Navigation
{
    /// <summary>
    /// This page contains the main navigation menu for the app. 
    /// </summary>
    public sealed partial class NavigationPage : Page, INotifyPropertyChanged
    {
        public ObservableCollection<NavigationButtonBase> Buttons { get; set; } = new ObservableCollection<NavigationButtonBase>();
        private IHealthVaultConnection connection;

        public NavigationPage()
        {
            this.InitializeComponent();

            //Get a resourceloader for the strings below
            ResourceLoader loader = new ResourceLoader();

            this.Buttons.Add(new NavigationButtonBase()
            {
                Title = loader.GetString("ProfileTitle"),
                Description = loader.GetString("ProfileDescription"),
                BackgroundColor = "#00b294",
                Destination = typeof(Views.Profile.ProfilePage),
                FontIcon = "\xE77B"
            });
            this.Buttons.Add(new NavigationButtonBase()
            {
                Title = loader.GetString("ActionPlansTitle"),
                Description = loader.GetString("ActionPlansDescription"),
                BackgroundColor = "#e88829",
                Destination = typeof(Views.ActionPlans.ActionPlansPage),
                ImageSource = "/Assets/Health/ap_icon.png"
            });
            this.Buttons.Add(new NavigationButtonBase()
            {
                Title = loader.GetString("MedicationsTitle"),
                Description = loader.GetString("MedicationsDescription"),
                BackgroundColor = "#86bbbf",
                Destination = typeof(Views.Medications.MedicationsPage),
                ImageSource = "/Assets/Health/meds_icon.png"
            });
            this.Buttons.Add(new NavigationButtonBase()
            {
                Title = loader.GetString("WeightTitle"),
                Description = loader.GetString("WeightDescription"),
                BackgroundColor = "#f8b942",
                Destination = typeof(Views.Weights.WeightPage),
                ImageSource = "/Assets/Health/weight_icon.png"
            });
            this.Buttons.Add(new NavigationButtonBase()
            {
                Title = loader.GetString("HealthTitle"),
                Description = loader.GetString("HealthDescription"),
                BackgroundColor = "#00b294",
                Destination = typeof(Views.ThingsPage),
                FontIcon = "\xE8A6"
            });

            OnPropertyChanged("Buttons");
            }

        protected override void OnNavigatedTo(NavigationEventArgs e)
        {
            base.OnNavigatedTo(e);
            this.connection = (e.Parameter as NavigationParams).Connection;
        }

        #region INotifyPropertyChanged
        public event PropertyChangedEventHandler PropertyChanged;

        private void OnPropertyChanged(string propertyName)
        {
            if (PropertyChanged != null)
            {
                PropertyChanged(this, new PropertyChangedEventArgs(propertyName));
            }
        }
        #endregion

        /// <summary>
        /// Navigates the app to the selected page. 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void ListView_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            if (e.AddedItems.Count > 0)
            {
                this.Frame.Navigate((e.AddedItems[0] as NavigationButtonBase).Destination, new NavigationParams() { Connection = this.connection });
            }
        }
    }
}
