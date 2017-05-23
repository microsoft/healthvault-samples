using HealthVaultMobileSample.UWP.Helpers;
using System;
using Windows.UI.Xaml.Controls;
using Windows.UI.Xaml.Navigation;
using System.ComponentModel;
using Microsoft.HealthVault.ItemTypes;
using Microsoft.HealthVault.Clients;
using Microsoft.HealthVault.Person;

// The Blank Page item template is documented at https://go.microsoft.com/fwlink/?LinkId=234238

namespace HealthVaultMobileSample.UWP.Views.Medications
{
    /// <summary>
    /// This page allows a user to edit a medication.
    ///
    /// TODO: Complete editing experience with full vocabulary support.
    /// </summary>
    public sealed partial class EditMedication : Page, INotifyPropertyChanged
    {
        private IVocabularyClient _vocabularyClient;
        private IThingClient _thingClient;
        private PersonInfo _personInfo;

        public Medication Item { get; set; }

        public EditMedication()
        {
            InitializeComponent();
        }

        protected async override void OnNavigatedTo(NavigationEventArgs e)
        {
            base.OnNavigatedTo(e);

            var navParams = ((NavigationParams)e.Parameter);
            if (navParams != null)
            {
                var connection = navParams.Connection;

                Item = navParams.Context as Medication;
                OnPropertyChanged("Item");

                _vocabularyClient = connection.CreateVocabularyClient();
                _thingClient = connection.CreateThingClient();
                _personInfo = await connection.GetPersonInfoAsync();
            }
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

        //TODO
        private async void Name_TextChanging(TextBox sender, TextBoxTextChangingEventArgs args)
        {
        }
    }
}
