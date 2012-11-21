using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Threading;

namespace processbgc
{
    public partial class Form1 : Form
    {
        int counter = 0;
        public Form1()
        {
            InitializeComponent();
        }

        private void doItButton_Click(object sender, EventArgs e)
        {
            doItButton.Enabled = false;
            bgWorker.RunWorkerAsync();
        }

        private void bgWorker_ProgressChanged(object sender, ProgressChangedEventArgs e)
        {
            pgBar.Value = counter;
        }

        private void bgWorker_RunWorkerCompleted(object sender, RunWorkerCompletedEventArgs e)
        {
            doItButton.Enabled = true;

        }

        private void bgWorker_DoWork(object sender, DoWorkEventArgs e)
        {
            int i;
            for (i = 0; i < 20; i++)
            {
                Thread.Sleep(500);
                counter++;
                bgWorker.ReportProgress(i);
            }
        }
    }
}
