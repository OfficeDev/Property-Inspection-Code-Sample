var viewModel = {
    propetyDetailView: {
        Title: ko.observable(),
        Owner: ko.observable(),
        Address: ko.observable(),
        ImageUrl: ko.observable(),
        ContactOwner: ko.observable(),
        ContactOffice: ko.observable(),
        ContactOwnerClick: function () {
            rpUtil.sendEmailByNative(new Array(this.ContactOwner()));
        },
        ContactOfficeClick: function () {
            rpUtil.sendEmailByNative(new Array(this.ContactOwner()));
        },
    },
    inspectionDetailView: {
        IncidentId: ko.observable(),
        completedDate: ko.observable(),
        inspectionDetailArray: ko.observableArray(),
        inspectionDetailClick: function (index, obj) {
            if (index == 1) {
                rpUtil.sendEmailByNative(new Array(obj.Detail()));
            }
        },
        finalizeBtnClick: function () {
            incidentCtrl.updateRepairCompleted(this.IncidentId());
        }
    },
    incidentListsView: {
        incidentList: ko.observableArray(),
        IncidentItemClick: function (index) {
            incidentCtrl.showIncidentDetailPage(index);
        }
    },
    incidentItem: function (objData) {
        var propertyData = objData["sl_propertyID"];
        var inspectionData = objData["sl_inspectionID"];
        var roomData = objData["sl_roomID"];
        this.IncidentId = ko.observable(objData["ID"]);
        this.InspectionId = ko.observable(objData["sl_inspectionIDId"]);
        this.RoomId = ko.observable(objData["sl_roomIDId"]);
        this.RoomTitle = ko.observable(roomData["Title"]);
        this.IncidentTitle = ko.observable(objData["Title"]);
        this.InspectionDate = ko.observable(rpUtil.getTimeString(inspectionData["sl_datetime"]));
        this.RepairDate = ko.observable(rpUtil.getTimeString(inspectionData["sl_finalized"]));
        this.Approved = ko.observable(objData["sl_status"]);
        this.ImageUrl = ko.observable("images/default.png");

        this.RepairApproveDate = ko.observable(objData["sl_repairApproved"]);
        this.ApprovedWP = ko.computed(function () {
            var html = "";
            if (this.RepairApproveDate() != null) {
                html = "<span class='approved'>Approved: " + rpUtil.getTimeString(this.RepairApproveDate()) + "</span>";
            }
            else {
                html = "<span class='notApproved'>Not Approved</span>";
            }
            return html;
        }, this);
    },
    inspectionDetailItem: function (objData) {
        this.ImageUrl = ko.observable(objData["ImageUrl"]);
        this.Detail = ko.observable(objData["Detail"]);
    },
    incidentDetailView: null,
    incidentDetailViewModle: function (objData) {
        var propertyData = objData["sl_propertyID"];
        var inspectionData = objData["sl_inspectionID"];
        var roomData = objData["sl_roomID"];
        this.IncidentId = ko.observable(objData["ID"]);
        this.RoomTitle = ko.observable(roomData["Title"]);
        this.IncidentType = ko.observable(objData["sl_type"]);
        this.Status = ko.observable(objData["sl_status"]);
        this.detailTitle = ko.computed(function () {
            var str = "Room: ";
            if (typeof (this.RoomTitle()) != "undefined") {
                str += this.RoomTitle();
            }
            str += "  |  Type: ";
            if (typeof (this.IncidentType()) != "undefined") {
                str += this.IncidentType();
            }
            return str;
        }, this);

        this.DispatcherComments = ko.observable(objData["sl_dispatcherComments"]);
        this.InspectorIncidentComments = ko.observable(objData["sl_inspectorIncidentComments"]);
        this.InspectorRoomPhotosList = ko.observableArray();
        this.NewPhotosList = ko.observableArray();
        this.RepairComments = ko.observable(objData["sl_repairComments"]);

        this.RepairCommentsEnable = ko.computed(function () {
            return (!(this.Status() == 'Repair Pending Approval' || this.Status() == 'Repair Approved'))
        }, this);

        this.DoneBtnHidden = ko.computed(function () {
            return (this.Status() == 'Repair Pending Approval' || this.Status() == 'Repair Approved');
        }, this);

        this.DoneBtnClick = function () {
            incidentCtrl.updateRepairComments(this.IncidentId(), this.RepairComments());
        };

        this.selectButonIndex = ko.observable(0);
        this.dispatcherBtnClick = function () {
            this.selectButonIndex(0);
        };
        this.inspectorComentsBtnClick = function () {
            this.selectButonIndex(1);
            incidentCtrl.showRoomInspectionPhotosView(this.IncidentId());
        };
        this.addComentsBtnClick = function () {
            this.selectButonIndex(2);
        };
        this.cameraBtnClick = function () {
            incidentCtrl.adjustBackgroundHeight()
            viewModel.cameraHintView.bshow(true);
        };
        this.InpectorRoomPhotoClick = function (index, data) {
            viewModel.largeImageView.showLargeImage(data);
        };
        this.NewRepairPhotoClick = function (index, data) {
            viewModel.largeImageView.showLargeImage(data);
        };
    },
    largeImageView: {
        imageBase64Data: ko.observable(),
        bshow: ko.observable(false),
        showLargeImage: function (data) {
            incidentCtrl.adjustBackgroundHeight();
            this.imageBase64Data(data).bshow(true);
        },
        closeLargeImage: function () {
            this.bshow(false);
            incidentCtrl.hideBackground();
        },
    },
    cameraHintView: {
        bshow: ko.observable(false),
        showCameraHint: function (data) {
            incidentCtrl.adjustBackgroundHeight();
            this.bshow(true);
        },
        hideCameraHint: function () {
            this.bshow(false);
            incidentCtrl.hideBackground();
        },
        selectPhotoClick: function () {
            this.bshow(false);
            incidentCtrl.hideBackground();
            incidentCtrl.selectPhoto(viewModel.incidentDetailView.IncidentId());
        },
        takeNewPhotoClick: function () {
            this.bshow(false);
            incidentCtrl.hideBackground();
            incidentCtrl.takeNewPhoto(viewModel.incidentDetailView.IncidentId());
        },
    },
    bindViewModel: function () {
        ko.applyBindings(this.propetyDetailView, document.getElementById('rp_propertyDetailTable'));
        ko.applyBindings(this.inspectionDetailView, document.getElementById('rp_inspectionDetail'));
        ko.applyBindings(this.incidentListsView, document.getElementById('rp_incidentslist'));
        ko.applyBindings(this.largeImageView, document.getElementById('rp_largeimage'));
        ko.applyBindings(this.cameraHintView, document.getElementById('rp_cameraHint'));
    },
    updatePropertyViewMOdel: function (obj) {
        this.propetyDetailView
                    .Title(obj.Title)
                    .Owner(obj.sl_owner)
                    .Address(obj.sl_address1)
                    .ContactOffice(O365Auth.Settings.dispatcherEmail)
                    .ContactOwner(obj.sl_emailaddress);
    },
    updateincidentListsViewMOdel: function (array) {
        var retArray = new Array();
        for (var i = 0; i < array.length; i++) {
            var itemmodel = new this.incidentItem(array[i]);
            retArray.push(itemmodel);

        }
        this.incidentListsView.incidentList(retArray);
    },
    updateIncidentDetailViewModel: function (objData) {
        var propertyData = objData["sl_propertyID"];
        var inspectionData = objData["sl_inspectionID"];
        var roomData = objData["sl_roomID"];

        this.incidentDetailView
            .IncidentId(objData["ID"])
            .selectButonIndex(0)
            .RoomTitle(roomData["Title"])
            .IncidentType(objData["sl_type"])
            .Status(objData["sl_status"])
            .DispatcherComments(objData["sl_dispatcherComments"])
            .InspectorIncidentComments(objData["sl_inspectorIncidentComments"])
            .RepairComments(objData["sl_repairComments"]);
        this.incidentDetailView.InspectorRoomPhotosList.removeAll();
        this.incidentDetailView.NewPhotosList.removeAll();

    },
    updateinspectionAndIncidentDetailViewModel: function (obj) {
        var inspectionData = obj["sl_inspectionID"];
        var array = [new this.inspectionDetailItem({ "ImageUrl": "images/man.png", "Detail": inspectionData["sl_inspector"] }),
                    new this.inspectionDetailItem({ "ImageUrl": "images/email.png", "Detail": inspectionData["sl_emailaddress"] }),
                    new this.inspectionDetailItem({ "ImageUrl": "images/calendar.png", "Detail": rpUtil.getTimeString(inspectionData["sl_datetime"]) })];
        this.inspectionDetailView
            .IncidentId(obj["ID"])
            .completedDate(obj["sl_repairCompleted"])
            .inspectionDetailArray(array);

        if (this.incidentDetailView == null) {
            this.incidentDetailView = new this.incidentDetailViewModle(obj)
            ko.applyBindings(this.incidentDetailView, document.getElementById('rp_incidentsdetail'));
        }
        else {
            this.updateIncidentDetailViewModel(obj);
        }
    },
    updateInspectorRoomsPhotosList: function (array) {
        this.incidentDetailView.InspectorRoomPhotosList(array)
    },
    updateAnInspectorRoomPhoto: function (data) {
        this.incidentDetailView.InspectorRoomPhotosList.push(data)
    },
    updateNewPhotoList: function (data) {
        this.incidentDetailView.NewPhotosList.push(data)
    }
};