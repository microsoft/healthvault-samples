using Microsoft.HealthVault.Clients;
using Microsoft.HealthVault.Connection;
using Microsoft.HealthVault.ItemTypes;
using Microsoft.HealthVault.Person;
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
    /// This page allows a user to edit a medication. 
    /// 
    /// TODO: Complete editing experience with full vocabulary support. 
    /// </summary>
    public sealed partial class EditMedication : Page, INotifyPropertyChanged
    {
        private IVocabularyClient vocabularyClient;
        private IThingClient thingClient;
        private PersonInfo personInfo;

        public Medication Item { get; set; }

        public EditMedication()
        {
            this.InitializeComponent();
        }

        protected async override void OnNavigatedTo(NavigationEventArgs e)
        {
            base.OnNavigatedTo(e);
            
            var navParams = ((object[])e.Parameter);
            if (navParams != null && navParams.Length > 1)
            {
                var connection = navParams[0] as IHealthVaultConnection;

                this.Item = navParams[1] as Medication;
                OnPropertyChanged("Item");

                this.vocabularyClient = Microsoft.HealthVault.Clients.ClientHealthVaultFactory.GetVocabularyClient(connection);
                this.thingClient = Microsoft.HealthVault.Clients.ClientHealthVaultFactory.GetThingClient(connection);
                this.personInfo = await connection.GetPersonInfoAsync();
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
