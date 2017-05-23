using System;
using System.ComponentModel;
using HealthVaultMobileSample.UWP.Helpers;
using Microsoft.HealthVault.Connection;
using Microsoft.HealthVault.ItemTypes;
using Windows.UI.Xaml;
using Windows.UI.Xaml.Controls;
using Windows.UI.Xaml.Navigation;

// The Blank Page item template is documented at https://go.microsoft.com/fwlink/?LinkId=234238

namespace HealthVaultMobileSample.UWP.Views.Medications
{
    /// <summary>
    /// An empty page that can be used on its own or navigated to within a Frame.
    /// </summary>
    public sealed partial class MedicationDetailsPage : Page, INotifyPropertyChanged
    {
        private IHealthVaultConnection _connection;
        public Medication Item { get; set; }

        public MedicationDetailsPage()
        {
            InitializeComponent();
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

            var navParams = ((NavigationParams)e.Parameter);
            if (navParams != null)
            {
                _connection = navParams.Connection;

                Item = navParams.Context as Medication;
                OnPropertyChanged("Item");
            }
        }

        private void Edit_Click(object sender, RoutedEventArgs e)
        {
            var navParams = new NavigationParams()
            {
                Connection = _connection,
                Context = Item
            };

            Frame.Navigate(typeof(EditMedication), navParams);
        }
    }
}
