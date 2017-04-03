<%--
    Copyright (c) Microsoft Corporation.  All rights reserved.
    MIT License
    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the ""Software""), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED *AS IS*, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
--%>

<%@ Page Title="Download Meaningful Use Reports" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Reporting.aspx.cs" Inherits="MeaningfulUseReporting.Reporting" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="jumbotron">
        <h1>Reporting</h1>
    </div>
    <div class="row">
        Reporting Period Start Date
    <br />
        <asp:TextBox ID="tbReportStart" runat="server" CssClass="inputControls" onclick="ToggleVisible('MainContent_cldReportStart')" ToolTip="Specifies the reporting period start date" /><br />
        <asp:Calendar ID="cldReportStart" runat="server" CssClass="inputControls" Style="display: none" OnSelectionChanged="cldReportStart_SelectionChanged" OnVisibleMonthChanged="CalReportStart_VisibleMonthChanged" />
        <br />
        Reporting Period End Date
    <br />
        <asp:TextBox ID="tbReportEnd" runat="server" CssClass="inputControls" onclick="ToggleVisible('MainContent_cldReportEnd')" ToolTip="Specifies the reporting period end date" /><br />
        <asp:Calendar ID="cldReportEnd" runat="server" CssClass="inputControls" Style="display: none" OnSelectionChanged="cldReportEnd_SelectionChanged" OnVisibleMonthChanged="CalReportEnd_VisibleMonthChanged" />
        <br />
        <asp:Button ID="btnGetVDTReport" runat="server" Text="Get View, Download, Transmit report" OnClick="btnGetVDTReport_Click" />
    </div>

    <div class="row">
        <asp:Label ID="lblErrorOutput" runat="server" Text="" Style="color: red" />
    </div>
</asp:Content>
