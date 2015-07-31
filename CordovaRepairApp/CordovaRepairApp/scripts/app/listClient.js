var listClient = {
    accessToken: '',
    emailaccessToken: '',
    authContext: null,
    setToken: function (tk) {
        this.accessToken = tk;
    },
    getToken: function () {
        return this.accessToken;
    },
    setEmailToken: function (tk) {
        this.emailaccessToken = tk;
    },
    getEmailToken: function () {
        return this.emailaccessToken;
    },
    getAccessToken: function (successCallBack, rejectCallBack) {
        //authenticate to Office 365
        if (this.authContext == null) {
            this.authContext = new O365Auth.Context();
        }
        this.authContext.getAccessToken(O365Auth.Settings.resourceId).then(
            (function (token) {
                this.setToken(token);
                successCallBack();
            }).bind(this),
            function (reason) {
                rejectCallBack(reason);
            });
    },
    signOut: function (successCallBack, rejectCallBack) {
        if (this.authContext == null) {
            this.authContext = new O365Auth.Context();
        }
        this.authContext.logOut().then(function () {
            successCallBack()
        }, function (reason) {
            rejectCallBack(reason)
        });
    },
    getEmailAccessToken: function (successCallBack, rejectCallBack) {
        //authenticate to Office 365
        if (this.authContext == null) {
            this.authContext = new O365Auth.Context();
        }
        this.authContext.getAccessToken("https://graph.microsoft.com/").then(
            (function (token) {
                this.setEmailToken(token);
                successCallBack();
            }).bind(this),
            function (reason) {
                rejectCallBack(reason);
            })
    },
    getListItems: function (url, successcallback, failcallback) {
        $.ajax({
            type: "GET",
            async: true,
            url: url,
            headers: {
                "Authorization": "Bearer " + this.getToken(),
                "accept": "application/json;odata=verbose"
            },
        }).
            done(
            (function (data) {
                var listitems = this.parseJsonDataToArray(data);
                successcallback(listitems);
            }).bind(this)).fail(function (jqXHR, textStatus) {
                failcallback(textStatus)
            });
    },
    postData: function (url, postdata, successcallback, failcallback) {
        $.ajax({
            type: "POST",
            async: true,
            url: url,
            data: postdata,
            headers: {
                "Authorization": "Bearer " + this.getToken(),
                "accept": "application/json;odata=verbose",
                "content-type": "application/json;odata=verbose",
                "IF-MATCH": "*",
                "X-HTTP-Method": "MERGE",
            },
        }).
            done(function () {
                successcallback();
            }).fail(function (jqXHR, textStatus) {
                failcallback(textStatus)
            });
    },
    parseJsonDataToArray: function (data) {
        var ret = (data["d"])["results"];
        if (typeof (ret) == "undefined") {
            ret = data["d"];
        }
        return ret;
    },
    getBinary: function (url, successcallback, failcallback) {
        if (navigator.userAgent.indexOf('MSIE 10.0') != -1 && url.indexOf('jpg') != -1) {
            var request = new XMLHttpRequest();
            request.open("GET", url, false);
            request.responseType = "arraybuffer";
            request.setRequestHeader("Authorization", "Bearer " + this.getToken());
            request.send(null);
            if (request.status === 200) {
                var arrayBuffer = request.response; // Note: not oReq.responseText
                if (arrayBuffer) {
                    var byteArray = new Uint8Array(arrayBuffer);
                    var str = [];
                    for (var i = 0; i < byteArray.length; i++) {
                        str.push(String.fromCharCode(byteArray[i]));
                    }
                    successcallback(rpUtil.base64Encode(str.join('')));
                }
            }
        }
        else {
            $.ajax({
                async: true,
                url: url,
                type: "GET",
                headers: {
                    "Authorization": "Bearer " + this.getToken()
                },
                xhrFields: {
                    withCredentials: true
                },
                mimeType: "text/plain; charset=x-user-defined"
            }).done(function (data, textStatus, jqXHR) {
                successcallback(rpUtil.base64Encode(data))
            }).fail(function (jqXHR, textStatus, errorThrown) {
                failcallback(jqXHR)
            });
        }
    },
    postBinary: function (url, binary, successcallback, failcallback) {
        var imageBinary = rpUtil.convertDataURIToBinary(binary);
        $.ajax({
            async: true,
            url: url,
            data: imageBinary,
            type: 'POST',
            contentType: "application/octet-stream;odata=verbose",
            processData: false,
            headers: {
                "Authorization": "Bearer " + this.getToken(),
                "accept": "application/json;odata=verbose",
            }
        }).done(function () {
            successcallback();
        }).fail(function (jqXHR, textStatus, errorThrown) {
            failcallback(jqXHR);
        });
    },
};