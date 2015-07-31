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
        public static async Task<IUser[]> GetAllUsersAsync(this GraphService service)
        {
            var tenantDetails = await service.users
                .ExecuteAsync();
            return await tenantDetails.GetAllAsnyc();
        }

        public static async Task<IUser[]> GetAllUsersAsync(this GraphService service, Expression<Func<IUser, bool>> predicate)
        {
            var tenantDetails = await service.users
                .Where(predicate)
                .ExecuteAsync();
            return await tenantDetails.GetAllAsnyc();
        }

        public static async Task<IUser[]> GetAllUsersAsync(this GraphService service, IEnumerable<string> displayNames)
        {
            var param = Expression.Parameter(typeof(IUser), "user");
            var displayName = Expression.Property(param, "displayName");

            var body = displayNames
                .Select(name => Expression.Equal(displayName, Expression.Constant(name)))
               .Aggregate((a, b) => Expression.Or(a, b));
            var predicate = Expression.Lambda<Func<IUser, bool>>(body, param);

            return await GetAllUsersAsync(service, predicate);
        }

        public static async Task<IUser> GetFirstUserAsync(this GraphService service, Expression<Func<IUser, bool>> predicate)
        {
            return await service.users
                .Where(predicate)
                .Take(1)
                .ExecuteSingleAsync();
        }

        public static async Task<IGroup> GetGroupByDisplayNameAsync(this GraphService service, string displayName)
        {
            return await service.groups
                .Where(i => i.displayName == displayName)
                .Take(1)
                .ExecuteSingleAsync();
        }

        public static async Task<Group> AddGroupAsync(this GraphService service, string Name, string DisplayName, string Description)
        {
            Group newGroup = new Group
            {
                displayName = DisplayName,
                description = Description,
                mailNickname = Name,
                mailEnabled = false,
                securityEnabled = true
            };
            try
            {
                await service.groups.AddGroupAsync(newGroup);
                return newGroup;
            }
            catch (Exception e)
            {
                throw e;
            }
        }

        public static async Task<User> AddUserAsync(this GraphService service, string LoginName, string DisplayName, string Password)
        {
            var user = new User
            {
                displayName = DisplayName,
                userPrincipalName = LoginName + "@" + AppSettings.DemoSiteCollectionOwner.Split('@')[1],
                usageLocation = "US",
                passwordProfile = new PasswordProfile
                {
                    password = Password,
                    forceChangePasswordNextLogin = false
                },
                accountEnabled = true,
                mailNickname = LoginName,
            };


            await service.users.AddUserAsync(user);

            return user;
        }

        public static async Task<IUser[]> GetGroupMembersAsync(this GraphService service, string groupName)
        {
            var group = await GetGroupByDisplayNameAsync(service, groupName);
            if (group == null) return new User[0];

            var groupFetcher = service.groups.GetById(group.objectId);
            return await GetGroupMembersAsync(service, groupFetcher);
        }

        public static async Task<IUser[]> GetGroupMembersAsync(this GraphService service, IGroupFetcher groupFetcher)
        {
            var collection = await groupFetcher.members.ExecuteAsync();
            return (await collection.GetAllAsnyc())
                .OfType<IUser>().ToArray();
        }

        public static async Task AssignLicenseAsyncViaHttpClientAsync(this GraphService service, User user)
        {
            var subscribedSkus = await (await service.subscribedSkus.ExecuteAsync()).GetAllAsnyc();
            string token = await utils.AuthenticationHelper.GetGraphAccessTokenAsync();
            Guid skuId = Guid.Empty;
            Guid disabledPlansId = Guid.Empty;

            foreach (ISubscribedSku sku in subscribedSkus)
            {
                if ((sku.prepaidUnits.enabled.Value > sku.consumedUnits) &&
                        (sku.capabilityStatus == "Enabled"))
                {
                    skuId = sku.skuId.Value;
                }

                foreach (ServicePlanInfo servicePlan in sku.servicePlans)
                {

                    if (servicePlan.servicePlanName.Equals("MCOSTANDARD"))
                    {
                        disabledPlansId = servicePlan.servicePlanId.Value;
                        break;
                    }
                }
            }

            if (skuId == Guid.Empty) return;

            string json = string.Format("{{\"addLicenses\":[{{\"@odata.type\":\"#Microsoft.Graph.AssignedLicense\",\"disabledPlans\":[\"{0}\"],\"skuId\":\"{1}\"}}],\"removeLicenses\":[]}}", disabledPlansId.ToString(), skuId.ToString());

            string postUrl = string.Format("{0}{1}/users('{2}')/Microsoft.Graph.assignLicense", AADAppSettings.GraphResourceUrl, AppSettings.DemoSiteCollectionOwner.Split('@')[1], user.objectId);

            var request = new HttpRequestMessage(HttpMethod.Post, postUrl);
            request.Headers.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
            request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", token);
            request.Content = new StringContent(json, Encoding.UTF8, "application/json");
            var client = new HttpClient();
            await client.SendAsync(request);
        }

        public static async Task AssignLicenseAsync(this GraphService service, User user)
        {
            var subscribedSkus = await (await service.subscribedSkus.ExecuteAsync()).GetAllAsnyc();

            foreach (ISubscribedSku sku in subscribedSkus)
            {
                //E3 Tenant = ENTERPRISEPACK
                //E4 Tenant = ENTERPRISEPACKWITHCAL

                if (sku.skuPartNumber == "ENTERPRISEPACK")
                {
                    if ((sku.prepaidUnits.enabled.Value > sku.consumedUnits) &&
                        (sku.capabilityStatus == "Enabled"))
                    {
                        // create addLicense object and assign the Enterprise Sku GUID to the skuId
                        AssignedLicense addLicense = new AssignedLicense { skuId = sku.skuId.Value };

                        foreach (ServicePlanInfo servicePlan in sku.servicePlans)
                        {
                            // ---+++--- AVAILABLE SERVICE PLANS ---+++---
                            // OFFICESUBSCRIPTION (Office Pro Plus)
                            // MCOSTANDARD (Lync Online)
                            // SHAREPOINTWAC (Office Web Apps)
                            // SHAREPOINTENTERPRISE (Sharepoint Online)
                            // EXCHANGE_S_ENTERPRISE (Exchange Online)


                            if (servicePlan.servicePlanName.Equals("MCOSTANDARD"))
                            {
                                addLicense.disabledPlans.Add(servicePlan.servicePlanId.Value.ToString());
                                break;
                            }
                        }

                        IList<AssignedLicense> licensesToAdd = new[] { addLicense };
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