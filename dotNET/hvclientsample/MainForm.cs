using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using Microsoft.Health;
using ItemTypes = Microsoft.Health.ItemTypes ;

namespace HVClientSample
{
    public partial class MainForm : Form
    {
        public MainForm()
        {
            InitializeComponent();

            hvclient = new HVClient();
            UpdateProvisioningState();
        }

        private void buttonProvision_Click(object sender, EventArgs e)
        {
            hvclient.ProvisionApplication();
            UpdateProvisioningState();
        }

        private void buttonGetWeight_Click(object sender, EventArgs e)
        {
            listViewWeight.Items.Clear();

            HealthRecordItemCollection items = hvclient.GetWeightFromHealthVault();
            if (items != null)
            {
                foreach (HealthRecordItem item in items)
                {
                    ItemTypes.Weight weight = (ItemTypes.Weight)item;
                    ListViewItem lvi = new ListViewItem(weight.Value.Kilograms.ToString());
                    lvi.SubItems.Add(weight.When.ToString());

                    listViewWeight.Items.Add(lvi);
                }
            }
            
        }

        private void buttonPutWeight_Click(object sender, EventArgs e)
        {
            listViewWeight.Items.Clear();
            hvclient.SetWeightOnHealthVault(Convert.ToDouble(textBoxWeight.Text));
        }

        private HVClient hvclient;

        private void buttonDeProvision_Click(object sender, EventArgs e)
        {
            hvclient.DeProvision();
            UpdateProvisioningState();
        }

        private void UpdateProvisioningState()
        {
            if (hvclient.IsProvisioned)
            {
                labelConnectionStatus.Text = string.Format(
                    "Provisioned in the {0} (ID={1}) instance.",
                    hvclient.ServiceInstance.Name,
                    hvclient.ServiceInstance.Id);

                buttonDeProvision.Enabled = true;
                buttonProvision.Enabled = false;
            }
            else
            {
                labelConnectionStatus.Text = "Not provisioned.";

                buttonDeProvision.Enabled = false;
                buttonProvision.Enabled = true;
            }
        }
    }
}
