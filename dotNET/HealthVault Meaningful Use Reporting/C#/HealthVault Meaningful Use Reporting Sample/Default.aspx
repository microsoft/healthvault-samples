<%--
    Copyright (c) Microsoft Corporation.  All rights reserved.
    MIT License
    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the ""Software""), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED *AS IS*, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
--%>

<%@ Page Title="HealthVault Meaningful Use Reporting" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="MeaningfulUseReporting._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="jumbotron">
        <h1>Meaningful Use Reporting</h1>
        <p class="lead">HealthVault has EHR modular certification for the following Meaningful Use Stage 2 objectives:</p>
        <ul>
            <li>View, download, and transmit to a 3rd party (inpatient settings)</li>
            <li>View, download, and transmit to a 3rd party (ambulatory settings)</li>
            <li>Automated numerator recording (inpatient settings)</li>
            <li>Automated numerator recording (ambulatory settings).</li>
        </ul>
        <p><a href="https://www.healthvault.com/en-us/healthvault-meaningful-use/" class="btn btn-primary btn-lg">Learn more &raquo;</a></p>
    </div>

    <div class="row">
        <div class="col-md-4">
            <h2>Send CCDAs to HealthVault</h2>
            <p>
                Submit Consolidated Clinical Document Architecture encoded documents to HealthVault.
            </p>
            <p>
                <a class="btn btn-default" runat="server" href="~/SendCCDAs.aspx">Learn more &raquo;</a>
            </p>
        </div>
        <div class="col-md-4">
            <h2>Reporting</h2>
            <p>
                Get Meaningful Use reports from HealthVault.
            </p>
            <p>
                <a class="btn btn-default" runat="server" href="~/Reporting.aspx">Learn more &raquo;</a>
            </p>
        </div>
    </div>
</asp:Content>
