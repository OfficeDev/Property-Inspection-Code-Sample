var listClient =
{
    accessToken: '',
    emailaccessToken: '',
    authContext:null,
    setToken: function(tk)
    {
       // console.log(tk);
        this.accessToken = tk;
    },
    getToken: function()
    {
        return this.accessToken;
    },
    setEmailToken: function (tk) {
      //  console.log(tk);
        this.emailaccessToken = tk;
    },
    getEmailToken: function () {
        return this.emailaccessToken;
    },
    getAccessToken: function(successCallBack, rejectCallBack)
    {
        //authenticate to Office 365
        if (this.authContext == null)
        {
            this.authContext = new O365Auth.Context();
        }

        
        //authContext.logOut();
        this.authContext.getAccessToken(O365Auth.Settings.resourceId)
        .then(
            (function (token) {
                this.setToken(token);
                successCallBack();
            }).bind(this)
            ,
            function (reason) {
                rejectCallBack(reason);
            }
        )
    },
    signOut: function (successCallBack, rejectCallBack)
    {
        if (this.authContext == null) {
            this.authContext = new O365Auth.Context();
        }
        this.authContext.logOut()
        .then(function(){
            successCallBack()
        },
        function (reason) {
            rejectCallBack(reason)
        });
    },
    getEmailAccessToken: function (successCallBack, rejectCallBack) {
        //authenticate to Office 365
        if (this.authContext == null) {
            this.authContext = new O365Auth.Context();
        }
        this.authContext.getAccessToken("https://outlook.office365.com/")
        .then(
            (function (token) {
                this.setEmailToken(token);
                successCallBack();
            }).bind(this)
            ,
            function (reason) {
                rejectCallBack(reason);
            }
        )
    },
    getListItems: function(url , successcallback, failcallback)
    {
        $.ajax({
            type: "GET",
            async:true,
            url: url,
            headers: { "Authorization": "Bearer " +this.getToken(),
                     "accept":"application/json;odata=verbose"},
        }).
        done(
                (function (data) {
                    //console.log(data);
                    var listitems = this.parseJsonDataToArray(data);
                    successcallback(listitems);
                }).bind(this)
        )
        .fail(function (jqXHR, textStatus) {
            failcallback(textStatus)
        });
    },
    postData: function (url, postdata, successcallback, failcallback)
    {
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
        done(
            function () {
                successcallback();
            }
        )
        .fail(function (jqXHR, textStatus) {
            failcallback(textStatus)
        });
    },
    parseJsonDataToArray: function(data)
    {
        var ret = (data["d"])["results"];
        if(typeof(ret) == "undefined")
        {
            ret = data["d"];
        }
        return ret;
    },
    getBinary: function(url , successcallback, failcallback)
    {
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

    },
    postBinary: function(url,binary,successcallback, failcallback)
    {
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
                //"content-length": imageBinary.length
            }
        }).done(function () {
            successcallback();
        })
        .fail(function (jqXHR, textStatus, errorThrown) {
            failcallback(jqXHR);
        });
    },
};


