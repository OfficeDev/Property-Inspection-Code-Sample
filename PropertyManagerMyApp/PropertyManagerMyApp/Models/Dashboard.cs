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
        private string notebookName = "Contoso Property Management";
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

        public async Task<DashboardInspectionDetailsViewModel> GetDashboardInspectionDetailsViewModelAsync(Graph.GraphService graphService, OneNoteService oneNoteService, int incidentId, string CurrentUser)
        {
            Task<Graph.IUser[]> getRepairPeople = null;
            Task<RepairPhoto[]> getRepairPhotos = null;

            var videos = GetVideosAsync(AppSettings.VideoPortalIncidentsChannelName, incidentId);
            var notebook = GetOrCreateNoteBook(oneNoteService, notebookName);

            var incident = await GetIncidentByIdAsync(incidentId);
            if (incident.sl_inspectionIDId == null) return null;

            var inspectionID = incident.sl_inspectionIDId.Value;
            var inspection = GetInspectionByIdAsync(inspectionID);
            var getInspectionPhotos = GetInspectionPhotosAsync(inspectionID);

            var incidentStatus = incident.sl_status;
            if (incidentStatus == "Pending Assignment")
                getRepairPeople = graphService.GetGroupMembersAsync("Repair People");
            if (incidentStatus == "Repair Pending Approval" || incidentStatus == "Repair Approved")
                getRepairPhotos = GetRepairPhotosAsync(incidentId);

            var property = incident.sl_propertyID;
            var propertyImgUrl = GetPropertyPhotoAsync(property.Id);
            var pages = (await notebook) != null
                ? GetOneNotePagesAsync(oneNoteService, (await notebook).Id, property.Title, incidentId)
                : Task.FromResult(new HyperLink[0]);

            var unifiedGroupFetcher = graphService.groups.GetById(property.sl_group);
            var unifiedGroup = unifiedGroupFetcher.ExecuteAsync();
            var groupFiles = GetGroupFilesAsync(unifiedGroupFetcher, (await unifiedGroup).mailNickname);
            var groupConversations = GetConversationsAsync(unifiedGroupFetcher, (await unifiedGroup).mail);

            // Repair people are included in property group.
            // Before we get members of a group, we must make sure that repair people have been retrieved.
            // Otherwise, we'll get an error: 
            //         The context is already tracking a different entity with the same resource Uri.
            if (getRepairPeople != null) await getRepairPeople;
            var groupMembers = graphService.GetGroupMembersAsync(unifiedGroupFetcher);

            var recentEarliestDateTime = new DateTimeOffset(DateTime.UtcNow).AddDays(-7);
            var recentDocuments = (await groupFiles)
                .Where(i => i.dateTimeLastModified > recentEarliestDateTime)
                .ToList();

            property.propertyImgUrl = await propertyImgUrl;

            var isCurrentUserDispatcher = CurrentUser == AppSettings.DispatcherEmail;


            var viewModel = new DashboardInspectionDetailsViewModel
            {
                viewName = IncidentStatusViewMappings[incidentStatus],
                PropertyDetail = property,
                incidentId = incidentId,
                incident = incident,
                UnifiedGroupNickName = (await unifiedGroup).mailNickname,
                UnifiedGroupId = (await unifiedGroup).objectId,
                UnifiedGroupEmail = (await unifiedGroup).mail,
                inspection = await inspection,
                videos = await videos,
                files = (await groupFiles)
                    .Select(i => HyperLink.Create(i.name, i.webUrl))
                    .ToArray(),
                recentDocuments = recentDocuments
                    .Select(i => HyperLink.Create(i.name, i.webUrl))
                    .ToArray(),
                members = await groupMembers,
                roomInspectionPhotos = await getInspectionPhotos,
                inspectionComment = await GetInspectionCommentAsync(inspectionID, incident.sl_roomID.Id),
                //tasks = await GetTaskHyperLinksAsync(unifiedGroup)
                repairPeople = getRepairPeople != null ? await getRepairPeople : new Graph.IUser[0],
                repairPhotos = getRepairPhotos != null ? await getRepairPhotos : new RepairPhoto[0],
                DispatcherMails = isCurrentUserDispatcher ? await GetMailsForDispatcherAsync(graphService, CurrentUser) : new HyperLink[0],
                oneNoteUrl = (await notebook) != null ? (await notebook).Url : "",
                oneNotePages = await pages,
                conversations = await groupConversations
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

        public async Task<Graph.Event> ScheduleRepairAsync(GraphService graphService, ScheduleRepairModel model)
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
                EmailAddress = new Graph.EmailAddress
                {
                    Address = repairPeople.sl_emailaddress,
                    Name = repairPeople.Title
                },
                Type = Graph.AttendeeType.Required
            };
            var newEvent = new Graph.Event
            {
                Subject = "Repair Event",
                Body = new Graph.ItemBody
                {
                    Content = body,
                    ContentType = Graph.BodyType.HTML
                },
                ShowAs = Graph.FreeBusyStatus.Busy,
                Start = model.TimeSlotsSelectedValue.ToUniversalTime(),
                End = (model.TimeSlotsSelectedValue.AddHours(1)).ToUniversalTime(),
                Location = new Graph.Location
                {
                    DisplayName = incident.sl_roomID.Title
                },
                Attendees = new Graph.Attendee[] { attendee }
            };
            await graphService.Me.Events.AddEventAsync(newEvent);

            return newEvent;
        }

        public async Task<Graph.Event> CreateGroupRepairEventAsync(GraphService graphService, ScheduleRepairModel model)
        {
            var incident = await GetIncidentByIdAsync(model.IncidentId);
            var property = incident.sl_propertyID;
            var unifiedGroupFetcher = graphService.groups.GetById(property.sl_group);
            string body = string.Format("<p>{0}</p><br/><br/><p>Incident ID: <span id='x_IncidentID'>{1}</span><br/><br/>Property ID: <span id='x_PropertyID'>{2}</span></p>",
                    incident.sl_dispatcherComments,
                    incident.Id,
                    property.Id
                );

            var newEvent = new Graph.Event
            {
                Subject = "Repair Event",
                Body = new Graph.ItemBody
                {
                    Content = body,
                    ContentType = Graph.BodyType.HTML
                },
                ShowAs = Graph.FreeBusyStatus.Busy,
                Start = model.TimeSlotsSelectedValue.ToUniversalTime(),
                End = (model.TimeSlotsSelectedValue.AddHours(1)).ToUniversalTime(),
                Location = new Graph.Location
                {
                    DisplayName = incident.sl_roomID.Title
                },
                Reminder = 60 * 24
            };
            await unifiedGroupFetcher.Events.AddEventAsync(newEvent);

            return newEvent;
        }

        public async Task ApproveRepairAsync(int incidentId)
        {
            ApproveRepairUpdate updateJson = new ApproveRepairUpdate();
            updateJson.sl_repairApproved = System.DateTime.Now;
            updateJson.__metadata = new metadata { type = "SP.Data.IncidentsListItem" };
            await SuiteLevelWebApp.Utils.RestHelper.PostRestDataToDemoSiteAsync("/_api/lists/GetByTitle('Incidents')/Items(" + incidentId + ")", JsonConvert.SerializeObject(updateJson), _token);
        }

        //public async Task CreateTaskAsync(Graph.GraphService graphService, CreateTaskViewModel model)
        //{
        //    var inspection = await GetInspectionById(model.InspectionId);
        //    var property = inspection.sl_propertyID;

        //    var unifiedGroupFetcher = graphService.groups.GetById(property.sl_group);
        //    var unifiedGroup = await unifiedGroupFetcher.ExecuteAsync();

        //    var task = new Graph.Task
        //    {
        //        title = model.Title,
        //        percentComplete = 0,
        //        startDate = inspection.sl_datetime,
        //        dueDate = inspection.sl_datetime,
        //        // TODO: description = model.Description,
        //    };
        //    await unifiedGroupFetcher.tasks.AddTaskAsync(task);
        //}

        public async Task<string> AnnotateImagesAsync(Graph.GraphService graphService, OneNoteService oneNoteService, string siteRootDirectory, int incidentId)
        {
            var getIncident = GetIncidentByIdAsync(incidentId);
            var incidentVideos = GetVideosAsync(AppSettings.VideoPortalIncidentsChannelName, incidentId);

            var incident = await getIncident;
            var property = incident.sl_propertyID;

            var sectionId = await GetOrCreateNoteBook(oneNoteService, notebookName)
                .ContinueWith(async task =>
                {
                    var _notebookId = task.Result.Id;
                    var _sectionId = await oneNoteService.GetSectionIdAsync(_notebookId, property.Title);
                    if (_sectionId == null)
                        _sectionId = await oneNoteService.CreateSectionAsync(_notebookId, property.Title);
                    return _sectionId;
                });

            var inspectionPhotos = GetInspectionOrRepairPhotosAsync("Room Inspection Photos", incident.sl_inspectionIDId.Value, incident.sl_roomID.Id);

            var pageUrl = await oneNoteService.CreatePageForIncidentAsync(siteRootDirectory, await sectionId, incident, await inspectionPhotos, await incidentVideos);

            return pageUrl;
        }

        public async Task<bool> UploadFileAsync(Graph.GraphService graphService, UploadFileModel model)
        {
            var graphToken = AuthenticationHelper.GetGraphAccessTokenAsync();
            var propertyGroup = await graphService.GetGroupByDisplayNameAsync(model.PropertyTitle);

            if (propertyGroup == null) return false;

            string id = string.Empty;
            string requestUri = string.Format("{0}{1}/groups/{2}/files",
                AADAppSettings.GraphResourceUrl,
                AppSettings.DemoSiteCollectionOwner.Split('@')[1], propertyGroup.objectId);

            //create placeholder
            HttpWebRequest reqCreatePlaceholder = (HttpWebRequest)HttpWebRequest.Create(requestUri);
            reqCreatePlaceholder.Method = "POST";
            reqCreatePlaceholder.Headers.Add("Authorization", await graphToken);
            reqCreatePlaceholder.ContentType = "application/json";
            string content = string.Format("{{type:'File',name:'{0}'}}", model.File.FileName);
            byte[] contentBody = System.Text.ASCIIEncoding.UTF8.GetBytes(content);

            using (Stream dataStream = reqCreatePlaceholder.GetRequestStream())
            {
                dataStream.Write(contentBody, 0, contentBody.Length);
            }

            try
            {
                using (HttpWebResponse response = (HttpWebResponse)reqCreatePlaceholder.GetResponse())
                {
                    if (response.StatusCode == HttpStatusCode.Created)
                    {
                        string responseString = (new StreamReader(response.GetResponseStream())).ReadToEnd();
                        id = Newtonsoft.Json.Linq.JObject.Parse(responseString)["id"].ToString();
                    }
                }
            }
            catch
            {
                throw;
            }

            if (string.IsNullOrEmpty(id)) return false;

            //upload file
            HttpWebRequest req_uploadFile = (HttpWebRequest)HttpWebRequest.Create(string.Format("{0}/{1}/uploadContent", requestUri, id));
            req_uploadFile.Method = "POST";
            req_uploadFile.Headers.Add("Authorization", await graphToken);

            using (var dataStream = req_uploadFile.GetRequestStream())
                await model.File.InputStream.CopyToAsync(dataStream);

            try
            {
                using (HttpWebResponse response = (HttpWebResponse)req_uploadFile.GetResponse())
                {
                    if (response.StatusCode == HttpStatusCode.OK)
                    {
                        return true;
                    }
                }
            }
            catch (Exception el)
            {
                throw el;
            }


            return false;
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

        private async Task<String[]> GetPropertyOwnersAsync(Graph.GraphService graphService)
        {
            var resturl = "/_api/lists/GetByTitle('Properties')/Items?$select=sl_owner";
            var responseString = await RestHelper.GetDemoSiteJsonAsync(resturl, _token);
            var properties = JObject.Parse(responseString)["d"]["results"].ToObject<Property[]>();

            var users = await graphService.GetAllUsersAsync(properties.Select(i => i.sl_owner));
            return users.Select(i => i.mail).ToArray();
        }

        private async Task<HyperLink[]> GetMailsForDispatcherAsync(Graph.GraphService graphService, string CurrentUser)
        {
            List<HyperLink> result = new List<HyperLink>();

            var messages = await (await graphService.users.GetById(CurrentUser).Messages.ExecuteAsync()).GetAllAsnyc();

            var propertyOwners = await GetPropertyOwnersAsync(graphService);

            foreach (Graph.IMessage message in messages)
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
            Graph.GraphService graphService = await AuthenticationHelper.GetGraphServiceAsync();
            Microsoft.Graph.IUser repairPeople = await GraphServiceExtension.GetFirstUserAsync(graphService, i => i.mail == userPrincipalName);

            if (repairPeople == null) return null;

            return new RepairPeople()
            {
                Title = repairPeople.displayName,
                sl_emailaddress = repairPeople.userPrincipalName
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

        private async Task<List<File>> GetGroupFilesAsync(Microsoft.Graph.IGroupFetcher groupFetcher, string groupMailNickname)
        {
            return await GetGroupFilesAsync(groupFetcher, groupMailNickname, null);
        }

        private async Task<List<File>> GetGroupFilesAsync(Microsoft.Graph.IGroupFetcher groupFetcher, string groupMailNickname, Expression<Func<Microsoft.Graph.IItem, bool>> predicate)
        {
            var list = new List<File>();

            Graph.IItem[] files = null;

            try
            {
                var pagedCollection = predicate == null
                    ? await groupFetcher.files.ExecuteAsync()
                    : await groupFetcher.files.Where(predicate).ExecuteAsync();

                files = await pagedCollection.GetAllAsnyc();
            }
            catch
            {
                return list;
            }

            foreach (var file in files)
            {
                var fileId = Regex.Match(file.eTag, @"{.*}").Captures[0].Value;
                string url;
                if (file.name.ToLower().Contains(".docx") || file.name.ToLower().Contains(".pptx") || file.name.ToLower().Contains(".xlsx"))
                {
                    url = string.Format("{0}_layouts/15/WopiFrame.aspx?sourcedoc={1}&file={2}&action=default",
                        Regex.Match(file.webUrl, @"\S*/sites/\S*?/", RegexOptions.IgnoreCase).Captures[0].Value, fileId, file.name);
                }
                else
                {
                    url = file.webUrl;
                }

                list.Add(new File
                {
                    name = file.name,
                    webUrl = url,
                    dateTimeLastModified = file.dateTimeLastModified
                });
            }
            return list;
        }

        //private async Task<List<HyperLink>> GetTaskHyperLinksAsync(Microsoft.Graph.IGroup group)
        //{
        //    var tasks = await group.tasks.GetAll();

        //    var result = new List<HyperLink>(tasks.Length);
        //    foreach (var item in tasks)
        //    {
        //        var link = new HyperLink
        //        {
        //            Title = item.title,
        //            WebUrl = "#" // TODO: Get the web url of a task
        //        };
        //        result.Add(link);
        //    }
        //    return result;
        //}

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

        private async Task<OneNoteService.NoteBook> GetOrCreateNoteBook(OneNoteService service, string name)
        {
            var notebook = await service.GetNoteBookAsync(name);
            if (notebook == null)
            {
                try
                {
                    notebook = await service.CreateNoteBookAsync(name);
                }
                catch { }
            }
            return notebook;
        }

        private async Task<HyperLink[]> GetOneNotePagesAsync(OneNoteService service, string notebookId, string propertyName, int incidentId)
        {
            var sectionId = await service.GetSectionIdAsync(notebookId, propertyName);
            if (string.IsNullOrEmpty(sectionId)) return new HyperLink[0];
            return await service.GetPagesAsync(sectionId, incidentId);
        }

        private async Task<HyperLink[]> GetConversationsAsync(Graph.IGroupFetcher groupFethcer, string groupMail)
        {
            var conversations = await groupFethcer.Conversations.ExecuteAsync();
            var webUrl = string.Format("{0}owa/#path=/group/{1}/mail", AADAppSettings.OutlookResourceId, groupMail);

            return (await conversations.GetAllAsnyc())
                .Select(i => new HyperLink
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
        public Graph.IUser[] repairPeople { get; set; }
        public string viewName { get; set; }
        public RoomInspectionPhoto[] roomInspectionPhotos { get; set; }
        public InspectionComment inspectionComment { get; set; }
        public RepairPhoto[] repairPhotos { get; set; }
        public TimeSlot[] timeSlots { get; set; }
        public Video[] videos { get; set; }
        public HyperLink[] files { get; set; }
        public Graph.IUser[] members { get; set; }
        public HyperLink[] recentDocuments { get; set; }
        public HyperLink[] conversations { get; set; }
        public HyperLink[] oneNotePages { get; set; }
        public HyperLink[] DispatcherMails { get; set; }
        public string UnifiedGroupNickName { get; set; }
        public string UnifiedGroupId { get; set; }
        public string UnifiedGroupEmail { get; set; }
        public string oneNoteUrl { get; set; }
    }
    #endregion

    #region models
    public class File
    {
        public string name { get; set; }
        public string webUrl { get; set; }
        public DateTimeOffset dateTimeLastModified { get; set; }
    }

    public class TimeSlot
    {
        public int Start { get; set; }
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
        public string Title { get; set; }
        public string WebUrl { get; set; }

        public static HyperLink Create(string title, string webUrl)
        {
            return new HyperLink
            {
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

    #endregion
}