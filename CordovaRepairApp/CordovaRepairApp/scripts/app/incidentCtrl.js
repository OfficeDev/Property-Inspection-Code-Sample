var incidentCtrl =
    {
        incidentId: "23",
        selectPropertyId: "",
        incidentLoopIndex: 0,

        incidentListArray: new Array(),

        signOut: function(){
            listClient.signOut((function () {
                this.displayMessageAlert('Logout Successful.');
            }).bind(this), (function (reason) {
                this.displayMessageAlert('Logout Failed.' + reason);
            }).bind(this));
        },
        onGetAccessToken: function () {
            listClient.getAccessToken((this.getAccessTokenSuccess).bind(this), (this.getAccessTokenFail).bind(this));
        },

        getAccessTokenSuccess: function () {
            this.showIncidentPage();
        },

        getAccessTokenFail: function (reason) {
            console.log('Failed to login. Error = ' + reason.message);
            this.displayMessageAlert('Failed to login. Error = ' + reason.message);
        },

        showIncidentPage: function () {
            $("#login_page").hide();
            window.scroll(0, 0);
            $("#incidentpage").show();
            this.adjustPageHeight();

            //here we need loaddata
            this.blockLoadingUI("#listloadingui");
            this.getIncidentFirstId();
        },

        getIncidentFirstId:function(){
            var url = O365Auth.Settings.sitecollectionUrl + "/_api/lists/GetByTitle('Incidents')/Items?$select=ID&$orderby=ID asc&$top=1";
            listClient.getListItems(url,
                (function (listitems) {
                    if (listitems.length > 0) {
                        incidentCtrl.incidentId = (listitems[0])["ID"];
                        this.loadPropertyIdByIncidentId();
                    }
                    else {
                        this.displayMessageAlert("Can't find Incidents list item.");
                    }
                }).bind(this),
                (this.loadListFail).bind(this));

        },

        loadPropertyIdByIncidentId: function () {
            var url = O365Auth.Settings.sitecollectionUrl + "/_api/lists/GetByTitle('Incidents')/Items?$select=ID,sl_propertyIDId,sl_propertyID/ID&$expand=sl_propertyID&$filter=ID eq " + incidentCtrl.incidentId + " and sl_propertyIDId gt 0 and sl_inspectionIDId gt 0 and sl_roomIDId gt 0";
            listClient.getListItems(url, (this.loadPropertySuccess).bind(this), (this.loadListFail).bind(this));
        },

        loadPropertySuccess: function (listitems) {
            if (listitems.length > 0) {
                this.selectPropertyId = (listitems[0])["sl_propertyIDId"];

                //loadIncidentsData
                var url = O365Auth.Settings.sitecollectionUrl + "/_api/lists/GetByTitle('Incidents')/Items?$select=ID,Title,sl_inspectorIncidentComments,sl_dispatcherComments,sl_repairComments,sl_status,sl_type,sl_repairApproved,sl_date,sl_repairCompleted,sl_inspectionIDId,sl_roomIDId,sl_taskId,sl_inspectionID/ID,sl_inspectionID/sl_datetime,sl_inspectionID/sl_finalized,sl_inspectionID/sl_inspector,sl_inspectionID/sl_emailaddress,sl_propertyID/ID,sl_propertyID/Title,sl_propertyID/sl_emailaddress,sl_propertyID/sl_owner,sl_propertyID/sl_address1,sl_propertyID/sl_address2,sl_propertyID/sl_city,sl_propertyID/sl_state,sl_propertyID/sl_postalCode,sl_roomID/ID,sl_roomID/Title&$expand=sl_inspectionID,sl_propertyID,sl_roomID&$filter=sl_propertyIDId eq "
                           + this.selectPropertyId
                           + " and sl_inspectionIDId gt 0 and sl_roomIDId gt 0&$orderby=sl_date desc";

                listClient.getListItems(url, (this.loadIncidentsDataSuccess).bind(this), (this.loadListFail).bind(this));

            }
            else {
                this.displayMessageAlert("The incident with ID " + this.incidentId + " not found");
            }
        },
        loadIncidentsDataSuccess: function (listitems) {
            if (listitems.length > 0) {
                this.incidentListArray = listitems;

                var propertyDeatailDic = (listitems[0]).sl_propertyID
                viewModel.updatePropertyViewMOdel(propertyDeatailDic);
                viewModel.updateincidentListsViewMOdel(this.incidentListArray);

                var url = O365Auth.Settings.sitecollectionUrl + "/_api/lists/GetByTitle('Property Photos')/Items?$select=ID,Title&$filter=sl_propertyIDId eq "
                           + this.selectPropertyId
                           + "&$orderby=Modified desc&$top=1";

                listClient.getListItems(url, (this.getPropertyPhotoIdSuccess).bind(this), (this.loadListFail).bind(this));

            }
            else {
                this.displayMessageAlert("The incident with PropertyID " + this.selectPropertyId + " not found");
            }
        },

        loadListFail: function (xhr) {
            this.unBlockLoadingUI("#listloadingui");

            this.displayMessageAlert("Load Fail " + xhr);
        },

        getPropertyPhotoIdSuccess: function (listitems) {
            if (listitems.length > 0) {
                var photoId = listitems[0].ID;
                var url = O365Auth.Settings.sitecollectionUrl + "/_api/lists/GetByTitle('Property Photos')/Items(" + photoId + ")/File?$select=ServerRelativeUrl";
                listClient.getListItems(url, (this.getPropertyPhotoServerRelativeUrlSuccess).bind(this), (this.loadListFail).bind(this));
            }
            else {
                this.displayMessageAlert("The Property Photos with PropertyID " + this.selectPropertyId + " not found");
            }
        },
        getPropertyPhotoServerRelativeUrlSuccess: function (listitems) {
            var photoServerRelativeUrl = listitems.ServerRelativeUrl;

            var url = O365Auth.Settings.sitecollectionUrl + "/_api/web/GetFileByServerRelativeUrl('" + photoServerRelativeUrl + "')/$value";
            listClient.getBinary(url, (this.getPropertyPhotoFileSuccess).bind(this), (this.loadListFail).bind(this));
        },
        getPropertyPhotoFileSuccess: function (data) {
            viewModel.propetyDetailView.ImageUrl('data:image/jpeg;base64,' + data);
            this.getIncidentListPhoto();
        },
        getIncidentListPhoto: function () {
            if (this.incidentLoopIndex >= viewModel.incidentListsView.incidentList().length) {
                this.unBlockLoadingUI("#listloadingui");
            }
            else {
                var incidentitem = viewModel.incidentListsView.incidentList()[this.incidentLoopIndex];
                var incidentId = incidentitem.IncidentId();
                var inspectionId = incidentitem.InspectionId();
                var RoomId = incidentitem.RoomId();

                var url = O365Auth.Settings.sitecollectionUrl + "/_api/lists/GetByTitle('Room Inspection Photos')/Items?$select=ID,Title&$filter=sl_inspectionIDId eq "
                           + inspectionId
                           + " and sl_incidentIDId eq "
                           + incidentId
                           + " and sl_roomIDId eq "
                           + RoomId
                           + "&$orderby=Modified desc&$top=1";

                this.blockLoadingUI("#listloadingui");
                listClient.getListItems(url, (this.getRoomInspectionPhotoIdSuccess).bind(this), (this.getRoomInspectionPhotoIdFail).bind(this));
            }
        },
        getRoomInspectionPhotoIdSuccess: function (listitems)
        {
            //get relatvie url and binary file
            if (listitems.length > 0) {
                var photoId = listitems[0].ID;
                var url = O365Auth.Settings.sitecollectionUrl + "/_api/lists/GetByTitle('Room Inspection Photos')/Items(" + photoId + ")/File?$select=ServerRelativeUrl";
                listClient.getListItems(url, (function (pathitem){
                    var photoServerRelativeUrl = pathitem.ServerRelativeUrl;
                    var url = O365Auth.Settings.sitecollectionUrl + "/_api/web/GetFileByServerRelativeUrl('" + photoServerRelativeUrl + "')/$value";
                    listClient.getBinary(url, (function (data) {
                        //get binary success
                        if (this.incidentLoopIndex < viewModel.incidentListsView.incidentList().length) {
                            (viewModel.incidentListsView.incidentList()[this.incidentLoopIndex]).ImageUrl('data:image/jpeg;base64,' + data);
                        }
                        this.getNextIncidentPhoto();
                    }).bind(this),
                    (function (xhr) {
                        //get binary failed
                        console.log("get Inspection Photo fail.")
                        this.getNextIncidentPhoto();
                    }).bind(this));
                }).bind(this),
                (function (xhr) {
                    console.log("get incident list items fail.")
                    this.getNextIncidentPhoto();
                }).bind(this));
            }
            else {
                console.log("The Room Inspection Photos not found");
                this.getNextIncidentPhoto();
            }
        },
        getRoomInspectionPhotoIdFail: function ()
        {
            console.log("The Room Inspection Photos Fail");
            this.getNextIncidentPhoto();
        },
        getNextIncidentPhoto: function()
        {
            this.incidentLoopIndex = this.incidentLoopIndex + 1;
            this.getIncidentListPhoto();
        },
        getRoomInspectionPhotosListId: function (incidentItem) {
            var incidentId = incidentItem.ID;
            var inspectionId = incidentItem.sl_inspectionIDId;
            var RoomId = incidentItem.sl_roomIDId;

            var url = O365Auth.Settings.sitecollectionUrl + "/_api/lists/GetByTitle('Room Inspection Photos')/Items?$select=ID,Title&$filter=sl_inspectionIDId eq "
                       + inspectionId
                       + " and sl_incidentIDId eq "
                       + incidentId
                       + " and sl_roomIDId eq "
                       + RoomId
                       + "&$orderby=Modified desc";

            this.blockLoadingUI("#detailloadingui");
            listClient.getListItems(url,
                (function (listitems) {
                    if (listitems.length > 0) {
                        incidentItem.imagesCount = listitems.length;
                        incidentItem.imageArray = new Array();
                        this.getRoomInspectionPhotosListLoop(incidentItem, listitems, 0)
                    }
                    else {
                        this.unBlockLoadingUI("#detailloadingui");
                    }
                 }).bind(this),
                 (function (xhr) {
                     this.unBlockLoadingUI("#detailloadingui");
                     this.displayMessageAlert("Get Room Inspection Photos List Id Fail " + xhr);
                 }).bind(this));
        },
        getRoomInspectionPhotosListLoop: function (incidentItem, listitems, index)
        {
            if (index >= incidentItem.imagesCount)
            {
                this.unBlockLoadingUI("#detailloadingui");
            }
            else
            {
                var photoId = listitems[index].ID;
                var nextindex = index + 1;

                this.blockLoadingUI("#detailloadingui");

                var url = O365Auth.Settings.sitecollectionUrl + "/_api/lists/GetByTitle('Room Inspection Photos')/Items(" + photoId + ")/File?$select=ServerRelativeUrl";
                listClient.getListItems(url, (function (pathitem) {
                    var photoServerRelativeUrl = pathitem.ServerRelativeUrl;
                    var url = O365Auth.Settings.sitecollectionUrl + "/_api/web/GetFileByServerRelativeUrl('" + photoServerRelativeUrl + "')/$value";
                    listClient.getBinary(url, (function (data) {
                        //get binary success

                        var base64date = 'data:image/jpeg;base64,' + data;
                        incidentItem.imageArray.push(base64date);
                        viewModel.updateAnInspectorRoomPhoto(base64date);
                        this.getRoomInspectionPhotosListLoop(incidentItem, listitems, nextindex)
                    }).bind(this),
                    (function (xhr) {
                        //get binary failed
                        console.log("get RoomInspection Photos List Loop fail." + index);
                        this.getRoomInspectionPhotosListLoop(incidentItem, listitems, nextindex)
                    }).bind(this));
                }).bind(this),
                (function (xhr) {
                    console.log("get incident list items fail." + index)
                    this.getRoomInspectionPhotosListLoop(incidentItem, listitems, nextindex)
                }).bind(this));
            }
        },
        showIncidentDetailPage: function (index) {
            var incidentItem = this.incidentListArray[index];
            viewModel.updateinspectionAndIncidentDetailViewModel(incidentItem);
            rpDevice.showBeforeBtn();
        },
        showRoomInspectionPhotosView: function(idtemp){
            var incidentItem = this.findIncidentItemById(idtemp);
            if (incidentItem != null) {
                if (typeof (incidentItem.imageArray) == 'undefined') {
                    this.getRoomInspectionPhotosListId(incidentItem);
                }
                else
                {
                    viewModel.updateInspectorRoomsPhotosList(incidentItem.imageArray);
                }
            }
        },
        updateRepairCompleted: function(incidentId)
        {
            //var incidentItem = this.findIncidentItemById(incidentId);
            //this.sendEmailUsingREST(incidentItem);
            //return;

            var url = O365Auth.Settings.sitecollectionUrl +
                   "/_api/lists/GetByTitle('Incidents')/Items(" + incidentId + ")";


            var repairCompleted = rpUtil.getStringFromCurrentDate();
            var data = "{'__metadata': {'type': 'SP.Data.IncidentsListItem'},'sl_repairCompleted': '" + repairCompleted + "','sl_status':'Repair Pending Approval'}";
            this.blockLoadingUI("#detailloadingui");
            listClient.postData(url, data,
                (function () {
                    var incidentItem = this.findIncidentItemById(incidentId);
                    incidentItem["sl_status"] = "Repair Pending Approval";
                    incidentItem["sl_repairCompleted"] = repairCompleted;
                    var taskId = incidentItem["sl_taskId"];
                    if (typeof (taskId) == 'undefined'
                        || taskId==null)
                    {
                        viewModel.updateinspectionAndIncidentDetailViewModel(incidentItem);
                        //complete
                        this.unBlockLoadingUI("#detailloadingui");
                        this.displayMessageAlert("Finalized repair successfully.");
                        //send email by REST
                        this.sendEmailUsingREST(incidentItem);
                    }
                    else
                    {
                        this.updateIncidentWorkflowTask(taskId, incidentItem);
                    }

                }).bind(this), (function () {
                    this.unBlockLoadingUI("#detailloadingui");
                    this.displayMessageAlert("Finalize repair failed.")
                }).bind(this));
        },
        updateIncidentWorkflowTask: function (taskId, incidentItem)
        {
            var url = O365Auth.Settings.sitecollectionUrl + "/_api/lists/GetByTitle('Incident Workflow Tasks')/Items(" + taskId + ")";
            var data = "{'__metadata': { 'type': 'SP.Data.Incident_x0020_Workflow_x0020_TasksListItem' },'PercentComplete':1,'Status':'Completed'}";
            listClient.postData(url, data,(
                function(){
                    viewModel.updateinspectionAndIncidentDetailViewModel(incidentItem);
                    //complete
                    this.unBlockLoadingUI("#detailloadingui");
                    this.displayMessageAlert("Finalized repair successfully.");
                    //send email by REST
                    this.sendEmailUsingREST(incidentItem);
                }
                ).bind(this), (function () {
                    this.unBlockLoadingUI("#detailloadingui");
                    this.displayMessageAlert("Update Incident Workflow task failed.")
                }).bind(this));
        },
        updateRepairComments: function (incidentId, repairComments)
        {
            var url = O365Auth.Settings.sitecollectionUrl + "/_api/lists/GetByTitle('Incidents')/Items(" + incidentId + ")";
            var data = "{'__metadata': {'type': 'SP.Data.IncidentsListItem'},'sl_repairComments': '" + repairComments + "'}";
            this.blockLoadingUI("#detailloadingui");
            listClient.postData(url, data,
                (function () {
                    var incidentItem = this.findIncidentItemById(incidentId);
                    if(incidentItem!=null)
                    {
                        incidentItem["sl_repairComments"] = repairComments;

                        this.unBlockLoadingUI("#detailloadingui");
                        this.displayMessageAlert("Updated repair comments successfully.");
                    }
                }).bind(this),
                (function () {
                    this.unBlockLoadingUI("#detailloadingui");
                    this.displayMessageAlert("Update repair comments failed.");
                }).bind(this));
        },
        findIncidentItemById: function (id) {
            var found = null;
            for (var i = 0; i < this.incidentListArray.length; i++) {
                if (this.incidentListArray[i].ID == id) {
                    found = this.incidentListArray[i];
                    break;
                }
            }
            return found;
        },
        sendEmailUsingREST:function(incidentItem)
        {
            if (listClient.getEmailToken().length > 0){
                this.sendEmailNow(incidentItem);
            }
            else {
                listClient.getEmailAccessToken((function () {
                    this.sendEmailNow(incidentItem);
                }).bind(this), (function () {
                    this.displayMessageAlert("get email token failed");
                }).bind(this));
            }
        },
        sendEmailNow: function (incidentItem) {
            var propertyDeatailDic = incidentItem.sl_propertyID
            var inspectionData = incidentItem.sl_inspectionID;
            var roomData = incidentItem.sl_roomID;


            var toaddress = propertyDeatailDic.sl_emailaddress;
            var ccaddress = O365Auth.Settings.dispatcherEmail;

            var subject = "Repair Report - " + propertyDeatailDic.Title + " - " + rpUtil.getStringFromCurrentDate();
            var body = "The incident found during a recent inspection on your property has been repaired.\r\n\r\nProperty Name: " + propertyDeatailDic.Title + "\r\n\r\nProperty Address: " + propertyDeatailDic.sl_address1
                       + "\r\n\r\nInspection Date: " + rpUtil.getTimeString(inspectionData.sl_datetime)
                       + "\r\n\r\nIncident Type: " + incidentItem.sl_type
                       + "\r\n\r\nRoom: " + roomData.Title;

            if (incidentItem.sl_inspectorIncidentComments != null) {
                body = body + "\r\n\r\nComments from the inspector: \r\n" + incidentItem.sl_inspectorIncidentComments;
            }
            if (incidentItem.sl_date != null) {
                body = body + "\r\n\r\nIncident reported: " + incidentItem.sl_date;
            }
            body = body + "\r\n\r\nRepair Date: " + incidentItem.sl_repairCompleted;
            if (incidentItem.sl_repairComments != null) {
                body = body + "\r\n\r\nComments from repair person: \r\n" + incidentItem.sl_repairComments;
            }

            var postdata = {
                "Message": {
                    "Subject": subject,
                    "Body": {
                        "ContentType": "Text",
                        "Content": body
                    },
                    "ToRecipients": [
                      {
                          "EmailAddress": {
                              "Address": toaddress
                          }
                      }
                    ],
                    "CcRecipients": [
                        {
                            "EmailAddress": {
                                "Address": ccaddress
                            }
                        }
                    ]
                },
                "SaveToSentItems": "true"
            }

            var url = "https://outlook.office365.com/api/v1.0/me/sendmail";
            //this.displayMessageAlert(JSON.stringify(postdata));
            $.ajax({
                type: "POST",
                async: true,
                url: url,
                contentType: "application/json",
                data: JSON.stringify(postdata),
                headers: {
                    "Authorization": "Bearer " + listClient.getEmailToken(),
                    "accept": "application/json"
                },
            })
            .done(
                   (function () {
                       //this.displayMessageAlert("send email success");
                   }).bind(this)
               )
            .fail((function () {
                this.displayMessageAlert("send email failed");
            }).bind(this));
        },
        //image is base64 string data:image/jpeg;base64,
        uploadImage: function (incidentId, image)
        {
            var filename = rpUtil.getFileName()+".jpg";
            var url = O365Auth.Settings.sitecollectionUrl + "/_api/web/GetFolderByServerRelativeUrl('RepairPhotos')/Files/add(url='" + filename + "',overwrite=true)";
            this.blockLoadingUI("#detailloadingui");
            listClient.postBinary(url, image,
                (function () {
                    var url = O365Auth.Settings.sitecollectionUrl + "/_api/web/GetFolderByServerRelativeUrl('RepairPhotos')/Files('" + filename + "')/ListItemAllFields";
                    listClient.getListItems(url, (function (listitem) {

                        var photoId = listitem.Id;
                        var incidentItem = this.findIncidentItemById(incidentId);
                        var inspectionId = incidentItem.sl_inspectionIDId;
                        var RoomId = incidentItem.sl_roomIDId;
                        var url = O365Auth.Settings.sitecollectionUrl + "/_api/lists/GetByTitle('Repair Photos')/Items(" + photoId + ")";
                        var data = "{'__metadata': { 'type': 'SP.Data.RepairPhotosItem' },'sl_inspectionIDId':" + inspectionId + ",'sl_incidentIDId':" + incidentId + ",'sl_roomIDId':" + RoomId + "}";

                        listClient.postData(url, data,
                            (function () {
                                this.unBlockLoadingUI("#detailloadingui");
                            }).bind(this),
                            (function () {
                                this.unBlockLoadingUI("#detailloadingui");
                                this.displayMessageAlert("Update Repair Photos failed.");
                            }).bind(this));
                    }).bind(this),
                    (function () {
                        this.unBlockLoadingUI("#detailloadingui");
                        this.displayMessageAlert("Get Image Item Id Failed.");
                    }).bind(this));
                }).bind(this),
                (function () {
                    this.unBlockLoadingUI("#detailloadingui");
                    this.displayMessageAlert("UploadImage failed.");
                }).bind(this));
        },
        selectPhoto: function (incidentId) {

            navigator.camera.getPicture((function (imageData) {
                var src = "data:image/jpeg;base64," + imageData;
                viewModel.updateNewPhotoList(src);
                this.uploadImage(incidentId, src)
            }).bind(this),
            (function () {
                this.displayMessageAlert('Camera Failed because: ' + message);
            }).bind(this),
            {
                quality: 50,
                destinationType: Camera.DestinationType.DATA_URL,
                encodingType: Camera.EncodingType.JPEG,
                sourceType: Camera.PictureSourceType.PHOTOLIBRARY
            });
        },
        takeNewPhoto: function (incidentId) {

            navigator.camera.getPicture((function (imageData) {
                var src = "data:image/jpeg;base64," + imageData;
                viewModel.updateNewPhotoList(src);
                this.uploadImage(incidentId, src)
            }).bind(this),
            (function () {
                this.displayMessageAlert('Camera Failed because: ' + message);
            }).bind(this),
            {
                quality: 50,
                destinationType: Camera.DestinationType.DATA_URL,
                encodingType: Camera.EncodingType.JPEG,
                sourceType: Camera.PictureSourceType.CAMERA
            });
        },
        displayMessageAlert: function (message) {
            navigator.notification.alert(
                             message,
                             null,
                             'Notification',
                             'OK'
                             );

        },

        blockLoadingUI: function (obj) {
            $(obj).show();

        },
        unBlockLoadingUI: function (obj) {
            $(obj).hide();
        },
        adjustPageHeight: function () {
            var height = window.screen.height;
            if (height > 644 + 71) {
                $("#incidentpage>table").css("min-height", height - 71);
            }
        },
        adjustBackgroundHeight: function () {
            var height = window.screen.height;
            var pageHeight = $(".page").height();

            if (height < pageHeight) {
                height = pageHeight
            }
            $("#rp_background").height(height);
            $("#rp_background").show();
        },
        hideBackground: function () {
            $("#rp_background").hide();;
        },
        clickBackground: function () {
            if (viewModel.cameraHintView.bshow()) {
                viewModel.cameraHintView.hideCameraHint();
            }
        },
    };