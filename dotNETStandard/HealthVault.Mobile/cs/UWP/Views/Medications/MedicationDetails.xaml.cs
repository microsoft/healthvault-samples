using Microsoft.HealthVault.Connection;
using Microsoft.HealthVault.ItemTypes;
using System;
using System.Collections.Generic;
using System.ComponentModel;
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

// The Blank Page item template is documented at https://go.microsoft.com/fwlink/?LinkId=234238

namespace HealthVaultMobileSample.UWP.Views.Medications
{
    /// <summary>
    /// An empty page that can be used on its own or navigated to within a Frame.
    /// </summary>
    public sealed partial class MedicationDetails : Page, INotifyPropertyChanged
    {
        private IHealthVaultConnection connection;
        public Medication Item { get; set; }
        public MedicationDetails()
        {
            this.InitializeComponent();
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

        protected override void OnNavigatedTo(NavigationEventArgs e)
        {
            base.OnNavigatedTo(e);

            var navParams = ((object[])e.Parameter);
            if (navParams != null && navParams.Length > 1)
            {
                this.connection = navParams[0] as IHealthVaultConnection;

                this.Item = navParams[1] as Medication;
                OnPropertyChanged("Item");
            }
        }

        private void Edit_Click(object sender, RoutedEventArgs e)
        {
            var navParams = new object[2];
            navParams[0] = connection;
            navParams[1] = this.Item;

            this.Frame.Navigate(typeof(EditMedication), navParams);
        }
    }
}
