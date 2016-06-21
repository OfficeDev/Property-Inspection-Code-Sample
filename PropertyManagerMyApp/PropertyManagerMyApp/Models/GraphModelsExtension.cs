using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace GraphModelsExtension
{
    public class Plan
    {
        public string id{ get; set; }
    }

    public class Bucket
    {
        public string id { get; set; }
        public string planId { get; set; }
        public string name { get; set; }
    }
    public class task
    {
        public string title { get; set; }
        public string assignedTo { get; set; }
        public string assignedBy { get; set; }
        public DateTimeOffset? assignedDateTime { get; set; }
        public DateTimeOffset? dueDateTime { get; set; }
        public string planId { get; set; }
        public string bucketId { get; set; }
        
        public int? percentComplete { get; set; }
    }

    public class Notebook
    {
        public bool isDefault{ get; set; }
        public bool isShared { get; set; }
        public string sectionsUrl { get; set; }
        public string sectionGroupsUrl { get; set; }

        public string oneNoteWebUrl { get; set; }
        
        public string id { get; set; }
        public string name { get; set; }
    }
    public class Section
    {
        public string id { get; set; }
        public string name { get; set; }
        public string pagesUrl { get; set; }
        
    }
}