var O365Auth;
(function (O365Auth) {
    (function (Settings) {

        //PROD
        //Settings.clientId = 'YOUR CLIENT ID';
        //Settings.redirectUri = 'http://PropertyManagementRepairApp';
        //Settings.authUri = 'https://login.microsoftonline.com/common/';
        //Settings.resourceId = 'https://TENANCY.sharepoint.com/';
        //Settings.sitecollectionUrl = 'https://TENANCY.sharepoint.com/sites/SuiteLevelAppDemo';
        //Settings.dispatcherEmail = 'katiej@TENANCY.onmicrosoft.com';
        //Settings.graphResourceId = 'https://graph.microsoft.com/';
        //Settings.graphResourceUrl = 'https://graph.microsoft-ppe.com/beta/';

    })(O365Auth.Settings || (O365Auth.Settings = {}));
    var Settings = O365Auth.Settings;
})(O365Auth || (O365Auth = {}));