<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>HealthVault Meaningful Use Reporting Sample</title>
    <style type="text/css">

        .inputControls
        {
            width: 270px;
        }

    </style>
    <script type="text/javascript">        
        function ToggleVisible(id) {
            var elem = document.getElementById(id);
            if (elem.style.display == "none") {
                elem.style.display = "inline-block";
            } else {
                elem.style.display = "none"; 
            }
        }        
  </script>
</head>
<body style="font:12px Verdana">
    <form id="form1" runat="server">                    
        <h1>HealthVault Meaningful Use Reporting Sample</h1>
        <h2>Send CCDAs to HealthVault</h2>
        <asp:Label ID="lblErrorOutput" runat="server" Text="" style="color:red" />
        Select the method for contributing CCDA documents<br />                                                
        <asp:DropDownList ID="ddlContributeMethod" runat="server" CssClass="inputControls" AutoPostBack="true" >
            <asp:ListItem Value="RecordAuthorization" Text="Record Authorization"></asp:ListItem>
            <asp:ListItem Value="DOPU" Text="DOPU"></asp:ListItem>
        </asp:DropDownList>                
        <asp:LinkButton ID="lnkLogin" runat="server" Text="Log-in" OnClick="lnkLogin_Click" />
        <asp:LinkButton ID="lnkSwitchRecord" runat="server" Visible="false" Text="Switch Record" OnClick="lnkSwitchRecord_Click" />
        <br /><br />            
        <asp:Panel ID="tblDOPUInfo" runat="server">
            Secret Question
            <br />
            <asp:DropDownList ID="ddlDOPUQuestion" runat="server" CssClass="inputControls">
                <asp:ListItem Value="What is your mother's maiden name?"></asp:ListItem>
                <asp:ListItem Value="What was your first pet's name?"></asp:ListItem>
                <asp:ListItem Value="What street did you grow up on?"></asp:ListItem>
                <asp:ListItem Value="What was the make of your first car?"></asp:ListItem>
            </asp:DropDownList>            
            <br /><br />
            Secret Answer<br />
            <asp:TextBox ID="tbDOPUAnswer" runat="server" CssClass="inputControls" ></asp:TextBox>            
        </asp:Panel>
        <br />
        Patient ID (optional) <br />
        <asp:TextBox ID="tbPatientId" runat="server" CssClass="inputControls" ToolTip="Specifies the Patient ID" /><br /><br />
        Visit or Discharge Date (optional) <br />
        <asp:TextBox ID="tbEventDate"  runat="server" CssClass="inputControls" onclick="ToggleVisible('cldEventDate')" Tooltip="Specifies the date of the patient's visit or discharge date" /><br />                                                
        <asp:Calendar ID="cldEventDate" runat="server" CssClass="inputControls" style="display:none" OnSelectionChanged="cldEventDate_SelectionChanged" OnVisibleMonthChanged="Cal_VisibleMonthChanged" />                                        
        <br /><br />    
        <asp:Label ID="lblSelectCCDA" runat="server" CssClass="inputControls" Text="Select CCDA document" /><br />
        <asp:FileUpload ID="fileUpload" runat="server" CssClass="inputControls" /><br /><br />            
        <asp:Button ID="btnContributeCCDA" runat="server" Text="Send CCDA to HealthVault" OnClick="btnContributeCCDA_Click" />
        <br /><br /> 
        <div id="divSuccess" runat="server">
            <asp:Label ID="lblSuccessOutput" runat="server" Text="" style="color:green" />
        </div>
        <br /><br />        
        <h2>Meaningful Use Reports</h2>
        Reporting Period Start Date <br />
        <asp:TextBox ID="tbReportStart"  runat="server" CssClass="inputControls" onclick="ToggleVisible('cldReportStart')" Tooltip="Specifies the reporting period start date" /><br />                                                
        <asp:Calendar ID="cldReportStart" runat="server" CssClass="inputControls" style="display:none" OnSelectionChanged="cldReportStart_SelectionChanged" OnVisibleMonthChanged="CalReportStart_VisibleMonthChanged" />                                        
        <br />
        Reporting Period End Date <br />
        <asp:TextBox ID="tbReportEnd"  runat="server" CssClass="inputControls" onclick="ToggleVisible('cldReportEnd')" Tooltip="Specifies the reporting period end date" /><br />                                                
        <asp:Calendar ID="cldReportEnd" runat="server" CssClass="inputControls" style="display:none" OnSelectionChanged="cldReportEnd_SelectionChanged" OnVisibleMonthChanged="CalReportEnd_VisibleMonthChanged" />                                        
        <br />
        <asp:Button ID="btnGetVDTReport" runat="server" Text="Get View, Download, Transmit report" OnClick="btnGetVDTReport_Click"/>               
        
    </form>
</body>
</html>
