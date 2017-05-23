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
using Microsoft.Health.MeaningfulUse;
using Microsoft.Health.Web;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MeaningfulUseReporting
{
    public partial class Reporting : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
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
            OfflineWebApplicationConnection connection = new OfflineWebApplicationConnection(HealthWebApplicationConfiguration.Current.ApplicationId,
                HealthWebApplicationConfiguration.Current.HealthVaultMethodUrl,
                Guid.Empty);
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
        private void OutputMessage(Label output, string text)
        {
            output.Visible = true;
            output.Text = text + "<br/>";
        }
    }
}