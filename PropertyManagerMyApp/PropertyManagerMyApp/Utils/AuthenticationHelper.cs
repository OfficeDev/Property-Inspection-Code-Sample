using System;
using System.Threading.Tasks;
using System.Web.WebPages;
using Microsoft.Azure.ActiveDirectory.GraphClient;
using System.Security.Claims;
using System.Collections.Generic;
using Microsoft.Azure.ActiveDirectory.GraphClient.Extensions;
using System.Linq;
using System.Xml;
using System.Web;

namespace SuiteLevelWebApp.Utils
{
    public class AuthenticationHelper
    {
        public static string token;
        private ActiveDirectoryClient client { get; set; }
        private Dictionary<String, Group> groupsDict { get; set; }

        public static void SetToken(string tk)
        {
            token = tk;
        }

        public async Task<User> GetADUserByPrincipalName(string principalName)
        {
            this.client = await GetActiveDirectoryClient();
            User retUser = await GetUser(principalName);
            return retUser;
        }

        public async Task<List<User>> GetADUsersByGroupName(string groupName)
        {
            this.client = await GetActiveDirectoryClient();
            List<User> retUser = await GetUserFromADGrop(groupName);
            return retUser;
        }

        public async Task CreateADUsersAndGroups()
        {
            XmlDocument sampleData = new XmlDocument();
            var sampleDataUrl = HttpContext.Current.Request.Url.Scheme + "://" + HttpContext.Current.Request.Url.Authority + "/Content/SampleData.xml";
            sampleData.Load(sampleDataUrl);

            this.client = await this.GetActiveDirectoryClient();
            //VerifiedDomain defaultDomain = await this.GetTenantDefualtDomain();
            String defaultDomainValue = System.Configuration.ConfigurationManager.AppSettings["DemoSiteCollectionOwner"].Split('@')[1];
            await ParaseXmlAndCreateADGroups(sampleData);
            await ParserXmlAndCreateADUsers(sampleData, defaultDomainValue);
            return;
        }

        private async Task<string> AcquireTokenAsync()
        {
            if (token == null || token.IsEmpty())
            {
                throw new Exception("Authorization Required.");
            }
            return token;
        }

        private async Task<ActiveDirectoryClient> GetActiveDirectoryClient()
        {
            Uri baseServiceUri = new Uri(AADAppSettings.AADGraphResourceId);
            var tenantId = ClaimsPrincipal.Current.FindFirst("http://schemas.microsoft.com/identity/claims/tenantid").Value;
            ActiveDirectoryClient activeDirectoryClient =
                new ActiveDirectoryClient(new Uri(baseServiceUri, tenantId),
                    async () => await AcquireTokenAsync());

            return activeDirectoryClient;
        }
       
        private async Task ParaseXmlAndCreateADGroups(XmlDocument sampleData)
        {
            this.groupsDict = new Dictionary<string, Group>();

            XmlNode items = sampleData.SelectSingleNode("//List[@name='AD Groups']");
             foreach (XmlNode item in items)
             {
                 String displayName = null;
                 String description = null;
                 String mailNickname = null;
                 foreach (XmlNode column in item.ChildNodes)
                 {
                     if (column.Attributes["name"].Value == "DisplayName")
                     {
                         displayName = column.InnerText;
                     }
                     else if (column.Attributes["name"].Value == "Description")
                     {
                         description = column.InnerText;
                     }
                     else if (column.Attributes["name"].Value == "MailNickname")
                     {
                         mailNickname = column.InnerText;
                     }
                 }
                 Group newgroup = await GetGroup(displayName);
                 if (newgroup == null)
                 {
                     newgroup = new Microsoft.Azure.ActiveDirectory.GraphClient.Group
                     {
                         DisplayName = displayName,
                         Description = description,
                         MailNickname = mailNickname,
                         MailEnabled = false,
                         SecurityEnabled = true
                     };
                     await this.client.Groups.AddGroupAsync(newgroup);
                 }
                 this.groupsDict.Add(newgroup.DisplayName, newgroup);
             }
            return;
        }
        private async Task ParserXmlAndCreateADUsers(XmlDocument sampleData, String defaultDomainValue)
        {
            XmlNode items = sampleData.SelectSingleNode("//List[@name='AD Users']");
            foreach (XmlNode item in items)
            {
                String displayName = null;
                String userPrincipalName = null;
                String mailNickname = null;
                String password = null;
                String groups = null;
                foreach (XmlNode column in item.ChildNodes)
                {
                    if (column.Attributes["name"].Value == "displayName")
                    {
                        displayName = column.InnerText;
                    }
                    else if (column.Attributes["name"].Value == "userPrincipalName")
                    {
                        userPrincipalName = column.InnerText;
                    }
                    else if (column.Attributes["name"].Value == "mailNickname")
                    {
                        mailNickname = column.InnerText;
                    }
                    else if (column.Attributes["name"].Value == "password")
                    {
                        password = column.InnerText;
                    }
                    else if (column.Attributes["name"].Value == "groupsdisplayName")
                    {
                        groups = column.InnerText;
                    }
                }
                User newUser = await GetUser(userPrincipalName + "@" + defaultDomainValue);
                if (newUser == null)
                {
                    newUser = await this.CreateUser(displayName,
                              userPrincipalName + "@" + defaultDomainValue,
                              mailNickname, password);
                }
                
                if (groups != null)
                {
                    string[] grounpsID = groups.Split(',');
                    foreach (string groupDisplayName in grounpsID)
                    {
                        if(groupDisplayName.Length>0)
                        {
                            Group group = this.groupsDict[groupDisplayName];
                            if(group == null)
                            {
                                group = await GetGroup(groupDisplayName);
                            }
                            if(group!=null && !(await CheckUserWhetherExsitADGroup(newUser,group)))
                            {
                                await this.AddUserToGroup(newUser, group);
                            }
                        }
                    }
                }
            }
        }
        private async Task<User> CreateUser(String displayName, String userPrincipalName, String mailNickname, String password)
        {
            User newUser = new User();
            newUser.DisplayName = displayName;
            newUser.UserPrincipalName = userPrincipalName;
            newUser.AccountEnabled = true;
            newUser.MailNickname = mailNickname;
            newUser.PasswordProfile = new PasswordProfile
            {   
                Password = "TempP@ssw0rd!",
                ForceChangePasswordNextLogin = true
            };
            newUser.UsageLocation = "US";
            await this.client.Users.AddUserAsync(newUser);
            return newUser;
        }

        private async Task<User> GetUser(String userPrincipalName)
        {
            var userList = new List<User>();
            IPagedCollection<IUser> pagedCollection = await this.client.Users.Where(user => user.UserPrincipalName.Equals(userPrincipalName)).ExecuteAsync();
            if (pagedCollection != null)
            {
                do
                {
                    List<IUser> templist = pagedCollection.CurrentPage.ToList();
                    foreach (IUser user in templist)
                    {
                        userList.Add((User)user);
                    }

                    if(userList.Count>0)
                    {
                        break;
                    }

                    pagedCollection = await pagedCollection.GetNextPageAsync();

                } 
                while (pagedCollection != null && pagedCollection.MorePagesAvailable);
            }
            if(userList.Count>0)
            {
               return userList[0];
            }
            else
            {
                return null;
            }
        }

        public async Task GetAllUsers()
        {
            Dictionary<String, User>  usersDict = new Dictionary<String, User>();
            IPagedCollection<IUser> pagedCollection = await this.client.Users.ExecuteAsync();
            if (pagedCollection != null)
            {
                do
                {
                    List<IUser> templist = pagedCollection.CurrentPage.ToList();
                    foreach (IUser user in templist)
                    {
                        if (!usersDict.ContainsKey(user.UserPrincipalName))
                        {
                            usersDict.Add(user.UserPrincipalName, (User)user);
                        }                        
                    }
                    pagedCollection = await pagedCollection.GetNextPageAsync();
                } while (pagedCollection != null && pagedCollection.MorePagesAvailable);
            }
        }

        private async Task<Group> GetGroup(string displayName)
        {
            Group retrievedGroup = new Group();
            List<IGroup> foundGroups = new List<IGroup>();
            IPagedCollection<IGroup> pagedCollection = await this.client.Groups.Where(group => group.DisplayName.StartsWith(displayName)).ExecuteAsync();

            if (pagedCollection != null)
            {
                do
                {
                    List<IGroup> templist = pagedCollection.CurrentPage.ToList();
                    foreach (IGroup group in templist)
                    {
                        foundGroups.Add((IGroup)group);
                    }
                    if(foundGroups.Count>0)
                    {
                        break;
                    }
                    pagedCollection = await pagedCollection.GetNextPageAsync();
                } 
                while (pagedCollection != null && pagedCollection.MorePagesAvailable);
            }

            if (foundGroups != null && foundGroups.Count > 0)
            {
                return foundGroups.First() as Group;
            }
            else
            {
                return null;
            }
        }

        private async Task GetAllGroups()
        {
            this.groupsDict = new Dictionary<string, Group>();
            IPagedCollection<IGroup> pagedCollection = await this.client.Groups.ExecuteAsync();

            if (pagedCollection != null)
            {
                do
                {
                    List<IGroup> templist = pagedCollection.CurrentPage.ToList();
                    foreach (IGroup group in templist)
                    {
                        if (!this.groupsDict.ContainsKey(group.DisplayName))
                        {
                            this.groupsDict.Add(group.DisplayName, (Group)group);
                        }
                        
                    }

                    pagedCollection = await pagedCollection.GetNextPageAsync();
                } 
                while (pagedCollection != null && pagedCollection.MorePagesAvailable);
            }
        }

        private async Task AddUserToGroup(User user, Group group)
        {
            //Adding users to groups broke with ADAL 2.0.2, commenting out while 
            //the fix is determined.  README.md has been updated to let folks
            //know they should manually add the users to the groups.
            //client.Context.AddLink(group, "members", user);
            //await client.Context.SaveChangesAsync();
            return;
        }
        
        //public async Task GetUserAndAddToGrop(String userPrincipalName, Group group)
        //{
        //    User user = await this.GetUser(userPrincipalName);
        //    if(user!=null)
        //    {
        //        await this.AddUserToGroup(user, group);
        //    }
        //    return;
        //}

        private async Task<bool> CheckUserWhetherExsitADGroup(User user, Group group)
        {
            if (group.ObjectId != null)
            {
                IGroupFetcher retrievedGroupFetcher = group;
                IPagedCollection<IDirectoryObject> membersPagedCollection = await retrievedGroupFetcher.Members.ExecuteAsync();
                if (membersPagedCollection != null)
                {
                    do
                    {
                        List<IDirectoryObject> templist = membersPagedCollection.CurrentPage.ToList();
                        foreach (IDirectoryObject member in templist)
                        {
                            if (member is User)
                            {
                                User usertemp = member as User;
                                if (usertemp.UserPrincipalName.Equals(user.UserPrincipalName))
                                {
                                    return true;
                                }
                            }
                        }
                        membersPagedCollection = await membersPagedCollection.GetNextPageAsync();
                    } while (membersPagedCollection != null && membersPagedCollection.MorePagesAvailable);

                }

            }
            return false;
        }

        private async Task<bool> CheckUserWhetherExsitADGroup(String userPrincipalName, string groupName)
        {
            Group retrievedGroup = new Group();
            List<IGroup> foundGroups = new List<IGroup>();
            IPagedCollection<IGroup> pagedCollection = await this.client.Groups.Where(group => group.DisplayName.StartsWith(groupName)).ExecuteAsync();

            if (pagedCollection != null)
            {
                do
                {
                    List<IGroup> templist = pagedCollection.CurrentPage.ToList();
                    foreach (IGroup group in templist)
                    {
                        foundGroups.Add((IGroup)group);
                    }
                    if (foundGroups.Count > 0)
                    {
                        break;
                    }
                    pagedCollection = await pagedCollection.GetNextPageAsync();
                } 
                while (pagedCollection != null && pagedCollection.MorePagesAvailable);
            }

            if (foundGroups != null && foundGroups.Count > 0)
            {
                retrievedGroup = foundGroups.First() as Group;
                if (retrievedGroup.ObjectId != null)
                {
                    IGroupFetcher retrievedGroupFetcher = retrievedGroup;
                    IPagedCollection<IDirectoryObject> membersPagedCollection = await retrievedGroupFetcher.Members.ExecuteAsync();
                    if (membersPagedCollection != null)
                    {
                        do
                        {
                            List<IDirectoryObject> templist = membersPagedCollection.CurrentPage.ToList();
                            foreach (IDirectoryObject member in templist)
                            {
                                if (member is User)
                                {
                                    User user = member as User;
                                    if(user.UserPrincipalName.Equals(userPrincipalName))
                                    {
                                        return true;
                                    }
                                }
                            }
                            membersPagedCollection = await membersPagedCollection.GetNextPageAsync();
                        } 
                        while (membersPagedCollection != null && membersPagedCollection.MorePagesAvailable);
                        
                    }
                }
            }
            return false;
        }

        private async Task<List<User>> GetUserFromADGrop(string groupName)
        {
            List<User> userList = new List<User>();

            Group retrievedGroup = new Group();
            List<IGroup> foundGroups = new List<IGroup>();
            IPagedCollection<IGroup> pagedCollection = await this.client.Groups.Where(group => group.DisplayName.StartsWith(groupName)).ExecuteAsync();

            if (pagedCollection != null)
            {
                do
                {
                    List<IGroup> templist = pagedCollection.CurrentPage.ToList();
                    foreach (IGroup group in templist)
                    {
                        foundGroups.Add((IGroup)group);
                    }
                    if(foundGroups.Count>0)
                    {
                        break;
                    }
                    pagedCollection = await pagedCollection.GetNextPageAsync();
                } 
                while (pagedCollection != null && pagedCollection.MorePagesAvailable);
            }

            if (foundGroups != null && foundGroups.Count > 0)
            {
                retrievedGroup = foundGroups.First() as Group;
                if (retrievedGroup.ObjectId != null)
                {
                    IGroupFetcher retrievedGroupFetcher = retrievedGroup;
                    IPagedCollection<IDirectoryObject> membersPagedCollection = await retrievedGroupFetcher.Members.ExecuteAsync();
                    if (membersPagedCollection != null)
                    {
                        do
                        {
                            List<IDirectoryObject> templist = membersPagedCollection.CurrentPage.ToList();
                            foreach (IDirectoryObject member in templist)
                            {
                                if (member is User)
                                {
                                    User user = member as User;
                                    userList.Add(user);
                                }
                            }
                            membersPagedCollection = await membersPagedCollection.GetNextPageAsync();
                        } 
                        while (membersPagedCollection != null && membersPagedCollection.MorePagesAvailable);
                        return userList;
                    }
                }                
            }
            return null;
        }

        private async Task<VerifiedDomain> GetTenantDefualtDomain()
        {
            VerifiedDomain defaultDomain = new VerifiedDomain();
            ITenantDetail tenant = null;
            var tenantId = ClaimsPrincipal.Current.FindFirst("http://schemas.microsoft.com/identity/claims/tenantid").Value;

            var pageList = await this.client.TenantDetails
                 .Where(tenantDetail => tenantDetail.ObjectId.Equals(tenantId))
                 .ExecuteAsync();

            List<ITenantDetail> tenantList = pageList.CurrentPage.ToList<ITenantDetail>();

            if (tenantList.Count > 0)
            {
                tenant = tenantList.First();
            }

            if(tenant!=null)
            {
                TenantDetail tenantDetail = (TenantDetail)tenant;
                defaultDomain = tenantDetail.VerifiedDomains.First(x => x.@default.HasValue && x.@default.Value);
                return defaultDomain;
            }
            else
            {
                return null;
            }
        }
    }
}