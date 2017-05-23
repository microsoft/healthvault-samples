//Copyright (c) Microsoft Corporation.  All rights reserved.
//MIT License
//Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the ""Software""), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

//The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

//THE SOFTWARE IS PROVIDED *AS IS*, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MeaningfulUseReporting
{
    /// <summary>
    /// We have set the following in the Web.Config:
    /// <add key="NonProductionActionUrlRedirectOverride" value="Redirect.aspx"/>
    /// This means that any time we go to the shell, it will redirect back to this
    /// page once it handles our request. The shell will attach a target parameter
    /// in the URL that we can use to determine which page in our application we
    /// want to redirect to. Microsoft.Health.Web.HealthServiceActionPage (which
    /// this page extends) automatically handles processing the target param
    /// in the URL. It uses keys (WCPage_ActionXXX) set in the Web.Config file
    /// to look up where to redirect based on the target param.
    /// </summary>
    public partial class Redirect : Microsoft.Health.Web.HealthServiceActionPage
    {
        //We don't want this page to require log on because when we sign out,
        //we still want this page to read the WCPage_ActionSignOut key in the
        //Web.Config and redirect us to the proper page on sign out
        protected override bool LogOnRequired
        {
            get
            {
                return false;
            }
        }
    }
}