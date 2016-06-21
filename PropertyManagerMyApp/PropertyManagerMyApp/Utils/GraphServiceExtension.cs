using Microsoft.Graph;
using SuiteLevelWebApp.Utils;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Linq.Expressions;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Threading.Tasks;
using Newtonsoft.Json;
using utils = SuiteLevelWebApp.Utils;
using System.Net;
using System.IO;

namespace SuiteLevelWebApp
{
    public static class GraphServiceExtension
    {
        //Extension methods for the Microsoft.Graph.GraphService returned
        //by the GetGraphServiceAsync() method in the AuthenticationHelper class.

        //Controllers use these extension methods to interact with the Microsoft.Graph.GraphService
        public static async Task<User[]> GetAllUsersAsync(this GraphServiceClient service)
        {
            var tenantDetails = await service.Users
                .Request().GetAllAsnyc();
            return tenantDetails;
        }

        public static async Task<User[]> GetAllUsersAsync(this GraphServiceClient service, IEnumerable<string> displayNames)
        {
            var users = await service.Users.Request().GetAllAsnyc();
            var retUsers = users.Where(x => displayNames.Contains(x.DisplayName)).ToArray();

            return retUsers;
        }

        public static async Task<Group> GetGroupByDisplayNameAsync(this GraphServiceClient service, string displayName)
        {
            var groups = (await service.Groups.Request().Filter(string.Format("displayName eq '{0}'", displayName)).Top(1).GetAsync()).CurrentPage;
            return groups.Count > 0 ? groups[0] : null;
        }

        public static async Task<Group> AddGroupAsync(this GraphServiceClient service, string Name, string DisplayName, string Description)
        {
            Group newGroup = new Group
            {
                DisplayName = DisplayName,
                Description = Description,
                MailNickname = Name,
                MailEnabled = false,
                SecurityEnabled = true
            };
            try
            {
                newGroup = await service.Groups.Request().AddAsync(newGroup);
                return newGroup;
            }
            catch (Exception e)
            {
                throw e;
            }
        }

        public static async Task<User> AddUserAsync(this GraphServiceClient service, /*string LoginName, string DisplayName, string Password*/User user)
        {
            User newUser = await service.Users.Request().AddAsync(user);

            return newUser;
        }

        public static async Task<User[]> GetGroupMembersAsync(this GraphServiceClient service, string groupName)
        {
            var group = await GetGroupByDisplayNameAsync(service, groupName);

            if (group == null) return new User[0];

            var groupFetcher = service.Groups[group.Id];
            return await GetGroupMembersAsync(service, groupFetcher);
        }

        public static async Task<User[]> GetGroupMembersAsync(this GraphServiceClient service, IGroupRequestBuilder groupFetcher)
        {
            List<User> users = new List<User>();
            var collection = await groupFetcher.Members.Request().GetAllAsnyc();
            foreach (var item in collection)
            {
                var findUser = await service.Users[item.Id].Request().Select("id,displayName,department,officeLocation,mail,mobilePhone,businessPhones,jobTitle").GetAsync();
                if (findUser != null)
                    users.Add(findUser);
            }

            return users.ToArray();
        }

        public static async Task AddUserToGroupMembersAsync(this GraphServiceClient service, Group group, User user, string accessToken)
        {
            
            var requestMessage = new HttpRequestMessage(HttpMethod.Post, string.Format("{0}groups/{1}/members/$ref", AADAppSettings.GraphResourceUrl, group.Id));
            var odataID = string.Format("{0}directoryObjects/{1}", AADAppSettings.GraphResourceUrl, user.Id);
            Dictionary<string, string> oData = new Dictionary<string, string>();
            oData.Add("@odata.id", odataID);
            requestMessage.Content = new StringContent(JsonConvert.SerializeObject(oData), System.Text.Encoding.UTF8, "application/json");

            using (var client = new HttpClient())
            {
                client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);
                client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                var responseMessage = await client.SendAsync(requestMessage);

                if (responseMessage.StatusCode != System.Net.HttpStatusCode.NoContent)
                    throw new Exception();
            }
            return;
        }
        public static async Task AddUserToGroupOwnersAsync(this GraphServiceClient service, Group group, User user, string accessToken)
        {
            var requestMessage = new HttpRequestMessage(HttpMethod.Post, string.Format("{0}groups/{1}/owners/$ref", AADAppSettings.GraphResourceUrl, group.Id));
            var odataID = string.Format("{0}users/{1}", AADAppSettings.GraphResourceUrl, user.Id);
            Dictionary<string, string> oData = new Dictionary<string, string>();
            oData.Add("@odata.id", odataID);
            requestMessage.Content = new StringContent(JsonConvert.SerializeObject(oData), System.Text.Encoding.UTF8, "application/json");

            using (var client = new HttpClient())
            {
                client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);
                client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                var responseMessage = await client.SendAsync(requestMessage);

                if (responseMessage.StatusCode != System.Net.HttpStatusCode.NoContent)
                    throw new Exception();
            }
            return;
        }


        public static async Task AssignLicenseAsyncViaHttpClientAsync(this GraphServiceClient service, string GraphAccessToken, User user)
        {
            var subscribedSkus = await service.SubscribedSkus.Request().GetAllAsnyc();
            Guid skuId = Guid.Empty;

            foreach (SubscribedSku sku in subscribedSkus)
            {
                if ((sku.PrepaidUnits.Enabled.Value > sku.ConsumedUnits) &&
                        (sku.CapabilityStatus == "Enabled"))
                {
                    skuId = sku.SkuId.Value;

                    string json = string.Format("{{\"addLicenses\":[{{\"@odata.type\":\"#Microsoft.Graph.AssignedLicense\",\"disabledPlans\":[],\"skuId\":\"{0}\"}}],\"removeLicenses\":[]}}", skuId.ToString());

                    string postUrl = string.Format("{0}{1}/users('{2}')/Microsoft.Graph.assignLicense", AADAppSettings.GraphResourceUrl, AppSettings.DemoSiteCollectionOwner.Split('@')[1], user.Id);

                    var request = new HttpRequestMessage(HttpMethod.Post, postUrl);
                    request.Headers.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", GraphAccessToken);
                    request.Content = new StringContent(json, Encoding.UTF8, "application/json");
                    var client = new HttpClient();
                    await client.SendAsync(request);
                }
            } 
        }

        public static async Task<Subscription> GetSubscriptionAsync(this GraphServiceClient service, string graphAccessToken, string subscriptionId)
        {
            Subscription subscription = null;
            try
            {
                SubscriptionRequestBuilder builder = new SubscriptionRequestBuilder(string.Format("{0}subscriptions/{1}", AADAppSettings.GraphResourceUrl, subscriptionId), new BaseClient(AADAppSettings.GraphResourceUrl,
                                        new DelegateAuthenticationProvider(
                                            (requestMessage) =>
                                            {
                                                requestMessage.Headers.Authorization = new AuthenticationHeaderValue("bearer", graphAccessToken);
                                                requestMessage.Method = HttpMethod.Get;
                                                requestMessage.Headers.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                                                return Task.FromResult(0);
                                            })));
                subscription = await builder.Request().GetAsync();
            }
            catch
            {
                
            }
            return subscription;
        }

        public static async Task<Subscription> CreateSubscriptionAsync(this GraphServiceClient service, string graphAccessToken)
        {
            Subscription subscription = new Subscription()
            {
                ChangeType = "created,updated",
                ClientState = Guid.NewGuid().ToString(),
                //https://graph.microsoft.io/en-us/docs/api-reference/v1.0/resources/subscription
                ExpirationDateTime = DateTime.UtcNow + new TimeSpan(0, 2, 0, 0),//TimeSpan.FromMinutes(4230),//
                NotificationUrl = ConfigurationManager.AppSettings["NotificationUrl"],
                Resource = "me/mailFolders('Inbox')/messages"
            };
            int retrycount = 5;
            while (retrycount-- > 0)
            {
                try
                {
                    SubscriptionRequestBuilder builder = new SubscriptionRequestBuilder(string.Format("{0}subscriptions", AADAppSettings.GraphResourceUrl), new BaseClient(AADAppSettings.GraphResourceUrl,
                                            new DelegateAuthenticationProvider(
                                                (requestMessage) =>
                                                {
                                                    requestMessage.Headers.Authorization = new AuthenticationHeaderValue("bearer", graphAccessToken);
                                                    requestMessage.Method = HttpMethod.Post;
                                                    requestMessage.Headers.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                                                    return Task.FromResult(0);
                                                })));
                    subscription = await builder.Request().CreateAsync(subscription);

                    break;
                }
                catch
                {

                }
            }
            return subscription.Id != null ? subscription : null;
        }
        public static async Task DeleteSubscriptionAsync(this GraphServiceClient service, string graphAccessToken, string subscriptionId)
        {
            try
            {
                var accessToken = await AuthenticationHelper.GetGraphAccessTokenAsync();
                SubscriptionRequestBuilder builder = new Microsoft.Graph.SubscriptionRequestBuilder(string.Format("{0}subscriptions/{1}", AADAppSettings.GraphResourceUrl, subscriptionId), new Microsoft.Graph.BaseClient(AADAppSettings.GraphResourceUrl,
                                                                        new DelegateAuthenticationProvider(
                                                                            (requestMessage) =>
                                                                            {
                                                                                requestMessage.Headers.Authorization = new AuthenticationHeaderValue("bearer", accessToken);
                                                                                requestMessage.Method = HttpMethod.Delete;
                                                                                requestMessage.Headers.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                                                                                return Task.FromResult(0);
                                                                            })));

                await builder.Request().DeleteAsync();
                return;
            }
            catch (Exception ex)
            {
                //throw ex;
            }

        }

        //public static async Task AssignLicenseAsync(this GraphServiceClient service, User user)
        //{
        //    var subscribedSkus = await service.SubscribedSkus.Request().GetAllAsnyc();

        //    foreach (SubscribedSku sku in subscribedSkus)
        //    {
        //        //E3 Tenant = ENTERPRISEPACK
        //        //E4 Tenant = ENTERPRISEPACKWITHCAL

        //        if (sku.SkuPartNumber == "ENTERPRISEPACK")
        //        {
        //            if ((sku.PrepaidUnits.Enabled.Value > sku.ConsumedUnits) &&
        //                (sku.CapabilityStatus == "Enabled"))
        //            {
        //                // create addLicense object and assign the Enterprise Sku GUID to the skuId
        //                AssignedLicense addLicense = new AssignedLicense { SkuId = sku.SkuId.Value };

        //                foreach (ServicePlanInfo servicePlan in sku.ServicePlans)
        //                {
        //                    // ---+++--- AVAILABLE SERVICE PLANS ---+++---
        //                    // OFFICESUBSCRIPTION (Office Pro Plus)
        //                    // MCOSTANDARD (Lync Online)
        //                    // SHAREPOINTWAC (Office Web Apps)
        //                    // SHAREPOINTENTERPRISE (Sharepoint Online)
        //                    // EXCHANGE_S_ENTERPRISE (Exchange Online)


        //                    if (servicePlan.ServicePlanName.Equals("MCOSTANDARD"))
        //                    {
        //                        //UPGrade SDK
        //                        addLicense.DisabledPlans.ToList().Add(servicePlan.ServicePlanId.Value);
        //                        break;
        //                    }
        //                }

        //                IList<AssignedLicense> licensesToAdd = new[] { addLicense };
        //               // IList<Guid> licensesToRemove = new Guid[] { };

        //                // attempt to assign the license object to the new user 
        //                try
        //                {
        //                    //await user.assignLicenseAsync(licensesToAdd, licensesToRemove);

        //                    user.AssignedLicenses.ToList().AddRange(licensesToAdd/*, licensesToRemove*/);
        //                }
        //                catch (Exception e)
        //                {
        //                    throw e;
        //                }
        //            }
        //        }
        //    }
        //}
    }
}