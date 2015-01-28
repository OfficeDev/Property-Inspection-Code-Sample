using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;

namespace SuiteLevelWebApp.Models
{
    public class ProvisionDemoData
    {
        public ProvisionDemoData()
        {
            this.dateDemo = DateTime.Now;
        }
        [Editable(false)]
        [Display(Name = "Demo Date: ")]
        [DisplayFormat(DataFormatString = "{0:MM/dd/yy}", ApplyFormatInEditMode = true)]
        public DateTime dateDemo{get;set;}

        public string Message{get; set;}
    }
}