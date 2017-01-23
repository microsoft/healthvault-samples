using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;
using System.Runtime.Serialization;
using System.Xml;
using System.Xml.Serialization;


// PHIL : Experimenting with XmlSerializer from article here...  BUG : serializes twice!
// http://www.codeproject.com/Articles/14064/Using-the-XmlSerializer-Attributes

namespace HealthVaultProxyTest
{
    [Serializable()]
    public class PatientRecord : ISerializable
    {
        public string PatientId { get; set; }            // application scoped - our patient number
        public string PatientName { get; set; }
        public string PatientEmail { get; set; }
        public string SecretQuestion { get; set; }
        public string SecretAnswer { get; set; }
        public string ConnectCode { get; set; }
        public string PickUpURL { get; set; }
        public string PersonId { get; set; }
        public string RecordId { get; set; }
        public string ApplicationRecordId { get; set; }   // same as patient id for our purposes
        public string Status { get; set; }                // requested, validated, deleted, revoked

        public PatientRecord()
        {
        }

        public PatientRecord(PatientRecord copy)
        {
            PatientId = copy.PatientId;
            PatientName = copy.PatientName;
            PatientEmail = copy.PatientEmail;
            SecretQuestion = copy.SecretQuestion;
            SecretAnswer = copy.SecretAnswer;
            ConnectCode = copy.ConnectCode;
            PickUpURL = copy.PickUpURL;
            PersonId = copy.PersonId;
            RecordId = copy.RecordId;
            ApplicationRecordId = copy.ApplicationRecordId;
            Status = copy.Status;
        }

        public PatientRecord(string patientId, string patientName, string patientEmail,
                             string secretQuestion, string secretAnswer, string connectCode, string pickUpURL,
                             string personId, string recordId, string applicationRecordId, string status)
        {
            PatientId = patientId;
            PatientName = patientName;
            PatientEmail = patientEmail;
            SecretQuestion = secretQuestion;
            SecretAnswer = secretAnswer;
            ConnectCode = connectCode;
            PickUpURL = pickUpURL;
            PersonId = personId;
            RecordId = recordId;
            ApplicationRecordId = applicationRecordId;
            Status = status;
        }

        public PatientRecord(SerializationInfo info, StreamingContext ctxt)
        {
            this.PatientId = (string)info.GetValue("PatientId", typeof(string));
            this.PatientName = (string)info.GetValue("PatientName", typeof(string)); ;
            this.PatientEmail = (string)info.GetValue("PatientEmail", typeof(string)); ;
            this.SecretQuestion = (string)info.GetValue("SecretQuestion", typeof(string)); ;
            this.SecretAnswer = (string)info.GetValue("SecretAnswer", typeof(string)); ;
            this.ConnectCode = (string)info.GetValue("ConnectCode", typeof(string)); ;
            this.PickUpURL = (string)info.GetValue("PickUpURL", typeof(string)); ;
            this.PersonId = (string)info.GetValue("PersonId", typeof(string)); ;
            this.RecordId = (string)info.GetValue("RecordId", typeof(string)); ;
            this.ApplicationRecordId = (string)info.GetValue("ApplicationRecordId", typeof(string));
            this.Status = (string)info.GetValue("Status", typeof(string));

        }

        public void GetObjectData(SerializationInfo info, StreamingContext ctxt)
        {
            info.AddValue("PatientId", this.PatientId);
            info.AddValue("PatientName", this.PatientName);
            info.AddValue("PatientEmail", this.PatientEmail);
            info.AddValue("SecretQuestion", this.SecretQuestion);
            info.AddValue("SecretAnswer", this.SecretAnswer);
            info.AddValue("ConnectCode", this.ConnectCode);
            info.AddValue("PickUpURL", this.PickUpURL);
            info.AddValue("PersonId", this.PersonId);
            info.AddValue("RecordId", this.RecordId);
            info.AddValue("ApplicationRecordId", this.ApplicationRecordId);
            info.AddValue("Status", this.Status);
        }

    }

    [Serializable()]
    [XmlRoot("LocalPatientRecords")]
    public class LocalPatientRecords : ISerializable
    {
        [XmlElement("ListOfPatientRecords")]
        public List<PatientRecord> myLocalPatientRecords;

        public LocalPatientRecords()
        {
            myLocalPatientRecords = new List<PatientRecord>();
        }

        public LocalPatientRecords(LocalPatientRecords copy)
        {
            myLocalPatientRecords = copy.PatientRecords;
        }

        public List<PatientRecord> PatientRecords
        {
            get { return this.myLocalPatientRecords; }
            set { this.myLocalPatientRecords = value; }
        }

        public LocalPatientRecords(SerializationInfo info, StreamingContext ctxt)
        {
            this.myLocalPatientRecords = (List<PatientRecord>)info.GetValue("Patients", typeof(List<PatientRecord>));
        }

        public void GetObjectData(SerializationInfo info, StreamingContext ctxt)
        {
            info.AddValue("Patients", this.myLocalPatientRecords);
        }

        public bool ValidateRecord(HVConnect.ValidatedConnection vpc)
        {
            bool found = false;
            foreach (PatientRecord pr in myLocalPatientRecords)
            {
                // PHIL : Update the local record - overwrites blindly if PatientId matches...!
                if (pr.PatientId.Equals(vpc.ApplicationPatientId))
                {
                    found = true;
                    pr.ApplicationRecordId = vpc.ApplicationSpecificRecordId;
                    pr.PersonId = vpc.PersonId.ToString();
                    pr.RecordId = vpc.RecordId.ToString();
                    pr.Status = "validated";
                }
            }
            return found;
        }
    }


    public class PatientRecordsSerializer
    {
        private XmlSerializer s = null;
        private Type type = null;

        public PatientRecordsSerializer()
        {
            this.type = typeof(LocalPatientRecords);
            this.s = new XmlSerializer(this.type);
        }

        public LocalPatientRecords Deserialize(string xml)
        {
            TextReader reader = new StringReader(xml);
            return Deserialize(reader);
        }

        public LocalPatientRecords Deserialize(XmlDocument doc)
        {
            TextReader reader = new StringReader(doc.OuterXml);
            return Deserialize(reader);
        }

        public LocalPatientRecords Deserialize(TextReader reader)
        {
            LocalPatientRecords lpr = (LocalPatientRecords)s.Deserialize(reader);
            reader.Close();
            return lpr;
        }

        public XmlDocument Serialize(LocalPatientRecords lpr)
        {
            string xml = StringSerialize(lpr);
            XmlDocument doc = new XmlDocument();
            doc.PreserveWhitespace = true;
            doc.LoadXml(xml);
            return doc;
        }

        private string StringSerialize(LocalPatientRecords lpr)
        {
            TextWriter w = WriterSerialize(lpr);
            string xml = w.ToString();
            w.Close();
            return xml.Trim();
        }

        private TextWriter WriterSerialize(LocalPatientRecords lpr)
        {
            TextWriter w = new StringWriter();
            this.s = new XmlSerializer(this.type);
            s.Serialize(w, lpr);
            w.Flush();
            return w;
        }

        public static LocalPatientRecords ReadFile(string file)
        {
            PatientRecordsSerializer serializer = new PatientRecordsSerializer();
            try
            {
                string xml = string.Empty;
                using (StreamReader reader = new StreamReader(file))
                {
                    xml = reader.ReadToEnd();
                    reader.Close();
                }
                return serializer.Deserialize(xml);
            }
            catch { }
            return new LocalPatientRecords();
        }

        public static bool WriteFile(string file, LocalPatientRecords lpr)
        {
            bool ok = false;
            PatientRecordsSerializer serializer = new PatientRecordsSerializer();
            try
            {
                string xml = serializer.Serialize(lpr).OuterXml;
                using (StreamWriter writer = new StreamWriter(file, false))
                {
                    writer.Write(xml.Trim());
                    writer.Flush();
                    writer.Close();
                }
                ok = true;
            }
            catch { }
            return ok;
        }
    }

}
