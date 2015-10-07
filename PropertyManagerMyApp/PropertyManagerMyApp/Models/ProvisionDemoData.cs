using System;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace SuiteLevelWebApp.Models
{
    public class ProvisionDemoData
    {
        public ProvisionDemoData()
        {
            this.DateDemo = DateTime.Now;
        }

        [Editable(false)]
        [Display(Name = "Demo Date: ")]
        [DisplayFormat(DataFormatString = "{0:MM/dd/yy}", ApplyFormatInEditMode = true)]
        public DateTime DateDemo { get; set; }

        public string Message { get; set; }
    }

    public class SiteProvisioningTask
    {
        public Task Task { get; set; }
        public string Message { get; set; }
        public string Phase { get; set; }
    }
}