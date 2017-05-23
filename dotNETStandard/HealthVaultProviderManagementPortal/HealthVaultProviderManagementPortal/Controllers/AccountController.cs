// Copyright (c) Microsoft Corporation.  All rights reserved.
// MIT License
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the ""Software""), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED *AS IS*, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

using System.Web.Mvc;
using Microsoft.HealthVault.Web.Attributes;

namespace HealthVaultProviderManagementPortal.Controllers
{
    /// <summary>
    /// Controller for signing in and out of HealthVault.
    /// This is primarily for patient portal scenarios where a user would sign into HealthVault and manage their own data
    /// through an "online" HealthVault connection.
    ///
    /// For provider interactions (inviting patients to your program, managing action plans, viewing patients' data) you
    /// will usually be using an "offline" connection, where the user doesn't need to be actively signed into HealthVault.
    /// </summary>
    public class AccountController : Controller
    {
        [SignOut]
        public ActionResult LogOff()
        {
            return RedirectToAction("Index", "Home");
        }

        [RequireSignIn]
        public ActionResult LogOn()
        {
            return RedirectToAction("Index", "Home");
        }
    }
}
