<%--
    Copyright (c) Microsoft Corporation.  All rights reserved.
    MIT License
    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the ""Software""), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED *AS IS*, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
--%>

<%@ Page Title="Send CCDAs to HealthVault" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="SendCCDAs.aspx.cs" Inherits="MeaningfulUseReporting.SendCCDAs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="jumbotron">
        <h1>Send CCDAs to HealthVault</h1>
    </div>

    <div class="row">
        <div class="col-md-4">
            <h2>Record Authorization</h2>
            <asp:LinkButton ID="lnkLogin" runat="server" Text="Log-in" OnClick="lnkLogin_Click" />
            <asp:LinkButton ID="lnkSwitchRecord" runat="server" Visible="false" Text="Switch Record" OnClick="lnkSwitchRecord_Click" />
            <br />
            <br />
            Patient ID (optional)
            <br />
            <asp:TextBox ID="TextBox1" runat="server" CssClass="inputControls" ToolTip="Specifies the Patient ID" /><br />
            <br />
            Visit or Discharge Date (optional)
            <br />
            <asp:TextBox ID="TextBox2" runat="server" CssClass="inputControls" onclick="ToggleVisible('cldEventDate')" ToolTip="Specifies the date of the patient's visit or discharge date" /><br />
            <asp:Calendar ID="Calendar1" runat="server" CssClass="inputControls" Style="display: none" OnSelectionChanged="cldEventDate_SelectionChanged" OnVisibleMonthChanged="Cal_VisibleMonthChanged" />
            <br />
            <br />
            <asp:Label ID="Label1" runat="server" CssClass="inputControls" Text="Select CCDA document" /><br />
            <asp:FileUpload ID="fileUpload1" runat="server" CssClass="inputControls" /><br />
            <br />
            <asp:Button ID="btnContributeCCDA" runat="server" Text="Send CCDA to HealthVault" OnClick="btnContributeCCDARecordAuth_Click" />
            <br />
            <br />
        </div>
        <div class="col-md-4">
            <h2>Drop Off/Pick Up (DOPU)</h2>

            <asp:Panel ID="tblDOPUInfo" runat="server">
                Secret Question
            <br />
                <asp:DropDownList ID="ddlDOPUQuestion" runat="server" CssClass="inputControls">
                    <asp:ListItem Value="What is your mother's maiden name?"></asp:ListItem>
                    <asp:ListItem Value="What was your first pet's name?"></asp:ListItem>
                    <asp:ListItem Value="What street did you grow up on?"></asp:ListItem>
                    <asp:ListItem Value="What was the make of your first car?"></asp:ListItem>
                </asp:DropDownList>
                <br />
                <br />
                Secret Answer<br />
                <asp:TextBox ID="tbDOPUAnswer" runat="server" CssClass="inputControls"></asp:TextBox>
            </asp:Panel>
            <br />

            Patient ID (optional)
            <br />
            <asp:TextBox ID="tbPatientId" runat="server" CssClass="inputControls" ToolTip="Specifies the Patient ID" />
            <br />
            <br />

            Visit or Discharge Date (optional)
            <br />
            <asp:TextBox ID="tbEventDate" runat="server" CssClass="inputControls" onclick="ToggleVisible('MainContent_cldEventDate')" ToolTip="Specifies the date of the patient's visit or discharge date" /><br />
            <asp:Calendar ID="cldEventDate" runat="server" CssClass="inputControls" Style="display: none" OnSelectionChanged="cldEventDate_SelectionChanged" OnVisibleMonthChanged="Cal_VisibleMonthChanged" />
            <br />
            <br />
            <asp:Label ID="lblSelectCCDA" runat="server" CssClass="inputControls" Text="Select CCDA document" /><br />
            <asp:FileUpload ID="fileUpload" runat="server" CssClass="inputControls" /><br />
            <br />
            <asp:Button ID="btnContributeDOPU" runat="server" Text="Send CCDA to HealthVault" OnClick="btnContributeDOPU_Click" />
            <br />
            <br />
        </div>
    </div>
    <div class="row">
        <div id="divSuccess" runat="server">
            <asp:Label ID="lblSuccessOutput" runat="server" Text="" Style="color: green" />
        </div>
        <asp:Label ID="lblErrorOutput" runat="server" Text="" Style="color: red" />
    </div>
</asp:Content>
