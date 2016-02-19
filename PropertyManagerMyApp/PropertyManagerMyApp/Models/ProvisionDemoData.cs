using System;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace SuiteLevelWebApp.Models
{
    public class SiteProvisioningTask
    {
        public Task Task { get; set; }
        public string Message { get; set; }
        public string Phase { get; set; }
    }

    public class DemoDate
    {
        public string date { get; set; }
    }
}