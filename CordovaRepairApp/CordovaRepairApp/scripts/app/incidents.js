// For an introduction to the Blank template, see the following documentation:
// http://go.microsoft.com/fwlink/?LinkID=397704
// To debug code on page load in Ripple or on Android devices/emulators: launch your app, set breakpoints, 
// and then run "window.location.reload()" in the JavaScript Console.

(function () {
    "use strict";

    document.addEventListener('deviceready', onDeviceReady.bind(this), false);

    function onDeviceReady() {
        initLibrary();
        $("#rp_loginbtn").click(function () {
            incidentCtrl.onGetAccessToken();
        })
        $(".rp_backBtn").click(function () {
            rpDevice.beforeBtnClicked();
        })
        $("#rp_background").click(function () {
            incidentCtrl.clickBackground();
        });
        $("#rp_loginOut").click(function () {
            incidentCtrl.signOut();
        });
    };
    function initLibrary() {
        if (typeof (viewModel) == "undefined") {
            incidentCtrl.displayMessageAlert("Please check view model.")
        }
        viewModel.bindViewModel();
    };
})();






