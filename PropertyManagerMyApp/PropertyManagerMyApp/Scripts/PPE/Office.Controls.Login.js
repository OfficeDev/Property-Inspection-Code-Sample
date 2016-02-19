(function() {
    "use strict";

    if (window.Type && window.Type.registerNamespace) {
        Type.registerNamespace('Office.Controls');
    } else {
        if (window.Office === undefined) {
            window.Office = {};
            window.Office.namespace = true;
        }
        if (window.Office.Controls === undefined) {
            window.Office.Controls = {};
            window.Office.Controls.namespace = true;
        }
    }

    Office.Controls.ImplicitGrantLogin = function(config) {
        this.authContext = new AuthenticationContext(config);
        this.authContext.handleWindowCallback();
    };

    Office.Controls.ImplicitGrantLogin.prototype = {
        authContext: null,
        aadGraphResourceId: 'https://graph.microsoft-ppe.com/',
        apiVersion: '',

        login: function(callback) {
            var objNull = null;
            if (!Office.Controls.Utils.isNullOrUndefined(callback) && !Office.Controls.Utils.isFunction(callback)) {
                throw new Error('callback is not a function');
            }
            if (this.authContext) {
                if (!Office.Controls.Utils.isNullOrUndefined(callback)) {
                    this.authContext.callback = callback;
                }
                this.authContext.login();
            } else {
                console.log('SignIn failed');
            }
        },

        logout: function() {
            if (this.authContext && this.authContext.getCachedUser) {
                this.authContext.logOut();
            } else {
                console.log('SignOut failed');
            }
        },

        getAuthContext: function() {
            return this.authContext;
        },

        getAccessTokenAsync: function(resource, callback) {
            if (!Office.Controls.Utils.isFunction(callback)) {
                throw new Error('callback is not a function');
            }
            this.authContext.acquireToken(resource, function(error, token) {
                // Handle ADAL Error
                if (error || !token) {
                    console.log('ADAL Error Occurred: ' + error);
                    return;
                }
                callback(error, token)
            });
        },

        getCurrentUser: function() {
            return this.authContext.getCachedUser();
        },

        hasLogin: function() {
            var user = this.authContext.getCachedUser();
            if (user) {
                return true;
            } else {
                return false;
            }
        },

        getUserImageAsync: function(personId, callback) {
            var self = this;
            self.authContext.acquireToken(self.aadGraphResourceId, function(error, token) {
                // Handle ADAL Errors
                if (error || !token) {
                    callback('Error', null);
                    return;
                }

                var parsed = self.authContext._extractIdToken(token);
                var tenant = '';

                if (parsed) {
                    if (parsed.hasOwnProperty('tid')) {
                        tenant = parsed.tid;
                    }
                }

                var xhr = new XMLHttpRequest();

                xhr.open('GET', 'https://graph.microsoft-ppe.com/beta/' + tenant + '/users/' + personId + '/photo/$value');
                xhr.setRequestHeader('Content-Type', 'application/json');
                xhr.setRequestHeader('Authorization', 'Bearer ' + token);
                xhr.responseType = "blob";
                xhr.onabort = xhr.onerror = xhr.ontimeout = function() {
                    callback('Error', null);
                };
                xhr.onload = function() {
                    if (xhr.status === 401) {
                        callback('Unauthorized', null);
                        return;
                    }
                    if (xhr.status !== 200) {
                        callback('Unknown error', null);
                        return;
                    }

                    var reader = new FileReader();
                    reader.addEventListener("loadend", function() {
                        callback(null, reader.result);
                    });
                    reader.readAsDataURL(xhr.response);
                };
                xhr.send('');
            });
        },

        getUserInfoAsync: function(callback) {
            var user = this.authContext.getCachedUser()
            if (user) {
                var userInfo = new Object();
                userInfo.accountName = user.userName;
                userInfo.displayName = user.profile.given_name + ' ' + user.profile.family_name;
                this.getUserImageAsync(user.profile.oid, function(error, image) {
                    userInfo.imgSrc = image;
                    callback(error, userInfo);
                });
            } else {
                callback('Not login', null);
            }
        }
    };
})();