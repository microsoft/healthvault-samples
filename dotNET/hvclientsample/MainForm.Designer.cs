// Copyright (c) Microsoft Corporation.  All rights reserved.
// MIT License
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the ""Software""), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED *AS IS*, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

namespace HVClientSample
{
    partial class MainForm
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.buttonProvision = new System.Windows.Forms.Button();
            this.textBoxWeight = new System.Windows.Forms.TextBox();
            this.WeightLabel = new System.Windows.Forms.Label();
            this.buttonGetWeight = new System.Windows.Forms.Button();
            this.buttonPutWeight = new System.Windows.Forms.Button();
            this.listViewWeight = new System.Windows.Forms.ListView();
            this.columnHeaderWeight = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.columnHeaderWhen = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.buttonDeProvision = new System.Windows.Forms.Button();
            this.labelConnectionStatus = new System.Windows.Forms.Label();
            this.SuspendLayout();
            // 
            // buttonProvision
            // 
            this.buttonProvision.Location = new System.Drawing.Point(13, 38);
            this.buttonProvision.Name = "buttonProvision";
            this.buttonProvision.Size = new System.Drawing.Size(75, 23);
            this.buttonProvision.TabIndex = 0;
            this.buttonProvision.Text = "Provision";
            this.buttonProvision.UseVisualStyleBackColor = true;
            this.buttonProvision.Click += new System.EventHandler(this.buttonProvision_Click);
            // 
            // textBoxWeight
            // 
            this.textBoxWeight.Location = new System.Drawing.Point(68, 154);
            this.textBoxWeight.Name = "textBoxWeight";
            this.textBoxWeight.Size = new System.Drawing.Size(131, 20);
            this.textBoxWeight.TabIndex = 1;
            this.textBoxWeight.Text = "150";
            // 
            // WeightLabel
            // 
            this.WeightLabel.AutoSize = true;
            this.WeightLabel.Location = new System.Drawing.Point(12, 154);
            this.WeightLabel.Name = "WeightLabel";
            this.WeightLabel.Size = new System.Drawing.Size(41, 13);
            this.WeightLabel.TabIndex = 2;
            this.WeightLabel.Text = "Weight";
            // 
            // buttonGetWeight
            // 
            this.buttonGetWeight.Location = new System.Drawing.Point(15, 197);
            this.buttonGetWeight.Name = "buttonGetWeight";
            this.buttonGetWeight.Size = new System.Drawing.Size(52, 21);
            this.buttonGetWeight.TabIndex = 3;
            this.buttonGetWeight.Text = "Get";
            this.buttonGetWeight.UseVisualStyleBackColor = true;
            this.buttonGetWeight.Click += new System.EventHandler(this.buttonGetWeight_Click);
            // 
            // buttonPutWeight
            // 
            this.buttonPutWeight.Location = new System.Drawing.Point(87, 197);
            this.buttonPutWeight.Name = "buttonPutWeight";
            this.buttonPutWeight.Size = new System.Drawing.Size(52, 21);
            this.buttonPutWeight.TabIndex = 4;
            this.buttonPutWeight.Text = "Put";
            this.buttonPutWeight.UseVisualStyleBackColor = true;
            this.buttonPutWeight.Click += new System.EventHandler(this.buttonPutWeight_Click);
            // 
            // listViewWeight
            // 
            this.listViewWeight.Columns.AddRange(new System.Windows.Forms.ColumnHeader[] {
            this.columnHeaderWeight,
            this.columnHeaderWhen});
            this.listViewWeight.GridLines = true;
            this.listViewWeight.Location = new System.Drawing.Point(13, 246);
            this.listViewWeight.Name = "listViewWeight";
            this.listViewWeight.Size = new System.Drawing.Size(237, 104);
            this.listViewWeight.TabIndex = 5;
            this.listViewWeight.UseCompatibleStateImageBehavior = false;
            this.listViewWeight.View = System.Windows.Forms.View.Details;
            // 
            // columnHeaderWeight
            // 
            this.columnHeaderWeight.Text = "Weight";
            // 
            // columnHeaderWhen
            // 
            this.columnHeaderWhen.Text = "When";
            // 
            // buttonDeProvision
            // 
            this.buttonDeProvision.Location = new System.Drawing.Point(106, 38);
            this.buttonDeProvision.Name = "buttonDeProvision";
            this.buttonDeProvision.Size = new System.Drawing.Size(75, 23);
            this.buttonDeProvision.TabIndex = 6;
            this.buttonDeProvision.Text = "De-Provision";
            this.buttonDeProvision.UseVisualStyleBackColor = true;
            this.buttonDeProvision.Click += new System.EventHandler(this.buttonDeProvision_Click);
            // 
            // labelConnectionStatus
            // 
            this.labelConnectionStatus.AutoSize = true;
            this.labelConnectionStatus.Location = new System.Drawing.Point(15, 85);
            this.labelConnectionStatus.Name = "labelConnectionStatus";
            this.labelConnectionStatus.Size = new System.Drawing.Size(112, 13);
            this.labelConnectionStatus.TabIndex = 7;
            this.labelConnectionStatus.Text = "Connection status text";
            // 
            // MainForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(284, 383);
            this.Controls.Add(this.labelConnectionStatus);
            this.Controls.Add(this.buttonDeProvision);
            this.Controls.Add(this.listViewWeight);
            this.Controls.Add(this.buttonPutWeight);
            this.Controls.Add(this.buttonGetWeight);
            this.Controls.Add(this.WeightLabel);
            this.Controls.Add(this.textBoxWeight);
            this.Controls.Add(this.buttonProvision);
            this.Name = "MainForm";
            this.Text = "HealthVault Client";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Button buttonProvision;
        private System.Windows.Forms.TextBox textBoxWeight;
        private System.Windows.Forms.Label WeightLabel;
        private System.Windows.Forms.Button buttonGetWeight;
        private System.Windows.Forms.Button buttonPutWeight;
        private System.Windows.Forms.ListView listViewWeight;
        private System.Windows.Forms.ColumnHeader columnHeaderWeight;
        private System.Windows.Forms.ColumnHeader columnHeaderWhen;
        private System.Windows.Forms.Button buttonDeProvision;
        private System.Windows.Forms.Label labelConnectionStatus;
    }
}

