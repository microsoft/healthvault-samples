// Copyright (c) Microsoft Corporation.  All rights reserved.
// MIT License
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the ""Software""), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED *AS IS*, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

using System;

namespace HVAppCode
{
    //
    // NOTE : Optionally modify this class to read from a HealthVaultProxy_Settings.xml file instead.  The values herein are hard-coded for convenience only.
    //
    public static class AppSettings
    {
        private static readonly Guid[] s_myValidTokens = null;

        static AppSettings()   // constructor
        {                                                                                        // ASSIGNED TO //
            s_myValidTokens = new Guid[]{ (new Guid("A245FDA7-8D3B-4ACA-8A73-A4A2AC8001D9")),    // My CRM System #1
                                          (new Guid("ca3c57f4-f4c1-4e15-be67-0a3caf5414ed")),    // My Dev/Test System
                                          (new Guid("879e7c04-4e8a-4707-9ad3-b054df467ce4")),    // ...
                                          (new Guid("227f55fb-1001-4d4e-9f6a-8d893e07b451")),    // extend as needed
                                          (new Guid("25c94a9f-9d3d-4576-96dc-6791178a8143")),    // ...
                                          (new Guid("40750a6a-89b2-455c-bd8d-b420a4cb500b")),
                                          (new Guid("55E12BD9-4C69-499B-B483-B6BC2B3F8B22")) };
        }

        public static bool IsValidToken(string token)
        {
            bool found = false;
            Guid t = new Guid(token);

            foreach (Guid g in s_myValidTokens)
            {
                if (t.Equals(g))
                {
                    found = true;
                    break;
                }
            }
            return found;
        }

        public static string PlatformUrl() { return ("https://platform.healthvault-ppe.com/platform/"); }

        public static string PickupUrl() { return ("https://account.healthvault-ppe.com/patientwelcome.aspx"); }

        public const string NullInputEncountered = "Input parameter cannot be empty or null.";

        public const string DOPUemailTemplate = @"Hello! \n\n" +
                                                "A healthcare provider has dropped-off new health information for you, which can be picked-up " +
                                                "and saved to your HealthVault account. If you don't already have a HealthVault account, " +
                                                "don't worry! We'll help you set one up. Get started by visiting this link:\n\n" +
                                                "[PICKUP] \n\n" +
                                                "When you visit this link, you will be asked to provide a secret code and answer a " +
                                                "challenge question to prove that you are the intended recipient of this information.  " +
                                                "Your secret code is:\n\n" +
                                                "[SECRET] \n\n" +
                                                "Thank you! \n\n" +
                                                "Microsoft HealthVault Services \n";
    }
}
