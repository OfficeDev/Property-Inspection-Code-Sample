using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Net;
using System.IO;
using System.Json;
using Android.App;
using Android.Content;
using Android.OS;
using Android.Runtime;
using Android.Views;
using Android.Widget;
using Android.Graphics;
using XamarinRepairApp.Model;
using XamarinRepairApp.Utils;
using Android.Provider;
using Microsoft.Graph;

namespace XamarinRepairApp
{
    [Activity(Label = "IncidentDetailActivity")]
    public class IncidentDetailActivity : Activity
    {
        private IncidentModel CurrentIncident;
        private bool CanEdit = true;
        private ProgressDialog process;
        private ImageView backBtn;
        private Button finalizeBtn;
        private Button doneBtn;
        private TextView repairComment;
        private EditText repairCommentEdit;
        private LinearLayout tabWrap1;
        private LinearLayout tabWrap2;
        private LinearLayout tabWrap3;
        private ImageView propertyLogo;
        private LinearLayout inspectionImages;
        private LinearLayout repairImages;
        private RelativeLayout largeLayout;
        private ImageView largeImage;
        private ImageView closeImage;
        private ImageView camera;

        protected override void OnCreate(Bundle bundle)
        {
            base.OnCreate(bundle);
            SetContentView(Resource.Layout.IncidentDetail);

            CurrentIncident = App.SelectedIncidet;

            backBtn = (ImageView)FindViewById(Resource.Id.detail_back);
            tabWrap1 = (LinearLayout)FindViewById(Resource.Id.detail_tab1);
            tabWrap2 = (LinearLayout)FindViewById(Resource.Id.detail_tab2);
            tabWrap3 = (LinearLayout)FindViewById(Resource.Id.detail_tab3);
            camera = (ImageView)FindViewById(Resource.Id.detail_camera);

            inspectionImages = (LinearLayout)FindViewById(Resource.Id.detail_inspectionImages);
            repairImages = (LinearLayout)FindViewById(Resource.Id.detail_repairImages);
            largeLayout = (RelativeLayout)FindViewById(Resource.Id.detail_largeLayout);
            largeImage = (ImageView)FindViewById(Resource.Id.detail_largeImage);
            closeImage = (ImageView)FindViewById(Resource.Id.detail_largeClose);

            propertyLogo = (ImageView)FindViewById(Resource.Id.detail_propertyPhoto);
            doneBtn = (Button)FindViewById(Resource.Id.detail_commentDone);
            repairComment = (TextView)FindViewById(Resource.Id.detail_incidentRepairComments);
            repairCommentEdit = (EditText)FindViewById(Resource.Id.detail_incidentRepairCommentsEdit);
            finalizeBtn = (Button)FindViewById(Resource.Id.detail_finalizeBtn);

            backBtn.Click += delegate
            {
                Finish();
            };

            ((Button)FindViewById(Resource.Id.detail_tabBtn1)).Click += delegate
            {
                SelectTab(1);
            };
            ((Button)FindViewById(Resource.Id.detail_tabBtn2)).Click += delegate
            {
                SelectTab(2);
            };
            ((Button)FindViewById(Resource.Id.detail_tabBtn3)).Click += delegate
            {
                SelectTab(3);
            };
            closeImage.Click += delegate
            {
                largeLayout.Visibility = ViewStates.Gone;
            };
            camera.Click += delegate
            {
                if (this.CanEdit)
                {
                    OpenCamera();
                }
            };
            largeLayout.Click += delegate
            {

            };
            doneBtn.Click += delegate
            {
                UpdateRepairComments();
            };

            SelectTab(1);
            BindData();
            LoadPropertyPhoto();
            LoadRepariPhotos();
            LoadRoomInspectionPhotos();
        }

        #region data binding

        private void BindData()
        {
            ((TextView)FindViewById(Resource.Id.detail_propertyName)).SetText("Property Name: " + CurrentIncident.GetProperty().GetTitle(), TextView.BufferType.Normal);
            ((TextView)FindViewById(Resource.Id.detail_propertyOwner)).SetText("Owner: " + CurrentIncident.GetProperty().GetOwner(), TextView.BufferType.Normal);
            ((TextView)FindViewById(Resource.Id.detail_propertyAddress)).SetText(CurrentIncident.GetProperty().GetAddress1(), TextView.BufferType.Normal);
            ((TextView)FindViewById(Resource.Id.detail_inspectionName)).SetText(CurrentIncident.GetInspection().GetInspector(), TextView.BufferType.Normal);
            ((TextView)FindViewById(Resource.Id.detail_inspectionEmail)).SetText(CurrentIncident.GetInspection().GetEmailaddress(), TextView.BufferType.Normal);
            ((TextView)FindViewById(Resource.Id.detail_inspectionDate)).SetText(CurrentIncident.GetInspection().GetDateTime(), TextView.BufferType.Normal);

            ((TextView)FindViewById(Resource.Id.detail_roomTitle)).SetText("ROOM: " + CurrentIncident.GetRoom().GetTitle(), TextView.BufferType.Normal);
            ((TextView)FindViewById(Resource.Id.detail_roomType)).SetText("TYPE: " + CurrentIncident.GetType(), TextView.BufferType.Normal);
            ((TextView)FindViewById(Resource.Id.detail_incidentDispatcherComments)).SetText(CurrentIncident.GetDispatcherComments(), TextView.BufferType.Normal);
            ((TextView)FindViewById(Resource.Id.detail_incidentInspectionComments)).SetText(CurrentIncident.GetInspectorIncidentComments(), TextView.BufferType.Normal);
            ((TextView)FindViewById(Resource.Id.detail_incidentRepairComments)).SetText(CurrentIncident.GetRepairComments(), TextView.BufferType.Normal);
            ((TextView)FindViewById(Resource.Id.detail_incidentRepairCommentsEdit)).SetText(CurrentIncident.GetRepairComments(), TextView.BufferType.Normal);

            ((TextView)FindViewById(Resource.Id.detail_inspectionEmail)).Click += delegate
            {
                SendEmail(CurrentIncident.GetInspection().GetEmailaddress());
            };

            if (string.IsNullOrEmpty(CurrentIncident.GetRepairCompleted()))
            {
                finalizeBtn.Visibility = ViewStates.Visible;
                finalizeBtn.Click += delegate
                {
                    FinalizeRepair();
                };
            }
            else
            {
                finalizeBtn.Visibility = ViewStates.Gone;
            }

            String statusStr = CurrentIncident.GetStatus();
            if (!string.IsNullOrEmpty(CurrentIncident.GetRepairCompleted())
                || (!string.IsNullOrEmpty(statusStr) && statusStr.Equals("Repair Pending Approval"))
                || (!string.IsNullOrEmpty(statusStr) && statusStr.Equals("Repair Approved")))
            {
                SetBtnStatus(false);
            }
            else
            {
                SetBtnStatus(true);
            }
        }

        private void SelectTab(int index)
        {
            if (index == 1)
            {
                tabWrap1.Visibility = ViewStates.Visible;
                tabWrap2.Visibility = ViewStates.Gone;
                tabWrap3.Visibility = ViewStates.Gone;
            }
            else if (index == 2)
            {
                tabWrap1.Visibility = ViewStates.Gone;
                tabWrap2.Visibility = ViewStates.Visible;
                tabWrap3.Visibility = ViewStates.Gone;
            }
            else
            {
                tabWrap1.Visibility = ViewStates.Gone;
                tabWrap2.Visibility = ViewStates.Gone;
                tabWrap3.Visibility = ViewStates.Visible;
            }
        }

        private void SetBtnStatus(Boolean canEdit)
        {
            this.CanEdit = canEdit;
            if (!canEdit)
            {
                doneBtn.Visibility = ViewStates.Gone;
                repairCommentEdit.Visibility = ViewStates.Gone;
                repairComment.Visibility = ViewStates.Visible;
            }
            else
            {
                doneBtn.Visibility = ViewStates.Visible;
                repairComment.Visibility = ViewStates.Gone;
                repairCommentEdit.Visibility = ViewStates.Visible;
            }
        }

        #endregion

        #region async methods

        async void LoadPropertyPhoto()
        {
            Bitmap bitmap = await ListHelper.GetPropertyPhoto(Convert.ToInt32(App.PropertyId));
            if (bitmap != null)
            {
                ((ImageView)FindViewById(Resource.Id.detail_propertyPhoto)).SetImageBitmap(bitmap);
            }
        }

        async void LoadRoomInspectionPhotos()
        {
            string listName = "Room%20Inspection%20Photos";
            List<int> photoIdCollection = await ListHelper.GetPhotoIdCollection(listName, this.CurrentIncident.GetId(), this.CurrentIncident.GetInspectionId(), this.CurrentIncident.GetRoomId());
            if (photoIdCollection != null && photoIdCollection.Any())
            {
                for (int i = 0; i < photoIdCollection.Count; i++)
                {
                    Bitmap bitmap = await ListHelper.GetPhoto(listName, photoIdCollection[i]);
                    if (bitmap != null)
                    {
                        AddImageView(bitmap, true);
                    }
                }
            }
        }

        async void LoadRepariPhotos()
        {
            string listName = "Repair%20Photos";
            List<int> photoIdCollection = await ListHelper.GetPhotoIdCollection(listName, this.CurrentIncident.GetId(), this.CurrentIncident.GetInspectionId(), this.CurrentIncident.GetRoomId());
            if (photoIdCollection != null && photoIdCollection.Any())
            {
                for (int i = 0; i < photoIdCollection.Count; i++)
                {
                    Bitmap bitmap = await ListHelper.GetPhoto(listName, photoIdCollection[i]);
                    if (bitmap != null)
                    {
                        AddImageView(bitmap, false);
                    }
                }
            }
        }

        async void UploadPhoto(Bitmap bitmap)
        {
            process = ProgressDialog.Show(this, "Processing", "Uploading photo to SharePoint Document Library...");
            string listName = "RepairPhotos";
            string listName2 = "Repair%20Photos";
            string imageName = Helper.GetImageName();
            bool success = await ListHelper.UploadImage(listName, listName2, imageName, bitmap, CurrentIncident.GetId(), CurrentIncident.GetInspectionId(), CurrentIncident.GetRoomId());
            process.Dismiss();
            if (success)
            {
                AddImageView(bitmap, false);
                Toast.MakeText(this, "Uploaded photos successfully.", ToastLength.Long).Show();
            }
            else
            {
                Toast.MakeText(this, "Uploading photos failed.", ToastLength.Long).Show();
            }
        }

        async void UpdateRepairComments()
        {
            string comments = repairCommentEdit.Text.Trim();
            if (string.IsNullOrEmpty(comments))
            {
                Toast.MakeText(this, "Please input comments.", ToastLength.Long).Show();
            }
            else
            {
                process = ProgressDialog.Show(this, "Processing", "Sending data to SharePoint List...");
                bool success = await ListHelper.UploadRepairComments(CurrentIncident.GetId(), comments);
                if (success)
                {
                    App.SelectedIncidet.HasChanged = true;
                    App.SelectedIncidet.SetRepairComments(comments);
                    repairCommentEdit.Visibility = ViewStates.Gone;
                    repairComment.SetText(comments, TextView.BufferType.Normal);
                    repairComment.Visibility = ViewStates.Visible;
                    Toast.MakeText(this, "Updated repair comments successfully.", ToastLength.Long).Show();
                }
                else
                {
                    Toast.MakeText(this, "Updating repair comments failed.", ToastLength.Long).Show();
                }
                process.Dismiss();
            }
        }

        async void FinalizeRepair()
        {
            process = ProgressDialog.Show(this, "Processing", "Sending data to SharePoint List...");
            bool success = await ListHelper.UploadRepairComplete(CurrentIncident.GetId());
            if (success)
            {
                if (CurrentIncident.GetTaskId() > 0)
                {
                    UpdateRepairTask();
                }
                else
                {
                    FinalizeRepairSuccess();
                }
            }
            else
            {
                FinalizeRepairFailed();
            }
        }

        async void UpdateRepairTask()
        {
            bool success = await ListHelper.UploadRepairWorkFlowTask(CurrentIncident.GetTaskId());
            if (success)
            {
                FinalizeRepairSuccess();
            }
            else
            {
                FinalizeRepairFailed();
            }
        }

        async Task SendEmailAfterRepairCompleted()
        {
			var graphToken = await AuthenticationHelper.GetGraphAccessTokenAsync(this);
            var recipient = CurrentIncident.GetProperty().GetEmail();
            var dispatcherRecipient = Constants.DISPATCHEREMAIL;
            var subject = string.Format("Repair Report - {0} - {1:MM/dd/yyyy}", CurrentIncident.GetProperty().GetTitle(), DateTime.Now);
            var bodyContent = string.Format("The incident found during a recent inspection on you property has been repaired. Photographs taken during the inspection and after the repair are attached to this email." +
                       "<br/>" +
                       "<br/><b>Property Name:</b> {0}" +
                       "<br/><b>Property Address:</b> {1}" +
                       "<br/>" +
                       "<br/><b>Inspection Date:</b> {2}" +
                       "<br/><b>Incident Type:</b> {3}" +
                       "<br/><b>Room:</b> {4}" +
                       "<br/><b>Comments from the inspector:</b><br/>{5}" +
                       "<br/><br/><b>Incident reported:</b> {6}" +
                       "<br/>" +
                       "<br/><b>Repair Date:</b> {7:MM/dd/yyyy}" +
                       "<br/><b>Comments from repair person:</b><br/>{8}" +
                       "<br/>" +
                       "<br/><b>Attachments:</b>(Inspection & Repair Photos) - Email attachments are not supported at this time in Xamarin app, therefore no files are attached." +
                       "<br/>" +
                       "<p>Incident ID: <span id='x_IncidentID'>{9}</span></p>" +
                       "<p>Property ID: <span id='x_PropertyID'>{10}</span></p>",
                           CurrentIncident.GetProperty().GetTitle(),
                           CurrentIncident.GetProperty().GetAddress1(),
                           CurrentIncident.GetInspection().GetDateTime(),
                           CurrentIncident.GetType(),
                           CurrentIncident.GetRoom().GetTitle(),
                           CurrentIncident.GetInspectorIncidentComments(),
                           CurrentIncident.GetDate(),
                           DateTime.Now,
                           CurrentIncident.GetRepairComments(),
                           CurrentIncident.GetId(),
                           CurrentIncident.GetProperty().GetId()
                       );
            var message = new Microsoft.Graph.Message {
                Subject = subject,
                Body = new ItemBody { ContentType = BodyType.Html, Content = bodyContent },
                ToRecipients = new Recipient[] { new Recipient { EmailAddress = new EmailAddress { Address = dispatcherRecipient } } },
                CcRecipients = new Recipient[] { new Recipient { EmailAddress = new EmailAddress { Address = recipient } } }
            };
            var requestBuilder = App.GraphService.Me.SendMail(message, true);
            var request = requestBuilder.Request();
            request.ContentType = "application/json";
            request.Headers.Add(new HeaderOption("Authorization", "Bearer " + graphToken));
            process = ProgressDialog.Show(this, "Processing", "Sending email...");
            await request.PostAsync();
            process.Dismiss();
        }

        async Task UpdateTasks()
        {
            var graphToken = AuthenticationHelper.GetGraphAccessTokenAsync(this);

            var tasks = await GetTasks(await graphToken);

            if (tasks.Count == 0)
                return;

            byte[] btBodys = Encoding.UTF8.GetBytes("{'percentComplete': 100}");

            foreach (var task in tasks)
            {
                var requestUrl = string.Format("{0}Tasks/{1}", Constants.GraphBetaResourceUrl, task.TaskID);
                HttpWebRequest request = (HttpWebRequest)HttpWebRequest.Create(requestUrl);
                request.Method = "PATCH";
                request.Accept = "application/json";
                request.ContentType = "application/json";
                request.Headers.Add("Authorization", "Bearer " + await graphToken);
                request.Headers.Add("If-Match", task.Etag);
                request.GetRequestStream().Write(btBodys, 0, btBodys.Length);
                using (HttpWebResponse response = await request.GetResponseAsync() as HttpWebResponse)
                {
                    if (response.StatusCode == HttpStatusCode.NoContent)
                    {
                        //update successfully
                    }
                }
            }
        }

        async Task<List<TaskModel>> GetTasks(string graphToken)
        {
            var results = new List<TaskModel>();
            var IncidentId = CurrentIncident.GetId();
            var planID = GetPlanId(graphToken, CurrentIncident.GetProperty().GetGroupID());
            var bucketId = GetBucketId(graphToken, await planID, string.Format("Incident [{0}]", IncidentId));

            if (await bucketId == string.Empty) return results;

            var requestUrl = string.Format("{0}buckets/{1}/Tasks", Constants.GraphBetaResourceUrl, await bucketId);
            HttpWebRequest request = (HttpWebRequest)HttpWebRequest.Create(requestUrl);
            request.Method = "GET";
            request.Accept = "application/json";
            request.Headers.Add("Authorization", "Bearer " + graphToken);

            using (HttpWebResponse response = await request.GetResponseAsync() as HttpWebResponse)
            {
                if (response.StatusCode == HttpStatusCode.OK)
                {
                    using (StreamReader stream = new StreamReader(response.GetResponseStream()))
                    {
                        string content = await stream.ReadToEndAsync();
                        JsonValue jsonValue = JsonValue.Parse(content);
                        for (int i = 0; i < jsonValue["value"].Count; i++)
                        {
                            results.Add(new TaskModel
                            {
                                TaskID = Helper.GetString(jsonValue["value"][i]["id"]),
                                Etag = Helper.GetString(jsonValue["value"][i]["@odata.etag"]).Replace(@"\", "") + "\""
                            });
                        }
                    }
                }
            }

            return results;
        }

        async Task<string> GetPlanId(string graphToken, string groupId)
        {
            var requestUrl = string.Format("{0}groups/{1}/plans", Constants.GraphBetaResourceUrl, groupId);
            HttpWebRequest request = (HttpWebRequest)HttpWebRequest.Create(requestUrl);
            request.Method = "GET";
            request.Accept = "application/json";
            request.Headers.Add("Authorization", "Bearer " + graphToken);

            using (HttpWebResponse response = await request.GetResponseAsync() as HttpWebResponse)
            {
                if (response.StatusCode == HttpStatusCode.OK)
                {
                    using (StreamReader stream = new StreamReader(response.GetResponseStream()))
                    {
                        string content = await stream.ReadToEndAsync();
                        var jsonValue = JsonValue.Parse(content);
                        return Helper.GetString(jsonValue["value"][0]["id"]);
                    }
                }
            }

            return string.Empty;
        }

        async Task<string> GetBucketId(string graphToken, string planId, string BucketName)
        {
            var requestUrl = string.Format("{0}plans/{1}/Buckets", Constants.GraphBetaResourceUrl, planId);
            HttpWebRequest request = (HttpWebRequest)HttpWebRequest.Create(requestUrl);
            request.Method = "GET";
            request.Accept = "application/json";
            request.Headers.Add("Authorization", "Bearer " + graphToken);

            using (HttpWebResponse response = await request.GetResponseAsync() as HttpWebResponse)
            {
                if (response.StatusCode == HttpStatusCode.OK)
                {
                    using (StreamReader stream = new StreamReader(response.GetResponseStream()))
                    {
                        string content = await stream.ReadToEndAsync();
                        var jsonValue = JsonValue.Parse(content);

                        for (int i = 0; i < jsonValue["value"].Count; i++)
                        {
                            if (Helper.GetString(jsonValue["value"][i]["name"]) == BucketName)
                            {
                                return Helper.GetString(jsonValue["value"][i]["id"]);
                            }
                        }
                    }
                }
            }

            return string.Empty;
        }

        #endregion

        #region methods

        private void SendEmail(String to)
        {
            Intent intent = new Intent(Android.Content.Intent.ActionSend);
            intent.SetType("plain/text");
            intent.PutExtra(Android.Content.Intent.ExtraEmail, new String[] { to });
            intent.PutExtra(Android.Content.Intent.ExtraSubject, "");
            intent.PutExtra(Android.Content.Intent.ExtraText, "Sent from Xamarin Android");
            Intent chooserIntent = Intent.CreateChooser(intent, "Send Email");
            StartActivity(chooserIntent);
        }

        private void AddImageView(Bitmap bitmap, bool isRoomInspectionPhoto)
        {
            ImageView imageView = new ImageView(this);
            imageView.SetImageBitmap(bitmap);
            if (isRoomInspectionPhoto)
            {
                inspectionImages.AddView(imageView);
            }
            else
            {
                repairImages.AddView(imageView);
            }
            Android.Widget.LinearLayout.LayoutParams lparams = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WrapContent, LinearLayout.LayoutParams.WrapContent);
            lparams.Height = 210;
            lparams.Width = 280;
            lparams.SetMargins(0, 0, 20, 0);
            imageView.LayoutParameters = lparams;

            imageView.Click += delegate
            {
                ShowLargeImage(bitmap);
            };
        }

        private void ShowLargeImage(Bitmap bitmap)
        {
            largeImage.SetImageBitmap(bitmap);
            ViewGroup.LayoutParams lparams = largeImage.LayoutParameters;
            int width = bitmap.Width > 1600 ? 1600 : bitmap.Width;
            int height = bitmap.Width > 1600 ? Convert.ToInt32(bitmap.Height / (Convert.ToDouble(bitmap.Width) / Convert.ToDouble(1600))) : bitmap.Height;
            if (height > 800)
            {
                width = Convert.ToInt32(width / (Convert.ToDouble(height) / Convert.ToDouble(800)));
                height = 800;
            }
            lparams.Width = width;
            lparams.Height = height;
            largeLayout.Visibility = ViewStates.Visible;
        }

        private void OpenCamera()
        {
            Intent intent = new Intent(MediaStore.ActionImageCapture);
            StartActivityForResult(intent, 200);
        }

        async void FinalizeRepairSuccess()
        {
            process.Dismiss();
            App.SelectedIncidet.HasChanged = true;
            App.SelectedIncidet.SetStatus("Repair Pending Approval");
            App.SelectedIncidet.SetRepairCompleted(DateTime.Now.ToString("MM/dd/yyyy"));
            SetBtnStatus(false);
            finalizeBtn.Visibility = ViewStates.Gone;
            await UpdateTasks();
            Toast.MakeText(this, "Finalized repair successfully.", ToastLength.Long).Show();
            await SendEmailAfterRepairCompleted();
        }

        private void FinalizeRepairFailed()
        {
            process.Dismiss();
            Toast.MakeText(this, "Finalizing repair failed.", ToastLength.Long).Show();
        }

        #endregion

        protected override void OnActivityResult(int requestCode, Result resultCode, Intent data)
        {
            base.OnActivityResult(requestCode, resultCode, data);

            if (resultCode == Result.Ok)
            {
                Bitmap bitmap = (Bitmap)data.Extras.Get("data");
                if (bitmap != null)
                {
                    UploadPhoto(bitmap);
                }
            }
        }
    }
}