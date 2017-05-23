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
            buttonProvision = new System.Windows.Forms.Button();
            textBoxWeight = new System.Windows.Forms.TextBox();
            WeightLabel = new System.Windows.Forms.Label();
            buttonGetWeight = new System.Windows.Forms.Button();
            buttonPutWeight = new System.Windows.Forms.Button();
            listViewWeight = new System.Windows.Forms.ListView();
            columnHeaderWeight = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            columnHeaderWhen = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            buttonDeProvision = new System.Windows.Forms.Button();
            labelConnectionStatus = new System.Windows.Forms.Label();
            SuspendLayout();
            // 
            // buttonProvision
            // 
            buttonProvision.Location = new System.Drawing.Point(13, 38);
            buttonProvision.Name = "buttonProvision";
            buttonProvision.Size = new System.Drawing.Size(75, 23);
            buttonProvision.TabIndex = 0;
            buttonProvision.Text = "Provision";
            buttonProvision.UseVisualStyleBackColor = true;
            buttonProvision.Click += new System.EventHandler(buttonProvision_Click);
            // 
            // textBoxWeight
            // 
            textBoxWeight.Location = new System.Drawing.Point(68, 154);
            textBoxWeight.Name = "textBoxWeight";
            textBoxWeight.Size = new System.Drawing.Size(131, 20);
            textBoxWeight.TabIndex = 1;
            textBoxWeight.Text = "150";
            // 
            // WeightLabel
            // 
            WeightLabel.AutoSize = true;
            WeightLabel.Location = new System.Drawing.Point(12, 154);
            WeightLabel.Name = "WeightLabel";
            WeightLabel.Size = new System.Drawing.Size(41, 13);
            WeightLabel.TabIndex = 2;
            WeightLabel.Text = "Weight";
            // 
            // buttonGetWeight
            // 
            buttonGetWeight.Location = new System.Drawing.Point(15, 197);
            buttonGetWeight.Name = "buttonGetWeight";
            buttonGetWeight.Size = new System.Drawing.Size(52, 21);
            buttonGetWeight.TabIndex = 3;
            buttonGetWeight.Text = "Get";
            buttonGetWeight.UseVisualStyleBackColor = true;
            buttonGetWeight.Click += new System.EventHandler(buttonGetWeight_Click);
            // 
            // buttonPutWeight
            // 
            buttonPutWeight.Location = new System.Drawing.Point(87, 197);
            buttonPutWeight.Name = "buttonPutWeight";
            buttonPutWeight.Size = new System.Drawing.Size(52, 21);
            buttonPutWeight.TabIndex = 4;
            buttonPutWeight.Text = "Put";
            buttonPutWeight.UseVisualStyleBackColor = true;
            buttonPutWeight.Click += new System.EventHandler(buttonPutWeight_Click);
            // 
            // listViewWeight
            // 
            listViewWeight.Columns.AddRange(new System.Windows.Forms.ColumnHeader[] {
            columnHeaderWeight,
            columnHeaderWhen});
            listViewWeight.GridLines = true;
            listViewWeight.Location = new System.Drawing.Point(13, 246);
            listViewWeight.Name = "listViewWeight";
            listViewWeight.Size = new System.Drawing.Size(237, 104);
            listViewWeight.TabIndex = 5;
            listViewWeight.UseCompatibleStateImageBehavior = false;
            listViewWeight.View = System.Windows.Forms.View.Details;
            // 
            // columnHeaderWeight
            // 
            columnHeaderWeight.Text = "Weight";
            // 
            // columnHeaderWhen
            // 
            columnHeaderWhen.Text = "When";
            // 
            // buttonDeProvision
            // 
            buttonDeProvision.Location = new System.Drawing.Point(106, 38);
            buttonDeProvision.Name = "buttonDeProvision";
            buttonDeProvision.Size = new System.Drawing.Size(75, 23);
            buttonDeProvision.TabIndex = 6;
            buttonDeProvision.Text = "De-Provision";
            buttonDeProvision.UseVisualStyleBackColor = true;
            buttonDeProvision.Click += new System.EventHandler(buttonDeProvision_Click);
            // 
            // labelConnectionStatus
            // 
            labelConnectionStatus.AutoSize = true;
            labelConnectionStatus.Location = new System.Drawing.Point(15, 85);
            labelConnectionStatus.Name = "labelConnectionStatus";
            labelConnectionStatus.Size = new System.Drawing.Size(112, 13);
            labelConnectionStatus.TabIndex = 7;
            labelConnectionStatus.Text = "Connection status text";
            // 
            // MainForm
            // 
            AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            ClientSize = new System.Drawing.Size(284, 383);
            Controls.Add(labelConnectionStatus);
            Controls.Add(buttonDeProvision);
            Controls.Add(listViewWeight);
            Controls.Add(buttonPutWeight);
            Controls.Add(buttonGetWeight);
            Controls.Add(WeightLabel);
            Controls.Add(textBoxWeight);
            Controls.Add(buttonProvision);
            Name = "MainForm";
            Text = "HealthVault Client";
            ResumeLayout(false);
            PerformLayout();

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

