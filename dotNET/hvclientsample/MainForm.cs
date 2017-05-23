using System;
using System.Windows.Forms;
using Microsoft.Health;
using ItemTypes = Microsoft.Health.ItemTypes;

namespace HVClientSample
{
    public partial class MainForm : Form
    {
        public MainForm()
        {
            InitializeComponent();

            _hvclient = new HVClient();
            UpdateProvisioningState();
        }

        private void buttonProvision_Click(object sender, EventArgs e)
        {
            _hvclient.ProvisionApplication();
            UpdateProvisioningState();
        }

        private void buttonGetWeight_Click(object sender, EventArgs e)
        {
            listViewWeight.Items.Clear();

            HealthRecordItemCollection items = _hvclient.GetWeightFromHealthVault();
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
            _hvclient.SetWeightOnHealthVault(Convert.ToDouble(textBoxWeight.Text));
        }

        private HVClient _hvclient;

        private void buttonDeProvision_Click(object sender, EventArgs e)
        {
            _hvclient.DeProvision();
            UpdateProvisioningState();
        }

        private void UpdateProvisioningState()
        {
            if (_hvclient.IsProvisioned)
            {
                labelConnectionStatus.Text = string.Format(
                    "Provisioned in the {0} (ID={1}) instance.",
                    _hvclient.ServiceInstance.Name,
                    _hvclient.ServiceInstance.Id);

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
