using Microsoft.Graph;
using Microsoft.Office365.OutlookServices;
using Newtonsoft.Json.Linq;
using SuiteLevelWebApp.Services;
using SuiteLevelWebApp.Utils;
using System;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Threading.Tasks;
using System.Web.Mvc;
using Graph = Microsoft.Graph;

namespace SuiteLevelWebApp.Controllers
{
    [Authorize, HandleAdalException]
    public class TestController : Controller
    {
        public async Task<ActionResult> Index()
        {
            var service = await AuthenticationHelper.GetGraphServiceAsync();
            var users = await service.GetAllUsersAsync(i => i.accountEnabled == true);

            var names = string.Join(", ", users.Select(i => i.displayName));
            return Content(names);
        }

        public async Task<ActionResult> CreateGroup()
        {
            var service = await AuthenticationHelper.GetGraphServiceAsync();

            var group = new Group()
            {
                displayName = "Another Test Group " + DateTime.Now.ToString(),
                mailNickname = "testgroup",
                securityEnabled = false,
                mailEnabled = true,
                groupType = "Unified"
            };
            await service.groups.AddGroupAsync(group);

            var users = await service.GetAllUsersAsync();
            foreach (var user in users.OfType<Graph.User>())
                group.members.Add(user);
            await group.SaveChangesAsync();

            return Content(group.objectId);
        }

        public async Task<ActionResult> CreateADGroup()
        {
            var service = await AuthenticationHelper.GetGraphServiceAsync();

            var group = new Group()
            {
                displayName = "Another AD Test Group " + DateTime.Now.ToString(),
                securityEnabled = true,
                mailEnabled = false,
                mailNickname = "testgroup",
                description = "Repair People/Inspectors Group"
            };
            await service.groups.AddGroupAsync(group);

            var users = await service.GetAllUsersAsync();
            foreach (var user in users.OfType<Graph.User>())
                group.members.Add(user);
            await group.SaveChangesAsync();

            return Content(group.objectId);
        }

        public async Task<ActionResult> AddUserToGroup(string groupName = "Test Group")
        {
            var service = await AuthenticationHelper.GetGraphServiceAsync();

            var group = await service.GetGroupByDisplayNameAsync(groupName) as Graph.Group;
            var user = await service.GetFirstUserAsync(i => i.displayName == "Tenant Admin") as Graph.User;

            group.members.Add(user);
            await group.SaveChangesAsync();

            return Content("Success");
        }

        public async Task<ActionResult> TestGroupandUserProvision()
        {
            var graphService = AuthenticationHelper.GetGraphServiceAsync();
            using (var clientContext = await AuthenticationHelper.GetDemoSiteClientContextAsync())
            {
                SiteProvisioning siteProvisioning = new SiteProvisioning(clientContext);
                await siteProvisioning.AddGroupsAndUsersAsync(await graphService);
            }

            return Content("Success");
        }

        public async Task<ActionResult> TestAssignLicenseByProxy()
        {
            var service = await AuthenticationHelper.GetGraphServiceAsync();
            Graph.IUser user = await GraphServiceExtension.AddUserAsync(service, "testUser", "Test User", "1234Pass@word!");

            await GraphServiceExtension.AssignLicenseAsync(service, user as Graph.User);

            return Content("Success");
        }

        public async Task<ActionResult> TestAssignLicenseByHttpClient()
        {
            var service = await AuthenticationHelper.GetGraphServiceAsync();
            Graph.IUser user = await GraphServiceExtension.AddUserAsync(service, "testUser", "Test User", "1234Pass@word!");

            await GraphServiceExtension.AssignLicenseAsyncViaHttpClientAsync(service, user as Graph.User);

            return Content("Success");
        }

        public async Task<ActionResult> Messages()
        {
            var graphService = await AuthenticationHelper.GetGraphServiceAsync();
            var messages = await (await graphService.users.GetById(User.Identity.Name).Messages.ExecuteAsync()).GetAllAsnyc();
            string content = "messages count: " + messages.Count().ToString();
            return Content(content);
        }

        //Outlook API - Not used anymore
        public async Task<ActionResult> MessagesOutlook()
        {
            var service = await AuthenticationHelper.GetOutlookServiceAsync();
            var messages = (await service.Me.Messages.ExecuteAsync()).CurrentPage.ToArray();
            var content = string.Join("<br />", messages.Select(i => i.Subject));
            return Content(content);
        }

        public async Task<ActionResult> CreateEvent()
        {
            var service = await AuthenticationHelper.GetGraphServiceAsync();
            var @event = await CreateEventAsync(service);
            return Redirect(@event.WebLink);
        }

        public async Task<ActionResult> UploadVideo()
        {
            string token = await AuthenticationHelper.GetAccessTokenAsync(AppSettings.DemoSiteServiceResourceId); ;

            VideoPortalHelper helper = new VideoPortalHelper(token);

            string videoTitle = "Test - " + DateTime.Now.ToString();
            string videoDescription = "Description";
            string ChannelName = "TestUpload";
            string videoPhysicalPath = System.Web.HttpContext.Current.Server.MapPath("../") + "Content\\Videos\\LeakyFaucet[4].mp4";

            await helper.UploadVideoAsync(ChannelName, videoPhysicalPath, videoTitle, videoDescription);

            var message = "Video uploaded.";
            return Content(message);
        }

        public async Task<ActionResult> OneNote()
        {
            var token = await AuthenticationHelper.GetOneNoteAccessTokenAsync();
            var service = new OneNoteService(AADAppSettings.OneNoteResourceUrl, token);

            var notebookId = (await service.GetNoteBookAsync("Contoso Property Management")).Id;
            var sectionId = await service.GetSectionIdAsync(notebookId, "Au Residence");
            var pages = await service.GetPagesAsync(sectionId, 4);

            var content = string.Join("<br />",
                pages.Select(i => string.Format(@"<a href='{0}' target='_blank'>{1}</a>", i.WebUrl, i.Title)));
            return Content(content);
        }

        public async Task<ActionResult> OneNote_NoteBooks()
        {
            var token = await AuthenticationHelper.GetOneNoteAccessTokenAsync();

            var url = "https://www.onenote.com/api/beta/me/notes/notebooks";

            var client = new HttpClient();
            client.DefaultRequestHeaders.Add("Authorization", "Bearer " + token);
            client.DefaultRequestHeaders.Add("Accept", "application/json");
            using (var response = await client.GetAsync(url))
            {
                var books = await response.Content.ReadAsStringAsync();
                return Content(books);
            }
        }

        public async Task<ActionResult> OneNoteProd()
        {
            var token = await AuthenticationHelper.GetOneNoteAccessTokenAsync();

            var siteUrl = "https://TENANCY.sharepoint.com/sites/AuResidence";
            var url = string.Format("https://www.onenote.com/api/beta/myOrganization/siteCollections/FromUrl('{0}')", Server.UrlEncode(siteUrl));

            var client = new HttpClient();
            client.DefaultRequestHeaders.Add("Authorization", "Bearer " + token);
            client.DefaultRequestHeaders.Add("Accept", "application/json");
            using (var response = await client.GetAsync(url))
                return Content(response.ToString());
        }

        public async Task<ActionResult> GetUserPhoto(string email)
        {
            string userId = "ACCOUNT@TENANCY.onmicrosoft.com";
            if (!string.IsNullOrEmpty(email))
            {
                userId = email;
            }

            string token = await AuthenticationHelper.GetGraphAccessTokenAsync();

            Uri uri = new Uri(string.Format("{0}{1}/users/{2}/UserPhotos/48X48/$Value", AADAppSettings.GraphResourceUrl, AppSettings.DemoSiteCollectionOwner.Split('@')[1], userId));

            HttpWebRequest request = (HttpWebRequest)HttpWebRequest.Create(uri);

            request.Method = "GET";

            request.Headers.Add("Authorization", "Bearer " + token);

            try
            {
                using (HttpWebResponse response = (HttpWebResponse)request.GetResponse())
                {
                    if (response.StatusCode == HttpStatusCode.OK)
                    {
                        return Content("OK");
                    }
                }
            }
            catch (Exception el)
            {
                return Content(el.Message);
            }

            return Content("unknown error");
        }

        public async Task<ActionResult> GroupFiles()
        {
            var service = await AuthenticationHelper.GetGraphServiceAsync();

            var group = await service.GetGroupByDisplayNameAsync("Au Residence");
            var groupFetcher = service.groups.GetById(group.objectId);

            var files = await (await groupFetcher.files.ExecuteAsync()).GetAllAsnyc();

            var html = files.Any()
                ? string.Join("<br />", files.Select(i => i.name))
                : "No file was found";
            return Content(html);
        }

        //Outlook API - Not used anymore
        public async Task<ActionResult> GetUserPhotoOutlook(string email)
        {
            string userId = "ACCOUNT@TENANCY.onmicrosoft.com";
            if (!string.IsNullOrEmpty(email))
            {
                userId = email;
            }

            string token = await AuthenticationHelper.GetOutlookAccessTokenAsync();

            Uri uri = new Uri(string.Format("{0}api/beta/Users('{1}')/UserPhotos('48X48')/$Value", AADAppSettings.OutlookResourceId, userId));

            HttpWebRequest request = (HttpWebRequest)HttpWebRequest.Create(uri);

            request.Method = "GET";

            request.Headers.Add("Authorization", "Bearer " + token);

            try
            {
                using (HttpWebResponse response = (HttpWebResponse)request.GetResponse())
                {
                    if (response.StatusCode == HttpStatusCode.OK)
                    {
                        return Content("OK");
                    }
                }
            }
            catch (Exception el)
            {
                return Content(el.Message);
            }

            return Content("unknown error");
        }


        public async Task<ActionResult> GroupRecentDocuments()
        {
            var service = await AuthenticationHelper.GetGraphServiceAsync();

            var group = await service.GetGroupByDisplayNameAsync("Au Residence");
            var groupFetcher = service.groups.GetById(group.objectId);

            var recentEarliestDateTime = new DateTimeOffset(DateTime.UtcNow).AddDays(-7);
            var recentDocumentsCollection = await groupFetcher.files
                .Where(i => i.dateTimeLastModified > recentEarliestDateTime)
                .ExecuteAsync();
            var recentDocuments = await recentDocumentsCollection.GetAllAsnyc();

            var html = recentDocuments.Any()
                ? string.Join("<br />", recentDocuments.Select(i => i.name))
                : "No file was found";
            return Content(html);
        }

        public async Task<ActionResult> UploadFile()
        {
            var token = await AuthenticationHelper.GetGraphAccessTokenAsync();
            return View();
        }

        [HttpPost]
        public async Task<ActionResult> UploadToMe()
        {
            var token = await AuthenticationHelper.GetGraphAccessTokenAsync();

            if (Request.Files.Count > 0)
            {
                var file = Request.Files[0];

                if (file != null && file.ContentLength > 0)
                {

                    string requestUri = "https://graph.microsoft.com/beta/me/files";

                    string content = string.Format("{{type:'File',name:'{0}'}}", file.FileName);

                    HttpWebRequest request1 = (HttpWebRequest)HttpWebRequest.Create(requestUri);
                    request1.Method = "POST";
                    request1.Headers.Add("Authorization", token);
                    request1.ContentType = "application/json";

                    byte[] body = System.Text.ASCIIEncoding.UTF8.GetBytes(content);

                    using (Stream dataStream = request1.GetRequestStream())
                    {
                        dataStream.Write(body, 0, body.Length);
                    }

                    try
                    {
                        using (HttpWebResponse response = (HttpWebResponse)request1.GetResponse())
                        {
                            if (response.StatusCode == HttpStatusCode.OK)
                            {
                                StreamReader sr = new StreamReader(response.GetResponseStream());

                                string result = sr.ReadToEnd();
                            }
                        }
                    }
                    catch (Exception el)
                    {
                        throw el;
                    }

                    //byte[] body = new byte[file.InputStream.Length];
                    //file.InputStream.Read(body, 0, body.Length);

                    //HttpWebRequest request = (HttpWebRequest)HttpWebRequest.Create(requestUri);
                    //request.Method = "PUT";
                    //request.Headers.Add("Authorization", "Bearer " + token);

                    ////request.ContentLength = body.Length;
                    //using (Stream dataStream = request.GetRequestStream())
                    //{
                    //    dataStream.Write(body, 0, body.Length);
                    //}

                    //try
                    //{
                    //    using (HttpWebResponse response = (HttpWebResponse)request.GetResponse())
                    //    {
                    //        if (response.StatusCode == HttpStatusCode.Created)
                    //        {
                    //            //upload file successfully
                    //            //do something
                    //        }
                    //    }
                    //}
                    //catch
                    //{
                    //    throw;
                    //}
                }
            }

            return RedirectToAction("UploadFile");
        }

        public async Task<ActionResult> UploadToGroup()
        {
            var token = await AuthenticationHelper.GetGraphAccessTokenAsync();

            if (Request.Files.Count > 0)
            {
                var file = Request.Files[0];

                if (file != null && file.ContentLength > 0)
                {
                    string requestUri = "https://graph.microsoft.com/beta/TENANCT.sharepoint.com/groups/GROUP GUID/files";

                    string content = string.Format("{{type:'File',name:'{0}'}}", file.FileName);

                    HttpWebRequest request1 = (HttpWebRequest)HttpWebRequest.Create(requestUri);
                    request1.Method = "POST";
                    request1.Headers.Add("Authorization", token);
                    request1.ContentType = "application/json";

                    byte[] body = System.Text.ASCIIEncoding.UTF8.GetBytes(content);

                    using (Stream dataStream = request1.GetRequestStream())
                    {
                        dataStream.Write(body, 0, body.Length);
                    }

                    try
                    {
                        using (HttpWebResponse response = (HttpWebResponse)request1.GetResponse())
                        {
                            if (response.StatusCode == HttpStatusCode.OK)
                            {
                                StreamReader sr = new StreamReader(response.GetResponseStream());

                                string result = sr.ReadToEnd();
                            }
                        }
                    }
                    catch (Exception el)
                    {
                        throw el;
                    }

                    //byte[] body = new byte[file.InputStream.Length];
                    //file.InputStream.Read(body, 0, body.Length);

                    //HttpWebRequest request = (HttpWebRequest)HttpWebRequest.Create(requestUri);
                    //request.Method = "PUT";
                    //request.Headers.Add("Authorization", "Bearer " + token);

                    ////request.ContentLength = body.Length;
                    //using (Stream dataStream = request.GetRequestStream())
                    //{
                    //    dataStream.Write(body, 0, body.Length);
                    //}

                    //try
                    //{
                    //    using (HttpWebResponse response = (HttpWebResponse)request.GetResponse())
                    //    {
                    //        if (response.StatusCode == HttpStatusCode.Created)
                    //        {
                    //            //upload file successfully
                    //            //do something
                    //        }
                    //    }
                    //}
                    //catch
                    //{
                    //    throw;
                    //}
                }
            }

            return RedirectToAction("UploadFile");
        }

        //public async Task<ActionResult> GroupTasks()
        //{
        //    var service = await AuthenticationHelper.GetGraphServiceAsync();

        //    var group = await service.GetGroupByDisplayName("Au Residence");
        //    var tasks = await group.tasks.GetAll();

        //    var html = tasks.Any()
        //        ? string.Join("<br />", tasks.Select(i => i.title))
        //        : "No task was found";
        //    return Content(html);
        //}

        //public async Task<ActionResult> CreateTask()
        //{
        //    var service = await AuthenticationHelper.GetGraphServiceAsync();

        //    var group = await service.GetGroupByDisplayName("Au Residence");
        //    var groupFetcher = service.groups.GetById(group.objectId);

        //    var task = new Graph.Task
        //    {
        //        title = "Test Task " + DateTime.Now.ToString(),
        //        percentComplete = 0,
        //        startDate = DateTime.Today,
        //        dueDate = DateTime.Today.AddDays(1),
        //        // TODO: description = model.Description,
        //    };
        //    await groupFetcher.tasks.AddTaskAsync(task);
        //    return Content(task.id);
        //}

        public async Task<ActionResult> VerifyIssues()
        {
            var service = await AuthenticationHelper.GetGraphServiceAsync();
            string outlooktoken = await AuthenticationHelper.GetOutlookAccessTokenAsync();
            var outlookService = await AuthenticationHelper.GetOutlookServiceAsync();
            var GraphToken = await AuthenticationHelper.GetGraphAccessTokenAsync();

            #region get user photo
            string userId = "ACCOUNT@TENANCY.onmicrosoft.com";

            Uri uri = new Uri(string.Format("{0}api/beta/Users('{1}')/UserPhotos('48X48')/$Value", AADAppSettings.OutlookResourceId, userId));

            HttpWebRequest request = (HttpWebRequest)HttpWebRequest.Create(uri);

            request.Method = "GET";

            request.Headers.Add("Authorization", "Bearer " + outlooktoken);

            try
            {
                using (HttpWebResponse response = (HttpWebResponse)request.GetResponse())
                {
                    if (response.StatusCode == HttpStatusCode.OK)
                    {
                        ViewBag.personalphoto = "ok";
                    }
                }
            }
            catch (Exception el)
            {
                ViewBag.personalphoto = el.Message;
            }
            #endregion

            #region Add user to unified group
            try
            {
                var group1 = await service.GetGroupByDisplayNameAsync("Au Residence") as Graph.Group;
                var user1 = await service.GetFirstUserAsync(i => i.displayName == "Tenant Admin");

                var groupFetcher = service.groups.GetById(group1.objectId);
                await groupFetcher.members.AddDirectoryObjectAsync(user1);

                ViewBag.addUserToGroup = "ok";
            }

            catch (Exception el)
            {
                ViewBag.addUserToGroup = el.Message;
            }
            #endregion

            #region SharedCalendar
            try
            {
                var @event = await CreateEventAsync(service);
                ViewBag.sharedCalendar = @event.WebLink;
            }
            catch (Exception el)
            {
                ViewBag.sharedCalendar = el.Message;
            }

            #endregion

            #region email count
            try
            {
                var messages = await (await service.users.GetById(User.Identity.Name).Messages.ExecuteAsync()).GetAllAsnyc();
                ViewBag.messagescount = "Current messages count: " + messages.Count().ToString();
            }
            catch (Exception el)
            {
                ViewBag.messagescount = el.Message;
            }
            #endregion

            return View();
        }

        public async Task<ActionResult> Conversation()
        {
            var service = await AuthenticationHelper.GetGraphServiceAsync();

            var group = await service.GetGroupByDisplayNameAsync("Au Residence");
            var groupFetcher = service.groups.GetById(group.objectId);

            var conversation = await groupFetcher.Conversations.Take(1).ExecuteSingleAsync();

            if (conversation != null)
                return Json(conversation, JsonRequestBehavior.AllowGet);
            else
                return Content("No conversation");
        }

        public async Task<ActionResult> CalendarEvents()
        {
            var service = await AuthenticationHelper.GetGraphServiceAsync();

            var group = await service.GetGroupByDisplayNameAsync("Au Residence");
            {
                var sharedCalendar = group.Calendar;  // Known issue, current the Calendar property returns null.
                var calendarViewEvents = await group.CalendarView.GetAllAsnyc(); //Fails due to null Calendar property.
            }

            var groupFetcher = service.groups.GetById(group.objectId);
            var calendarEvents = await (await groupFetcher.Calendar.Events.ExecuteAsync()).GetAllAsnyc();

            var content = string.Join("<br />", calendarEvents.Select(i => i.Subject));
            return Content(content);
        }

        private async Task<Graph.Event> CreateEventAsync(GraphService service)
        {
            var group = await service.GetGroupByDisplayNameAsync("Au Residence") as Graph.Group;
            var groupFetcher = service.groups.GetById(group.objectId);

            //var calendar = group.Calendar; // null
            //// Workaround
            //if (calendar == null)
            //    calendar = await groupFetcher.Calendar.ExecuteAsync() as Graph.Calendar;

            var @event = new Graph.Event
            {
                Subject = "Test Event " + DateTime.Now.ToString(),
                Start = DateTime.Now.AddMinutes(30),
                End = DateTime.Now.AddMinutes(60),
                Body = new Graph.ItemBody
                {
                    Content = "Test Event"
                },
                Importance = Graph.Importance.Low,
                Reminder = 60 * 24
            };

            // The line below will cause an error:
            // Multiple navigation are currently not supported in write requests.
            // await groupFetcher.Calendar.Events.AddEventAsync(@event); 

            //calendar.Events.Add(@event);
            //await calendar.SaveChangesAsync();

            await groupFetcher.Events.AddEventAsync(@event);


            return @event;
        }

        public async Task<ActionResult> Group()
        {
            var service = AuthenticationHelper.GetGraphServiceAsync();
            var group = (await service).groups
               .Where(i => i.displayName == "Au Residence")
               .Take(1)
               .ExecuteSingleAsync();
            return Json(await group, JsonRequestBehavior.AllowGet);
        }

        public async Task<ActionResult> Me()
        {
            var service = AuthenticationHelper.GetGraphServiceAsync();
            var messages = (await service).Me.Messages.ExecuteAsync();
            var content = string.Join("<br />", (await messages).CurrentPage.Select(i => i.Body.Content));
            return Content(content);
        }

        public async Task<ActionResult> CreateUnifiedGroupsForProperties()
        {
            var graphService = AuthenticationHelper.GetGraphServiceAsync();

            using (var clientContext = await AuthenticationHelper.GetDemoSiteClientContextAsync())
            {
                var siteProvisioning = new SiteProvisioning(clientContext);
                await siteProvisioning.CreateUnifiedGroupsForPropertiesAsync(await graphService);
            }
            return Content("Success");
        }

        public async Task<ActionResult> DeleteAllPropertyGroups()
        {
            var service = await AuthenticationHelper.GetGraphServiceAsync();

            var groups = await (await service.groups.ExecuteAsync()).GetAllAsnyc();
            var propertyGroups = groups
                .Where(i => i.description == "Property Group")
                .ToArray();

            foreach (var group in propertyGroups)
                await group.DeleteAsync();

            return Content(propertyGroups.Length + " property group(s) have been deleted.");
        }

        public async Task<ActionResult> AddUserToAllPropertyGroups(string userName)
        {
            var service = await AuthenticationHelper.GetGraphServiceAsync();

            var user = (await service.GetFirstUserAsync(i => i.displayName == userName)) as Graph.User;

            var groups = await (await service.groups.ExecuteAsync()).GetAllAsnyc();
            var propertyGroups = groups
                .Where(i => i.description == "Property Group")
                .ToArray();

            foreach (var group in propertyGroups.OfType<Group>())
            {
                group.members.Add(user);
                try
                {
                    await group.SaveChangesAsync();
                }
                catch { }
            }
            return Content("Success");
        }

        public async Task<ActionResult> TestCreateChannel()
        {
            //please replace <Channel Name> with a new channel name for testing
            string ChannelName = "Test " + DateTime.Now.ToString();
            
            var token = AuthenticationHelper.GetAccessTokenAsync(AppSettings.DemoSiteServiceResourceId);
            VideoPortalHelper videoPortalHelper = new VideoPortalHelper(await token);

            return Content(await videoPortalHelper.CreateChannelAsync(ChannelName));            
        }
    }
}