using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;
using System.Diagnostics;


// **** Format of a GetThingsResponse element.   Use the SimpleThing derived classes to parse thing elements.
//
//<thing>
//  <thing-id version-stamp="1e45bce8-7da5-492a-adce-f3b73ef3f2a6">95c9c80a-064f-4049-ab60-aa3444b7a72a</thing-id>
//  <type-id name="Weight Measurement">3d34d87e-7fc1-4153-800f-f56592cb0d17</type-id>
//  <thing-state>Active</thing-state>
//  <flags>0</flags>
//  <eff-date>1990-01-01T01:00:00Z</eff-date>
//  <created>
//    <timestamp>2013-04-11T04:12:12.94Z</timestamp>
//    <app-id name="HealthVaultProxy2">aa8741ce-adce-4508-aaed-946ef470fb6d</app-id>
//    <person-id name="Mom ThePenningtons">db6b0275-d0b4-4ef7-a6c9-4969937e301a</person-id>
//    <access-avenue>Offline</access-avenue>
//    <audit-action>Created</audit-action>
//  </created>
//  <updated>
//    <timestamp>2013-04-11T04:12:12.94Z</timestamp>
//    <app-id name="HealthVaultProxy2">aa8741ce-adce-4508-aaed-946ef470fb6d</app-id>
//    <person-id name="Mom ThePenningtons">db6b0275-d0b4-4ef7-a6c9-4969937e301a</person-id>
//    <access-avenue>Offline</access-avenue>
//    <audit-action>Created</audit-action>
//  </updated>
//  <data-xml>
//    <weight>
//      <when>
//        <date>
//          <y>1990</y>
//          <m>1</m>
//          <d>1</d>
//        </date>
//        <time>
//          <h>1</h>
//          <m>0</m>
//          <s>0</s>
//          <f>0</f>
//        </time>
//      </when>
//      <value>
//        <kg>60</kg>
//        <display units="lb">132</display>
//      </value>
//    </weight>
//    <common />
//  </data-xml>
//</thing>


namespace HealthVaultProxyTest
{
        public class SimpleThing
        {
            public Guid ThingId { get; set; }
            public Guid TypeId { get; set; }
            public Guid VersionId { get; set; }
            public DateTime EffectiveDate { get; set; }
            public DateTime LastUpdatedUtc { get; set; }
            public string LastUpdatedAppName { get; set; }
            public Guid LastUpdatedAppId { get; set; }
            public bool IsOriginalData { get; set; }
            public string Note { get; set; }

            public SimpleThing()
            {
            }

            public SimpleThing(SimpleThing copy)
            {
                this.ThingId = copy.ThingId;
                this.TypeId = copy.TypeId;
                this.VersionId = copy.VersionId;
                this.EffectiveDate = copy.EffectiveDate;
                this.LastUpdatedUtc = copy.LastUpdatedUtc;
                this.LastUpdatedAppId = copy.LastUpdatedAppId;
                this.LastUpdatedAppName = copy.LastUpdatedAppName;
                this.IsOriginalData = copy.IsOriginalData;
                this.Note = copy.Note;
            }

            public virtual void Initialize(string xmlThing)
            {
                XElement thing = XElement.Parse(xmlThing);
                this.Initialize(ref thing);
            }

            public virtual void Initialize(ref XElement thing)
            {
                this.ThingId = new Guid(thing.Element("thing-id").Value);
                this.TypeId = new Guid(thing.Element("type-id").Value);
                this.VersionId = new Guid(thing.Element("thing-id").Attribute("version-stamp").Value);
                this.EffectiveDate = (DateTime)thing.Element("eff-date");
                this.LastUpdatedUtc = (DateTime)thing.Element("updated").Element("timestamp");
                this.LastUpdatedAppId = (Guid)thing.Element("updated").Element("app-id");
                this.LastUpdatedAppName = thing.Element("updated").Element("app-id").Attribute("name").Value;
                DateTime created = (DateTime)thing.Element("created").Element("timestamp");
                this.IsOriginalData = (created == this.LastUpdatedUtc);
                this.Note = thing.Element("data-xml").Element("common").Value;
            }
        }

        public class SimpleWeight : SimpleThing
        {
            public DateTime When { get; set; }
            public double Value { get; set; }
            public string Display { get; set; }

            public SimpleWeight()
                : base()
            {
                Value = 0.0;
                When = DateTime.Today;
                Display = string.Empty;
            }

            SimpleWeight(SimpleWeight copy)
                : base(copy)
            {
                this.Value = copy.Value;
                this.When = copy.When;
                this.Display = copy.Display;
            }

            public override void Initialize(ref XElement thing)
            {
                base.Initialize(ref thing);
 
                Debug.Assert(this.TypeId.Equals(new Guid("3d34d87e-7fc1-4153-800f-f56592cb0d17")));   // must be weight type

                int year = (int)thing.Element("data-xml").Element("weight").Element("when").Element("date").Element("y");
                int month = (int)thing.Element("data-xml").Element("weight").Element("when").Element("date").Element("m");
                int day = (int)thing.Element("data-xml").Element("weight").Element("when").Element("date").Element("d");
                int hour = (int)thing.Element("data-xml").Element("weight").Element("when").Element("time").Element("h");
                int minute = (int)thing.Element("data-xml").Element("weight").Element("when").Element("time").Element("m");
                int second = (int)thing.Element("data-xml").Element("weight").Element("when").Element("time").Element("m");

                this.When = new DateTime(year, month, day, hour, minute, second);
                this.Value = (double)thing.Element("data-xml").Element("weight").Element("value").Element("kg");
                this.Display = thing.Element("data-xml").Element("weight").Element("value").Element("display").Value;
                this.Display += thing.Element("data-xml").Element("weight").Element("value").Element("display").Attribute("units").Value;
            }
        }

        public class SimpleBloodPressure : SimpleThing
        {
            public int Systolic { get; set; }
            public int Diastolic { get; set; }
            public int? Pulse { get; set; }

            public SimpleBloodPressure()
                : base()
            {
                this.Systolic = 0;
                this.Diastolic = 0;
                this.Pulse = 0;
            }

            public SimpleBloodPressure(SimpleBloodPressure copy)
                : base(copy)
            {
                this.Systolic = copy.Systolic;
                this.Diastolic = copy.Diastolic;
                this.Pulse = copy.Pulse;
            }

            public override void Initialize(ref XElement thing)
            {
                base.Initialize(ref thing);
                
                Debug.Assert(this.TypeId.Equals(new Guid("ca3c57f4-f4c1-4e15-be67-0a3caf5414ed")), "Expecting blood pressure thing type.");  
                Debug.Assert(true, "SimpleBloodPressure : InitializeFromThingType : Need to complete this method.");
            }
        }

        public class SimpleBloodGlucose : SimpleThing
        {
            public double MMOLL { get; set; }
            public double MGDL { get; set; }
            public string DisplayValue { get; set; }
            public string Context { get; set; }

            public SimpleBloodGlucose()
                : base()
            {
                this.MMOLL = 0.0;
                this.MGDL = 0.0;
                this.DisplayValue = string.Empty;
                this.Context = string.Empty;
            }

            public SimpleBloodGlucose(SimpleBloodGlucose copy)
                : base(copy)
            {
                this.MMOLL = copy.MMOLL;
                this.MGDL = copy.MGDL;
                this.DisplayValue = copy.DisplayValue;
                this.Context = copy.Context;
            }

            public override void Initialize(ref XElement thing)
            {
                base.Initialize(ref thing);

                Debug.Assert(this.TypeId.Equals(new Guid("879e7c04-4e8a-4707-9ad3-b054df467ce4")), "Expecting blood glucose thing type.");                
                Debug.Assert(true, "SimpleBloodGlucose : InitializeFromThingType : Need to complete this method.");

                //this.MMOLL = bg.Value.Value;
                //this.MGDL = this.MMOLL * 18.0;
            }
        }

        public class SimpleHeight : SimpleThing
        {
            public double Value { get; set; }

            public SimpleHeight()
                : base()
            {
                Value = 0.0;
            }

            public SimpleHeight(SimpleHeight copy)
                : base(copy)
            {
                this.Value = copy.Value;
            }

            public override void Initialize(ref XElement thing)
            {
                base.Initialize(ref thing);
                
                Debug.Assert(this.TypeId.Equals(new Guid("40750a6a-89b2-455c-bd8d-b420a4cb500b")), "Expecting height thing type.");
                Debug.Assert(true, "SimpleHeight : InitializeFromThingType : Need to complete this method.");
            }
        }

        public class SimpleCholesterol : SimpleThing
        {
            public int? HDL { set; get; }
            public int? LDL { set; get; }
            public int? TotalCholesterol { set; get; }
            public int? Triglyceride { set; get; }
            public DateTime When { set; get; }

            public SimpleCholesterol()
                : base()
            {
                this.HDL = 0;
                this.LDL = 0;
                this.TotalCholesterol = 0;
                this.Triglyceride = 0;
                this.When = DateTime.UtcNow;
            }

            public SimpleCholesterol(SimpleCholesterol copy)
                : base(copy)
            {
                this.HDL = copy.HDL;
                this.LDL = copy.LDL;
                this.TotalCholesterol = copy.TotalCholesterol;
                this.Triglyceride = copy.Triglyceride;
                this.When = copy.When;
            }

            public override void Initialize(ref XElement thing)
            {
                base.Initialize(ref thing);
                
                Debug.Assert(this.TypeId.Equals(new Guid("796c186f-b874-471c-8468-3eeff73bf66e")), "Expecting cholesterol thing type.");
                Debug.Assert(true, "SimpleCholesterol : InitializeFromThingType : Need to complete this method.");
            }
        }

        public class SimpleCondition : SimpleThing
        {
            public string Name { get; set; }
            public string Onset { get; set; }
            public string Status { get; set; }
            public string Stop { get; set; }
            public string StopReason { get; set; }

            public SimpleCondition()
                : base()
            {
                this.Name = string.Empty;
                this.Onset = string.Empty;
                this.Status = string.Empty;
                this.Stop = string.Empty;
                this.StopReason = string.Empty;
            }

            public SimpleCondition(SimpleCondition copy)
                : base(copy)
            {
                this.Name = copy.Name;
                this.Onset = copy.Onset;
                this.Status = copy.Status;
                this.Stop = copy.Stop;
                this.StopReason = copy.StopReason;
            }

            public override void Initialize(ref XElement thing)
            {
                base.Initialize(ref thing);

                Debug.Assert(this.TypeId.Equals(new Guid("7ea7a1f9-880b-4bd4-b593-f5660f20eda8")), "Expecting condition thing type.");
                Debug.Assert(true, "SimpleCondition : InitializeFromThingType : Need to complete this method.");
            }
        }

        public class SimpleExercise : SimpleThing
        {
            public string Activity { get; set; }
            public string Details { get; set; }
            public string Distance { get; set; }
            public string Duration { get; set; }
            public string Segments { get; set; }
            public string Title { get; set; }
            public string When { set; get; }

            public SimpleExercise()
                : base()
            {
                this.Activity = string.Empty;
                this.Details = string.Empty;
                this.Distance = string.Empty;
                this.Duration = string.Empty;
                this.Segments = string.Empty;
                this.Title = string.Empty;
                this.When = string.Empty;
            }

            public SimpleExercise(SimpleExercise copy)
                : base(copy)
            {
                this.Activity = copy.Activity;
                this.Details = copy.Details;
                this.Distance = copy.Distance;
                this.Duration = copy.Duration;
                this.Segments = copy.Segments;
                this.Title = copy.Title;
                this.When = copy.When;
            }

            public override void Initialize(ref XElement thing)
            {
                base.Initialize(ref thing);

                Debug.Assert(this.TypeId.Equals(new Guid("85a21ddb-db20-4c65-8d30-33c899ccf612")), "Expecting exercise thing type.");
                Debug.Assert(true, "SimpleExercise : InitializeFromThingType : Need to complete this method.");
            }
        }

        public class SimpleHbA1C : SimpleThing
        {
            public string AssayMethod { get; set; }
            public string DeviceId { get; set; }
            public double Value { get; set; }
            public DateTime When { set; get; }

            public SimpleHbA1C()
                : base()
            {
                this.AssayMethod = string.Empty;
                this.DeviceId = string.Empty;
                this.Value = 0.0;
                this.When = DateTime.UtcNow;
            }

            public SimpleHbA1C(SimpleHbA1C copy)
                : base(copy)
            {
                this.AssayMethod = copy.AssayMethod;
                this.DeviceId = copy.DeviceId;
                this.Value = copy.Value;
                this.When = copy.When;
            }

            public override void Initialize(ref XElement thing)
            {
                base.Initialize(ref thing);

                Debug.Assert(this.TypeId.Equals(new Guid("227f55fb-1001-4d4e-9f6a-8d893e07b451")), "Expecting SimpleHbA1C thing type.");
                Debug.Assert(true, "SimpleHbA1C : InitializeFromThingType : Need to complete this method.");
            }
        }

}  // namespace HealthVaultProxyTest
