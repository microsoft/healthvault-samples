using HealthVaultMobileSample.UWP.Helpers;
using Microsoft.HealthVault.Client;
using Microsoft.HealthVault.Clients;
using Microsoft.HealthVault.ItemTypes;
using Microsoft.HealthVault.Record;
using Microsoft.HealthVault.Thing;
using System;
using System.Collections.Generic;
using System.ComponentModel;
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

namespace HealthVaultMobileSample.UWP.Views
{
    /// <summary>
    /// This page demonstrates how to query for multiple Thing types simultaneously 
    /// and build a UX using ItemTemplateSelectors. 
    /// </summary>
    public sealed partial class ThingsPage : HealthVaultBasePage
    {
        public IEnumerable<IGrouping<string, IThing>> Groups { get; set; }

        public override async Task Initialize(NavigationParams navParams)
        {
            HealthRecordInfo recordInfo = (await navParams.Connection.GetPersonInfoAsync()).SelectedRecord;
            IThingClient thingClient = navParams.Connection.CreateThingClient();

            var query = new ThingQuery(new Guid[]{ BloodGlucose.TypeId, Weight.TypeId, BloodPressure.TypeId, CholesterolProfile.TypeId,
                LabTestResults.TypeId, Immunization.TypeId, Procedure.TypeId, Allergy.TypeId, Condition.TypeId });

            var items = await thingClient.GetThingsAsync(recordInfo.Id, query);

            //Create a grouped view of the Things by type
            this.Groups = from collection in items
                          from colItem in collection
                          orderby (colItem as ThingBase).TypeName, (colItem as ThingBase).EffectiveDate descending
                          group colItem by (colItem as ThingBase).TypeName into newGroup
                          select newGroup;
            OnPropertyChanged("Groups");
        }

        public ThingsPage()
        {
            this.InitializeComponent();
        }
    }
}
