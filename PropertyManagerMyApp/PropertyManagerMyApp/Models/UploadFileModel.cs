using System.Web;

namespace SuiteLevelWebApp.Models
{
    public class UploadFileModel
    {
        public int IncidentId { get; set; }
        public string PropertyTitle { get; set; }
        public HttpPostedFileBase File { get; set; }
    }
}
