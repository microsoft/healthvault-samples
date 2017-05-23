// Copyright (c) Microsoft Corporation.  All rights reserved.
// MIT License
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the ""Software""), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED *AS IS*, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

using System;
using System.Collections.Generic;
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
            PatientId = (string)info.GetValue("PatientId", typeof(string));
            PatientName = (string)info.GetValue("PatientName", typeof(string)); ;
            PatientEmail = (string)info.GetValue("PatientEmail", typeof(string)); ;
            SecretQuestion = (string)info.GetValue("SecretQuestion", typeof(string)); ;
            SecretAnswer = (string)info.GetValue("SecretAnswer", typeof(string)); ;
            ConnectCode = (string)info.GetValue("ConnectCode", typeof(string)); ;
            PickUpURL = (string)info.GetValue("PickUpURL", typeof(string)); ;
            PersonId = (string)info.GetValue("PersonId", typeof(string)); ;
            RecordId = (string)info.GetValue("RecordId", typeof(string)); ;
            ApplicationRecordId = (string)info.GetValue("ApplicationRecordId", typeof(string));
            Status = (string)info.GetValue("Status", typeof(string));
        }

        public void GetObjectData(SerializationInfo info, StreamingContext ctxt)
        {
            info.AddValue("PatientId", PatientId);
            info.AddValue("PatientName", PatientName);
            info.AddValue("PatientEmail", PatientEmail);
            info.AddValue("SecretQuestion", SecretQuestion);
            info.AddValue("SecretAnswer", SecretAnswer);
            info.AddValue("ConnectCode", ConnectCode);
            info.AddValue("PickUpURL", PickUpURL);
            info.AddValue("PersonId", PersonId);
            info.AddValue("RecordId", RecordId);
            info.AddValue("ApplicationRecordId", ApplicationRecordId);
            info.AddValue("Status", Status);
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
            get { return myLocalPatientRecords; }
            set { myLocalPatientRecords = value; }
        }

        public LocalPatientRecords(SerializationInfo info, StreamingContext ctxt)
        {
            myLocalPatientRecords = (List<PatientRecord>)info.GetValue("Patients", typeof(List<PatientRecord>));
        }

        public void GetObjectData(SerializationInfo info, StreamingContext ctxt)
        {
            info.AddValue("Patients", myLocalPatientRecords);
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
        private XmlSerializer _s = null;
        private Type _type = null;

        public PatientRecordsSerializer()
        {
            _type = typeof(LocalPatientRecords);
            _s = new XmlSerializer(_type);
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
            LocalPatientRecords lpr = (LocalPatientRecords)_s.Deserialize(reader);
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
            _s = new XmlSerializer(_type);
            _s.Serialize(w, lpr);
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
