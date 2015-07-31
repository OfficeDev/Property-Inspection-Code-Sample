var rpUtil = {
    getTimeString: function (time) {
        if (typeof (time) == "undefined"
            || !time) {
            return "";
        }
        else {
            var year = time.substring(0, 4);
            var month = time.substring(5, 7);
            var day = time.substring(8, 10);
            return month + "/" + day + "/" + year;
        }
    },
    getStringFromCurrentDate: function () {
        var date = new Date();

        var month = date.getMonth() + 1;
        if (month < 10) {
            month = "0" + month;
        }
        var day = date.getDate();
        if (day < 10) {
            day = "0" + day;
        }
        var year = date.getFullYear() + "";

        var str = month + "/" + day + "/" + year.substr(2, 2);
        return str;
    },
    getFileName: function () {
        var date = new Date();

        var month = date.getMonth() + 1;
        if (month < 10) {
            month = "0" + month;
        }
        var day = date.getDate();
        if (day < 10) {
            day = "0" + day;
        }
        var year = date.getFullYear() + "";

        var hours = date.getHours();
        if (hours < 10) {
            hours = "0" + hours;
        }
        var mins = date.getMinutes();
        if (mins < 10) {
            mins = "0" + mins;
        }
        var str = year.substr(2, 2) + month + day + hours + mins;
        for (var i = 0 ; i < 5; i++) {
            str = str + this.getRandomInt(0, 10);
        }
        return str;
    },
    getRandomInt: function (min, max) {
        return Math.floor(Math.random() * (max - min)) + min;
    },
    sendEmailByNative: function (toArray) {
        window.plugin.email.open({
            to: toArray, // email addresses for TO field
            cc: null, // email addresses for CC field
            bcc: null, // email addresses for BCC field
            attachments: null, // paths to the files you want to attach or base64 encoded data streams
            subject: "Repair App Demo send email", // subject of the email
            body: "Repair App Demo send email", // email body (could be HTML code, in this case set isHtml to true)
            isHtml: false, // indicats if the body is HTML or plain text
        });
    },
    base64Encode: function (str) {
        var CHARS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
        var out = "", i = 0, len = str.length, c1, c2, c3;
        while (i < len) {
            c1 = str.charCodeAt(i++) & 0xff;
            if (i == len) {
                out += CHARS.charAt(c1 >> 2);
                out += CHARS.charAt((c1 & 0x3) << 4);
                out += "==";
                break;
            }
            c2 = str.charCodeAt(i++);
            if (i == len) {
                out += CHARS.charAt(c1 >> 2);
                out += CHARS.charAt(((c1 & 0x3) << 4) | ((c2 & 0xF0) >> 4));
                out += CHARS.charAt((c2 & 0xF) << 2);
                out += "=";
                break;
            }
            c3 = str.charCodeAt(i++);
            out += CHARS.charAt(c1 >> 2);
            out += CHARS.charAt(((c1 & 0x3) << 4) | ((c2 & 0xF0) >> 4));
            out += CHARS.charAt(((c2 & 0xF) << 2) | ((c3 & 0xC0) >> 6));
            out += CHARS.charAt(c3 & 0x3F);
        }
        return out;
    },
    decodeBase64: function (s) {
        var e = {}, i, b = 0, c, x, l = 0, a, r = '', w = String.fromCharCode, L = s.length;
        var A = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
        for (i = 0; i < 64; i++) { e[A.charAt(i)] = i; }
        for (x = 0; x < L; x++) {
            c = e[s.charAt(x)]; b = (b << 6) + c; l += 6;
            while (l >= 8) { ((a = (b >>> (l -= 8)) & 0xff) || (x < (L - 2))) && (r += w(a)); }
        }
        return r;
    },
    convertDataURIToBinary: function (dataURI) {
        var BASE64_MARKER = ';base64,';
        var base64Index = dataURI.indexOf(BASE64_MARKER) + BASE64_MARKER.length;
        var base64 = dataURI.substring(base64Index);
        var raw = window.atob(base64);
        var rawLength = raw.length;
        var array = new Uint8Array(new ArrayBuffer(rawLength));

        for (i = 0; i < rawLength; i++) {
            array[i] = raw.charCodeAt(i);
        }
        return array;
    }
}
