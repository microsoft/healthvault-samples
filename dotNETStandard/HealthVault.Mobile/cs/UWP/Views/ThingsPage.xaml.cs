using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using HealthVaultMobileSample.UWP.Helpers;
using Microsoft.HealthVault.Clients;
using Microsoft.HealthVault.ItemTypes;
using Microsoft.HealthVault.Record;
using Microsoft.HealthVault.Thing;

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
            Groups = from colItem in items
                          orderby (colItem as ThingBase).TypeName, (colItem as ThingBase).EffectiveDate descending
                          group colItem by (colItem as ThingBase).TypeName into newGroup
                          select newGroup;
            OnPropertyChanged("Groups");
        }

        public ThingsPage()
        {
            InitializeComponent();
        }
    }
}
