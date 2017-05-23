// Copyright(c) Microsoft Corporation.All rights reserved.
//
//MIT License
//
//Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the ""Software""), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED *AS IS*, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

using Microsoft.Health;
using Microsoft.Health.Package;
using Microsoft.Health.Web;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;

namespace MeaningfulUseReporting
{
    public partial class SendCCDAs : System.Web.UI.Page
    {
        private string _patientID;
        private DateTime _eventTime;
        private bool _overrideCCDAfields;
        private string _DOPUQuestion;
        private string _DOPUAnswer;
        private StringBuilder _sb = new StringBuilder();
        private HealthRecordItem _newCcdaItem;

        protected void Page_Load(object sender, EventArgs e)
        {
            SetLoggedInState();
        }
        protected void cldEventDate_SelectionChanged(object sender, EventArgs e)
        {
            tbEventDate.Text = cldEventDate.SelectedDate.ToShortDateString();
            cldEventDate.Style.Add("display", "none");
        }
        protected void Cal_VisibleMonthChanged(object sender, MonthChangedEventArgs e)
        {
            cldEventDate.Style.Add("display", "inline-block");
        }

        protected void btnContributeDOPU_Click(object sender, EventArgs e)
        {
            if (!TryParseSendCCDAInput(CcdaContributionMethod.DOPU))
            {
                OutputMessage(lblErrorOutput, _sb.ToString());
                return;
            }

            GenerateCCDA();

            ContributeCCDAViaDOPU();
        }

        private void ContributeCCDAViaDOPU()
        {
            OfflineWebApplicationConnection connection = new OfflineWebApplicationConnection(HealthWebApplicationConfiguration.Current.ApplicationId,
                HealthWebApplicationConfiguration.Current.HealthVaultMethodUrl,
                Guid.Empty);
            connection.Authenticate();
            string packageId = ConnectPackage.Create(connection, "friendly name", _DOPUQuestion, _DOPUAnswer, "patientID", new[] { _newCcdaItem });

            Uri pickupUrl = new Uri(HealthApplicationConfiguration.Current.HealthVaultShellUrl, "patientwelcome.aspx?packageid=" + packageId);

            OutputMessage(lblSuccessOutput, "Successfully sent a DOPU package containing CCDA document to HealthVault. Visit the following URL to add the CCDA to a HealthVault record:");

            HyperLink link = new HyperLink();
            link.Text = pickupUrl.ToString();
            link.NavigateUrl = pickupUrl.ToString();
            link.Target = "_blank";
            divSuccess.Controls.Add(link);
        }

        protected void btnContributeCCDARecordAuth_Click(object sender, EventArgs e)
        {
            if (!TryParseSendCCDAInput(CcdaContributionMethod.RecordAuthorization))
            {
                OutputMessage(lblErrorOutput, _sb.ToString());
                return;
            }

            GenerateCCDA();

            ContributeCCDAViaRecordAuthorization();
        }

        private void ContributeCCDAViaRecordAuthorization()
        {
            // Note: Applications can store the HealthVault personID and recordID and use this to make offline requests to store new information
            // in the patient's record whenever new data is available. In this sample, since we don't maintain offline storage (i.e. a DB) to associate
            // the data source organization's patient identifier with the HealthVault person and record ID, we instead sign-in the user to determine the
            // person and record ID everytime a request to send a new CCDA to HealthVault happens (i.e. clicking the "Send CCDA to HealthVault" button);

            PersonInfo pi = WebApplicationUtilities.LoadPersonInfoFromCookie(HttpContext.Current);
            if (pi == null)
            {
                OutputMessage(lblErrorOutput, "Must login first");
                return;
            }

            // Make the offline call to stor the CCDA in the patient's HealthVault record.
            OfflineWebApplicationConnection connection = new OfflineWebApplicationConnection(pi.PersonId);
            HealthRecordAccessor receordAccessor = new HealthRecordAccessor(connection, pi.SelectedRecord.Id);
            receordAccessor.NewItem(_newCcdaItem);

            OutputMessage(lblSuccessOutput, "Successfully sent CCDA document to HealthVault via Record Authorization.");
        }

        private bool TryParseSendCCDAInput(CcdaContributionMethod method)
        {
            bool error = false;
            if (!fileUpload.HasFile)
            {
                _sb.Append("Must specify a CCDA document to upload.");
                error = true;
            }

            _patientID = tbPatientId.Text.Trim();

            if (!string.IsNullOrWhiteSpace(tbEventDate.Text) && !DateTime.TryParse(tbEventDate.Text.Trim(), out _eventTime))
            {
                _sb.Append("Invalid date format. Please specify a date in mm/dd/yyyy format.");
                error = true;
            }

            if (!string.IsNullOrEmpty(_patientID) || !DateTime.Equals(_eventTime, DateTime.MinValue))
            {
                _overrideCCDAfields = true;
            }

            if (method == CcdaContributionMethod.DOPU)
            {
                if (string.IsNullOrWhiteSpace(ddlDOPUQuestion.SelectedValue) || string.IsNullOrWhiteSpace(tbDOPUAnswer.Text))
                {
                    _sb.Append(" To use DOPU please specify a question and answer.");
                    error = true;
                }
                else if (tbDOPUAnswer.Text.Length < 6)
                {
                    _sb.Append(" DOPU answer must be at least 6 characters longs.");
                    error = true;
                }
                else
                {
                    _DOPUQuestion = ddlDOPUQuestion.SelectedValue;
                    _DOPUAnswer = tbDOPUAnswer.Text;
                }
            }

            return error == false;
        }

        private void GenerateCCDA()
        {
            XmlDocument ccdaDocumentData = new XmlDocument();
            ccdaDocumentData.Load(fileUpload.FileContent);

            HealthRecordItem ccda = new HealthRecordItem(new Guid("9c48a2b8-952c-4f5a-935d-f3292326bf54"), ccdaDocumentData);

            if (_overrideCCDAfields)
            {
                StringBuilder stringBuilder = new StringBuilder(150);
                string extSource = "hv-meaningfuluse";

                using (XmlWriter writer = XmlWriter.Create(stringBuilder, new XmlWriterSettings() { OmitXmlDeclaration = true }))
                {
                    writer.WriteStartElement("extension");
                    writer.WriteAttributeString("source", extSource);
                    if (_eventTime != DateTime.MinValue)
                    {
                        writer.WriteElementString("event-date", _eventTime.ToString());
                    }
                    if (!string.IsNullOrEmpty(_patientID))
                    {
                        writer.WriteElementString("patient-id", _patientID);
                    }
                    writer.WriteEndElement();
                }

                HealthRecordItemExtension ext = new HealthRecordItemExtension(extSource);
                ext.ExtensionData.CreateNavigator().InnerXml = stringBuilder.ToString();

                ccda.CommonData.Extensions.Add(ext);
            }

            _newCcdaItem = ccda;
        }

        private PersonInfo GetLoggedInPerson()
        {
            return WebApplicationUtilities.LoadPersonInfoFromCookie(HttpContext.Current);
        }

        private void SetLoggedInState()
        {
            if (GetLoggedInPerson() == null)
            {
                lnkLogin.Text = "Log-in";
                lnkSwitchRecord.Visible = false;
            }
            else
            {
                lnkLogin.Text = "Log-out";
                lnkSwitchRecord.Visible = true;
            }
        }

        protected void lnkSwitchRecord_Click(object sender, EventArgs e)
        {
            ShellRedirectParameters a = new ShellRedirectParameters();
            a.TargetLocation = "AUTH";
            a.TargetParameters.Add("forceappauth", "true");
            a.TargetParameters.Add("appid", HealthApplicationConfiguration.Current.ApplicationId.ToString());
            WebApplicationUtilities.RedirectToShellUrl(HttpContext.Current, a);
        }

        protected void lnkLogin_Click(object sender, EventArgs e)
        {
            if (string.Equals(lnkLogin.Text, "Log-in", StringComparison.OrdinalIgnoreCase))
            {
                WebApplicationUtilities.RedirectToLogOn(HttpContext.Current);
            }
            else
            {
                WebApplicationUtilities.SignOut(HttpContext.Current);
            }
        }

        private void OutputMessage(Label output, string text)
        {
            output.Visible = true;
            output.Text = text + "<br/>";
        }
    }

    public enum CcdaContributionMethod
    {
        RecordAuthorization,
        DOPU
    }
}