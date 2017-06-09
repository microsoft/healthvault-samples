using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Threading.Tasks;
using HealthVaultMobileSample.UWP.Helpers;
using Microsoft.HealthVault.Clients;
using Microsoft.HealthVault.Connection;
using Microsoft.HealthVault.ItemTypes;
using Microsoft.HealthVault.Record;
using Microsoft.HealthVault.Thing;
using Windows.ApplicationModel.Resources;
using Windows.UI.Xaml;
using Windows.UI.Xaml.Controls;
using Windows.UI.Xaml.Input;
using NodaTime;
using Duration = NodaTime.Duration;

namespace HealthVaultMobileSample.UWP.Views.Weights
{
    /// <summary>
    /// This page demonstrates how to implement a comprehensive view using the Weight type.
    /// </summary>
    public sealed partial class WeightPage : HealthVaultBasePage
    {
        private IHealthVaultConnection _connection;
        public IReadOnlyCollection<Weight> Items { get; set; }
        public Weight Latest
        {
            get
            {
                return Items?.FirstOrDefault();
            }
        }

        private enum QueryTimeframeEnum
        {
            Default = 0,
            Last30d = 1
        }

        public WeightPage()
        {
            InitializeComponent();
        }

        /// <summary>
        /// Obtains Weight objects from HealthVault
        /// </summary>
        /// <returns></returns>
        public override async Task Initialize(NavigationParams navParams)
        {
            //Save the connection so that we can reuse it for updates later
            _connection = navParams.Connection;

            HealthRecordInfo recordInfo = (await _connection.GetPersonInfoAsync()).SelectedRecord;
            IThingClient thingClient = _connection.CreateThingClient();

            if (QueryTimeframe.SelectedIndex == (int)QueryTimeframeEnum.Default)
            {
                //Uses a simple query which specifies the Thing type as the only filter
                Items = await thingClient.GetThingsAsync<Weight>(recordInfo.Id);
            }
            else if (QueryTimeframe.SelectedIndex == (int)QueryTimeframeEnum.Last30d)
            {
                LocalDateTime localNow = SystemClock.Instance.GetCurrentInstant().InZone(DateTimeZoneProviders.Tzdb.GetSystemDefault()).LocalDateTime;

                //In this mode, the app specifies a ThingQuery which can be used for functions like
                //filtering, or paging through values
                ThingQuery query = new ThingQuery
                {
                    EffectiveDateMin = localNow.Minus(Period.FromDays(30))
                };

                Items = await thingClient.GetThingsAsync<Weight>(recordInfo.Id, query);
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

            if (double.TryParse(NewWeight.Text, out value))
            {
                if (Units.SelectedIndex == 0)
                {
                    kg = value / kgToLbsFactor;
                }
                else
                {
                    kg = value;
                }

                LocalDateTime localNow = SystemClock.Instance.GetCurrentInstant().InZone(DateTimeZoneProviders.Tzdb.GetSystemDefault()).LocalDateTime;

                List<Weight> list = new List<Weight>();
                list.Add(new Weight(
                    new HealthServiceDateTime(localNow),
                    new WeightValue(kg, new DisplayValue(value, (Units.SelectedValue as ComboBoxItem).Content.ToString()))));

                HealthRecordInfo recordInfo = (await _connection.GetPersonInfoAsync()).SelectedRecord;
                IThingClient thingClient = _connection.CreateThingClient();
                thingClient.CreateNewThingsAsync<Weight>(recordInfo.Id, list);

                Initialize(new NavigationParams() { Connection = _connection });
                AddWeightPopup.IsOpen = false;
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

            var position = e.GetPosition(AddWeightPopup as UIElement);
            AddWeightPopup.VerticalOffset = position.Y - 100;
            AddWeightPopup.IsOpen = true;
        }

        /// <summary>
        /// Uses the CurrentUICulture to determine the default units for new weight entries.
        /// </summary>
        private void configureDefaultUnits()
        {
            if (CultureInfo.CurrentUICulture.Name == "en-US")
            {
                Units.SelectedIndex = 0; //lbs
            }
            else
            {
                Units.SelectedIndex = 1; //kg
            }
        }

        /// <summary>
        /// Closes the AddWeightPopup.
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void CloseButton_Click(object sender, RoutedEventArgs e)
        {
            AddWeightPopup.IsOpen = false;
        }

        #endregion

        /// <summary>
        /// Calls the Initialize method any time the selected value changes.
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void QueryTimeframe_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            Initialize(new NavigationParams() { Connection = _connection });
        }
    }
}
