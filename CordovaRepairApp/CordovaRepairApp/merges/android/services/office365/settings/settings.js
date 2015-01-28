
var O365Auth;
(function (O365Auth) {
    (function (Settings) {
        Settings.clientId = 'YOUR CLIENT ID';

        //Android
        Settings.redirectUri = 'http://localhost:4420/services/office365/redirectTarget.html';

        Settings.authUri = 'https://login.windows.net/common/';
        Settings.resourceId = 'https://TENANCY.sharepoint.com/';
        Settings.sitecollectionUrl = 'https://TENANCY.sharepoint.com/sites/SuiteLevelAppDemo';
        Settings.dispatcherEmail = 'katiej@TENANCY.onmicrosoft.com';
    })(O365Auth.Settings || (O365Auth.Settings = {}));
    var Settings = O365Auth.Settings;
})(O365Auth || (O365Auth = {}));
