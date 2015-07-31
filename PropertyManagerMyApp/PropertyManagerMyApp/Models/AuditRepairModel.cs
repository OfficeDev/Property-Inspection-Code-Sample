namespace SuiteLevelWebApp.Models
{
    public enum ApprovalResult
    {
        Rejected = 0,
        Approved = 1
    }

    public class AuditRepairModel
    {
        public int IncidentId { get; set; }
        public ApprovalResult Result { get; set; }
    }
}
