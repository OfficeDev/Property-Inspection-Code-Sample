using Microsoft.Graph;
using SuiteLevelWebApp.Utils;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Threading.Tasks;
using utils = SuiteLevelWebApp.Utils;

namespace SuiteLevelWebApp
{
    public static class GraphServiceExtension
    {
        //Extension methods for the Microsoft.Graph.GraphService returned
        //by the GetGraphServiceAsync() method in the AuthenticationHelper class.

        //Controllers use these extension methods to interact with the Microsoft.Graph.GraphService
        public static async Task<Iuser[]> GetAllUsersAsync(this GraphService service)
        {
            var tenantDetails = await service.users
                .ExecuteAsync();
            return await tenantDetails.GetAllAsnyc();
        }

        public static async Task<Iuser[]> GetAllUsersAsync(this GraphService service, Expression<Func<Iuser, bool>> predicate)
        {
            var tenantDetails = await service.users
                .Where(predicate)
                .ExecuteAsync();
            return await tenantDetails.GetAllAsnyc();
        }

        public static async Task<Iuser[]> GetAllUsersAsync(this GraphService service, IEnumerable<string> displayNames)
        {
            var param = Expression.Parameter(typeof(Iuser), "user");
            var displayName = Expression.Property(param, "displayName");

            var body = displayNames
                .Select(name => Expression.Equal(displayName, Expression.Constant(name)))
               .Aggregate((a, b) => Expression.Or(a, b));
            var predicate = Expression.Lambda<Func<Iuser, bool>>(body, param);

            return await GetAllUsersAsync(service, predicate);
        }

        public static async Task<Iuser> GetFirstUserAsync(this GraphService service, Expression<Func<Iuser, bool>> predicate)
        {
            return await service.users
                .Where(predicate)
                .Take(1)
                .ExecuteSingleAsync();
        }

        public static async Task<Igroup> GetGroupByDisplayNameAsync(this GraphService service, string displayName)
        {
            return await service.groups
                .Where(i => i.displayName == displayName)
                .Take(1)
                .ExecuteSingleAsync();
        }

        public static async Task<group> AddGroupAsync(this GraphService service, string Name, string DisplayName, string Description)
        {
            group newGroup = new group
            {
                displayName = DisplayName,
                description = Description,
                mailNickname = Name,
                mailEnabled = false,
                securityEnabled = true
            };
            try
            {
                await service.groups.AddgroupAsync(newGroup);
                return newGroup;
            }
            catch (Exception e)
            {
                throw e;
            }
        }

        public static async Task<user> AddUserAsync(this GraphService service, string LoginName, string DisplayName, string Password)
        {
            var newUser = new user
            {
                displayName = DisplayName,
                userPrincipalName = LoginName + "@" + AppSettings.DemoSiteCollectionOwner.Split('@')[1],
                usageLocation = "US",
                passwordProfile = new passwordProfile
                {
                    password = Password,
                    forceChangePasswordNextSignIn = false
                },
                accountEnabled = true,
                mailNickname = LoginName,
            };


            await service.users.AdduserAsync(newUser);

            return newUser;
        }

        public static async Task<Iuser[]> GetGroupMembersAsync(this GraphService service, string groupName)
        {
            var group = await GetGroupByDisplayNameAsync(service, groupName);

            if (group == null) return new user[0];

            var groupFetcher = service.groups.GetById(group.id);
            return await GetGroupMembersAsync(service, groupFetcher);
        }

        public static async Task<Iuser[]> GetGroupMembersAsync(this GraphService service, IgroupFetcher groupFetcher)
        {
            List<Iuser> users = new List<Iuser>();
            var collection = await groupFetcher.members.ExecuteAsync();

            var items = (await collection.GetAllAsnyc())
                .OfType<directoryObject>().ToArray();


            foreach (var item in items)
            {
                var findUser = await GraphServiceExtension.GetFirstUserAsync(service, i => i.id == item.id);

                if (findUser != null)
                    users.Add(findUser);
            }

            return users.ToArray();
        }

        public static async Task AssignLicenseAsyncViaHttpClientAsync(this GraphService service, string GraphAccessToken, user user)
        {
            var subscribedSkus = await (await service.subscribedSkus.ExecuteAsync()).GetAllAsnyc();
            Guid skuId = Guid.Empty;

            foreach (IsubscribedSku sku in subscribedSkus)
            {
                if ((sku.prepaidUnits.enabled.Value > sku.consumedUnits) &&
                        (sku.capabilityStatus == "Enabled"))
                {
                    skuId = sku.skuId.Value;

                    string json = string.Format("{{\"addLicenses\":[{{\"@odata.type\":\"#Microsoft.Graph.AssignedLicense\",\"disabledPlans\":[],\"skuId\":\"{0}\"}}],\"removeLicenses\":[]}}", skuId.ToString());

                    string postUrl = string.Format("{0}{1}/users('{2}')/Microsoft.Graph.assignLicense", AADAppSettings.GraphResourceUrl, AppSettings.DemoSiteCollectionOwner.Split('@')[1], user.id);

                    var request = new HttpRequestMessage(HttpMethod.Post, postUrl);
                    request.Headers.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", GraphAccessToken);
                    request.Content = new StringContent(json, Encoding.UTF8, "application/json");
                    var client = new HttpClient();
                    await client.SendAsync(request);
                }
            } 
        }

        public static async Task AssignLicenseAsync(this GraphService service, user user)
        {
            var subscribedSkus = await (await service.subscribedSkus.ExecuteAsync()).GetAllAsnyc();

            foreach (IsubscribedSku sku in subscribedSkus)
            {
                //E3 Tenant = ENTERPRISEPACK
                //E4 Tenant = ENTERPRISEPACKWITHCAL

                if (sku.skuPartNumber == "ENTERPRISEPACK")
                {
                    if ((sku.prepaidUnits.enabled.Value > sku.consumedUnits) &&
                        (sku.capabilityStatus == "Enabled"))
                    {
                        // create addLicense object and assign the Enterprise Sku GUID to the skuId
                        assignedLicense addLicense = new assignedLicense { skuId = sku.skuId.Value };

                        foreach (servicePlanInfo servicePlan in sku.servicePlans)
                        {
                            // ---+++--- AVAILABLE SERVICE PLANS ---+++---
                            // OFFICESUBSCRIPTION (Office Pro Plus)
                            // MCOSTANDARD (Lync Online)
                            // SHAREPOINTWAC (Office Web Apps)
                            // SHAREPOINTENTERPRISE (Sharepoint Online)
                            // EXCHANGE_S_ENTERPRISE (Exchange Online)


                            if (servicePlan.servicePlanName.Equals("MCOSTANDARD"))
                            {
                                addLicense.disabledPlans.Add(servicePlan.servicePlanId.Value);
                                break;
                            }
                        }

                        IList<assignedLicense> licensesToAdd = new[] { addLicense };
                        IList<Guid> licensesToRemove = new Guid[] { };

                        // attempt to assign the license object to the new user 
                        try
                        {
                            await user.assignLicenseAsync(licensesToAdd, licensesToRemove);
                        }
                        catch (Exception e)
                        {
                            throw e;
                        }
                    }
                }
            }
        }
    }
}