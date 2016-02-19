(function () {
    "use strict";

    if (window.Type && window.Type.registerNamespace) {
        Type.registerNamespace('Office.Controls');
    } else {
        if (window.Office === undefined) {
            window.Office = {}; window.Office.namespace = true;
        }
        if (window.Office.Controls === undefined) {
            window.Office.Controls = {}; window.Office.Controls.namespace = true;
        }
    }

    Office.Controls.Context = function (options) {
        if (typeof options !== 'object') {
            Office.Controls.Utils.errorConsole('Invalid parameters type');
            return;
        }
        var sharepointHost = options.HostUrl;
        if (Office.Controls.Utils.isNullOrUndefined(sharepointHost)) {
            var param = Office.Controls.Utils.getQueryStringParameter('SPHostUrl');
            if (!Office.Controls.Utils.isNullOrEmptyString(param)) {
                param = decodeURIComponent(param);
            }
            this.HostUrl = param;
        } else {
            this.HostUrl = sharepointHost;
        }
        this.HostUrl = this.HostUrl.toLocaleLowerCase();
    };
    Office.Controls.Context.prototype = {
        HostUrl: null
    };

    Office.Controls.Runtime = function () { };
    Office.Controls.Runtime.initialize = function (options) {
        Office.Controls.Runtime.context = new Office.Controls.Context(options);
    };

    Office.Controls.Browser = function (browserType) {
        this.browserType = browserType;
        this.userAgent = navigator.userAgent.toLowerCase();
    } ;

    Office.Controls.Browser.prototype = {
        /**
         * Check the type of current browser
         * @return {Boolean}
         */
        isExpectedBrowser: function() {
            var isExpected = (this.userAgent.indexOf(this.browserType.toString()) !== -1);

            switch (this.browserType) {
                case Office.Controls.Browser.TypeEnum.IE:
                case Office.Controls.Browser.TypeEnum.Firefox:
                case Office.Controls.Browser.TypeEnum.Opera:
                    return isExpected;
                case Office.Controls.Browser.TypeEnum.Safari:
                    // The part of Chrome UserAgent value is AppleWebKit/537.36 (KHTML, like Gecko) Chrome/31.0.1650.63 Safari/537.36
                    return isExpected && (!this.isContainChromeStr());
                case Office.Controls.Browser.TypeEnum.Chrome:
                    // The part of Opera UserAgent value is Chrome/31.0.1650.63 Safari/537.36 OPR/18.0.1284.68
                    return isExpected && (!this.isContainOperaStr());
                default:
                    return false;
            }
        },

        isContainChromeStr: function() {
            return (this.userAgent.indexOf(Office.Controls.Browser.TypeEnum.Chrome.toString()) !== -1);
        },

        isContainOperaStr: function() {
            return (this.userAgent.indexOf(Office.Controls.Browser.TypeEnum.Opera.toString()) !== -1);
        }
    };

    // The browser type
    Office.Controls.Browser.TypeEnum = {
        // The article of search
        IE: "trident",
        // Table of contents, means the chapter of current search article
        Chrome: "chrome",
        // The images in current search article
        Firefox: "firefox",
        // The infobox tables in current search article
        Safari: "safari",
        // The reference of current search article
        Opera: "opr"
    };

    Office.Controls.Utils = function () { };
    // Construct browser in different browser type
    Office.Controls.Utils.isIE = function () {
        var browser = new Office.Controls.Browser(Office.Controls.Browser.TypeEnum.IE);
        return browser.isExpectedBrowser();
    };

    Office.Controls.Utils.isChrome = function () {
        var browser = new Office.Controls.Browser(Office.Controls.Browser.TypeEnum.Chrome);
        return browser.isExpectedBrowser();
    };

    Office.Controls.Utils.isSafari = function () {
        var browser = new Office.Controls.Browser(Office.Controls.Browser.TypeEnum.Safari);
        return browser.isExpectedBrowser();
    };

    Office.Controls.Utils.isFirefox = function () {
        var browser = new Office.Controls.Browser(Office.Controls.Browser.TypeEnum.Firefox);
        return browser.isExpectedBrowser();
    };

    Office.Controls.Utils.isOpera = function () {
        var browser = new Office.Controls.Browser(Office.Controls.Browser.TypeEnum.Opera);
        return browser.isExpectedBrowser();
    };

    Office.Controls.Utils.deserializeJSON = function (data) {
        if (Office.Controls.Utils.isNullOrEmptyString(data)) {
            return {};
        }
        return JSON.parse(data);
    };
    Office.Controls.Utils.serializeJSON = function (obj) {
        return JSON.stringify(obj);
    };
    Office.Controls.Utils.isNullOrEmptyString = function (str) {
        var strNull = null;
        return str === strNull || str === undefined || !str.length;
    };
    Office.Controls.Utils.isNullOrUndefined = function (obj) {
        var objNull = null;
        return obj === objNull || obj === undefined;
    };
    Office.Controls.Utils.getQueryStringParameter = function (paramToRetrieve) {
        if (document.URL.split('?').length < 2) {
            return null;
        }
        var queryParameters = document.URL.split('?')[1].split('#')[0].split('&'), i;
        for (i = 0; i < queryParameters.length; i = i + 1) {
            var singleParam = queryParameters[i].split('=');
            if (singleParam[0].toLowerCase() === paramToRetrieve.toLowerCase()) {
                return singleParam[1];
            }
        }
        return null;
    };

    Office.Controls.Utils.logConsole = function (message) {
        console.log(message);
    };

    Office.Controls.Utils.warnConsole = function (message) {
        console.warn(message);
    };

    Office.Controls.Utils.errorConsole = function (message) {
        // console.error(message);
    };

    Office.Controls.Utils.getObjectFromFullyQualifiedName = function (objectName) {
        var currentObject = window.self;
        return Office.Controls.Utils.getObjectFromJSONObjectName(currentObject, objectName);
    };

    // Parse the json object to get the corresponding value
    Office.Controls.Utils.getObjectFromJSONObjectName = function (jsonObject, objectName) {
        var currentObject = jsonObject;
        if (Office.Controls.Utils.isNullOrUndefined(currentObject)) {
                return null;
        } 

        var controlNameParts = objectName.split('.'), i;
        for (i = 0; i < controlNameParts.length; i++) {
            currentObject = currentObject[controlNameParts[i]];
            if (Office.Controls.Utils.isNullOrUndefined(currentObject)) {
                return null;
            }
        }
        return currentObject;
    };

    Office.Controls.Utils.getStringFromResource = function (controlName, stringName) {
        var resourceObjectName = 'Office.Controls.' + controlName + 'Resources', res,
        nonPreserveCase = stringName.charAt(0).toString().toLowerCase() + stringName.substr(1);
        resourceObjectName += 'Defaults';
        res = Office.Controls.Utils.getObjectFromFullyQualifiedName(resourceObjectName);
        if (!Office.Controls.Utils.isNullOrUndefined(res)) {
            return res[stringName];
        }
        return stringName;
    };

    Office.Controls.Utils.addEventListener = function (element, eventName, handler) {
        var h = function (e) {
            try {
                return handler(e);
            } catch (ex) {
                throw ex;
            }
        };
        if (!Office.Controls.Utils.isNullOrUndefined(element.addEventListener)) {
            element.addEventListener(eventName, h, false);
        } else if (!Office.Controls.Utils.isNullOrUndefined(element.attachEvent)) {
            element.attachEvent('on' + eventName, h);
        }
    };

    Office.Controls.Utils.removeEventListener = function (element, eventName, handler) {
        var h = function (e) {
            try {
                return handler(e);
            } catch (ex) {
                throw ex;
            }
        };
        if (!Office.Controls.Utils.isNullOrUndefined(element.removeEventListener)) {
            element.removeEventListener(eventName, h, false);
        } else if (!Office.Controls.Utils.isNullOrUndefined(element.detachEvent )) {  // For IE
            element.detachEvent ('on' + eventName, h);
        }
    };

    Office.Controls.Utils.getEvent = function (e) {
        return (Office.Controls.Utils.isNullOrUndefined(e)) ? window.event : e;
    };

    Office.Controls.Utils.getTarget = function (e) {
        return (Office.Controls.Utils.isNullOrUndefined(e.target)) ? e.srcElement : e.target;
    };

    Office.Controls.Utils.cancelEvent = function (e) {
        if (!Office.Controls.Utils.isNullOrUndefined(e.cancelBubble)) {
            e.cancelBubble = true;
        }
        if (!Office.Controls.Utils.isNullOrUndefined(e.stopPropagation)) {
            e.stopPropagation();
        }
        if (!Office.Controls.Utils.isNullOrUndefined(e.preventDefault)) {
            e.preventDefault();
        }
        if (!Office.Controls.Utils.isNullOrUndefined(e.returnValue)) {
            e.returnValue = false;
        }
        if (!Office.Controls.Utils.isNullOrUndefined(e.cancel)) {
            e.cancel = true;
        }
    };

    Office.Controls.Utils.addClass = function (elem, className) {
        if (elem.className !== '') {
            elem.className += ' ';
        }
        elem.className += className;
    };

    Office.Controls.Utils.removeClass = function (elem, className) {
        var regex = new RegExp('( |^)' + className + '( |$)');
        elem.className = elem.className.replace(regex, ' ').trim();
    };

    Office.Controls.Utils.containClass = function (elem, className) {
        return elem.className.indexOf(className) !== -1;
    };

    Office.Controls.Utils.cloneData = function (obj) {
        return Office.Controls.Utils.deserializeJSON(Office.Controls.Utils.serializeJSON(obj));
    };

    Office.Controls.Utils.formatString = function (format) {
        var args = [], $ai_8;
        for ($ai_8 = 1; $ai_8 < arguments.length; ++$ai_8) {
            args[$ai_8 - 1] = arguments[$ai_8];
        }
        var result = '';
        var i = 0;
        while (i < format.length) {
            var open = Office.Controls.Utils.findPlaceHolder(format, i, '{');
            if (open < 0) {
                result = result + format.substr(i);
                break;
            }
            var close = Office.Controls.Utils.findPlaceHolder(format, open, '}');
            if (close > open) {
                result = result + format.substr(i, open - i);
                var position = format.substr(open + 1, close - open - 1);
                var pos = parseInt(position);
                result = result + args[pos];
                i = close + 1;
            } else {
                Office.Controls.Utils.errorConsole('Invalid Operation');
                return null;
            }
        }
        return result;
    };

    Office.Controls.Utils.findPlaceHolder = function (format, start, ch) {
        var index = format.indexOf(ch, start);
        while (index >= 0 && index < format.length - 1 && format.charAt(index + 1) === ch) {
            start = index + 2;
            index = format.indexOf(ch, start);
        }
        return index;
    };

    Office.Controls.Utils.htmlEncode = function (value) {
        if (typeof (value) == "undefined") return "";
        value = value.replace(new RegExp('&', 'g'), '&amp;');
        value = value.replace(new RegExp('\"', 'g'), '&quot;');
        value = value.replace(new RegExp('\'', 'g'), '&#39;');
        value = value.replace(new RegExp('<', 'g'), '&lt;');
        value = value.replace(new RegExp('>', 'g'), '&gt;');
        return value;
    };

    Office.Controls.Utils.getLocalizedCountValue = function (locText, intervals, count) {
        var ret = '';
        var locIndex = -1;
        var intervalsArray = intervals.split('||'), i, length;
        for (i = 0, length = intervalsArray.length; i < length; i++) {
            var interval = intervalsArray[i];
            if (Office.Controls.Utils.isNullOrEmptyString(interval)) {
                continue;
            }
            var subIntervalsArray = interval.split(','), k, subLength;
            for (k = 0, subLength = subIntervalsArray.length; k < subLength; k++) {
                var subInterval = subIntervalsArray[k];
                if (Office.Controls.Utils.isNullOrEmptyString(subInterval)) {
                    continue;
                }
                if (isNaN(Number(subInterval))) {
                    var range = subInterval.split('-');
                    if (Office.Controls.Utils.isNullOrUndefined(range) || range.length !== 2) {
                        continue;
                    }
                    var min;
                    var max;
                    if (range[0] === '') {
                        min = 0;
                    } else {
                        if (isNaN(Number(range[0]))) {
                            continue;
                        }
                        min = parseInt(range[0]);
                    }
                    if (count >= min) {
                        if (range[1] === '') {
                            locIndex = i;
                            break;
                        } else {
                            if (isNaN(Number(range[1]))) {
                                continue;
                            }
                            max = parseInt(range[1]);
                        }
                        if (count <= max) {
                            locIndex = i;
                            break;
                        }
                    }
                } else {
                    var exactNumber = parseInt(subInterval);
                    if (count === exactNumber) {
                        locIndex = i;
                        break;
                    }
                }
            }
            if (locIndex !== -1) {
                break;
            }
        }
        var locValues = locText.split('||');
        if (locIndex !== -1) {
            ret = locValues[locIndex];
        }
        return ret;
    };
    Office.Controls.Utils.isFirefox = function () { return typeof InstallTrigger !== 'undefined' && navigator.userAgent.toLowerCase().indexOf('firefox') > -1; /* Firefox 1.0+ */ };
    Office.Controls.Utils.isIE10 = function () { return Function('/*@cc_on return document.documentMode===10@*/')(); } // jshint ignore:line
    Office.Controls.Utils.isFunction = function (functionToCheck) {
        var getType = {};
        return functionToCheck && getType.toString.call(functionToCheck) === '[object Function]';
    }
    Office.Controls.Utils.NOP = function () { };

    if (Office.Controls.Context.registerClass) { Office.Controls.Context.registerClass('Office.Controls.Context'); }
    if (Office.Controls.Runtime.registerClass) { Office.Controls.Runtime.registerClass('Office.Controls.Runtime'); }
    if (Office.Controls.Utils.registerClass) { Office.Controls.Utils.registerClass('Office.Controls.Utils'); }
    Office.Controls.Runtime.context = null;
    Office.Controls.Utils.oDataJSONAcceptString = 'application/json;odata=verbose';
    Office.Controls.Utils.clientTagHeaderName = 'X-ClientService-ClientTag';
})();
(function () {

    "use strict";

    if (window.Type && window.Type.registerNamespace) {
        Type.registerNamespace('Office.Controls');
    } else {
        if (window.Office === undefined) {
            window.Office = {}; window.Office.namespace = true;
        }
        if (window.Office.Controls === undefined) {
            window.Office.Controls = {}; window.Office.Controls.namespace = true;
        }
    }

    Office.Controls.PeopleAadDataProvider = function (authContext) {
        if (Office.Controls.Utils.isFunction(authContext)) {
            this.getTokenAsync = authContext;
        } else {
            this.authContext = authContext;
            if (this.authContext) {
                this.getTokenAsync = function(dataProvider, callback) {
                   this.authContext.acquireToken(this.aadGraphResourceId, function (error, token) {
                        callback(error, token);
                    });
                };
            }
        }
    }

    Office.Controls.PeopleAadDataProvider.prototype = {
        maxResult: 50,
        authContext: null,
        getTokenAsync: undefined,
        aadGraphResourceId: 'https://graph.microsoft-ppe.com/',
        apiVersion: 'api-version=1.5', 
        searchPeopleAsync: function (keyword, callback) {
            if (!this.getTokenAsync) {
                callback('getTokenAsync not set', null);
                return;
            }

            var self = this;
            self.getTokenAsync(this, function (error, token) {

                // Handle ADAL Errors
                if (error || !token) {
                    callback('Error', null);
                    return;
                }
                var parsed = self._extractIdToken(token);
                var tenant = '';

                if (parsed) {
                    if (parsed.hasOwnProperty('tid')) {
                        tenant = parsed.tid;
                    }
                }

                var xhr = new XMLHttpRequest();
                xhr.open('GET', 'https://graph.microsoft-ppe.com/beta/' + tenant + '/users?' + "&$filter=startswith(displayName," +
                    encodeURIComponent("'" + keyword + "') or ") + "startswith(userPrincipalName," + encodeURIComponent("'" + keyword + "')"), true);
                xhr.setRequestHeader('Content-Type', 'application/json');
                xhr.setRequestHeader('Authorization', 'Bearer ' + token);
                xhr.onabort = xhr.onerror = xhr.ontimeout = function () {
                    callback('Error', null);
                };
                xhr.onload = function () {
                    if (xhr.status === 401) {
                        callback('Unauthorized', null);
                        return;
                    }
                    if (xhr.status !== 200) {
                        callback('Unknown error', null);
                        return;
                    }
                    var result = JSON.parse(xhr.responseText), people = [];
                    if (result["odata.error"] !== undefined) {
                        callback(result["odata.error"], null);
                        return;
                    }

                    result.value.forEach(
                        function (e) {
                            var person = {};
                            person.displayName = e.displayName;
                            person.description = person.department = e.department;
                            person.jobTitle = e.jobTitle;
                            person.mail = e.mail;
                            person.workPhone = e.telephoneNumber;
                            person.mobile = e.mobile;
                            person.office = e.physicalDeliveryOfficeName;
                            person.sipAddress = e.userPrincipalName;
                            person.alias = e.mailNickname;
                            person.id = e.id;
                            people.push(person);
                        });
                    if (people.length > self.maxResult) {
                        people = people.slice(0, self.maxResult);
                    }
                    callback(null, people);
                };
                xhr.send('');
            });
        },

        getImageAsync: function (personId, callback) {

            var self = this;
            self.getTokenAsync(self.aadGraphResourceId, function (error, token) {

                // Handle ADAL Errors
                if (error || !token) {
                    callback('Error', null);
                    return;
                }

                var parsed = self._extractIdToken(token);
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
                xhr.onabort = xhr.onerror = xhr.ontimeout = function () {
                    callback('Error', null);
                };
                xhr.onload = function () {
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
        
        _extractIdToken: function (encodedIdToken) {
            // id token will be decoded to get the username
            var decodedToken = this._decodeJwt(encodedIdToken);
            if (!decodedToken) {
                return null;
            }

            try {
                var base64IdToken = decodedToken.JWSPayload;
                var base64Decoded = this._base64DecodeStringUrlSafe(base64IdToken);
                if (!base64Decoded) {
                    return null;
                }

                // ECMA script has JSON built-in support
                return JSON.parse(base64Decoded);
            } catch (err) {
            }

            return null;
        },
        
        _decodeJwt: function (jwtToken) {
            var idTokenPartsRegex = /^([^\.\s]*)\.([^\.\s]+)\.([^\.\s]*)$/;

            var matches = idTokenPartsRegex.exec(jwtToken);
            if (!matches || matches.length < 4) {
                this._logstatus('The returned id_token is not parseable.');
                return null;
            }

            var crackedToken = {
                header: matches[1],
                JWSPayload: matches[2],
                JWSSig: matches[3]
            };

            return crackedToken;
        },
        
        _base64DecodeStringUrlSafe: function (base64IdToken) {
            // html5 should support atob function for decoding
            base64IdToken = base64IdToken.replace(/-/g, '+').replace(/_/g, '/');
            if (window.atob) {
                return decodeURIComponent(escape(window.atob(base64IdToken))); // jshint ignore:line
            }

            // TODO add support for this
            return null;
        }
    };
})();
(function () {
    "use strict";

    if (window.Type && window.Type.registerNamespace) {
        Type.registerNamespace('Office.Controls');
    } else {
        if (window.Office === undefined) {
            window.Office = {}; window.Office.namespace = true;
        }
        if (window.Office.Controls === undefined) {
            window.Office.Controls = {}; window.Office.Controls.namespace = true;
        }
    }

    Office.Controls.PrincipalInfo = function () { };

    Office.Controls.PeoplePickerRecord = function () { };

    Office.Controls.PeoplePickerRecord.prototype = {
        isResolved: false,
        text: null,
        displayName: null,
        description: null,
        id: null,
        imgSrc: null,
        principalInfo: null
    }

    Office.Controls.PeoplePicker = function (root, dataProvider, options) {
        try {
            if (typeof root !== 'object' || typeof dataProvider !== 'object' || (!Office.Controls.Utils.isNullOrUndefined(options) && typeof options !== 'object')) {
                Office.Controls.Utils.errorConsole('Invalid parameters type');
                return;
            }
            this.root = root;
            this.dataProvider = dataProvider;
            if (!Office.Controls.Utils.isNullOrUndefined(options)) {
                if (!Office.Controls.Utils.isNullOrUndefined(options.allowMultipleSelections)) {
                    this.allowMultipleSelections = (String(options.allowMultipleSelections) === "true");
                }
                if (!Office.Controls.Utils.isNullOrUndefined(options.startSearchCharLength) && options.startSearchCharLength >= 1) {
                    this.startSearchCharLength = options.startSearchCharLength;
                }
                if (!Office.Controls.Utils.isNullOrUndefined(options.delaySearchInterval)) {
                    this.delaySearchInterval = options.delaySearchInterval;
                }
                if (!Office.Controls.Utils.isNullOrUndefined(options.enableCache)) {
                    this.enableCache = (String(options.enableCache) === "true");
                }
                if (!Office.Controls.Utils.isNullOrUndefined(options.numberOfResults)) {
                    this.numberOfResults = options.numberOfResults;
                }
                if (!Office.Controls.Utils.isNullOrEmptyString(options.inputHint)) {
                    this.inputHint = options.inputHint;
                }
                if (!Office.Controls.Utils.isNullOrUndefined(options.showValidationErrors)) {
                    this.showValidationErrors = (String(options.showValidationErrors) === "true");
                }
                if (!Office.Controls.Utils.isNullOrUndefined(options.showImage)) {
                    this.showImage = (String(options.showImage) === "true");
                }
                if (!Office.Controls.Utils.isNullOrUndefined(options.onAdd)) {
                    this.onAdd = options.onAdd;
                }
                if (!Office.Controls.Utils.isNullOrUndefined(options.onRemove)) {
                    this.onRemove = options.onRemove;
                }
                if (!Office.Controls.Utils.isNullOrUndefined(options.onChange)) {
                    this.onChange = options.onChange;
                }
                if (!Office.Controls.Utils.isNullOrUndefined(options.onFocus)) {
                    this.onFocus = options.onFocus;
                }
                if (!Office.Controls.Utils.isNullOrUndefined(options.onBlur)) {
                    this.onBlur = options.onBlur;
                }
                this.onError = options.onError;

                if (!Office.Controls.Utils.isNullOrUndefined(options.resourceStrings)) {
                    Office.Controls.PeoplePicker.resourceStrings = options.resourceStrings;
                }
            }

            this.currentTimerId = -1;
            this.selectedItems = new Array(0);
            this.internalSelectedItems = new Array(0);
            this.errors = new Array(0);
            if (this.enableCache === true) {
                Office.Controls.Runtime.initialize({ HostUrl: window.location.host });
                this.cache = Office.Controls.PeoplePicker.mruCache.getInstance();
            }

            this.renderControl();
            this.autofill = new Office.Controls.PeoplePicker.autofillContainer(this);
        } catch (ex) {
            throw ex;
        }
    };

    Office.Controls.PeoplePicker.copyToRecord = function (record, info) {
        record.displayName = info.displayName;
        record.description = info.description;
        record.id = info.id;
        record.imgSrc = info.imgSrc;
        record.principalInfo = info;
    };

    Office.Controls.PeoplePicker.parseUserPaste = function (content) {
        var openBracket = content.indexOf('<'), emailSep = content.indexOf('@', openBracket),
        closeBracket = content.indexOf('>', emailSep);
        if (openBracket !== -1 && emailSep !== -1 && closeBracket !== -1) {
            return content.substring(openBracket + 1, closeBracket);
        }
        return content;
    };
    Office.Controls.PeoplePicker.getSearchBoxClass = function () {
        return 'ms-PeoplePicker-searchBox';
    };
    Office.Controls.PeoplePicker.nopAddRemove = function () { };
    Office.Controls.PeoplePicker.nopOperation = function () { };

    Office.Controls.PeoplePicker.create = function (root, contextOrGetTokenAsync, options) {
        var dataProvider = new Office.Controls.PeopleAadDataProvider(contextOrGetTokenAsync);
        return new Office.Controls.PeoplePicker(root, dataProvider, options);
    };
    Office.Controls.PeoplePicker.prototype = {
        allowMultipleSelections: false,
        startSearchCharLength: 1,
        delaySearchInterval: 300,
        enableCache: true,
        inputHint: null,
        numberOfResults: 30,
        onAdd: Office.Controls.PeoplePicker.nopAddRemove,
        onRemove: Office.Controls.PeoplePicker.nopAddRemove,
        onChange: Office.Controls.PeoplePicker.nopOperation,
        onFocus: Office.Controls.PeoplePicker.nopOperation,
        onBlur: Office.Controls.PeoplePicker.nopOperation,
        onError: null,
        dataProvider: null,
        showValidationErrors: true,
        showImage: true,
        showInputHint: true,
        inputTabindex: 0,
        searchingTimes: 0,
        inputBeginAction: false,
        actualRoot: null,
        textInput: null,
        inputData: null,
        defaultText: null,
        resolvedListRoot: null,
        autofillElement: null,
        errorMessageElement: null,
        root: null,
        lastSearchQuery: '',
        currentToken: null,
        widthSet: false,
        currentPrincipalsChoices: null,
        hasErrors: false,
        errorDisplayed: null,
        hasMultipleMatchValidationError: false,
        hasNoMatchValidationError: false,
        autofill: null,

        reset: function () {
            var record;
            while (this.internalSelectedItems.length) {
                record = this.internalSelectedItems[0];
                record.removeAndNotTriggerUserListener();
            }
            this.setTextInputDisplayStyle();
            this.validateMultipleMatchError();
            this.validateNoMatchError();
            this.clearInputField();
            this.clearCacheData();
            if (Office.Controls.PeoplePicker.autofillContainer.currentOpened) {
                Office.Controls.PeoplePicker.autofillContainer.currentOpened.close();
            }
            Office.Controls.PeoplePicker.autofillContainer.currentOpened = null;
            Office.Controls.PeoplePicker.autofillContainer.boolBodyHandlerAdded = false;
            this.autofill = new Office.Controls.PeoplePicker.autofillContainer(this);
            this.toggleDefaultText();

        },

        remove: function (entryToRemove) {
            var record = this.internalSelectedItems, i, recordToRemove;
            for (i = 0; i < record.length; i++) {
                if (record[i].Record.principalInfo === entryToRemove) {
                    recordToRemove = record[i].Record;
                    record[i].removeAndNotTriggerUserListener();
                    this.onRemove(this, recordToRemove.principalInfo);
                    this.validateMultipleMatchError();
                    this.validateNoMatchError();
                    this.setTextInputDisplayStyle();
                    this.textInput.focus();
                    break;
                }
            }
        },

        add: function (p1, resolved) {
            if (typeof p1 === 'string') {
                this.addThroughString(p1);
            } else {
                var record = new Office.Controls.PeoplePickerRecord();
                Office.Controls.PeoplePicker.copyToRecord(record, p1);
                record.text = p1.displayName;
                if (Office.Controls.Utils.isNullOrUndefined(resolved)) {
                    record.isResolved = false;
                    this.addThroughRecord(record, false);
                } else {
                    record.isResolved = resolved;
                    this.addThroughRecord(record, resolved);
                }
            }
        },

        getAddedPeople: function () {
            var record = this.internalSelectedItems, addedPeople = [], i;
            for (i = 0; i < record.length; i++) {
                addedPeople[i] = record[i].Record.principalInfo;
            }
            return addedPeople;
        },

        clearCacheData: function () {
            if (this.cache !== null) {
                this.cache.cacheDelete('Office.PeoplePicker.Cache');
                this.cache.dataObject = new Office.Controls.PeoplePicker.mruCache.mruData();
                this.cache.dataObject.cacheMapping[Office.Controls.Runtime.context.HostUrl] = new Array(0);
            }
        },

        getErrorDisplayed: function () {
            return this.errorDisplayed;
        },

        getUserInfoAsync: function (userInfoHandler, userEmail) {
            var record = new Office.Controls.PeoplePickerRecord();
            this.dataProvider.searchPeopleAsync(userEmail, function (error, principalsReceived) {
                if (principalsReceived !== null) {
                    Office.Controls.PeoplePicker.copyToRecord(record, principalsReceived[0]);
                    userInfoHandler(record);
                } else {
                    userInfoHandler(null);
                }
            });
        },

        get_textInput: function () {
            return this.textInput;
        },

        get_actualRoot: function () {
            return this.actualRoot;
        },

        addThroughString: function (input) {
            if (Office.Controls.Utils.isNullOrEmptyString(input)) {
                Office.Controls.Utils.errorConsole('Input can\'t be null or empty string. PeoplePicker Id : ' + this.root.id);
                return;
            }
            this.addUnresolvedPrincipal(input, false);
        },

        addThroughRecord: function (info, resolved) {
            if (!resolved) {
                this.addUncertainPrincipal(info);
            } else {
                this.addResolvedRecord(info);
            }
        },

        renderControl: function (inputName) {
            this.root.innerHTML = Office.Controls.peoplePickerTemplates.generateControlTemplate(inputName, this.allowMultipleSelections, this.inputHint);
            if (this.root.className.length > 0) {
                this.root.className += ' ';
            }
            this.root.className += 'office office-peoplepicker';
            this.actualRoot = this.root.querySelector('div.ms-PeoplePicker');
            var self = this;
            Office.Controls.Utils.addEventListener(this.actualRoot, 'click', function (e) {
                return self.onPickerClick(e);
            });
            this.inputData = this.actualRoot.querySelector('input[type=\"hidden\"]');
            this.textInput = this.actualRoot.querySelector('input[type=\"text\"]');
            this.defaultText = this.actualRoot.querySelector('span.office-peoplepicker-default');
            this.resolvedListRoot = this.actualRoot.querySelector('div.office-peoplepicker-recordList');
            this.autofillElement = this.actualRoot.querySelector('.ms-PeoplePicker-results');
            Office.Controls.Utils.addEventListener(this.textInput, 'focus', function (e) {
                return self.onInputFocus(e);
            });
            Office.Controls.Utils.addEventListener(this.textInput, 'blur', function (e) {
                return self.onInputBlur(e);
            });
            Office.Controls.Utils.addEventListener(this.textInput, 'keydown', function (e) {
                return self.onInputKeyDown(e);
            });
            Office.Controls.Utils.addEventListener(this.textInput, 'input', function (e) {
                return self.onInput(e);
            });
            Office.Controls.Utils.addEventListener(window.self, 'resize', function (e) {
                return self.onResize(e);
            });
            this.toggleDefaultText();
            if (!Office.Controls.Utils.isNullOrUndefined(this.inputTabindex)) {
                this.textInput.setAttribute('tabindex', this.inputTabindex);
            }
        },

        toggleDefaultText: function () {
            if (this.actualRoot.className.indexOf('office-peoplepicker-autofill-focus') === -1 && this.showInputHint && !this.selectedItems.length && !this.textInput.value.length) {
                this.defaultText.className = 'office-peoplepicker-default';
            } else {
                this.defaultText.className = 'office-hide';
            }
        },

        onResize: function () {
            this.toggleDefaultText();
            return true;
        },

        onInputKeyDown: function (e) {
            var keyEvent = Office.Controls.Utils.getEvent(e), self = this;
            if (keyEvent.keyCode === 27) { // 'escape'
                this.autofill.close();
            } else if ((keyEvent.keyCode === 9 || keyEvent.keyCode === 13) && this.autofill.IsDisplayed) { // 'tab' || 'enter'
                var focusElement = this.autofillElement.querySelector("li.ms-PeoplePicker-resultAddedForSelect");
                if (focusElement !== null) {
                    var personId = this.autofill.getPersonIdFromListElement(focusElement);
                    this.addResolvedPrincipal(this.autofill.entries[personId]);
                    this.autofill.flushContent();
                    Office.Controls.Utils.cancelEvent(e);
                    return false;
                }
                this.autofill.close();
            } else if ((keyEvent.keyCode === 40 || keyEvent.keyCode === 38) && this.autofill.IsDisplayed) { // 'down arrow' || 'up arrow'
                this.autofill.onKeyDownFromInput(keyEvent);
                keyEvent.preventDefault();
                keyEvent.stopPropagation();
                Office.Controls.Utils.cancelEvent(e);
                return false;
            } else if (keyEvent.keyCode === 37 && this.internalSelectedItems.length) { // 'left arrow'
                this.resolvedListRoot.lastChild.focus();
                Office.Controls.Utils.cancelEvent(e);
                return false;
            } else if (keyEvent.keyCode === 8) { // 'backspace'
                var shouldRemove = false;
                if (!Office.Controls.Utils.isNullOrUndefined(document.selection)) {
                    var range = document.selection.createRange(), selectedText = range.text, caretPos = range.text.length;
                    range.moveStart('character', -this.textInput.value.length);
                    if (!selectedText.length && !caretPos) {
                        shouldRemove = true;
                    }
                } else {
                    var selectionStart = this.textInput.selectionStart, selectionEnd = this.textInput.selectionEnd;
                    if (!selectionStart && selectionStart === selectionEnd) {
                        shouldRemove = true;
                    }
                }
                if (shouldRemove && this.internalSelectedItems.length) {
                    this.internalSelectedItems[this.internalSelectedItems.length - 1].remove();
                    Office.Controls.Utils.cancelEvent(e);
                }
            } else if ((keyEvent.keyCode === 75 && keyEvent.ctrlKey) || (keyEvent.keyCode === 186) || (keyEvent.keyCode === 59) || (keyEvent.keyCode === 13)) {
                // 'Ctrl + k' || 'semi-colon' (59 on Firefox and 186 on other browsers) || 'enter'
                keyEvent.preventDefault();
                keyEvent.stopPropagation();
                this.cancelLastRequest();
                this.attemptResolveInput();
                Office.Controls.Utils.cancelEvent(e);
                return false;
            } else if ((keyEvent.keyCode === 86 && keyEvent.ctrlKey) || (keyEvent.keyCode === 186)) {
                // 'Ctrl + v' || 'semi-colon'
                this.cancelLastRequest();
                window.setTimeout(function () {
                    self.textInput.value = Office.Controls.PeoplePicker.parseUserPaste(self.textInput.value);
                    self.attemptResolveInput();
                }, 0);
                return true;
            } else if (keyEvent.keyCode === 13 && keyEvent.shiftKey) { // 'shift + enter'
                this.autofill.open(function (selectedPrincipal) {
                    self.addResolvedPrincipal(selectedPrincipal);
                });
            } else {
                this.resizeInputField();
            }
            return true;
        },

        cancelLastRequest: function () {
            window.clearTimeout(this.currentTimerId);
            if (!Office.Controls.Utils.isNullOrUndefined(this.currentToken)) {
                this.hideLoadingIcon();
                this.currentToken.cancel();
                this.currentToken = null;
            }
        },

        onInput: function (e) {
            this.startQueryAfterDelay();
            this.resizeInputField();
            this.autofill.close();
            return true;
        },

        displayCachedEntries: function () {
            var cachedEntries = this.cache.get(this.textInput.value, 5), self = this;
            this.autofill.setCachedEntries(cachedEntries);
            this.autofill.setServerEntries(new Array(0));
            if (!cachedEntries.length) {
                return;
            }
            this.autofill.open(function (selectedPrincipal) {
                self.addResolvedPrincipal(selectedPrincipal);
            });
        },

        resizeInputField: function () {
            var size = Math.max(this.textInput.value.length + 1, 1);
            this.textInput.size = size;
        },

        clearInputField: function () {
            this.textInput.value = '';
            this.resizeInputField();
        },

        startQueryAfterDelay: function () {
            this.cancelLastRequest();
            var currentValue = this.textInput.value, self = this;
            this.currentTimerId = window.setTimeout(function () {
                if (currentValue !== self.lastSearchQuery || self.startSearchCharLength === 0) {
                    self.lastSearchQuery = currentValue;
                    if (currentValue.length >= self.startSearchCharLength) {
                        self.searchingTimes++;
                        self.removeValidationError('ServerProblem');
                        if (self.enableCache) {
                            self.displayCachedEntries();
                            self.displayLoadingIcon(currentValue, true);
                        } else {
                            self.displayLoadingIcon(currentValue, false);
                        }
                        var token = new Office.Controls.PeoplePicker.cancelToken();
                        self.currentToken = token;
                        self.dataProvider.searchPeopleAsync(self.textInput.value, function (error, principalsReceived) {
                            if (!token.IsCanceled) {
                                if (principalsReceived !== null) {
                                    self.onDataReceived(principalsReceived);
                                } else {
                                    self.onDataFetchError(error);
                                }
                            }
                        });
                    } else {
                        self.autofill.close();
                        if (self.enableCache) {
                            self.displayCachedEntries();
                        }
                    }
                }
            }, self.delaySearchInterval);
        },

        onDataFetchError: function (message) {
            this.hideLoadingIcon();
            this.addValidationError(Office.Controls.PeoplePicker.ValidationError.createServerProblemError());
        },

        onDataReceived: function (principalsReceived) {
            if (! Office.Controls.Utils.isNullOrUndefined(this.textInput.value ) && this.textInput.value !== " " && this.textInput.value.length>= this.startSearchCharLength) {
                this.currentPrincipalsChoices = {};
                var self = this, i;
                for (i = 0; i < principalsReceived.length; i++) {
                    var principal = principalsReceived[i];
                    this.currentPrincipalsChoices[principal.id] = principal;
                }
                this.autofill.setServerEntries(principalsReceived);
                this.hideLoadingIcon();
                this.autofill.open(function (selectedPrincipal) {
                    self.addResolvedPrincipal(selectedPrincipal);
                });
            }
        },

        onPickerClick: function (e) {
            this.textInput.focus();
            e = Office.Controls.Utils.getEvent(e);
            var element = Office.Controls.Utils.getTarget(e);
            if (element.nodeName.toLowerCase() !== 'input') {
                this.focusToEnd();
            }
            return true;
        },

        focusToEnd: function () {
            var endPos = this.textInput.value.length;
            if (!Office.Controls.Utils.isNullOrUndefined(this.textInput.createTextRange)) {
                var range = this.textInput.createTextRange();
                range.collapse(true);
                range.moveStart('character', endPos);
                range.moveEnd('character', endPos);
                range.select();
            } else {
                this.textInput.focus();
                this.textInput.setSelectionRange(endPos, endPos);
            }
        },

        onInputFocus: function (e) {
            var self = this;
            if (Office.Controls.Utils.isNullOrEmptyString(this.actualRoot.className)) {
                this.actualRoot.className = 'office-peoplepicker-autofill-focus';
            } else {
                this.actualRoot.className += ' office-peoplepicker-autofill-focus';
            }
            if (!this.widthSet) {
                this.setInputMaxWidth();
            }
            this.toggleDefaultText();
            this.onFocus(this);

            if (this.startSearchCharLength === 0 && (this.allowMultipleSelections === true || this.internalSelectedItems.length === 0)) {
                self.startQueryAfterDelay();
            }
            return true;
        },

        setInputMaxWidth: function () {
            var maxwidth = this.actualRoot.clientWidth - 25;
            if (maxwidth <= 0) {
                maxwidth = 20;
            }
            this.textInput.style.maxWidth = maxwidth.toString() + 'px';
            this.widthSet = true;
        },

        onInputBlur: function (e) {
            Office.Controls.Utils.removeClass(this.actualRoot, 'office-peoplepicker-autofill-focus');
            if (this.textInput.value.length > 0 || this.selectedItems.length > 0) {
                this.onBlur(this);
                return true;
            }
            this.toggleDefaultText();
            this.onBlur(this);
            return true;
        },

        onDataSelected: function (selectedPrincipal) {
            this.lastSearchQuery = '';
            this.clearInputField();
            this.refreshInputField();
        },

        onDataRemoved: function (selectedPrincipal) {
            this.refreshInputField();
            this.validateMultipleMatchError();
            this.validateNoMatchError();
            this.onRemove(this, selectedPrincipal.principalInfo);
            this.onChange(this);
        },

        addToCache: function (entry) {
            if (!this.cache.isCacheAvailable) {
                return;
            }
            this.cache.set(entry);
        },

        refreshInputField: function () {
            this.inputData.value = Office.Controls.Utils.serializeJSON(this.selectedItems);
            this.setTextInputDisplayStyle();
        },

        setTextInputDisplayStyle: function () {
            if ((!this.allowMultipleSelections) && (this.internalSelectedItems.length === 1)) {
                this.textInput.className = 'ms-PeoplePicker-searchFieldAddedForSingleSelectionHidden';
                this.textInput.setAttribute('readonly', 'readonly');
            } else {
                this.textInput.removeAttribute('readonly');
                this.textInput.className = 'ms-PeoplePicker-searchField ms-PeoplePicker-searchFieldAdded';
            }
        },

        displayLoadingIcon: function (searchingName, isAppended) {
            this.autofill.openSearchingLoadingStatus(searchingName, isAppended);
        },

        hideLoadingIcon: function () {
            this.autofill.closeSearchingLoadingStatus();
        },

        attemptResolveInput: function () {
            this.autofill.close();
            if (this.textInput.value.length > 0) {
                this.lastSearchQuery = '';
                this.addUnresolvedPrincipal(this.textInput.value, true);
            }
        },

        onDataReceivedForResolve: function (principalsReceived, internalRecordToResolve) {
            this.hideLoadingIcon();
            if (principalsReceived.length === 1) {
                internalRecordToResolve.resolveTo(principalsReceived[0]);
            } else {
                internalRecordToResolve.setResolveOptions(principalsReceived);
            }
            this.refreshInputField();
            return internalRecordToResolve;
        },

        onDataReceivedForStalenessCheck: function (principalsReceived, internalRecordToCheck) {
            if (principalsReceived.length === 1) {
                internalRecordToCheck.resolveTo(principalsReceived[0]);
            } else {
                internalRecordToCheck.unresolve();
                internalRecordToCheck.setResolveOptions(principalsReceived);
            }
            this.refreshInputField();
        },

        addResolvedPrincipal: function (principal) {
            var record = new Office.Controls.PeoplePickerRecord(),
            internalRecord = new Office.Controls.PeoplePicker.internalPeoplePickerRecord(this, record);
            Office.Controls.PeoplePicker.copyToRecord(record, principal);
            record.text = principal.displayName;
            record.isResolved = true;
            this.selectedItems.push(record);
            internalRecord.add();
            internalRecord.updateHoverText();
            this.internalSelectedItems.push(internalRecord);
            this.onDataSelected(record);
            if (this.enableCache) {
                this.addToCache(principal);
            }
            this.currentPrincipalsChoices = null;
            this.autofill.close();
            this.textInput.focus();
            this.onAdd(this, record.principalInfo);
            this.onChange(this);
        },

        addResolvedRecord: function (record) {
            this.selectedItems.push(record);
            var internalRecord = new Office.Controls.PeoplePicker.internalPeoplePickerRecord(this, record);
            internalRecord.add();
            internalRecord.updateHoverText();
            this.internalSelectedItems.push(internalRecord);
            this.onDataSelected(record);
            this.onAdd(this, record.principalInfo);
            this.currentPrincipalsChoices = null;
        },

        addUncertainPrincipal: function (record) {
            this.selectedItems.push(record);
            var internalRecord = new Office.Controls.PeoplePicker.internalPeoplePickerRecord(this, record),
            self = this;
            internalRecord.add();
            internalRecord.updateHoverText();
            this.internalSelectedItems.push(internalRecord);
            this.setTextInputDisplayStyle();
            this.displayLoadingIcon(record.text, false);
            this.dataProvider.searchPeopleAsync(record.displayName, function (error, ps) {
                if (ps !== null) {
                    internalRecord = self.onDataReceivedForResolve(ps, internalRecord);
                    self.onAdd(this, internalRecord.Record.principalInfo);
                    self.onChange(self);
                } else {
                    self.onDataFetchError(error);
                }
            });
        },

        addUnresolvedPrincipal: function (input, triggerUserListener) {
            var record = new Office.Controls.PeoplePickerRecord(), self = this,
            principalInfo = new Office.Controls.PrincipalInfo();
            principalInfo.displayName = input;
            record.text = input;
            record.principalInfo = principalInfo;
            record.isResolved = false;
            var internalRecord = new Office.Controls.PeoplePicker.internalPeoplePickerRecord(this, record);
            internalRecord.add();
            internalRecord.updateHoverText();
            this.selectedItems.push(record);
            this.internalSelectedItems.push(internalRecord);
            this.clearInputField();
            this.setTextInputDisplayStyle();
            this.displayLoadingIcon(input, false);
            this.dataProvider.searchPeopleAsync(input, function (error, ps) {
                if (ps !== null) {
                    internalRecord = self.onDataReceivedForResolve(ps, internalRecord);
                    if (triggerUserListener) {
                        self.onAdd(self, internalRecord.Record.principalInfo);
                        self.onChange(self);
                    }
                } else {
                    self.onDataFetchError(error);
                }
            });
        },

        addValidationError: function (err) {
            this.hasErrors = true;
            this.errors.push(err);
            this.displayValidationErrors();
            if (!Office.Controls.Utils.isNullOrUndefined(this.onError)) {
                this.onError(this, err);
            }
        },

        removeValidationError: function (errorName) {
            var i;
            for (i = 0; i < this.errors.length; i++) {
                if (this.errors[i].errorName === errorName) {
                    this.errors.splice(i, 1);
                    break;
                }
            }
            if (!this.errors.length) {
                this.hasErrors = false;
            }
            if (!Office.Controls.Utils.isNullOrUndefined(this.onError) && this.errors.length) {
                this.onError(this, this.errors[0]);
            } else {
                this.displayValidationErrors();
            }
        },

        validateMultipleMatchError: function () {
            var oldStatus = this.hasMultipleMatchValidationError, newStatus = false, i;
            for (i = 0; i < this.internalSelectedItems.length; i++) {
                if (!Office.Controls.Utils.isNullOrUndefined(this.internalSelectedItems[i].optionsList) && this.internalSelectedItems[i].optionsList.length > 0) {
                    newStatus = true;
                    break;
                }
            }
            if (!oldStatus && newStatus) {
                this.addValidationError(Office.Controls.PeoplePicker.ValidationError.createMultipleMatchError());
            }
            if (oldStatus && !newStatus) {
                this.removeValidationError('MultipleMatch');
            }
            this.hasMultipleMatchValidationError = newStatus;
        },

        validateNoMatchError: function () {
            var oldStatus = this.hasNoMatchValidationError, newStatus = false, i;
            for (i = 0; i < this.internalSelectedItems.length; i++) {
                if (!Office.Controls.Utils.isNullOrUndefined(this.internalSelectedItems[i].optionsList) && !this.internalSelectedItems[i].optionsList.length) {
                    newStatus = true;
                    break;
                }
            }
            if (!oldStatus && newStatus) {
                this.addValidationError(Office.Controls.PeoplePicker.ValidationError.createNoMatchError());
            }
            if (oldStatus && !newStatus) {
                this.removeValidationError('NoMatch');
            }
            this.hasNoMatchValidationError = newStatus;
        },

        displayValidationErrors: function () {
            if (!this.showValidationErrors) {
                return;
            }
            if (!this.errors.length) {
                if (!Office.Controls.Utils.isNullOrUndefined(this.errorMessageElement)) {
                    this.errorMessageElement.parentNode.removeChild(this.errorMessageElement);
                    this.errorMessageElement = null;
                    this.errorDisplayed = null;
                }
            } else {
                if (this.errorDisplayed !== this.errors[0]) {
                    if (!Office.Controls.Utils.isNullOrUndefined(this.errorMessageElement)) {
                        this.errorMessageElement.parentNode.removeChild(this.errorMessageElement);
                    }
                    var holderDiv = document.createElement('div');
                    holderDiv.innerHTML = Office.Controls.peoplePickerTemplates.generateErrorTemplate(this.errors[0].localizedErrorMessage);
                    this.errorMessageElement = holderDiv.firstChild;
                    this.root.appendChild(this.errorMessageElement);
                    this.errorDisplayed = this.errors[0];
                }
            }
        },

        setDataProvider: function (newProvider) {
            this.dataProvider = newProvider;
        }
    };

    Office.Controls.PeoplePicker.internalPeoplePickerRecord = function (parent, record) {
        this.parent = parent;
        this.Record = record;
    };

    Office.Controls.PeoplePicker.internalPeoplePickerRecord.prototype = {
        Record: null,

        get_record: function () {
            return this.Record;
        },

        set_record: function (value) {
            this.Record = value;
            return value;
        },

        _principalOptions: null,
        _optionsList: null,
        Node: null,

        get_node: function () {
            return this.Node;
        },

        set_node: function (value) {
            this.Node = value;
            return value;
        },

        parent: null,

        onRecordRemovalClick: function (e) {
            var recordRemovalEvent = Office.Controls.Utils.getEvent(e),
            target = Office.Controls.Utils.getTarget(recordRemovalEvent);
            this.remove();
            Office.Controls.Utils.cancelEvent(e);
            this.parent.autofill.close();
            return false;
        },

        onRecordRemovalKeyDown: function (e) {
            var recordRemovalEvent = Office.Controls.Utils.getEvent(e);
            if (recordRemovalEvent.keyCode === 8 || recordRemovalEvent.keyCode === 13 || recordRemovalEvent.keyCode === 46) {
                this.remove();
                Office.Controls.Utils.cancelEvent(e);
                this.parent.autofill.close();
            }
            return false;
        },

        onRecordKeyDown: function (e) {
            var keyEvent = Office.Controls.Utils.getEvent(e);
            var target = Office.Controls.Utils.getTarget(keyEvent);
            if (keyEvent.keyCode === 8 || keyEvent.keyCode === 13 || keyEvent.keyCode === 46) {
                this.remove();
                Office.Controls.Utils.cancelEvent(e);
                this.parent.autofill.close();
            } else if (keyEvent.keyCode === 37) {
                if (this.Node.previousSibling !== null) {
                    this.Node.previousSibling.focus();
                }
                Office.Controls.Utils.cancelEvent(e);
            } else if (keyEvent.keyCode === 39) {
                if (this.Node.nextSibling !== null) {
                    this.Node.nextSibling.focus();
                } else {
                    this.parent.textInput.focus();
                }
                Office.Controls.Utils.cancelEvent(e);
            }
            return false;
        },

        add: function () {
            var holderDiv = document.createElement('div');
            holderDiv.innerHTML = Office.Controls.peoplePickerTemplates.generateRecordTemplate(this.Record, this.parent.allowMultipleSelections, this.parent.showImage);
            var recordElement = holderDiv.firstChild,
            removeButtonElement = recordElement.querySelector('div.ms-PeoplePicker-personaRemove'),
            self = this;
            Office.Controls.Utils.addEventListener(recordElement, 'keydown', function (e) {
                return self.onRecordKeyDown(e);
            });

            Office.Controls.Utils.addEventListener(removeButtonElement, 'click', function (e) {
                return self.onRecordRemovalClick(e);
            });
            Office.Controls.Utils.addEventListener(removeButtonElement, 'keydown', function (e) {
                return self.onRecordRemovalKeyDown(e);
            });
            this.parent.resolvedListRoot.appendChild(recordElement);
            this.parent.defaultText.className = 'office-hide';
            this.Node = recordElement;
        },

        remove: function () {
            this.removeAndNotTriggerUserListener();
            this.parent.onDataRemoved(this.Record);
            this.parent.textInput.focus();
        },

        removeAndNotTriggerUserListener: function () {
            this.parent.resolvedListRoot.removeChild(this.Node);
            var i;
            for (i = 0; i < this.parent.internalSelectedItems.length; i++) {
                if (this.parent.internalSelectedItems[i] === this) {
                    this.parent.internalSelectedItems.splice(i, 1);
                }
            }
            for (i = 0; i < this.parent.selectedItems.length; i++) {
                if (this.parent.selectedItems[i] === this.Record) {
                    this.parent.selectedItems.splice(i, 1);
                }
            }
        },

        setResolveOptions: function (options) {
            this.optionsList = options;
            this.principalOptions = {};
            var i;
            for (i = 0; i < options.length; i++) {
                this.principalOptions[options[i].id] = options[i];
            }
            var self = this;
            Office.Controls.Utils.addEventListener(this.Node, 'click', function (e) {
                return self.onUnresolvedUserClick(e);
            });
            this.parent.validateMultipleMatchError();
            this.parent.validateNoMatchError();
        },

        onUnresolvedUserClick: function (e) {
            e = Office.Controls.Utils.getEvent(e);
            this.parent.autofill.flushContent();
            this.parent.autofill.setServerEntries(this.optionsList);
            var self = this;
            this.parent.autofill.open(function (selectedPrincipal) {
                self.onAutofillClick(selectedPrincipal);
            });
            this.addKeyListenerForAutofill();
            this.parent.autofill.focusOnFirstElement();
            Office.Controls.Utils.cancelEvent(e);
            return false;
        },

        addKeyListenerForAutofill: function () {
            var autofillElementsLiTags = this.parent.autofill.root.querySelectorAll('li'), i;
            for (i = 0; i < autofillElementsLiTags.length; i++) {
                var li = autofillElementsLiTags[i];
                var self = this;
                Office.Controls.Utils.addEventListener(li, 'keydown', function (e) {
                    return self.onAutofillKeyDown(e);
                });
            }
        },

        onAutofillKeyDown: function (e) {
            var key = Office.Controls.Utils.getEvent(e),
            target = Office.Controls.Utils.getTarget(key);
            if (key.keyCode === 38) { // 'up arrow'
                if (target.previousSibling !== null) {
                    this.parent.autofill.changeFocus(target, target.previousSibling);
                    target.previousSibling.focus();
                } else if (target.parentNode.parentNode.previousSibling !== null) {
                    var autofillElementsUlTags = this.parent.root.querySelectorAll('ul'),
                    ul = autofillElementsUlTags[0];
                    this.parent.autofill.changeFocus(target, ul.lastChild);
                    ul.lastChild.focus();
                } else if (target.parentNode.parentNode.nextSibling !== null) {
                    var autofillElementsUlTags = this.parent.root.querySelectorAll('ul'),
                    ul = autofillElementsUlTags[1];
                    this.parent.autofill.changeFocus(target, ul.lastChild);
                    ul.lastChild.focus();
                } else {
                    var resultList = this.parent.root.querySelector('ul.ms-PeoplePicker-resultList');
                    this.parent.autofill.changeFocus(target, resultList.lastChild);
                    resultList.lastChild.focus();
                }
            } else if (key.keyCode === 40) { // 'down arrow'
                if (target.nextSibling !== null) {
                    this.parent.autofill.changeFocus(target, target.nextSibling);
                    target.nextSibling.focus();
                } else if (target.parentNode.parentNode.nextSibling !== null) {
                    var autofillElementsUlTags = this.parent.root.querySelectorAll('ul'),
                    ul = autofillElementsUlTags[1];
                    this.parent.autofill.changeFocus(target, ul.firstChild);
                    ul.firstChild.focus();
                } else if (target.parentNode.parentNode.previousSibling !== null) {
                    var autofillElementsUlTags = this.parent.root.querySelectorAll('ul'),
                    ul = autofillElementsUlTags[0];
                    this.parent.autofill.changeFocus(target, ul.firstChild);
                    ul.firstChild.focus();
                } else {
                    var resultList = this.parent.root.querySelector('ul.ms-PeoplePicker-resultList');
                    this.parent.autofill.changeFocus(target, resultList.firstChild);
                    resultList.firstChild.focus();
                }
            } else if (key.keyCode === 9 || key.keyCode === 13) { // 'tab' or 'enter'
                var personId = this.parent.autofill.getPersonIdFromListElement(target);
                this.onAutofillClick(this.parent.autofill.entries[personId]);
                Office.Controls.Utils.cancelEvent(e);
            }
            return true;
        },

        resolveTo: function (principal) {
            Office.Controls.PeoplePicker.copyToRecord(this.Record, principal);
            this.Record.text = principal.displayName;
            this.Record.isResolved = true;
            if (this.parent.enableCache) {
                this.parent.addToCache(principal);
            }
            Office.Controls.Utils.removeClass(this.Node, 'has-error');
            var primaryTextNode = this.Node.querySelector('div.ms-Persona-primaryText');
            primaryTextNode.innerHTML = Office.Controls.Utils.htmlEncode(principal.displayName);
            this.updateHoverText();
        },

        refresh: function (principal) {
            Office.Controls.PeoplePicker.copyToRecord(this.Record, principal);
            this.Record.text = principal.displayName;
            var primaryTextNode = this.Node.querySelector('div.ms-Persona-primaryText');
            primaryTextNode.innerHTML = Office.Controls.Utils.htmlEncode(principal.displayName);
        },

        unresolve: function () {
            this.Record.isResolved = false;
            var primaryTextNode = this.Node.querySelector('div.ms-Persona-primaryText');
            primaryTextNode.innerHTML = Office.Controls.Utils.htmlEncode(this.Record.text);
            this.updateHoverText();
        },

        updateHoverText: function () {
            var userLabel = this.Node.querySelector('div.ms-Persona-primaryText');
            userLabel.title = Office.Controls.Utils.htmlEncode(this.Record.text);
            this.Node.querySelector('div.ms-PeoplePicker-personaRemove').title = Office.Controls.Utils.formatString(Office.Controls.peoplePickerTemplates.getString(Office.Controls.Utils.htmlEncode('PP_RemovePerson')), this.Record.text);
        },

        onAutofillClick: function (selectedPrincipal) {
            this.parent.onRemove(this.parent, this.Record.principalInfo);
            this.resolveTo(selectedPrincipal);
            this.parent.refreshInputField();
            this.principalOptions = null;
            this.optionsList = null;
            if (this.parent.enableCache) {
                this.parent.addToCache(selectedPrincipal);
            }
            this.parent.validateMultipleMatchError();
            this.parent.autofill.close();
            this.parent.textInput.focus();
            this.parent.onAdd(this.parent, this.Record.principalInfo);
            this.parent.onChange(this.parent);
        }
    };

    Office.Controls.PeoplePicker.autofillContainer = function (parent) {
        this.entries = {};
        this.cachedEntries = new Array(0);
        this.serverEntries = new Array(0);
        this.parent = parent;
        this.root = parent.autofillElement;
        if (!Office.Controls.PeoplePicker.autofillContainer.boolBodyHandlerAdded) {
            Office.Controls.Utils.addEventListener(document.body, 'click', function (e) {
                return Office.Controls.PeoplePicker.autofillContainer.bodyOnClick(e);
            });
            Office.Controls.PeoplePicker.autofillContainer.boolBodyHandlerAdded = true;
        }
    };
    Office.Controls.PeoplePicker.autofillContainer.getControlRootFromSubElement = function (element) {
        while (element && element.nodeName.toLowerCase() !== 'body') {
            if (element.className.indexOf('office office-peoplepicker') !== -1) {
                return element;
            }
            element = element.parentNode;
        }
        return null;
    };
    Office.Controls.PeoplePicker.autofillContainer.bodyOnClick = function (e) {
        if (!Office.Controls.PeoplePicker.autofillContainer.currentOpened) {
            return true;
        }
        var click = Office.Controls.Utils.getEvent(e),
        target = Office.Controls.Utils.getTarget(click),
        controlRoot = Office.Controls.PeoplePicker.autofillContainer.getControlRootFromSubElement(target);
        if (!target || controlRoot !== Office.Controls.PeoplePicker.autofillContainer.currentOpened.parent.root) {
            Office.Controls.PeoplePicker.autofillContainer.currentOpened.close();
        }
        return true;
    };
    Office.Controls.PeoplePicker.autofillContainer.prototype = {
        _parent: null,
        _root: null,
        IsDisplayed: false,

        get_isDisplayed: function () {
            return this.IsDisplayed;
        },

        set_isDisplayed: function (value) {
            this.IsDisplayed = value;
            return value;
        },

        setCachedEntries: function (entries) {
            this.cachedEntries = entries;
            this.entries = {};
            var length = entries.length, i;
            for (i = 0; i < length; i++) {
                this.entries[entries[i].id] = entries[i];
            }
        },

        getCachedEntries: function () {
            return this.cachedEntries;
        },

        getServerEntries: function () {
            return this.serverEntries;
        },

        setServerEntries: function (entries) {
            if (this.parent.enableCache === true) {
                var newServerEntries = new Array(0),
                length = entries.length, i;
                for (i = 0; i < length; i++) {
                    var currentEntry = entries[i];
                    if (Office.Controls.Utils.isNullOrUndefined(this.entries[currentEntry.id])) {
                        this.entries[entries[i].id] = entries[i];
                        newServerEntries.push(currentEntry);
                    }
                }
                this.serverEntries = newServerEntries;
            } else {
                this.entries = {};
                var length = entries.length, i;
                for (i = 0; i < length; i++) {
                    this.entries[entries[i].id] = entries[i];
                }
                this.serverEntries = entries;
            }
        },

        renderList: function (handler) {
            this.root.innerHTML = Office.Controls.peoplePickerTemplates.generateAutofillListTemplate(this.cachedEntries, this.serverEntries, this.parent.numberOfResults, this.parent.showImage);
            var isTabKey = false,
            autofillElementsLinkTags = this.root.querySelectorAll('a'),
            self = this, i;
            for (i = 0; i < autofillElementsLinkTags.length; i++) {
                var link = autofillElementsLinkTags[i];
                Office.Controls.Utils.addEventListener(link, 'click', function (e) {
                    return self.onEntryClick(e, handler);
                });
                Office.Controls.Utils.addEventListener(link, 'focus', function (e) {
                    return self.onEntryFocus(e);
                });
                Office.Controls.Utils.addEventListener(link, 'blur', function (e) {
                    return self.onEntryBlur(e, isTabKey);
                });
            }
            var autofillElementsLiTags = this.root.querySelectorAll('li');
            if (autofillElementsLiTags.length > 0) {
                Office.Controls.Utils.addClass(autofillElementsLiTags[0], 'ms-PeoplePicker-resultAddedForSelect');
            }
            if (this.parent.showImage) {
                for (i = 0; i < autofillElementsLiTags.length; i++) {
                    var li = autofillElementsLiTags[i];
                    var image = li.querySelector('.ms-PeoplePicker-Persona-image');
                    var personId = this.getPersonIdFromListElement(li);
                    (function (self, image, personId) {
                        self.parent.dataProvider.getImageAsync(personId, function (error, imgSrc) {
                            if (imgSrc != null) {
                                image.style.backgroundImage = "url('" + imgSrc + "')";
                                if (!Office.Controls.Utils.isNullOrUndefined(self.entries[personId])) {
                                    self.entries[personId].imgSrc = imgSrc;
                                }
                            }
                        });
                    })(this, image, personId);
                }
            }
        },

        flushContent: function () {
            var entry = this.root.querySelectorAll('div.ms-PeoplePicker-resultGroups'), i;
            for (i = 0; i < entry.length; i++) {
                this.root.removeChild(entry[i]);
            }
            this.entries = {};
            this.serverEntries = new Array(0);
            this.cachedEntries = new Array(0);
        },

        open: function (handler) {
            this.renderList(handler);
            this.IsDisplayed = true;
            Office.Controls.PeoplePicker.autofillContainer.currentOpened = this;
            if (!Office.Controls.Utils.containClass(this.parent.actualRoot, 'is-active')) {
                Office.Controls.Utils.addClass(this.parent.actualRoot, 'is-active');
            }
        },

        close: function () {
            this.IsDisplayed = false;
            Office.Controls.Utils.removeClass(this.parent.actualRoot, 'is-active');
        },

        openSearchingLoadingStatus: function (searchingName, isAppended) {
            if (isAppended == false) {
                this.root.innerHTML = Office.Controls.peoplePickerTemplates.generateSerachingLoadingTemplate();
            }
            else {
                var resultNode = this.root.querySelector('div.ms-PeoplePicker-resultGroups')
                if (resultNode !=null){
                    resultNode.innerHTML += Office.Controls.peoplePickerTemplates.generateSerachingLoadingTemplate();
                }
                else {
                    this.root.innerHTML = Office.Controls.peoplePickerTemplates.generateSerachingLoadingTemplate();
                }
            }
            this.IsDisplayed = true;
            Office.Controls.PeoplePicker.autofillContainer.currentOpened = this;
            if (!Office.Controls.Utils.containClass(this.parent.actualRoot, 'is-active')) {
                Office.Controls.Utils.addClass(this.parent.actualRoot, 'is-active');
            }
        },

        closeSearchingLoadingStatus: function () {
            this.IsDisplayed = false;
            Office.Controls.Utils.removeClass(this.parent.actualRoot, 'is-active');
        },

        onEntryClick: function (e, handler) {
            var click = Office.Controls.Utils.getEvent(e),
            target = Office.Controls.Utils.getTarget(click),
            listItem = this.getParentListItem(target),
            personId = this.getPersonIdFromListElement(listItem);
            handler(this.entries[personId]);
            this.flushContent();
            return true;
        },

        focusOnFirstElement: function () {
            var first = this.root.querySelector('li.ms-PeoplePicker-result');
            if (!Office.Controls.Utils.isNullOrUndefined(first)) {
                first.focus();
            }
        },

        onKeyDownFromInput: function (key) {
            var target = this.root.querySelector("li.ms-PeoplePicker-resultAddedForSelect");
            if (key.keyCode === 38) { // 'up arrow'
                if (target.previousSibling !== null) {
                    this.changeFocus(target, target.previousSibling);
                    target.previousSibling.focus();
                } else if (target.parentNode.parentNode.previousSibling !== null) {
                    var autofillElementsUlTags = this.parent.root.querySelectorAll('ul'),
                    ul = autofillElementsUlTags[0];
                    this.parent.autofill.changeFocus(target, ul.lastChild);
                    ul.lastChild.focus();
                } else if (target.parentNode.parentNode.nextSibling !== null) {
                    var autofillElementsUlTags = this.parent.root.querySelectorAll('ul'),
                    ul = autofillElementsUlTags[1];
                    this.parent.autofill.changeFocus(target, ul.lastChild);
                    ul.lastChild.focus();
                } else {
                    var resultList = this.root.querySelector('ul.ms-PeoplePicker-resultList');
                    this.changeFocus(target, resultList.lastChild);
                    resultList.lastChild.focus();
                }
            } else if (key.keyCode === 40) { // 'down arrow'
                if (target.nextSibling !== null) {
                    this.changeFocus(target, target.nextSibling);
                    target.nextSibling.focus();
                } else if (target.parentNode.parentNode.nextSibling !== null) {
                    var autofillElementsUlTags = this.parent.root.querySelectorAll('ul'),
                    ul = autofillElementsUlTags[1];
                    this.parent.autofill.changeFocus(target, ul.firstChild);
                    ul.firstChild.focus();
                } else if (target.parentNode.parentNode.previousSibling !== null) {
                    var autofillElementsUlTags = this.parent.root.querySelectorAll('ul'),
                    ul = autofillElementsUlTags[0];
                    this.parent.autofill.changeFocus(target, ul.firstChild);
                    ul.firstChild.focus();
                } else {
                    var resultList = this.root.querySelector('ul.ms-PeoplePicker-resultList');
                    this.changeFocus(target, resultList.firstChild);
                    resultList.firstChild.focus();
                }
            }
            this.parent.textInput.focus();
            return true;
        },

        changeFocus: function (lastElement, nextElement) {
            Office.Controls.Utils.removeClass(lastElement, 'ms-PeoplePicker-resultAddedForSelect');
            Office.Controls.Utils.addClass(nextElement, 'ms-PeoplePicker-resultAddedForSelect');
        },

        getPersonIdFromListElement: function (listElement) {
            return listElement.attributes.getNamedItem('data-office-peoplepicker-value').value;
        },

        getParentListItem: function (element) {
            while (element && element.nodeName.toLowerCase() !== 'li') {
                element = element.parentNode;
            }
            return element;
        },

        onEntryFocus: function (e) {
            var target = Office.Controls.Utils.getTarget(e);
            target = this.getParentListItem(target);
            if (!Office.Controls.Utils.containClass(target, 'office-peoplepicker-autofill-focus')) {
                Office.Controls.Utils.addClass(target, 'office-peoplepicker-autofill-focus');
            }
            return false;
        },

        onEntryBlur: function (e, isTabKey) {
            var target = Office.Controls.Utils.getTarget(e);
            target = this.getParentListItem(target);
            Office.Controls.Utils.removeClass(target, 'office-peoplepicker-autofill-focus');
            if (isTabKey) {
                var next = target.nextSibling;
                if (next && (next.nextSibling.className.toLowerCase() === 'ms-PeoplePicker-searchMore js-searchMore'.toLowerCase())) {
                    Office.Controls.PeoplePicker.autofillContainer.currentOpened.close();
                }
            }
            return false;
        }
    };

    Office.Controls.PeoplePicker.Parameters = function () { };

    Office.Controls.PeoplePicker.cancelToken = function () {
        this.IsCanceled = false;
    };
    Office.Controls.PeoplePicker.cancelToken.prototype = {
        IsCanceled: false,

        get_isCanceled: function () {
            return this.IsCanceled;
        },

        set_isCanceled: function (value) {
            this.IsCanceled = value;
            return value;
        },

        cancel: function () {
            this.IsCanceled = true;
        }
    };

    Office.Controls.PeoplePicker.ValidationError = function () {};
    Office.Controls.PeoplePicker.ValidationError.createMultipleMatchError = function () {
        var err = new Office.Controls.PeoplePicker.ValidationError();
        err.errorName = 'MultipleMatch';
        err.localizedErrorMessage = Office.Controls.peoplePickerTemplates.getString('PP_MultipleMatch');
        return err;
    };
    Office.Controls.PeoplePicker.ValidationError.createNoMatchError = function () {
        var err = new Office.Controls.PeoplePicker.ValidationError();
        err.errorName = 'NoMatch';
        err.localizedErrorMessage = Office.Controls.peoplePickerTemplates.getString('PP_NoMatch');
        return err;
    };
    Office.Controls.PeoplePicker.ValidationError.createServerProblemError = function () {
        var err = new Office.Controls.PeoplePicker.ValidationError();
        err.errorName = 'ServerProblem';
        err.localizedErrorMessage = Office.Controls.peoplePickerTemplates.getString('PP_ServerProblem');
        return err;
    };
    Office.Controls.PeoplePicker.ValidationError.prototype = {
        errorName: null,
        localizedErrorMessage: null
    };

    Office.Controls.PeoplePicker.mruCache = function () {
        this.isCacheAvailable = this.checkCacheAvailability();
        if (!this.isCacheAvailable) {
            return;
        }
        this.initializeCache();
    };

    Office.Controls.PeoplePicker.mruCache.getInstance = function () {
        if (!Office.Controls.PeoplePicker.mruCache.instance) {
            Office.Controls.PeoplePicker.mruCache.instance = new Office.Controls.PeoplePicker.mruCache();
        }
        return Office.Controls.PeoplePicker.mruCache.instance;
    };

    Office.Controls.PeoplePicker.mruCache.prototype = {
        isCacheAvailable: false,
        _localStorage: null,
        _dataObject: null,

        get: function (key, maxResults) {
            if (Office.Controls.Utils.isNullOrUndefined(maxResults) || !maxResults) {
                maxResults = 2147483647;
            }
            var numberOfResults = 0,
            results = new Array(0),
            cache = this.dataObject.cacheMapping[Office.Controls.Runtime.context.HostUrl],
            cacheLength = cache.length, i;
            for (i = cacheLength; i > 0 && numberOfResults < maxResults; i--) {
                var candidate = cache[i - 1];
                if (this.entityMatches(candidate, key)) {
                    results.push(candidate);
                    numberOfResults += 1;
                }
            }
            return results;
        },

        set: function (entry) {
            var cache = this.dataObject.cacheMapping[Office.Controls.Runtime.context.HostUrl],
            cacheSize = cache.length,
            alreadyThere = false, i;
            for (i = 0; i < cacheSize; i++) {
                var cacheEntry = cache[i];
                if (cacheEntry.id === entry.id) {
                    cache.splice(i, 1);
                    alreadyThere = true;
                    break;
                }
            }
            if (!alreadyThere) {
                if (cacheSize >= 200) {
                    cache.splice(0, 1);
                }
            }
            cache.push(entry);
            this.cacheWrite('Office.PeoplePicker.Cache', Office.Controls.Utils.serializeJSON(this.dataObject));
        },

        entityMatches: function (candidate, key) {
            if (Office.Controls.Utils.isNullOrEmptyString(key) || Office.Controls.Utils.isNullOrUndefined(candidate)) {
                return false;
            }
            key = key.toLowerCase();
            var userNameKey = candidate.id;
            if (Office.Controls.Utils.isNullOrUndefined(userNameKey)) {
                userNameKey = '';
            }
            var divideIndex = userNameKey.indexOf('\\');
            if (divideIndex !== -1 && divideIndex !== userNameKey.length - 1) {
                userNameKey = userNameKey.substr(divideIndex + 1);
            }
            var emailKey = candidate.Email;
            if (Office.Controls.Utils.isNullOrUndefined(emailKey)) {
                emailKey = '';
            }
            var atSignIndex = emailKey.indexOf('@');
            if (atSignIndex !== -1) {
                emailKey = emailKey.substr(0, atSignIndex);
            }
            if (Office.Controls.Utils.isNullOrUndefined(candidate.displayName)) {
                candidate.displayName = '';
            }
            if ((!userNameKey.toLowerCase().indexOf(key)) || (!emailKey.toLowerCase().indexOf(key)) || (!candidate.displayName.toLowerCase().indexOf(key))) {
                return true;
            }
            return false;
        },

        initializeCache: function () {
            var cacheData = this.cacheRetreive('Office.PeoplePicker.Cache');
            if (Office.Controls.Utils.isNullOrEmptyString(cacheData)) {
                this.dataObject = new Office.Controls.PeoplePicker.mruCache.mruData();
            } else {
                var datas = Office.Controls.Utils.deserializeJSON(cacheData);
                if (datas.cacheVersion) {
                    this.dataObject = new Office.Controls.PeoplePicker.mruCache.mruData();
                    this.cacheDelete('Office.PeoplePicker.Cache');
                } else {
                    this.dataObject = datas;
                }
            }
            if (Office.Controls.Utils.isNullOrUndefined(this.dataObject.cacheMapping[Office.Controls.Runtime.context.HostUrl])) {
                this.dataObject.cacheMapping[Office.Controls.Runtime.context.HostUrl] = new Array(0);
            }
        },

        checkCacheAvailability: function () {
            try {
                if (typeof window.self.localStorage === 'undefined') {
                    return false;
                }
                this.localStorage = window.self.localStorage;
                return true;
            } catch (e) {
                return false;
            }
        },

        cacheRetreive: function (key) {
            return this.localStorage.getItem(key);
        },

        cacheWrite: function (key, value) {
            this.localStorage.setItem(key, value);
        },

        cacheDelete: function (key) {
            this.localStorage.removeItem(key);
        }
    };

    Office.Controls.PeoplePicker.mruCache.mruData = function () {
        this.cacheMapping = {};
        this.cacheVersion = 0;
    };

    Office.Controls.PeoplePickerResourcesDefaults = function () {
    };

    Office.Controls.peoplePickerTemplates = function () {
    };
    Office.Controls.peoplePickerTemplates.getString = function (stringName) {
        var newName = 'PeoplePicker' + stringName.substr(3);
        if (Office.Controls.PeoplePicker.resourceStrings.hasOwnProperty(newName)) {
            return Office.Controls.PeoplePicker.resourceStrings[newName];
        }
        return Office.Controls.Utils.getStringFromResource('PeoplePicker', stringName);
    };

    Office.Controls.peoplePickerTemplates.getDefaultText = function (allowMultipleSelections) {
        if (allowMultipleSelections) {
            return Office.Controls.peoplePickerTemplates.getString('PP_DefaultMessagePlural');
        }
        return Office.Controls.peoplePickerTemplates.getString('PP_DefaultMessage');
    };

    Office.Controls.peoplePickerTemplates.generateControlTemplate = function (inputName, allowMultipleSelections, inputHint) {
        var defaultText;
        if (Office.Controls.Utils.isNullOrEmptyString(inputHint)) {
            defaultText = Office.Controls.Utils.htmlEncode(Office.Controls.peoplePickerTemplates.getDefaultText(allowMultipleSelections));
        } else {
            defaultText = Office.Controls.Utils.htmlEncode(inputHint);
        }
        var body = '<div class=\"ms-PeoplePicker\">';
        body += '<input type=\"hidden\"';
        if (!Office.Controls.Utils.isNullOrEmptyString(inputName)) {
            body += ' name=\"' + Office.Controls.Utils.htmlEncode(inputName) + '\"';
        }
        body += '/>';
        body += '<div class=\"ms-PeoplePicker-searchBox ms-PeoplePicker-searchBoxAdded\">';
        body += '<span class=\"office-peoplepicker-default\">' + defaultText + '</span>';
        body += '<div class=\"office-peoplepicker-recordList\"></div>';
        body += '<input type=\"text\" class=\"ms-PeoplePicker-searchField\" size=\"1\" autocorrect=\"off\" autocomplete=\"off\" autocapitalize=\"off\" />';
        body += '</div>';
        body += '<div class=\"ms-PeoplePicker-results\">';
        body += '</div>';
        body += Office.Controls.peoplePickerTemplates.generateAlertNode();
        body += '</div>';
        return body;
    };

    Office.Controls.peoplePickerTemplates.generateErrorTemplate = function (ErrorMessage) {
        var innerHtml = '<span class=\"office-peoplepicker-error\">';
        innerHtml += Office.Controls.Utils.htmlEncode(ErrorMessage);
        innerHtml += '</span>';
        return innerHtml;
    };

    Office.Controls.peoplePickerTemplates.generateAutofillListItemTemplate = function (principal, isCached, showImage) {
        var titleText = Office.Controls.Utils.htmlEncode((Office.Controls.Utils.isNullOrEmptyString(principal.Email)) ? '' : principal.Email),
        itemHtml = '<li tabindex=\"0\" class=\"ms-PeoplePicker-result\" data-office-peoplepicker-value=\"' + Office.Controls.Utils.htmlEncode(principal.id) + '\" title=\"' + titleText + '\">';
        itemHtml += '<a onclick=\"return false;\" href=\"#\" tabindex=\"-1\">';
        itemHtml += '<div class=\"ms-Persona ms-PersonaAdded\">';
        if (showImage) {
            if (isCached && !Office.Controls.Utils.isNullOrUndefined(principal.imgSrc)) {
                if (Office.Controls.Utils.isIE10()) {
                    itemHtml += '<div class=\"ms-PeoplePicker-Persona-image\" style=\"display:block;background-image:url(\'' + principal.imgSrc + '\')\"></div>';
                } else {
                    itemHtml += '<img class=\"ms-PeoplePicker-Persona-image\" style=\"background-image:url(\'' + principal.imgSrc + '\')\">';
                }
            } else {
                if (Office.Controls.Utils.isIE10()) {
                    itemHtml += '<div class=\"ms-PeoplePicker-Persona-image\" style=\"display:block\"></div>';
                } else {
                    itemHtml += '<img class=\"ms-PeoplePicker-Persona-image\">';
                }
            }
        } else {
            itemHtml += '<div class=\"ms-Persona-image-placeholder\"></div>';
        }
        if (Office.Controls.Utils.isFirefox()) {
            itemHtml += '<div class=\"ms-Persona-details\" style=\"max-width:100%; width: auto;\">';
        } else {
            itemHtml += '<div class=\"ms-Persona-details\">';
        }
        itemHtml += '<div class=\"ms-Persona-primaryText\" >' + Office.Controls.Utils.htmlEncode(principal.displayName) + '</div>';
        if (!Office.Controls.Utils.isNullOrEmptyString(principal.description)) {
            itemHtml += '<div class=\"ms-Persona-secondaryText\" >' + Office.Controls.Utils.htmlEncode(principal.description) + '</div>';
        }
        itemHtml += '</div></div></a></li>';
        return itemHtml;
    };

    Office.Controls.peoplePickerTemplates.generateAutofillListTemplate = function (cachedEntries, serverEntries, maxCount, showImage) {
        var html = '<div class=\"ms-PeoplePicker-resultGroups\">',
        actualCount = cachedEntries.length + serverEntries.length;
        if (Office.Controls.Utils.isNullOrUndefined(cachedEntries)) {
            cachedEntries = new Array(0);
        }
        if (Office.Controls.Utils.isNullOrUndefined(serverEntries) || cachedEntries.length >= maxCount) {
            serverEntries = new Array(0);
        }
        if (actualCount > maxCount && cachedEntries.length < maxCount) {
            serverEntries = serverEntries.slice(0, maxCount - cachedEntries.length);
        }
        html += Office.Controls.peoplePickerTemplates.generateAutofillGroupTemplate(cachedEntries, true, showImage, true);
        html += Office.Controls.peoplePickerTemplates.generateAutofillGroupTemplate(serverEntries, false, showImage, (cachedEntries.length > 0));
        html += '</div>';
        html += Office.Controls.peoplePickerTemplates.generateAutofillFooterTemplate(actualCount, maxCount);
        return html;
    };

    Office.Controls.peoplePickerTemplates.generateAutofillGroupTemplate = function (principals, isCached, showImage, showTitle) {
        var listHtml = '',
        cachedGrouptTitle = Office.Controls.Utils.htmlEncode(Office.Controls.peoplePickerTemplates.getString('PP_SearchResultRecentGroup')),
        searchedGroupTitle = Office.Controls.Utils.htmlEncode(Office.Controls.peoplePickerTemplates.getString('PP_SearchResultMoreGroup')), i,
        groupTitle = isCached ? cachedGrouptTitle : searchedGroupTitle;
        if (!principals.length) {
            return listHtml;
        }
        listHtml += '<div class=\"ms-PeoplePicker-resultGroup\">';
        if (showTitle) {
            listHtml += '<div class=\"ms-PeoplePicker-resultGroupTitle\">' + groupTitle + '</div>';
        }
        listHtml += '<ul class=\"ms-PeoplePicker-resultList\" id=\"' + groupTitle + '\">';
        for (i = 0; i < principals.length; i++) {
            listHtml += Office.Controls.peoplePickerTemplates.generateAutofillListItemTemplate(principals[i], isCached, showImage);
        }
        listHtml += '</ul></div>';
        return listHtml;
    };

    Office.Controls.peoplePickerTemplates.generateAutofillFooterTemplate = function (count, maxCount) {
        var footerHtml = '<div class=\"ms-PeoplePicker-searchMore js-searchMore\">';
        footerHtml += '<div class=\"ms-PeoplePicker-searchMoreIcon\"></div>';
        var footerText;
        if (count >= maxCount) {
            footerText = Office.Controls.Utils.formatString(Office.Controls.peoplePickerTemplates.getString('PP_ShowingTopNumberOfResults'), maxCount.toString());
        } else if (count > 1) {
            footerText = Office.Controls.Utils.formatString(Office.Controls.peoplePickerTemplates.getString('PP_MultipleResults'), count.toString());
        } else if (count > 0) {
            footerText = Office.Controls.Utils.formatString(Office.Controls.peoplePickerTemplates.getString('PP_SingleResult'), count.toString());
        } else {
            footerText = Office.Controls.peoplePickerTemplates.getString('PP_NoResult');
        }
        footerText = Office.Controls.Utils.htmlEncode(footerText);
        footerHtml += '<div class=\"ms-PeoplePicker-searchMorePrimary ms-PeoplePicker-searchMorePrimaryAdded\">' + footerText + '</div>';
        footerHtml += '</div>';
        return footerHtml;
    };

    Office.Controls.peoplePickerTemplates.generateSerachingLoadingTemplate = function () {
        var searchingLable = Office.Controls.Utils.htmlEncode(Office.Controls.peoplePickerTemplates.getString('PP_Searching'));
        var searchingLoadingHtml = '<div class=\"ms-PeoplePicker-searchMore js-searchMore is-searching\">';
        searchingLoadingHtml += '<div class=\"ms-PeoplePicker-searchMoreIconFixed\"></div>';
        searchingLoadingHtml += '<div class=\"ms-PeoplePicker-searchMorePrimary ms-PeoplePicker-searchMorePrimaryAdded\">' + searchingLable + '</div>';
        searchingLoadingHtml += '</div>';
        return searchingLoadingHtml;
    };

    Office.Controls.peoplePickerTemplates.generateRecordTemplate = function (record, allowMultipleSelections, showImage) {
        var recordHtml;
        var userRecordClass = 'ms-PeoplePicker-persona';
        if (!allowMultipleSelections) {
            userRecordClass += ' ms-PeoplePicker-personaForSingleAdded';
        }
        if (record.isResolved) {
            recordHtml = '<div class=\"' + userRecordClass + '\" tabindex=\"0\">';
        } else {
            recordHtml = '<div class=\"' + userRecordClass + ' ' + 'has-error' + '\" tabindex=\"0\">';
        }
        recordHtml += '<div class=\"ms-Persona ms-Persona--xs\" >';
        if (showImage) {
            if (Office.Controls.Utils.isNullOrUndefined(record.imgSrc)) {
                if (Office.Controls.Utils.isIE10()) {
                    recordHtml += '<div class=\"ms-PeoplePicker-Persona-image\" style=\"display:block\"></div>';
                } else {
                    recordHtml += '<img class=\"ms-PeoplePicker-Persona-image\">';
                }
            } else  {
                if (Office.Controls.Utils.isIE10()) {
                    recordHtml += '<div class=\"ms-PeoplePicker-Persona-image\" style=\"display:block;background-image:url(\'' + record.imgSrc + '\')\"></div>';
                } else {
                    recordHtml += '<img class=\"ms-PeoplePicker-Persona-image\" style=\"background-image:url(\'' + record.imgSrc + '\')\">';
                }
            }
        }
        recordHtml += '<div class=\"ms-Persona-details\">';
        recordHtml += '<div class=\"ms-Persona-primaryText ms-Persona-primaryTextForResolvedUserAdded\">' + Office.Controls.Utils.htmlEncode(record.text);
        recordHtml += '</div></div></div>';
        if (showImage) {
            recordHtml += '<div class=\"ms-PeoplePicker-personaRemove\">';
        } else {
            recordHtml += '<div class=\"ms-PeoplePicker-personaRemove\">';
        }
        recordHtml += '<i class=\"ms-Icon ms-Icon--x ms-Icon-added\">';
        recordHtml += '</i></div>';
        recordHtml += '</div>';
        return recordHtml;
    };

    Office.Controls.peoplePickerTemplates.generateAlertNode = function () {
        var alertHtml = '<div role=\"alert\" class=\"office-peoplepicker-alert\">';
        alertHtml += '</div>';
        return alertHtml;
    };

    if (Office.Controls.PrincipalInfo.registerClass) { Office.Controls.PrincipalInfo.registerClass('Office.Controls.PrincipalInfo'); }
    if (Office.Controls.PeoplePickerRecord.registerClass) { Office.Controls.PeoplePickerRecord.registerClass('Office.Controls.PeoplePickerRecord'); }
    if (Office.Controls.PeoplePicker.registerClass) { Office.Controls.PeoplePicker.registerClass('Office.Controls.PeoplePicker'); }
    if (Office.Controls.PeoplePicker.internalPeoplePickerRecord.registerClass) { Office.Controls.PeoplePicker.internalPeoplePickerRecord.registerClass('Office.Controls.PeoplePicker.internalPeoplePickerRecord'); }
    if (Office.Controls.PeoplePicker.autofillContainer.registerClass) { Office.Controls.PeoplePicker.autofillContainer.registerClass('Office.Controls.PeoplePicker.autofillContainer'); }
    if (Office.Controls.PeoplePicker.Parameters.registerClass) { Office.Controls.PeoplePicker.Parameters.registerClass('Office.Controls.PeoplePicker.Parameters'); }
    if (Office.Controls.PeoplePicker.cancelToken.registerClass) { Office.Controls.PeoplePicker.cancelToken.registerClass('Office.Controls.PeoplePicker.cancelToken');}
    if (Office.Controls.PeoplePicker.ValidationError.registerClass) { Office.Controls.PeoplePicker.ValidationError.registerClass('Office.Controls.PeoplePicker.ValidationError'); }
    if (Office.Controls.PeoplePicker.mruCache.registerClass) { Office.Controls.PeoplePicker.mruCache.registerClass('Office.Controls.PeoplePicker.mruCache');}
    if (Office.Controls.PeoplePicker.mruCache.mruData.registerClass) { Office.Controls.PeoplePicker.mruCache.mruData.registerClass('Office.Controls.PeoplePicker.mruCache.mruData'); }
    if (Office.Controls.PeoplePickerResourcesDefaults.registerClass) { Office.Controls.PeoplePickerResourcesDefaults.registerClass('Office.Controls.PeoplePickerResourcesDefaults'); }
    if (Office.Controls.peoplePickerTemplates.registerClass) { Office.Controls.peoplePickerTemplates.registerClass('Office.Controls.peoplePickerTemplates'); }
    Office.Controls.PeoplePicker.resourceStrings = {};
    Office.Controls.PeoplePicker.autofillContainer.currentOpened = null;
    Office.Controls.PeoplePicker.autofillContainer.boolBodyHandlerAdded = false;
    Office.Controls.PeoplePicker.ValidationError.multipleMatchName = 'MultipleMatch';
    Office.Controls.PeoplePicker.ValidationError.noMatchName = 'NoMatch';
    Office.Controls.PeoplePicker.ValidationError.serverProblemName = 'ServerProblem';
    Office.Controls.PeoplePicker.mruCache.instance = null;
    Office.Controls.PeoplePickerResourcesDefaults.PP_NoMatch = 'We couldn\'t find an exact match.';
    Office.Controls.PeoplePickerResourcesDefaults.PP_ServerProblem = 'Sorry, we\'re having trouble reaching the server.';
    Office.Controls.PeoplePickerResourcesDefaults.PP_DefaultMessagePlural = 'Enter names or email addresses...';
    Office.Controls.PeoplePickerResourcesDefaults.PP_MultipleMatch = 'Multiple entries matched, please click to resolve.';
    Office.Controls.PeoplePickerResourcesDefaults.PP_NoResult = 'No results found';
    Office.Controls.PeoplePickerResourcesDefaults.PP_SingleResult = 'Showing {0} result';
    Office.Controls.PeoplePickerResourcesDefaults.PP_MultipleResults = 'Showing {0} results';
    Office.Controls.PeoplePickerResourcesDefaults.PP_ShowingTopNumberOfResults = 'Showing top {0} results';
    Office.Controls.PeoplePickerResourcesDefaults.PP_Searching = 'Searching...';
    Office.Controls.PeoplePickerResourcesDefaults.PP_RemovePerson = 'Remove person or group {0}';
    Office.Controls.PeoplePickerResourcesDefaults.PP_DefaultMessage = 'Enter a name or email address...';
    Office.Controls.PeoplePickerResourcesDefaults.PP_SearchResultRecentGroup = 'Recent';
    Office.Controls.PeoplePickerResourcesDefaults.PP_SearchResultMoreGroup = 'More';
})();


(function () {
    "use strict";

    if (window.Type && window.Type.registerNamespace) {
        Type.registerNamespace('Office.Controls');
    } else {
        if (window.Office === undefined) {
            window.Office = {}; window.Office.namespace = true;
        }
        if (window.Office.Controls === undefined) {
            window.Office.Controls = {}; window.Office.Controls.namespace = true;
        }
    }

    /*
    *  The format of personaObject:
    * {
            "id": "person id",
            "imgSrc": "control/images/icon.png",
            "primaryText": 'Cat Miao',
            "secondaryText": 'Engineer 2, DepartmentA China', // JobTitle, Department
            "tertiaryText": 'BEIJING-Building1-1/XXX', // Office

            "actions":
                {
                    "email": "catmiao@companya.com",
                    "workPhone": "+86(10) 12345678", 
                    "mobile" : "+86 1861-0000-000",
                    "skype" : "catmiao@companya.com",
                }
            }
        };
    */
    Office.Controls.Persona = function (root, personaType, personaObject, isHidden) {
        if (typeof root !== 'object' || typeof personaType !== 'string' || typeof personaObject !== 'object') {
                Office.Controls.Utils.errorConsole('Invalid parameters type');
                return;
        }
            
        this.root = root;
        this.templateID = personaType.toString();
        this.personaObject = personaObject;
        this.isHidden = isHidden;
        // Load template & bind data
        this.loadDefaultTemplate(this.templateID);
    };

    Office.Controls.Persona.prototype = {
        onError: null,
        rootNode: null,
        mainNode: null,
        actionNodes: null,
        actionDetailNodes: null,
        constantObject: {}, 
        oriID: "",

        get_rootNode: function() {
            return this.rootNode;
        },

        get_mainNode: function() {
            return this.mainNode;
        },

        get_actionNodes: function() {
            return this.actionNodes;
        },

        get_actionDetailNodes: function() {
            return this.actionDetailNodes;
        },

        /**
         * Load the given default template
         * @return {[type]}             [description]
         */
        loadDefaultTemplate: function (templateID) {
            var templateNode = Office.Controls.Persona.Templates.DefaultDefinition[templateID].value;
            if (templateNode === "" || (Office.Controls.Utils.isNullOrUndefined(templateNode))) {
                alert('Fail to get the corret template content in loadDefaultTemplate');
                return;
            }
            this.parseTemplate(templateNode);
        },

        /**
         * Parse the persona content loading from template that includes 3 parts:
         *     1. Main: It's a detail card
         *     2. Action bar: It includes the action icons and the click event listener is also attached to each icon.
         *     3. The detail content of each Action icon: When click the icon, the detail shows up.
         * @xmlDoc  {[DomElment} xmlDoc The document loading from template
         */
        parseTemplate: function (templatedContent) {
            try {
                var templateElement = document.createElement("div");
                this.showNode(templateElement, this.isHidden);

                // Get cached view
                var cachedViewWithConstants = Office.Controls.Persona.PersonaHelper.getLocalCache(this.templateID);
                if (cachedViewWithConstants === null)
                {
                    // Replace the constant strings
                    cachedViewWithConstants = this.replaceConstantStrings(templatedContent);
                    // Save view to local cache
                    Office.Controls.Persona.PersonaHelper.setLocalCache(this.templateID, cachedViewWithConstants);
                }

                // Bind the business data
                templateElement.innerHTML = this.bindPersonaData(cachedViewWithConstants);
                if ((Office.Controls.Utils.isNullOrUndefined(templateElement))) {
                    Office.Controls.Utils.errorConsole('Fail to get persona document');
                    return;
                }
                this.root.appendChild(templateElement);
                this.rootNode = templateElement;

                // Get main node
                this.mainNode = templateElement.getElementsByClassName(Office.Controls.PersonaConstants.SectionTag_Main);
                if (this.mainNode === null) {
                    this.mainNode = this.rootNode;
                } else {
                    // Get action nodes
                    this.actionNodes = templateElement.getElementsByClassName(Office.Controls.PersonaConstants.SectionTag_Action);
                    if (this.actionNodes !== null) {
                        // Get actiondetail nodes
                        this.actionDetailNodes = templateElement.getElementsByClassName(Office.Controls.PersonaConstants.SectionTag_ActionDetail);
                        // Add click event to show the action detail node
                        var node = null;
                        var self = this;
                        for (var i = 0; i < self.actionNodes.length; i++) {
                            if (self.actionNodes[i] !== null) {
                                node = self.actionNodes[i];
                                Office.Controls.Utils.addEventListener(node, 'click', function (e) {
                                    self.setActiveStyle(event);
                                });
                            }
                        }
                    }
                }
            } catch (ex) {
                throw ex;
            }
        },

        /**
         * Bind businees data to template
         * @htmlStr  {string}
         * @return {string}
         */
        bindPersonaData: function (htmlStr) {
            var regExp = /\$\{([^\}\{]+)\}/g;
            return this.bindData(htmlStr, regExp, this.personaObject);
        },

        /**
         * Replace constant strings to template
         * @htmlStr  {string}
         * @return {string}
         */
        replaceConstantStrings : function (htmlStr) {
            // Init constant strings
            this.initiateStringObject();

            var regExp = /\$\{strings([^\}\{]+)\}/g;
            return this.bindData(htmlStr, regExp, this.constantObject);
        },

         /**
          * Bind generic data to template
          * @htmlStr  {string}
          * @regExp  {string}
          * @dataObject  {JsonObject}
          * @return {string}
          */
        bindData : function(htmlStr, regExp, dataObject)
        {
            if ((htmlStr === "") || Office.Controls.Utils.isNullOrUndefined(htmlStr) || (regExp === "") || Office.Controls.Utils.isNullOrUndefined(regExp) || (typeof dataObject !== 'object') || Office.Controls.Utils.isNullOrUndefined(dataObject)) {
                Office.Controls.Utils.errorConsole('data object is null.');
                return htmlStr;
            }
            
            var resultStr = htmlStr;
            var propertyName, propertyValue;
            var self = this;

            // Get the property names
            var properties = resultStr.match(regExp);
            if (properties !== null) {
                for (var i = 0; i < properties.length; i++) { 
                    propertyName = properties[i].substring(2, properties[i].length - 1);
                    propertyValue = self.getValueFromJSONObject(dataObject, propertyName);
                    resultStr = resultStr.replace(properties[i], propertyValue);
                }
            }

            return resultStr;
        },

        /**
         * strings:
         * {
            "label":{
                        "email": "Work: "
                        "workPhone": "Work: ",
                        "mobile": "Mobile: ",
                        "skype": "Skype: "
                    },

            "protocol": {
                            "email": "mailto:",
                            "phone": "tel:",
                            "skype": "sip:",
                        }
            }
         */
        initiateStringObject : function()
        {
            var colonSpace = Office.Controls.Persona.Strings.Colon + Office.Controls.Persona.Strings.Space;

            this.constantObject.strings = {};
            this.constantObject.strings.label = {};
            this.constantObject.strings.label.email = Office.Controls.Persona.Strings.Label_Work + colonSpace;
            this.constantObject.strings.label.workPhone = Office.Controls.Persona.Strings.Label_Work + colonSpace;
            this.constantObject.strings.label.mobile = Office.Controls.Persona.Strings.Label_Mobile + colonSpace
            this.constantObject.strings.label.skype = Office.Controls.Persona.Strings.Label_Skype + colonSpace;
            
            this.constantObject.strings.protocol = {};
            this.constantObject.strings.protocol.email = Office.Controls.Persona.Strings.Protocol_Mail;
            this.constantObject.strings.protocol.phone = Office.Controls.Persona.Strings.Protocol_Phone;
            this.constantObject.strings.protocol.skype = Office.Controls.Persona.Strings.Protocol_Skype;
        },

        /**
         * Parse the json object to get the corresponding value
         * @objectName  {string}
         * @return {object}
         */
        getValueFromJSONObject: function (obj, objectName) {
            var rtnValue =  Office.Controls.Utils.getObjectFromJSONObjectName(obj, objectName);
            if (rtnValue === null) {
                Office.Controls.Utils.errorConsole('the json object is null for data binding.');
                return;
            } 

            return rtnValue;
        },

        /**
         * Show the given domElement node
         * @node  {DomElement}
         * @isHidden  {Boolean}
         */
        showNode: function (node, isHidden) {
            if (isHidden)
            {
                node.style.visibility = "";
                node.style.display = "";
            }
            else
            {
                node.style.visibility = "hidden";
                node.style.display = "none";
            }
        },

        /**
         * Set the style of ative action button
         * @event {HtmlEvent}
         */
        setActiveStyle: function (event) {
            // Get the element triggers the event
            var e = event || window.event;
            var currentNode = e.currentTarget;

            var changedClassName = "is-active";
            var childClassName = currentNode.getAttribute('child');

            for (var i = 0; i < this.actionNodes.length; i++) {
                if ((currentNode === this.actionNodes[i])) {
                    if (this.oriID !== childClassName) {
                        Office.Controls.Utils.addClass(this.actionNodes[i], changedClassName); 
                        this.oriID = childClassName;
                    } else {
                        this.oriID = "";
                        Office.Controls.Utils.removeClass(this.actionNodes[i], changedClassName); 
                    }
                } else {
                    Office.Controls.Utils.removeClass(this.actionNodes[i], changedClassName);
                }
            }

            for (var i = 0; i < this.actionDetailNodes.length; i++) {
                if (Office.Controls.Utils.containClass(this.actionDetailNodes[i], childClassName) && (this.oriID === childClassName)) {
                    Office.Controls.Utils.addClass(this.actionDetailNodes[i], changedClassName); 
                } else {
                    Office.Controls.Utils.removeClass(this.actionDetailNodes[i], changedClassName);
                } 
            }
        }
    };

    Office.Controls.Persona.PersonaHelper = function () { };
    /**
     * [createPersona description]
     * @param  {[type]} root         [description]
     * @param  {[type]} personObject same as peoplepicker's personObject queried from AAD
     * @param  {[type]} personaType  [description]
     * @return {[type]}              [description]
     */
    Office.Controls.Persona.PersonaHelper.createPersona = function (root, personObj, personaType) {
        // Make sure the data object is legal.
        var personaObj = Office.Controls.Persona.PersonaHelper.convertAadUserToPersonaObject(personObj);
        var dataObj = Office.Controls.Persona.PersonaHelper.ensurePersonaObjectLegal(personaObj, personaType);
        // Create Persona 
        return new Office.Controls.Persona(root, personaType, dataObj, true);
    };

    Office.Controls.Persona.PersonaHelper.createInlinePersona = function (root, personObject, eventType) {
        var personaCard = null;
        var showNodeQueue = Office.Controls.Persona.PersonaHelper._showNodeQueue;
        var personaInstance = Office.Controls.Persona.PersonaHelper.createPersona(root, personObject, Office.Controls.Persona.PersonaType.TypeEnum.NameImage);
        if (eventType === "click") {
            if (personaInstance.rootNode !== null) {
                Office.Controls.Utils.addEventListener(personaInstance.rootNode, eventType, function (e) {
                    if (personaCard == null) {
                        // Close other instances on the same page and keep one instance show at most
                        if (showNodeQueue.length !== 0) {
                            var nodeItem = showNodeQueue.pop();
                            nodeItem.showNode(nodeItem.get_rootNode(), false);
                        }
                        personaCard = Office.Controls.Persona.PersonaHelper.createPersonaCard(root, personObject);
                        showNodeQueue.push(personaCard);
                    } else {
                        if (showNodeQueue.length !== 0) {
                            var nodeItem = showNodeQueue.pop();
                            nodeItem.showNode(nodeItem.get_rootNode(), false);
                            if (nodeItem !== personaCard) {
                                personaCard.showNode(personaCard.get_rootNode(),true);
                                showNodeQueue.push(personaCard);
                            } 
                        } else {
                            personaCard.showNode(personaCard.get_rootNode(),true);        
                            showNodeQueue.push(personaCard);
                        }
                    }
                });
                Office.Controls.Utils.addEventListener(document, eventType, function () {
                    if (event.target.tagName.toLowerCase() === "html") {
                        if (showNodeQueue.length !== 0) {
                            var nodeItem = showNodeQueue.pop();
                            nodeItem.showNode(nodeItem.get_rootNode(), false);
                        }
                    }
                });
            } else {
                Office.Controls.Utils.errorConsole('Wrong template path');
            }
        } 
        return personaInstance;
    };

    Office.Controls.Persona.PersonaHelper.createPersonaCard = function (root, personObject) {
        return Office.Controls.Persona.PersonaHelper.createPersona(root, personObject, Office.Controls.Persona.PersonaType.TypeEnum.PersonaCard);
    };

    /**
     * Make sure the data object to be used for creating Persona is legal
     */
    Office.Controls.Persona.PersonaHelper.ensurePersonaObjectLegal = function(oriPersonaObj, personaType) {
        // Get the definition of standard object
        var personaObj = Office.Controls.Persona.PersonaHelper.ensureJsonObjectLegal(Office.Controls.Persona.PersonaHelper.getPersonaObjectDef(), oriPersonaObj);
        personaObj.imgSrc = Office.Controls.Persona.StringUtils.setNullOrUndefinedAsEmpty(oriPersonaObj.imgSrc, Office.Controls.Persona.PersonaHelper._defaultImage);
        
        personaObj.primaryTextShort = Office.Controls.Persona.StringUtils.getDisplayText(personaObj.primaryText, personaType, 0);
        personaObj.secondaryTextShort = Office.Controls.Persona.StringUtils.getDisplayText(personaObj.secondaryText, personaType, 2);
        personaObj.tertiaryTextShort = Office.Controls.Persona.StringUtils.getDisplayText(personaObj.tertiaryText, personaType, 2);
        
        personaObj.actions.emailShort = Office.Controls.Persona.StringUtils.getDisplayText(personaObj.actions.email, personaType, 3);
        personaObj.actions.workPhoneShort = Office.Controls.Persona.StringUtils.getDisplayText(personaObj.actions.workPhone, personaType, 3);
        personaObj.actions.mobileShort = Office.Controls.Persona.StringUtils.getDisplayText(personaObj.actions.mobile, personaType, 3);
        personaObj.actions.skypeShort = Office.Controls.Persona.StringUtils.getDisplayText(personaObj.actions.skype, personaType, 3);
        return personaObj;
    }

    Office.Controls.Persona.PersonaHelper.getPersonaObjectDef = function() {
        return { "id": "", "imgSrc": "", "primaryText": "", "secondaryText": "", "tertiaryText": "", "actions": { "email": "", "workPhone": "", "mobile" : "", "skype" : "" }};
    }

    Office.Controls.Persona.PersonaHelper.ensureJsonObjectLegal = function(legalObj, originObj) {
        if (typeof originObj !== 'object') {
            Office.Controls.Utils.errorConsole('illegal json object');
            return;
        }

        var key;
        for (key in legalObj) {
            if (typeof legalObj[key] === 'object') {
                Office.Controls.Persona.PersonaHelper.ensureJsonObjectLegal(legalObj[key], originObj[key]);
            } else {
                legalObj[key] = Office.Controls.Persona.StringUtils.setNullOrUndefinedAsEmpty(originObj[key]);
            }
        }
        return legalObj;
    }

    /**
     * Convert AAD User Data To Persona Object
     * @aadUserObject {JSON Object}
     * @return {JSON personaObject}
     */
    Office.Controls.Persona.PersonaHelper.convertAadUserToPersonaObject = function(aadUserObject) {
        if (typeof aadUserObject !== 'object' || (Office.Controls.Utils.isNullOrUndefined(aadUserObject))) {
            Office.Controls.Utils.errorConsole('AAD user data is null.');
            return;
        }

        var displayName = Office.Controls.Persona.StringUtils.getDisplayText(aadUserObject.displayName, Office.Controls.Persona.PersonaType.TypeEnum.NameImage, 0);
            
        var personaObj = {};
        personaObj.id = aadUserObject.id;
        personaObj.imgSrc = (!aadUserObject.imgSrc) ? Office.Controls.Persona.PersonaHelper._defaultImage: aadUserObject.imgSrc;
        personaObj.primaryText = (displayName === "") ? Office.Controls.Persona.Strings.EmptyDisplayName : displayName;
        
        if (aadUserObject.jobTitle !== null) {
            personaObj.secondaryText = aadUserObject.jobTitle  + Office.Controls.Persona.Strings.Comma + aadUserObject.department;
        } else {
            personaObj.secondaryText = aadUserObject.department;   
        }
        personaObj.secondaryTextShort = Office.Controls.Persona.StringUtils.getDisplayText(personaObj.SecondaryText, Office.Controls.Persona.PersonaType.TypeEnum.PersonaCard, 2);
        personaObj.tertiaryText = Office.Controls.Persona.StringUtils.getDisplayText(aadUserObject.office, Office.Controls.Persona.PersonaType.TypeEnum.PersonaCard, 2);

        personaObj.actions = {};
        personaObj.actions.email = aadUserObject.mail;
        personaObj.actions.workPhone = aadUserObject.workPhone;
        personaObj.actions.mobile = aadUserObject.mobile;
        personaObj.actions.skype = aadUserObject.sipAddress;
        
        return personaObj;
    }

    Office.Controls.Persona.PersonaHelper.convertAadUsersToPersonaObjects = function(aadUsers) {
        if (typeof aadUsers !== 'object' || (Office.Controls.Utils.isNullOrUndefined(aadUsers))) {
            Office.Controls.Utils.errorConsole('AAD user collection is null.');
            return;
        }

        var personaObjects = [];
        aadUsers.forEach(function (aadUser) {
            personaObjects.push(Office.Controls.Persona.PersonaHelper.convertAadUserToPersonaObject(aadUser));
        });
        return personaObjects;
    }

    Office.Controls.Persona.PersonaHelper.getLocalCache = function (cacheId) {
        if ((cacheId === "") || Office.Controls.Utils.isNullOrUndefined(cacheId)) {
            Office.Controls.Utils.errorConsole('Wrong Cache ID');
            return;
        }

        var cacheIndex = cacheId.toLowerCase();
        var cachedObject = Office.Controls.Persona.PersonaHelper._localCache[cacheIndex];
        if (Office.Controls.Utils.isNullOrUndefined(cachedObject)) {
            return null;
        } else {
            return cachedObject;
        }
    };

    Office.Controls.Persona.PersonaHelper.setLocalCache = function (cacheId, object) {
        if ((cacheId === "") || Office.Controls.Utils.isNullOrUndefined(cacheId)) {
            Office.Controls.Utils.errorConsole('Wrong Cache ID');
            return;
        }

        if ((typeof object !== 'object' && typeof object !== 'string') || (Office.Controls.Utils.isNullOrUndefined(object))) {
            Office.Controls.Utils.errorConsole('Invalid Cached Object');
            return;
        }

        var cacheIndex = cacheId.toLowerCase();
        Office.Controls.Persona.PersonaHelper._localCache[cacheIndex] = object;
    };

    // The Persona Type
    Office.Controls.Persona.PersonaType = function() {};
    Office.Controls.Persona.PersonaType.TypeEnum = {
        NameImage: "nameimage",
        PersonaCard: "personacard"
    };

    Office.Controls.Persona.StringUtils = function () { };
    Office.Controls.Persona.StringUtils.getDisplayText = function (displayText, personaType, position) {
        if (!displayText) {
            return '';
        }
        
        // configurations of inline persona & cersonaCard
        var displayConfig = ((personaType === Office.Controls.Persona.PersonaType.TypeEnum.NameImage) ? [ 26, 26, 40, 42 ] : [ 18, 30, 36, 32 ]);
        
        var len = displayConfig[position];
        if (displayText.length > len) {
            return displayText.substr(0, len) + '...';
        } else {
            return displayText;
        }
    };

    Office.Controls.Persona.StringUtils.setNullOrUndefinedAsEmpty = function (str, value) {
        var val = ((value === undefined) ? "" : value);
        return Office.Controls.Utils.isNullOrEmptyString(str) ? val : str;
    };

    Office.Controls.Persona.Strings = function() {
    }

    Office.Controls.Persona.Templates = function() {
    }

    Office.Controls.PersonaResources = function () {
    };

    Office.Controls.PersonaConstants = function () {
    };

    
    if (Office.Controls.Persona.registerClass) { Office.Controls.Persona.registerClass('Office.Controls.Persona'); }
    if (Office.Controls.Persona.Strings.registerClass) { Office.Controls.Persona.Strings.registerClass('Office.Controls.Persona.Strings'); }
    if (Office.Controls.PersonaConstants.registerClass) { Office.Controls.PersonaConstants.registerClass('Office.Controls.PersonaConstants'); }
    if (Office.Controls.PersonaResources.registerClass) { Office.Controls.PersonaResources.registerClass('Office.Controls.PersonaResources'); }
    if (Office.Controls.Persona.PersonaHelper.registerClass) { Office.Controls.Persona.PersonaHelper.registerClass('Office.Controls.Persona.PersonaHelper'); }
    if (Office.Controls.Persona.StringUtils.registerClass) { Office.Controls.Persona.StringUtils.registerClass('Office.Controls.Persona.StringUtils'); }
    Office.Controls.PersonaResources.PersonaName = 'Persona';
    Office.Controls.Persona.Strings.Label_Skype = 'Skype';
    Office.Controls.Persona.Strings.Label_Work = 'Work';
    Office.Controls.Persona.Strings.Label_Mobile = 'Mobile';
    Office.Controls.Persona.Strings.Protocol_Mail = 'mailto:';
    Office.Controls.Persona.Strings.Protocol_Phone = 'tel:';
    Office.Controls.Persona.Strings.Protocol_Skype = 'sip:';
    Office.Controls.Persona.Strings.Colon = ':';
    Office.Controls.Persona.Strings.Comma = ',';
    Office.Controls.Persona.Strings.Space = ' ';
    Office.Controls.Persona.Strings.SuspensionPoints = '...';
    Office.Controls.Persona.Strings.EmptyDisplayName = 'No Name';
    Office.Controls.Persona.PersonaHelper._localCache = {};
    Office.Controls.Persona.PersonaHelper._showNodeQueue = [];
    Office.Controls.Persona.PersonaHelper._defaultImage = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAGAAAABgCAMAAADVRocKAAAABGdBTUEAALGPC/xhBQAAAAFzUkdCAK7OHOkAAAAgY0hSTQAAeiYAAICEAAD6AAAAgOgAAHUwAADqYAAAOpgAABdwnLpRPAAAAORQTFRFsbGxv7+/wcHBu7u72dnZ7u7u/////Pz85ubmy8vLtbW1wsLC5OTk/f3939/ft7e34eHh+vr61NTUs7OzwMDA8/Pz7OzsxMTE9PT0vLy8+/v7+fn5urq6vb298fHxtLS0srKyzc3N9/f32NjYtra209PT7e3t7+/v/v7+yMjI3t7e4+Pj6+vr6urq4uLi19fXx8fH0tLS9fX1ubm59vb2z8/PuLi4+Pj429vbzs7O0NDQ4ODg1dXV2tra1tbWzMzMxcXF6enp0dHR8vLyysrKxsbG3d3d6Ojovr6+5eXl5+fn8PDwYCkYCwAAAAFiS0dEBmFmuH0AAAAJcEhZcwAAdTAAAHUwAd0zcs0AAAKgSURBVGje7ZjdVtpQEIUByxCIIRKtYECgSSVULbWopRDBarVq+/7vU1raBcTMmbEzueha7Ous/XEOZ35zuY022mij/0z5QqGQmfnWqyL8VskqV/Tt7W1YkVN1de0rO5BQzdtV9N97Dc+1r3eIegnS1DhQ8rd9SFezpeJ/2ARM7Y6Cf7cIuCwFgAcmvRH7t3wjIBCHXBXMCoX+rkMA/LcywBFQOpIBeiQgkt1QnwSAKNre0f6ylxoyAMcSwAkDsC8BnDIAgQQQMQCOBNBmAECSUotZA95zAJIrGjD8mxLABwagKAGcMQADCYCTiz5KAIxsCnkRwCP9hyJ/uqKJayb1UJ1zIeDc3FXAjtCfCoWa9ADzzv3CBLgU+8/HphLuf6rgn8uVUf/GJxUA2hwFOu37rzOk3tJQawCZy075p7eFTeO6OmHiECN5455Q63OwtG+PdWbM+qQaXx0uL2oa96IoGsxWE+h1bB1P7H9x3wpHi59bNQwZ7p+q3fZeOtR+Wan3DXQ/YS+vzYlf8mjd9Z7RuUr9ajdcS+ZOzE5Ml7Xkm7xJidn8s7bMP2PZd+OUqGom01onTKlF/VsOAJn7vpZXnmZrFqR/dUf7j9Hc5lu39UIlfz+Jh/g3ZA/g4psDlhrU5EwNxqSILuCA0WqZRUzOU6k/gPEldUdyQM8E4HS7lPqmtMSZW0mZSsWNBsA0OQdye+P6oqLhDz4O2FMBAJ6273QAdRRAzxssTVDANx3AFAVYOgB88OQsPxh6QAHCWvBX6GyuEwbzooMBHpUAaKTdKwEA61zHcuuFsMlnpgV4zDbO8FzxpAXA2i/Wio4jbHy+kFsv5CEAcrXCFdJ8uVr+WFXOqwFOMg5k+J5xIGMbebVAhh8ZBzK2KVQLZKituP4EqRB824c6sq4AAAAldEVYdGRhdGU6Y3JlYXRlADIwMTQtMTAtMjlUMjA6MjQ6MTktMDU6MDBCpOLkAAAAJXRFWHRkYXRlOm1vZGlmeQAyMDE0LTEwLTI5VDIwOjI0OjE5LTA1OjAwM/laWAAAAABJRU5ErkJggg==";
    Office.Controls.PersonaConstants.SectionTag_Main = "persona-section-tag-main";
    Office.Controls.PersonaConstants.SectionTag_Action = "ms-PersonaCard-action";
    Office.Controls.PersonaConstants.SectionTag_ActionDetail = "ms-PersonaCard-actionDetails";
    Office.Controls.Persona.Templates.DefaultDefinition = {
        "nameimage": 
        {
            value: "<div class=\"ms-Persona\"><div class=\"image\"><img class=\"imageOfNameImage\" style=\"background-image:url(${imgSrc})\"></img></div><div class=\"ms-Persona-details ms-Persona-details-nameImage\"><div class=\"ms-Persona-primaryText ms-Persona-primaryText-nameImage\"><Label class=\"clickStyle\" title=\"${primaryText}\">${primaryTextShort}</Label></div><div class=\"ms-Persona-secondaryText ms-Persona-secondaryText-nameImage\"><Label class=\"clickStyle\" title=\"${secondaryText}\">${secondaryTextShort}</Label></div></div></div>"
        },
        "personacard": 
        {
            value: "<div class=\"ms-PersonaCard personaCard-customized detail displayMode\"><div class=\"ms-PersonaCard-persona persona-section-tag-main\"><div class=\"ms-Persona ms-Persona--xl\"><img class=\"ms-Persona-image image\" style=\"background-image:url(${imgSrc})\"></img><div class=\"ms-Persona-details\"><div class=\"ms-Persona-primaryText\"><Label class=\"defaultStyle\" title=\"${primaryText}\">${primaryTextShort}</Label></div><div class=\"ms-Persona-secondaryText\"><Label class=\"defaultStyle\" title=\"${secondaryText}\">${secondaryTextShort}</Label></div><div class=\"ms-Persona-tertiaryText\"><Label class=\"defaultStyle\" title=\"${tertiaryText}\">${tertiaryTextShort}</Label></div></div></div></div><ul class=\"ms-PersonaCard-actions\"><li class=\"ms-PersonaCard-action\" child=\"action-detail-mail\"><i class=\"ms-Icon ms-Icon--mail icon\"><span></span></i></li><li class=\"ms-PersonaCard-action\" child=\"action-detail-phone\"><i class=\"ms-Icon ms-Icon--phone icon\"><span></span></i></li><li class=\"ms-PersonaCard-action\" child=\"action-detail-chat\"><i class=\"ms-Icon ms-Icon--chat icon\"><span></span></i></li></ul><div class=\"ms-PersonaCard-actionDetails action-detail-mail\"><div class=\"ms-PersonaCard-detailLine\"><span class=\"ms-PersonaCard-detailLabel\">${strings.label.email}</span><a href=\"${strings.protocol.email}${actions.email}\">${actions.emailShort}</a></div></div><div class=\"ms-PersonaCard-actionDetails action-detail-phone\"><div class=\"ms-PersonaCard-detailLine\"><span class=\"ms-PersonaCard-detailLabel\">${strings.label.workPhone}</span><a href=\"${strings.protocol.phone}${actions.workPhone}\">${actions.workPhoneShort}</a><br/><span class=\"ms-PersonaCard-detailLabel\">${strings.label.mobile}</span><a href=\"${strings.protocol.phone}${actions.mobile}\">${actions.mobileShort}</a></div></div><div class=\"ms-PersonaCard-actionDetails action-detail-chat\"><div class=\"ms-PersonaCard-detailLine\"><span class=\"ms-PersonaCard-detailLabel\">${strings.label.skype}</span><a href=\"${strings.protocol.skype}${actions.skype}\">${actions.skypeShort}</a></div></div></div>"
        }
    };
})();