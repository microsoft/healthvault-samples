using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;

using Microsoft.Health;
using Microsoft.Health.MeaningfulUse;
using Microsoft.Health.Package;
using Microsoft.Health.Web;

public partial class _Default : Page
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
        SetContributeMethod();
        SetupOutput();         
    }

    protected void btnContributeCCDA_Click(object sender, EventArgs e)
    {
        if (!TryParseSendCCDAInput())
        {
            OutputMessage(lblErrorOutput, _sb.ToString());
            return;
        }

        GenerateCCDA();

        switch (ddlContributeMethod.SelectedValue)
        {
            case "RecordAuthorization":
                ContributeCCDAViaRecordAuthorization();
                break;
            case "DOPU":
                ContributeCCDAViaDOPU();
                break;
        }
    }   

    private bool TryParseSendCCDAInput()
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

        if (string.Equals(ddlContributeMethod.SelectedValue, "DOPU", StringComparison.OrdinalIgnoreCase))
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
            
            using (XmlWriter writer = XmlWriter.Create(stringBuilder, new XmlWriterSettings() {OmitXmlDeclaration=true}))
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
        HealthRecordAccessor receordAccessor = new HealthRecordAccessor(connection,  pi.SelectedRecord.Id);
        receordAccessor.NewItem(_newCcdaItem);

        OutputMessage(lblSuccessOutput, "Successfully sent CCDA document to HealthVault via Record Authorization.");
    }

    private void ContributeCCDAViaDOPU()
    {
        OfflineWebApplicationConnection connection = new OfflineWebApplicationConnection();        
        string packageId = ConnectPackage.Create(connection, "friendly name", _DOPUQuestion, _DOPUAnswer, "patientID", new[] { _newCcdaItem });
        
        Uri pickupUrl = new Uri(HealthApplicationConfiguration.Current.HealthVaultShellUrl, "patientwelcome.aspx?packageid=" + packageId); 

        OutputMessage(lblSuccessOutput, "Successfully sent a DOPU package containing CCDA document to HealthVault. Visit the following URL to add the CCDA to a HealthVault record:"); 

        HyperLink link = new HyperLink();
        link.Text = pickupUrl.ToString(); 
        link.NavigateUrl = pickupUrl.ToString();
        link.Target = "_blank"; 
        divSuccess.Controls.Add(link);       
    }

    private void OutputMessage(Label output, string text)
    {
        output.Visible = true;
        output.Text = text + "<br/>"; 
    }

    protected void btnGetVDTReport_Click(object sender, EventArgs e)
    {
        string report = GetVDTReports();

        if (string.IsNullOrEmpty(report))
        {
            return;
        }

        Response.ContentType = "text/plain";
        Response.AppendHeader("Content-Disposition", "attachment; filename=HealthVaultVDTReport-" + DateTime.Now.ToString("u") + ".csv");

        using (StreamWriter sw = new StreamWriter(Response.OutputStream))
        {
            sw.Write(report);
        }
        Response.End();
    }

    // Calls HealthVault to a View, Download, Transmit report
    private string GetVDTReports()
    {
        DateTime reportStart = DateTime.MinValue;
        DateTime reportEnd = DateTime.MaxValue; 
        if (!string.IsNullOrWhiteSpace(tbReportStart.Text) && !DateTime.TryParse(tbReportStart.Text.Trim(), out reportStart))
        {
            OutputMessage(lblErrorOutput, "Invalid reporting period start date. Please specify a date in mm/dd/yyyy format.");
            return null; 
        }

        if (!string.IsNullOrWhiteSpace(tbReportEnd.Text) && !DateTime.TryParse(tbReportEnd.Text.Trim(), out reportEnd))
        {
            OutputMessage(lblErrorOutput, "Invalid reporting period end date. Please specify a date in mm/dd/yyyy format.");
            return null; 
        }

        DateRange dateFilter = new DateRange(reportStart, reportEnd);
        OfflineWebApplicationConnection connection = new OfflineWebApplicationConnection();
        IEnumerable<PatientActivity> resultActivities = connection.GetMeaningfulUseVDTReport(dateFilter);

        StringBuilder sb = new StringBuilder();
        sb.AppendLine(string.Join(",", "Report Start = " + reportStart.ToString(), "Report End = " + reportEnd.ToString())); 
        sb.AppendLine(string.Join(",", "Source", "PatientID", "Organization"));
        foreach (PatientActivity p in resultActivities)
        {
            sb.AppendLine(string.Join(",", p.Source, p.PatientId, p.OrganizationId));
        }

        return sb.ToString();
    }    

    private void SetupOutput()
    {
        lblSuccessOutput.Visible = false;
        lblSuccessOutput.Text = string.Empty;
        lblErrorOutput.Visible = false; 
        lblErrorOutput.Text = string.Empty; 
    }

    private void SetContributeMethod()
    {
        if (string.Equals(ddlContributeMethod.SelectedValue, "RecordAuthorization", StringComparison.OrdinalIgnoreCase))
        {
            lnkLogin.Visible = true;
            tblDOPUInfo.Visible = false;             
        }
        else
        {
            lnkLogin.Visible = false;
            tblDOPUInfo.Visible = true; 
        }
    }

    private PersonInfo GetLoggedInPerson()
    {
        return WebApplicationUtilities.LoadPersonInfoFromCookie(HttpContext.Current);
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

    protected void lnkSwitchRecord_Click(object sender, EventArgs e)
    {
        ShellRedirectParameters a = new ShellRedirectParameters();
        a.TargetLocation = "AUTH";
        a.TargetParameters.Add("forceappauth", "true");
        a.TargetParameters.Add("appid", HealthApplicationConfiguration.Current.ApplicationId.ToString());
        WebApplicationUtilities.RedirectToShellUrl(HttpContext.Current, a);
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

    // event date calendar handlers
    protected void cldEventDate_SelectionChanged(object sender, EventArgs e)
    {
        tbEventDate.Text = cldEventDate.SelectedDate.ToShortDateString();
        cldEventDate.Style.Add("display", "none"); 
        
    }
    protected void Cal_VisibleMonthChanged(object sender, MonthChangedEventArgs e)
    {
        cldEventDate.Style.Add("display", "inline-block"); 
    }

    // report start calendar handlers
    protected void cldReportStart_SelectionChanged(object sender, EventArgs e)
    {        
        tbReportStart.Text = cldReportStart.SelectedDate.ToShortDateString();
        cldReportStart.Style.Add("display", "none");         
    }
    protected void CalReportStart_VisibleMonthChanged(object sender, MonthChangedEventArgs e)
    {
        cldReportStart.Style.Add("display", "inline-block"); 
    }

    // report end calendar handlers
    protected void cldReportEnd_SelectionChanged(object sender, EventArgs e)
    {
        tbReportEnd.Text = cldReportEnd.SelectedDate.ToShortDateString();
        cldReportEnd.Style.Add("display", "none");
    }
    protected void CalReportEnd_VisibleMonthChanged(object sender, MonthChangedEventArgs e)
    {
        cldReportEnd.Style.Add("display", "inline-block");
    }            
}
