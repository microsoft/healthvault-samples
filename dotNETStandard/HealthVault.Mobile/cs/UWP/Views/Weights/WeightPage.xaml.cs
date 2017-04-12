using Microsoft.HealthVault.Clients;
using Microsoft.HealthVault.Connection;
using Microsoft.HealthVault.ItemTypes;
using Microsoft.HealthVault.Record;
using Microsoft.HealthVault.Thing;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Runtime.InteropServices.WindowsRuntime;
using System.Threading.Tasks;
using Windows.ApplicationModel.Resources;
using Windows.Foundation;
using Windows.Foundation.Collections;
using Windows.UI.Xaml;
using Windows.UI.Xaml.Controls;
using Windows.UI.Xaml.Controls.Primitives;
using Windows.UI.Xaml.Data;
using Windows.UI.Xaml.Input;
using Windows.UI.Xaml.Media;
using Windows.UI.Xaml.Navigation;

namespace HealthVaultMobileSample.UWP.Views.Weights
{
    /// <summary>
    /// This page demonstrates how to implement a comprehensive view using the Weight type. 
    /// </summary>
    public sealed partial class WeightPage : HealthVaultBasePage
    {
        private IHealthVaultConnection connection;
        public IReadOnlyCollection<Weight> Items { get; set; }
        public Weight Latest
        {
            get
            {
                return Items?.First();
            }
        }
        private enum QueryTimeframeEnum
        {
            Default = 0,
            Last30d = 1
        }

        public WeightPage()
        {
            this.InitializeComponent();
        }

        /// <summary>
        /// Obtains Weight objects from HealthVault
        /// </summary>
        /// <returns></returns>
        public override async Task Initialize(IHealthVaultConnection connection)
        {
            //Save the connection so that we can reuse it for updates later
            this.connection = connection;

            HealthRecordInfo recordInfo = (await connection.GetPersonInfoAsync()).SelectedRecord;
            IThingClient thingClient = ClientHealthVaultFactory.GetThingClient(connection);

            if (this.QueryTimeframe.SelectedIndex == (int)QueryTimeframeEnum.Default)
            {
                //Uses a simple query which specifies the Thing type as the only filter
                this.Items = await thingClient.GetThingsAsync<Weight>(recordInfo.Id);
            }
            else if (this.QueryTimeframe.SelectedIndex == (int)QueryTimeframeEnum.Last30d)
            {
                //In this mode, the app specifies a ThingQuery which can be used for functions like
                //filtering, or paging through values
                ThingQuery query = new ThingQuery()
                {
                    EffectiveDateMin = DateTime.Now.AddDays(-30)
                };

                this.Items = await thingClient.GetThingsAsync<Weight>(recordInfo.Id, query);
            }

            OnPropertyChanged("Items");
            OnPropertyChanged("Latest");

            return;
        }

        #region Add Weight
        /// <summary>
        /// Creates a new Weight object and publishes to HealthVault. 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private async void Add_Tapped(object sender, TappedRoutedEventArgs e)
        {
            const double kgToLbsFactor = 2.20462;
            double value;
            double kg;

            if (double.TryParse(this.NewWeight.Text, out value))
            {
                if (this.Units.SelectedIndex == 0)
                {
                    kg = value / kgToLbsFactor;
                }
                else
                {
                    kg = value;
                }

                List<Weight> list = new List<Weight>();
                list.Add(new Weight(
                    new HealthServiceDateTime(DateTime.Now),
                    new WeightValue(kg, new DisplayValue(value, (this.Units.SelectedValue as ComboBoxItem).Content.ToString()))));

                HealthRecordInfo recordInfo = (await this.connection.GetPersonInfoAsync()).SelectedRecord;
                IThingClient thingClient = ClientHealthVaultFactory.GetThingClient(this.connection);
                thingClient.CreateNewThingsAsync<Weight>(recordInfo.Id, list);

                Initialize(this.connection);
                this.AddWeightPopup.IsOpen = false;
            }
            else // Show an error message. 
            {
                ResourceLoader loader = new ResourceLoader();
                Windows.UI.Popups.MessageDialog messageDialog = new Windows.UI.Popups.MessageDialog(loader.GetString("InvalidWeight"));
                await messageDialog.ShowAsync();
            }
        }

        /// <summary>
        /// Opens the AddWeightPopup and positions it just above where the user tapped. 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void AddWeight_Tapped(object sender, TappedRoutedEventArgs e)
        {
            configureDefaultUnits();

            var position = e.GetPosition(this.AddWeightPopup as UIElement);
            this.AddWeightPopup.VerticalOffset = position.Y - 100;
            this.AddWeightPopup.IsOpen = true;
        }

        /// <summary>
        /// Uses the CurrentUICulture to determine the default units for new weight entries. 
        /// </summary>
        private void configureDefaultUnits()
        {
            if (CultureInfo.CurrentUICulture.Name == "en-US")
            {
                this.Units.SelectedIndex = 0; //lbs
            } else
            {
                this.Units.SelectedIndex = 1; //kg
            }
        }
        /// <summary>
        /// Closes the AddWeightPopup. 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void CloseButton_Click(object sender, RoutedEventArgs e)
        {
            this.AddWeightPopup.IsOpen = false;
        }
        #endregion

        /// <summary>
        /// Calls the Initialize method any time the selected value changes.  
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void QueryTimeframe_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            Initialize(this.connection);
        }
    }
}
