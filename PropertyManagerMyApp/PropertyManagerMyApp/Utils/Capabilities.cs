using System;

namespace SuiteLevelWebApp.Utils
{
    [Flags]
    public enum Capabilities
    {
        Mail = 1,
        Calendar = 2,
        Contacts = 4,
        MyFiles = 8
    }
    
}