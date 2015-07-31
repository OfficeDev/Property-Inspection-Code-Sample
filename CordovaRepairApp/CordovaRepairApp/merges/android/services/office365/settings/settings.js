//Android app version settings
var O365Auth;
(function (O365Auth) {
    (function (Settings) {
        
        Settings.clientId = 'YOUR CLIENT ID';
        Settings.redirectUri = 'http://localhost:4400/services/office365/redirectTarget.html';
        Settings.authUri = 'https://login.microsoftonline.com/common/';
        Settings.resourceId = 'https://TENANCY.sharepoint.com/';
        Settings.sitecollectionUrl = 'https://TENANCY.sharepoint.com/sites/SuiteLevelAppDemo';
        Settings.dispatcherEmail = 'katiej@TENANCY.onmicrosoft.com';

    })(O365Auth.Settings || (O365Auth.Settings = {}));
    var Settings = O365Auth.Settings;
})(O365Auth || (O365Auth = {}));