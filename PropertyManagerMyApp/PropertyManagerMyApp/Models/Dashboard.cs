using Microsoft.Graph;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using SuiteLevelWebApp.Services;
using SuiteLevelWebApp.Utils;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Linq.Expressions;
using System.Net;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using System.Web;
using Graph = Microsoft.Graph;
using GraphModelsExtension;

namespace SuiteLevelWebApp.Models
{
    public class Dashboard
    {
        static Dictionary<string, string> IncidentStatusViewMappings = new Dictionary<string, string>
            {
                { "Pending Assignment", "ScheduleRepair"},
                { "Repair Assigned", "RepairInProgress"},
                { "Repair Pending Approval", "RepairComplete"},
                { "Repair Approved", "RepairApproved"}
            };

        #region private properties
        private Dictionary<int, string> _cachePropertyPhotos = new Dictionary<int, string>();
        private string _token = string.Empty;
        #endregion

        #region constructor
        public Dashboard(string token)
        {
            _token = token;
        }
        #endregion

        #region public methods
        public async Task<DashboardPropertyViewModel> GetDashboardPropertiesViewModelAsync(int propertyId = 0)
        {
            var inspections = (await GetInspectionsByPropertyIdAsync(propertyId)).ToList();
            var incidents = (await GetIncidentsByPropertyIdAsync(propertyId)).ToList();

            DashboardPropertyViewModel viewModel = new DashboardPropertyViewModel();

            foreach (var inspection in inspections)
            {
                if (inspection.sl_propertyID != null)
                {
                    if (inspection.sl_propertyID.Id > 0)
                    {
                        inspection.sl_propertyID.propertyImgUrl = await GetPropertyPhotoAsync(inspection.sl_propertyID.Id);

                        if (propertyId > 0 && viewModel.PropertyDetail == null)
                        {
                            viewModel.PropertyDetail = inspection.sl_propertyID;
                        }
                    }
                }
            }

            foreach (var incident in incidents)
            {
                if (incident.sl_inspectionIDId != null)
                {
                    incident.inspection = inspections.Where(i => i.Id == incident.sl_inspectionIDId.Value).FirstOrDefault();
                }

                if (incident.sl_propertyID.Id > 0)
                {
                    incident.sl_propertyID.propertyImgUrl = await GetPropertyPhotoAsync(incident.sl_propertyID.Id);
                }
            }

            viewModel.Inspections = inspections;
            viewModel.Incidents = incidents;

            return viewModel;
        }

        public async Task<DashboardInspectionDetailsViewModel> GetDashboardInspectionDetailsViewModelAsync(GraphServiceClient graphService, int incidentId, string CurrentUser)
        {
            Graph.User[] getRepairPeople = null;
            Task<RepairPhoto[]> getRepairPhotos = null;

            var videos = await GetVideosAsync(AppSettings.VideoPortalIncidentsChannelName, incidentId);

            var incident = await GetIncidentByIdAsync(incidentId);
            if (incident.sl_inspectionIDId == null) return null;

            var property = incident.sl_propertyID;
            var propertyImgUrl = GetPropertyPhotoAsync(property.Id);

            var inspectionID = incident.sl_inspectionIDId.Value;
            var inspection = await GetInspectionByIdAsync(inspectionID);
            var getInspectionPhotos = await GetInspectionPhotosAsync(inspectionID);

            var incidentStatus = incident.sl_status;
            if (incidentStatus == "Pending Assignment")
            {
                getRepairPeople = await graphService.GetGroupMembersAsync("Repair People");
            }
                

            if (incidentStatus == "Repair Pending Approval" || incidentStatus == "Repair Approved")
                getRepairPhotos = GetRepairPhotosAsync(incidentId);

            var unifiedGroupFetcher = graphService.Groups[property.sl_group];
            var unifiedGroup = await unifiedGroupFetcher.Request().GetAsync();
            var groupFiles = await GetGroupFilesAsync(unifiedGroupFetcher);
            var groupConversations = await GetConversationsAsync(unifiedGroupFetcher, unifiedGroup.Mail);
            var propertyExcelWorkbook = await ExcelService.GetPropertyExcelWorkbooksAsync(property.sl_group);

            var notebook = await OneNoteService.GetNoteBookByNameAsync(unifiedGroup, unifiedGroup.DisplayName + " Notebook");
            var oneNotePages = (notebook != null)
                ? await Services.OneNoteService.GetOneNotePagesAsync(graphService, unifiedGroup)
                : await Task.FromResult(new HyperLink[0]);

            var groupMembers = await graphService.GetGroupMembersAsync(unifiedGroupFetcher);

            var plan = await PlanService.GetPlanAsync(unifiedGroup);
            List<O365Task> tasks = new List<O365Task>();
            if (plan != null)
            {
                tasks = await GetO365TasksAsync(graphService, plan);
            }

            var recentEarliestDateTime = new DateTimeOffset(DateTime.UtcNow).AddDays(-7);
            var recentDocuments = groupFiles
                .Where(i => i.dateTimeLastModified > recentEarliestDateTime)
                .ToList();

            property.propertyImgUrl = await propertyImgUrl;

            var isCurrentUserDispatcher = CurrentUser == AppSettings.DispatcherEmail;

            var bannotateImage = true;
            if (notebook == null || string.IsNullOrEmpty(notebook.oneNoteWebUrl)||
                oneNotePages.Where(x => x.Title.ToString().Equals(string.Format("Incident[{0}]", incidentId))).Count() > 0)
            {
                bannotateImage = false;
            }
            var viewModel = new DashboardInspectionDetailsViewModel
            {
                viewName = IncidentStatusViewMappings[incidentStatus],
                PropertyDetail = property,
                incidentId = incidentId,
                incident = incident,
                UnifiedGroupNickName = unifiedGroup.MailNickname,
                UnifiedGroupId = unifiedGroup.Id,
                UnifiedGroupEmail = unifiedGroup.Mail,
                inspection = inspection,
                videos = videos,
                files = groupFiles
                    .Select(i => HyperLink.Create(i.name, i.webUrl, i.id))
                    .ToArray(),
                recentDocuments = recentDocuments
                    .Select(i => HyperLink.Create(i.name, i.webUrl, i.id))
                    .ToArray(),
                members = groupMembers,
                roomInspectionPhotos = getInspectionPhotos,
                inspectionComment = await GetInspectionCommentAsync(inspectionID, incident.sl_roomID.Id),
                tasks = tasks.ToArray(),
                repairPeople = getRepairPeople != null ? getRepairPeople : new Graph.User[0],
                repairPhotos = getRepairPhotos != null ? await getRepairPhotos : new RepairPhoto[0],
                DispatcherMails = isCurrentUserDispatcher ? await GetMailsForDispatcherAsync(graphService, CurrentUser) : new HyperLink[0],
                oneNotePages = oneNotePages,
                oneNoteUrl = notebook != null ? notebook.oneNoteWebUrl: "",
                conversations = groupConversations,
                PlanId = plan != null ? plan.id : string.Empty,
                PropertyExcelWorkbook =  propertyExcelWorkbook,
                bAnnotateImage = bannotateImage
            };
            return viewModel;
        }
        public async Task UpdateRepairScheduleInfoToIncidentAsync(ScheduleRepairModel model)
        {
            ScheduleRepairUpdate updateJson = new ScheduleRepairUpdate();
            updateJson.sl_dispatcherComments = model.DispatcherComments;
            updateJson.sl_repairScheduled = model.TimeSlotsSelectedValue.ToUniversalTime();
            updateJson.sl_repairPerson = model.RepairPeopleSelectedValue;
            updateJson.__metadata = new metadata { type = "SP.Data.IncidentsListItem" };
            await SuiteLevelWebApp.Utils.RestHelper.PostRestDataToDemoSiteAsync("/_api/lists/GetByTitle('Incidents')/Items(" + model.IncidentId + ")", JsonConvert.SerializeObject(updateJson), _token);
        }

        public async Task ScheduleRepairAsync(GraphServiceClient graphService, ScheduleRepairModel model)
        {
            var incident = await GetIncidentByIdAsync(model.IncidentId);
            var repairPeople = await GetRepairPeopleByEmailAddressAsync(model.RepairPeopleSelectedValue);

            string body = string.Format("<p>{0}</p><br/><br/><p>Incident ID: <span id='x_IncidentID'>{1}</span><br/><br/>Property ID: <span id='x_PropertyID'>{2}</span></p>",
                    incident.sl_dispatcherComments,
                    incident.Id,
                    incident.sl_propertyID.Id
                );

            var attendee = new Graph.Attendee

            {
                EmailAddress = new EmailAddress
                {
                    Address = repairPeople.sl_emailaddress,
                    Name = repairPeople.Title
                },
                Type = AttendeeType.Required,
                Status = new ResponseStatus()
            };

            var newEvent = new Graph.Event
            {
                Subject = "Repair Event",
                Body = new ItemBody
                {
                    Content = body,
                    ContentType = BodyType.Html
                },
                ShowAs = FreeBusyStatus.Busy,
                Start = new DateTimeTimeZone
                {
                    DateTime = model.TimeSlotsSelectedValue.ToString(),
                    TimeZone = TimeZone.CurrentTimeZone.StandardName
                },
                End = new DateTimeTimeZone
                {
                    DateTime = (model.TimeSlotsSelectedValue.AddHours(1)).ToString(),
                    TimeZone = TimeZone.CurrentTimeZone.StandardName
                },
                Location = new Location
                {
                    Address = new PhysicalAddress(),
                 //   Coordinates = new outlookGeoCoordinates(),
                    DisplayName = incident.sl_roomID.Title,

                },
                Attendees = new Attendee[] { attendee }
            };

            try
            {
                newEvent = await graphService.Me.Events.Request().AddAsync(newEvent);
            }
            catch
            { }
        }

        public async Task CreateO365TaskAsync(GraphServiceClient graphService, ScheduleRepairModel model)
        {
            var incident = await GetIncidentByIdAsync(model.IncidentId);
            var repairPeopleMail = (await GetRepairPeopleByEmailAddressAsync(model.RepairPeopleSelectedValue)).sl_emailaddress;
            var repairPeopleList = (await graphService.Users.Request().Filter(string.Format("mail eq '{0}'", repairPeopleMail)).Top(1).GetAsync()).CurrentPage;
            var repairPeople = repairPeopleList.Count > 0 ? repairPeopleList[0] : null;
            if (repairPeople == null) return;
            var me = graphService.Me.Request().GetAsync();
            var property = incident.sl_propertyID;
            var unifiedGroup = await graphService.Groups[property.sl_group].Request().GetAsync();

            var plan = PlanService.GetPlanAsync(unifiedGroup);

            if (await plan == null) return;

            var incidentBucket = PlanService.CreateBucketAsync(new Bucket
            {
                name = string.Format("Incident [{0}]", incident.Id),
                planId = (await plan).id
            });

            await PlanService.CreateTaskAsync(new task
            {
                title = "Clean up work site",
                assignedTo = repairPeople.Id,
                assignedBy = (await me).Id,
                percentComplete = 0,
                planId = (await incidentBucket).planId,
                bucketId = (await incidentBucket).id,
                dueDateTime = new DateTimeOffset(model.TimeSlotsSelectedValue)
            });

            await PlanService.CreateTaskAsync(new task
            {
                title = "Have property owner sign repair completion document",
                assignedTo = repairPeople.Id,
                assignedBy = (await me).Id,
                percentComplete = 0,
                planId = (await incidentBucket).planId,
                bucketId = (await incidentBucket).id,
                dueDateTime = new DateTimeOffset(model.TimeSlotsSelectedValue)
            });

            await PlanService.CreateTaskAsync(new task
            {
                title = "Call property owner to confirm repair appointment",
                assignedTo = repairPeople.Id,
                assignedBy = (await me).Id,
                percentComplete = 0,
                planId = (await incidentBucket).planId,
                bucketId = (await incidentBucket).id,
                dueDateTime = new DateTimeOffset(model.TimeSlotsSelectedValue)
            });
        }

        public async Task CreateGroupRepairEventAsync(GraphServiceClient graphService, ScheduleRepairModel model)
        {
            var incident = await GetIncidentByIdAsync(model.IncidentId);
            var property = incident.sl_propertyID;
            var unifiedGroupFetcher = graphService.Groups[property.sl_group];
            string body = string.Format("<p>{0}</p><br/><br/><p>Incident ID: <span id='x_IncidentID'>{1}</span><br/><br/>Property ID: <span id='x_PropertyID'>{2}</span></p>",
                    incident.sl_dispatcherComments,
                    incident.Id,
                    property.Id
                );

            var newEvent = new Graph.Event
            {
                Subject = "Repair Event",
                Body = new ItemBody
                {
                    Content = body,
                    ContentType = BodyType.Html
                },
                ShowAs = FreeBusyStatus.Busy,
                Start = new DateTimeTimeZone
                {
                    DateTime = model.TimeSlotsSelectedValue.ToString(),
                    TimeZone = TimeZone.CurrentTimeZone.StandardName
                },
                End = new DateTimeTimeZone
                {
                    DateTime = (model.TimeSlotsSelectedValue.AddHours(1)).ToString(),
                    TimeZone = TimeZone.CurrentTimeZone.StandardName
                },
                Location = new Location
                {
                    DisplayName = incident.sl_roomID.Title,
                    Address = new PhysicalAddress(),
                    //coordinates = new outlookGeoCoordinates()
                },
                ReminderMinutesBeforeStart = 60 * 24
            };

            try
            {
                newEvent = await unifiedGroupFetcher.Events.Request().AddAsync(newEvent);
            }
            catch
            { }
        }

        public async Task ApproveRepairAsync(int incidentId)
        {
            ApproveRepairUpdate updateJson = new ApproveRepairUpdate();
            updateJson.sl_repairApproved = System.DateTime.Now;
            updateJson.__metadata = new metadata { type = "SP.Data.IncidentsListItem" };
            await SuiteLevelWebApp.Utils.RestHelper.PostRestDataToDemoSiteAsync("/_api/lists/GetByTitle('Incidents')/Items(" + incidentId + ")", JsonConvert.SerializeObject(updateJson), _token);
        }

        public async Task<string> AnnotateImagesAsync(GraphServiceClient graphService, string siteRootDirectory, int incidentId)
        {
            var getIncident = GetIncidentByIdAsync(incidentId);
            var incidentVideos = GetVideosAsync(AppSettings.VideoPortalIncidentsChannelName, incidentId);

            var incident = await getIncident;
            var property = incident.sl_propertyID;

            var unifiedGroupFetcher = graphService.Groups[property.sl_group];
            var unifiedGroup = await unifiedGroupFetcher.Request().GetAsync();

            var notebookName = unifiedGroup.DisplayName + " Notebook";
            var notebook = await OneNoteService.GetNoteBookByNameAsync(unifiedGroup, notebookName);

            var section = await OneNoteService.GetOrCreateSectionIdAsync(notebook.sectionsUrl, property.Title);

            var inspectionPhotos = GetInspectionOrRepairPhotosAsync("Room Inspection Photos", incident.sl_inspectionIDId.Value, incident.sl_roomID.Id);

            var pageUrl = await OneNoteService.CreatePageForIncidentAsync(graphService, siteRootDirectory, unifiedGroup, section, incident, await inspectionPhotos, await incidentVideos);


            return pageUrl;
        }

        public async Task<bool> UploadFileAsync(GraphServiceClient graphService, UploadFileModel model)
        {
            try
            {
                var graphToken = AuthenticationHelper.GetGraphAccessTokenAsync();
                var propertyGroup = await graphService.GetGroupByDisplayNameAsync(model.PropertyTitle);

                if (propertyGroup == null) return false;

                DriveItem driveItem = new DriveItem();
                driveItem.Name = model.File.FileName;
                driveItem.File = new Microsoft.Graph.File();
                driveItem = await graphService.Groups[propertyGroup.Id].Drive.Root.Children.Request().AddAsync(driveItem);
                await graphService.Groups[propertyGroup.Id].Drive.Items[driveItem.Id].Content.Request().PutAsync<DriveItem>(model.File.InputStream);
            }
            catch (Exception el)
            {
                throw el;
            }
            return false;
        }

        public async Task CheckSubscriptionAsync(GraphServiceClient graphService, string accessToken)
        {
            Subscription subscription = System.Web.HttpContext.Current.Session["WebHookSubscription"] as Subscription;
            if (subscription != null && subscription.ExpirationDateTime.HasValue)
            {
                DateTimeOffset expiration = (DateTimeOffset)subscription.ExpirationDateTime;
                //check time
                if (DateTimeOffset.Now.CompareTo(expiration) >= 0)
                {
                    //delete old and recreate one
                    await graphService.DeleteSubscriptionAsync(accessToken, subscription.Id);
                    subscription = await graphService.CreateSubscriptionAsync(accessToken);
                    if (subscription != null)
                    {
                        System.Web.HttpContext.Current.Session["WebHookSubscription"] = subscription;
                    }
                }
            }
            else
            {
                subscription = await graphService.CreateSubscriptionAsync(accessToken);
                if (subscription != null)
                {
                    System.Web.HttpContext.Current.Session["WebHookSubscription"] = subscription;
                }
            }
        }

        #endregion

        #region private methods
        private async Task<Inspection[]> GetInspectionsByPropertyIdAsync(int propertyId = 0)
        {
            string resturl = "/_api/lists/GetByTitle('Inspections')/Items?"
                + "$select=Id,sl_datetime,sl_finalized,sl_inspector,sl_emailaddress,sl_propertyID/Id,sl_propertyID/Title,sl_propertyID/sl_owner,sl_propertyID/sl_address1,sl_propertyID/sl_address2"
                + "&$expand=sl_propertyID/Id,sl_propertyID/Title,sl_propertyID/sl_owner,sl_propertyID/sl_address1,sl_propertyID/sl_address2";

            if (propertyId > 0)
            {
                resturl += string.Format("&$Filter=(sl_propertyIDId eq {0})", propertyId);
            }
            string responseString = await RestHelper.GetDemoSiteJsonAsync(resturl, _token);
            return JObject.Parse(responseString)["d"]["results"].ToObject<Inspection[]>();

        }

        private async Task<Incident[]> GetIncidentsByPropertyIdAsync(int propertyId = 0)
        {
            string resturl = "/_api/lists/GetByTitle('Incidents')/Items?"
                + "$select=Id,sl_inspectionIDId,sl_status,sl_repairScheduled,sl_repairCompleted,sl_repairApproved,sl_propertyID/Id,sl_propertyID/Title,sl_propertyID/sl_owner,sl_roomID/Id,sl_roomID/Title"
                + "&$expand=sl_propertyID/Id,sl_propertyID/Title,sl_propertyID/sl_owner,sl_roomID/Id,sl_roomID/Title";

            if (propertyId > 0)
            {
                resturl += string.Format("&$Filter=(sl_propertyIDId eq {0})", propertyId);
            }

            string responseString = await RestHelper.GetDemoSiteJsonAsync(resturl, _token);
            return JObject.Parse(responseString)["d"]["results"].ToObject<Incident[]>();
        }

        private async Task<string> GetPropertyPhotoAsync(int Id)
        {
            if (_cachePropertyPhotos.ContainsKey(Id))
            {
                return _cachePropertyPhotos[Id];
            }
            string resturl = string.Format("/_api/lists/GetByTitle('Property Photos')/Items?$select=Id&$Filter=(sl_propertyIDId eq {0})", Id);

            string responseString = await RestHelper.GetDemoSiteJsonAsync(resturl, _token);

            string id = JObject.Parse(responseString)["d"]["results"][0]["Id"].ToString();

            resturl = string.Format("/_api/lists/GetByTitle('Property Photos')/Items({0})/File?$select=ServerRelativeUrl", id);

            responseString = await RestHelper.GetDemoSiteJsonAsync(resturl, _token);

            var url = JObject.Parse(responseString)["d"]["ServerRelativeUrl"].ToString();

            _cachePropertyPhotos[Id] = "/Photo/GetPhoto?url=" + url;

            return _cachePropertyPhotos[Id];
        }

        private async Task<RoomInspectionPhoto[]> GetInspectionPhotosAsync(int inspectionId)
        {
            string resturl = string.Format("/_api/lists/GetByTitle('Room Inspection Photos')/Items?$select=Id,sl_incidentIDId,sl_roomID/Title,File/ServerRelativeUrl&$expand=sl_roomID/Title,File/ServerRelativeUrl&$Filter=(sl_inspectionID eq {0})", inspectionId);
            string responseString = await RestHelper.GetDemoSiteJsonAsync(resturl, _token);

            var roomInspectionPhotos = JObject.Parse(responseString)["d"]["results"].ToObject<RoomInspectionPhoto[]>().ToArray();

            foreach (var item in roomInspectionPhotos)
                item.sl_roomID.imgUrl = "/Photo/GetPhoto?url=" + item.File.ServerRelativeUrl;

            return roomInspectionPhotos;
        }

        private async Task<RepairPhoto[]> GetRepairPhotosAsync(int incidentId)
        {
            string resturl = string.Format("/_api/lists/GetByTitle('Repair Photos')/Items?$select=Id,File/ServerRelativeUrl&$expand=File/ServerRelativeUrl&$Filter=(sl_incidentID eq {0})", incidentId);
            string responseString = await RestHelper.GetDemoSiteJsonAsync(resturl, _token);

            var repairPhotos = JObject.Parse(responseString)["d"]["results"].ToObject<RepairPhoto[]>().ToArray();

            foreach (var item in repairPhotos)
                item.imgUrl = "/Photo/GetPhoto?url=" + item.File.ServerRelativeUrl;

            return repairPhotos;
        }

        private async Task<Inspection> GetInspectionByIdAsync(int id)
        {
            string resturl = "/_api/lists/GetByTitle('Inspections')/Items?"
                + "$select=Id,sl_datetime,sl_finalized,sl_inspector,sl_emailaddress,sl_propertyID/Id,sl_propertyID/Title,sl_propertyID/sl_owner,sl_propertyID/sl_address1,sl_propertyID/sl_address2,sl_propertyID/sl_group"
                + "&$expand=sl_propertyID/Id,sl_propertyID/Title,sl_propertyID/sl_owner,sl_propertyID/sl_address1,sl_propertyID/sl_address2,sl_propertyID/sl_group"
                + string.Format("&$Filter=(Id eq {0})", id);

            string responseString = await RestHelper.GetDemoSiteJsonAsync(resturl, _token);

            return JObject.Parse(responseString)["d"]["results"].ToObject<Inspection[]>().FirstOrDefault();
        }

        private async Task<Incident> GetIncidentByIdAsync(int id)
        {
            string resturl = "/_api/lists/GetByTitle('Incidents')/Items?"
                + "$select=Id,sl_inspectionIDId,sl_status,sl_type,sl_date,sl_inspectorIncidentComments,sl_repairComments,sl_dispatcherComments,sl_repairScheduled,sl_repairCompleted,sl_repairApproved,"
                + "sl_propertyID/Id,sl_propertyID/Title,sl_propertyID/sl_address1,sl_propertyID/sl_address2,sl_propertyID/sl_group,sl_roomID/Id,sl_roomID/Title,sl_inspectionID/sl_datetime"
                + "&$expand=sl_propertyID/Id,sl_propertyID/Title,sl_propertyID/sl_address1,sl_propertyID/sl_address2,sl_propertyID/sl_group,sl_roomID/Id,sl_roomID/Title,sl_inspectionID/sl_datetime"
                + string.Format("&$Filter=(Id eq {0})", id);

            string responseString = await RestHelper.GetDemoSiteJsonAsync(resturl, _token);

            return JObject.Parse(responseString)["d"]["results"].ToObject<Incident[]>().FirstOrDefault();
        }

        private async Task<String[]> GetPropertyOwnersAsync(Graph.GraphServiceClient graphService)
        {
            var resturl = "/_api/lists/GetByTitle('Properties')/Items?$select=sl_owner";
            var responseString = await RestHelper.GetDemoSiteJsonAsync(resturl, _token);
            var properties = JObject.Parse(responseString)["d"]["results"].ToObject<Property[]>();

            var users = await graphService.GetAllUsersAsync(properties.Select(i => i.sl_owner));
            return users.Select(i => i.Mail).ToArray();
        }

        private async Task<HyperLink[]> GetMailsForDispatcherAsync(Graph.GraphServiceClient graphService, string CurrentUser)
        {
            List<HyperLink> result = new List<HyperLink>();

            var messages = await graphService.Users[CurrentUser].Messages.Request().GetAllAsnyc();

            var propertyOwners = await GetPropertyOwnersAsync(graphService);

            foreach (Graph.Message message in messages)
            {
                if (message.ToRecipients.Any(i => propertyOwners.Contains(i.EmailAddress.Address)))
                {
                    result.Add(new HyperLink
                    {
                        Title = message.Subject,
                        WebUrl = message.WebLink
                    });
                    break;
                }
            }

            return result.ToArray();
        }

        private async Task<RepairPeople> GetRepairPeopleByEmailAddressAsync(string userPrincipalName)
        {
            GraphServiceClient graphService = await AuthenticationHelper.GetGraphServiceAsync(AADAppSettings.GraphResourceUrl);
            var repairPeopleList = (await graphService.Users.Request().Filter(string.Format("mail eq '{0}'", userPrincipalName)).Top(1).GetAsync()).CurrentPage;
            var repairPeople = repairPeopleList.Count > 0 ? repairPeopleList[0] : null;

            if (repairPeople == null) return null;

            return new RepairPeople()
            {
                Title = repairPeople.DisplayName,
                sl_emailaddress = repairPeople.UserPrincipalName
            };
        }

        private async Task<InspectionComment> GetInspectionCommentAsync(int inspectionId, int roomId)
        {
            string resturl = string.Format(
                "/_api/lists/GetByTitle('Inspection Comments')/Items?$select=Id,Title&$Filter=(sl_inspectionID eq {0} and sl_roomID eq {1})",
                inspectionId, roomId);

            string responseString = await RestHelper.GetDemoSiteJsonAsync(resturl, _token);

            return JObject.Parse(responseString)["d"]["results"].ToObject<InspectionComment[]>().FirstOrDefault();
        }

        private async Task<Video[]> GetVideosAsync(string ChannelName, int incidentId)
        {
            var helper = new VideoPortalHelper(_token);
            var videos = await helper.GetVideosAsync(ChannelName, incidentId.ToString());

            return videos.Select(v => new Video
            {
                Title = v["Title"],
                ThumbnailUrl = v["ThumbnailUrl"],
                YammerObjectUrl = v["YammerObjectUrl"]
            }).ToArray();
        }

        private async Task<List<File>> GetGroupFilesAsync(IGroupRequestBuilder groupFetcher)
        {
            var list = new List<File>();

            Graph.DriveItem[] files = null;

            try
            {
                files = await groupFetcher.Drive.Root.Children.Request().GetAllAsnyc();
            }
            catch
            {
                return list;
            }

            foreach (var file in files)
            {
                var fileId = Regex.Match(file.ETag, @"{.*}").Captures[0].Value;
                string url;
                if (file.Name.ToLower().Contains(".docx") || file.Name.ToLower().Contains(".pptx") || file.Name.ToLower().Contains(".xlsx"))
                {
                    url = string.Format("{0}_layouts/15/WopiFrame.aspx?sourcedoc={1}&file={2}&action=default",
                        Regex.Match(file.WebUrl, @"\S*/sites/\S*?/", RegexOptions.IgnoreCase).Captures[0].Value, fileId, file.Name);
                }
                else
                {
                    url = file.WebUrl;
                }

                if (file.Folder == null)
                {
                    list.Add(new File
                    {
                        id = file.Id,
                        name = file.Name,
                        webUrl = url,
                        dateTimeLastModified = file.LastModifiedDateTime.HasValue ? file.LastModifiedDateTime.Value : new DateTimeOffset()
                    });
                }
            }
            return list;
        }
        
        private async Task<List<O365Task>> GetO365TasksAsync(GraphServiceClient graphService, Plan plan)
        {
            var tasks = await PlanService.GetTasksAsync(plan);

            var result = new List<O365Task>();

            foreach (var item in tasks)
            {
                var task = new O365Task
                {
                    Title = item.title,
                    AssignedTo = !string.IsNullOrEmpty(item.assignedTo) ? (await graphService.Users[item.assignedTo].Request().GetAsync()).DisplayName : "",
                    AssignedBy = !string.IsNullOrEmpty(item.assignedBy) ? (await graphService.Users[item.assignedBy].Request().GetAsync()).DisplayName : "",
                    AssignedDate = item.assignedDateTime.HasValue ? item.assignedDateTime.Value.DateTime.ToLocalTime().ToString() : ""
                };
                result.Add(task);
            }
            return result;
        }

        private async Task<FileContent[]> GetInspectionOrRepairPhotosAsync(string listName, int inspectionId, int roomId)
        {
            var format = "/_api/lists/GetByTitle('{0}')/Items?&$Filter=(sl_inspectionID eq {1} and sl_roomID eq {2})&$select=Id,File/Name&$expand=File/Name"; //&$select=File/TimeLastModified,File/Name

            var url = string.Format(format, listName, inspectionId, roomId);
            var json = await RestHelper.GetDemoSiteJsonAsync(url, _token);

            var items = JObject.Parse(json)["d"]["results"].ToArray();

            var attachments = new FileContent[items.Length];

            for (int i = 0; i < items.Length; i++)
            {
                var fileId = items[i]["Id"];
                var fileName = items[i]["File"]["Name"].ToString();
                var fileUrl = string.Format("/_api/lists/GetByTitle('{0}')/Items({1})/File/$value", listName, fileId);
                var data = await RestHelper.GetDemoSiteBytesAsync(fileUrl, _token);

                var attachment = new FileContent
                {
                    Id = (i + 1).ToString("000"),
                    Name = fileName,
                    Bytes = data
                };
                attachments[i] = attachment;
            }
            return attachments;
        }

        private async Task<HyperLink[]> GetConversationsAsync(IGroupRequestBuilder groupFethcer, string groupMail)
        {
            var conversations = await groupFethcer.Conversations.Request().GetAllAsnyc();
            var webUrl = string.Format("{0}owa/#path=/group/{1}/mail", AADAppSettings.OutlookUrl, groupMail);

            return conversations.Select(i => new HyperLink
                {
                    Title = i.Topic,
                    WebUrl = webUrl
                }).ToArray();
        }
        
        #endregion
    }

    #region viewmodles
    public class DashboardPropertyViewModel
    {
        public List<Inspection> Inspections { get; set; }
        public List<Incident> Incidents { get; set; }
        public Property PropertyDetail { get; set; }
    }

    public class DashboardInspectionDetailsViewModel
    {
        public Property PropertyDetail { get; set; }
        public int incidentId { get; set; }
        public Inspection inspection { get; set; }
        public Incident incident { get; set; }
        public User[] repairPeople { get; set; }
        public string viewName { get; set; }
        public RoomInspectionPhoto[] roomInspectionPhotos { get; set; }
        public InspectionComment inspectionComment { get; set; }
        public RepairPhoto[] repairPhotos { get; set; }
        public TimeSlot[] timeSlots { get; set; }
        public Video[] videos { get; set; }
        public HyperLink[] files { get; set; }
        public User[] members { get; set; }
        public O365Task[] tasks { get; set; }
        public HyperLink[] recentDocuments { get; set; }
        public HyperLink[] conversations { get; set; }
        public HyperLink[] oneNotePages { get; set; }
        public HyperLink[] DispatcherMails { get; set; }
        public PropertyExcelWorkbook PropertyExcelWorkbook { get; set; }
        public string UnifiedGroupNickName { get; set; }
        public string UnifiedGroupId { get; set; }
        public string UnifiedGroupEmail { get; set; }
        public string oneNoteUrl { get; set; }
        public string PlanId { get; set; }
        public bool bAnnotateImage { get; set; }
    }
    #endregion

    #region models
    public class File
    {
        public string id { get; set; }
        public string name { get; set; }
        public string webUrl { get; set; }
        public DateTimeOffset dateTimeLastModified { get; set; }
    }

    public class TimeSlot
    {
        public string Start { get; set; }
        public string Value { get; set; }
    }

    public class Inspection
    {
        public int Id { get; set; }
        public DateTime? sl_datetime { get; set; }
        public string sl_inspector { get; set; }
        public string sl_emailaddress { get; set; }
        public Property sl_propertyID { get; set; }
        public DateTime? sl_finalized { get; set; }
    }

    public class Property
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public string sl_owner { get; set; }
        public string sl_emailaddress { get; set; }
        public string sl_address1 { get; set; }
        public string sl_address2 { get; set; }
        public string propertyImgUrl { get; set; }
        public string sl_group { get; set; }
    }

    public class Room
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public string imgUrl { get; set; }
    }

    public class RoomInspectionPhoto
    {
        public int Id { get; set; }
        public int? sl_incidentIDId { get; set; }
        public Room sl_roomID { get; set; }
        public FileInfo File { get; set; }
    }

    public class FileInfo
    {
        public string ServerRelativeUrl { get; set; }
    }

    public class RepairPhoto
    {
        public int Id { get; set; }
        public string imgUrl { get; set; }
        public FileInfo File { get; set; }
    }

    public class Incident
    {
        public int Id { get; set; }
        public Property sl_propertyID { get; set; }
        public int? sl_inspectionIDId { get; set; }
        public DateTime? sl_date { get; set; }
        public DateTime? sl_repairScheduled { get; set; }
        public DateTime? sl_repairCompleted { get; set; }
        public DateTime? sl_repairApproved { get; set; }
        public string sl_inspectorIncidentComments { get; set; }
        public string sl_dispatcherComments { get; set; }
        public string sl_repairComments { get; set; }
        public Inspection sl_inspectionID { get; set; }
        public Inspection inspection { get; set; }
        public Room sl_roomID { get; set; }
        public string sl_status { get; set; }
        public string sl_type { get; set; }
    }

    public class RepairPeople
    {
        public string Title { get; set; }
        public string sl_emailaddress { get; set; }
        public string userPrincipalName { get; set; }
    }

    public class InspectionComment
    {
        public int Id { get; set; }
        public string Title { get; set; }
    }

    public class ScheduleRepairUpdate
    {
        public metadata __metadata { get; set; }
        public DateTime sl_repairScheduled { get; set; }
        public string sl_repairPerson { get; set; }
        public string sl_dispatcherComments { get; set; }
    }

    public class ApproveRepairUpdate
    {
        public metadata __metadata { get; set; }
        public DateTime sl_repairApproved { get; set; }
    }

    public class metadata
    {
        public string type { get; set; }
    }

    public class Video
    {
        public string Title { get; set; }
        public string ThumbnailUrl { get; set; }
        public string YammerObjectUrl { get; set; }
    }

    public class VideoWithThumnailContent : Video
    {
        public FileContent Thumbnail { get; set; }
    }

    public class HyperLink
    {
        public string Id { get; set; }
        public string Title { get; set; }
        public string WebUrl { get; set; }

        public static HyperLink Create(string title, string webUrl)
        {
            return Create(title, webUrl, "");
        }

        public static HyperLink Create(string title, string webUrl, string Id)
        {
            return new HyperLink
            {
                Id = Id,
                Title = title,
                WebUrl = webUrl
            };
        }
    }

    public class FileContent
    {
        public string Id { get; set; }
        public string Name { get; set; }
        public byte[] Bytes { get; set; }
    }

    public class O365Task
    {
        public string Title { get; set; }
        public string AssignedTo { get; set; }
        public string AssignedBy { get; set; }
        public string AssignedDate { get; set; }
    }
    public class PropertyExcelWorkbookItem
    {
        public string title { get; set; }
        public string total { get; set; }
    }
    public class PropertyExcelWorkbook
    {
        public string fileId { get; set; }
        public string webUrl { get; set; }
        public PropertyExcelWorkbookItem[] propertyExcelWorkbookItems { get; set; }
    }
    #endregion
}