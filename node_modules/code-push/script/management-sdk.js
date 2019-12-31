"use strict";
var __makeTemplateObject = (this && this.__makeTemplateObject) || function (cooked, raw) {
    if (Object.defineProperty) { Object.defineProperty(cooked, "raw", { value: raw }); } else { cooked.raw = raw; }
    return cooked;
};
var __importStar = (this && this.__importStar) || function (mod) {
    if (mod && mod.__esModule) return mod;
    var result = {};
    if (mod != null) for (var k in mod) if (Object.hasOwnProperty.call(mod, k)) result[k] = mod[k];
    result["default"] = mod;
    return result;
};
var fs = __importStar(require("fs"));
var os = __importStar(require("os"));
var path = __importStar(require("path"));
var Q = require("q");
var slash = require("slash");
var superagent = require("superagent");
var recursiveFs = __importStar(require("recursive-fs"));
var yazl = __importStar(require("yazl"));
var Promise = Q.Promise;
var superproxy = require("superagent-proxy");
superproxy(superagent);
var packageJson = require("../package.json");
// A template string tag function that URL encodes the substituted values
function urlEncode(strings) {
    var values = [];
    for (var _i = 1; _i < arguments.length; _i++) {
        values[_i - 1] = arguments[_i];
    }
    var result = "";
    for (var i = 0; i < strings.length; i++) {
        result += strings[i];
        if (i < values.length) {
            result += encodeURIComponent(values[i]);
        }
    }
    return result;
}
var AccountManager = /** @class */ (function () {
    function AccountManager(accessKey, customHeaders, serverUrl, proxy) {
        if (!accessKey)
            throw new Error("A token must be specified.");
        this._accessKey = accessKey;
        this._customHeaders = customHeaders;
        this._serverUrl = serverUrl || AccountManager.SERVER_URL;
        this._proxy = proxy;
    }
    Object.defineProperty(AccountManager.prototype, "accessKey", {
        get: function () {
            return this._accessKey;
        },
        enumerable: true,
        configurable: true
    });
    AccountManager.prototype.isAuthenticated = function (throwIfUnauthorized) {
        var _this = this;
        return Promise(function (resolve, reject, notify) {
            var request = superagent.get(_this._serverUrl + urlEncode(templateObject_1 || (templateObject_1 = __makeTemplateObject(["/authenticated"], ["/authenticated"]))));
            if (_this._proxy)
                request.proxy(_this._proxy);
            _this.attachCredentials(request);
            request.end(function (err, res) {
                var status = _this.getErrorStatus(err, res);
                if (err && status !== AccountManager.ERROR_UNAUTHORIZED) {
                    reject(_this.getCodePushError(err, res));
                    return;
                }
                var authenticated = status === 200;
                if (!authenticated && throwIfUnauthorized) {
                    reject(_this.getCodePushError(err, res));
                    return;
                }
                resolve(authenticated);
            });
        });
    };
    AccountManager.prototype.addAccessKey = function (friendlyName, ttl) {
        if (!friendlyName) {
            throw new Error("A name must be specified when adding an access key.");
        }
        var accessKeyRequest = {
            createdBy: os.hostname(),
            friendlyName: friendlyName,
            ttl: ttl
        };
        return this.post(urlEncode(templateObject_2 || (templateObject_2 = __makeTemplateObject(["/accessKeys/"], ["/accessKeys/"]))), JSON.stringify(accessKeyRequest), /*expectResponseBody=*/ true)
            .then(function (response) {
            return {
                createdTime: response.body.accessKey.createdTime,
                expires: response.body.accessKey.expires,
                key: response.body.accessKey.name,
                name: response.body.accessKey.friendlyName
            };
        });
    };
    AccountManager.prototype.getAccessKey = function (accessKeyName) {
        return this.get(urlEncode(templateObject_3 || (templateObject_3 = __makeTemplateObject(["/accessKeys/", ""], ["/accessKeys/", ""])), accessKeyName))
            .then(function (res) {
            return {
                createdTime: res.body.accessKey.createdTime,
                expires: res.body.accessKey.expires,
                name: res.body.accessKey.friendlyName,
            };
        });
    };
    AccountManager.prototype.getAccessKeys = function () {
        return this.get(urlEncode(templateObject_4 || (templateObject_4 = __makeTemplateObject(["/accessKeys"], ["/accessKeys"]))))
            .then(function (res) {
            var accessKeys = [];
            res.body.accessKeys.forEach(function (serverAccessKey) {
                !serverAccessKey.isSession && accessKeys.push({
                    createdTime: serverAccessKey.createdTime,
                    expires: serverAccessKey.expires,
                    name: serverAccessKey.friendlyName
                });
            });
            return accessKeys;
        });
    };
    AccountManager.prototype.getSessions = function () {
        return this.get(urlEncode(templateObject_5 || (templateObject_5 = __makeTemplateObject(["/accessKeys"], ["/accessKeys"]))))
            .then(function (res) {
            // A machine name might be associated with multiple session keys,
            // but we should only return one per machine name.
            var sessionMap = {};
            var now = new Date().getTime();
            res.body.accessKeys.forEach(function (serverAccessKey) {
                if (serverAccessKey.isSession && serverAccessKey.expires > now) {
                    sessionMap[serverAccessKey.createdBy] = {
                        loggedInTime: serverAccessKey.createdTime,
                        machineName: serverAccessKey.createdBy
                    };
                }
            });
            var sessions = Object.keys(sessionMap)
                .map(function (machineName) { return sessionMap[machineName]; });
            return sessions;
        });
    };
    AccountManager.prototype.patchAccessKey = function (oldName, newName, ttl) {
        var accessKeyRequest = {
            friendlyName: newName,
            ttl: ttl
        };
        return this.patch(urlEncode(templateObject_6 || (templateObject_6 = __makeTemplateObject(["/accessKeys/", ""], ["/accessKeys/", ""])), oldName), JSON.stringify(accessKeyRequest))
            .then(function (res) {
            return {
                createdTime: res.body.accessKey.createdTime,
                expires: res.body.accessKey.expires,
                name: res.body.accessKey.friendlyName,
            };
        });
    };
    AccountManager.prototype.removeAccessKey = function (name) {
        return this.del(urlEncode(templateObject_7 || (templateObject_7 = __makeTemplateObject(["/accessKeys/", ""], ["/accessKeys/", ""])), name))
            .then(function () { return null; });
    };
    AccountManager.prototype.removeSession = function (machineName) {
        return this.del(urlEncode(templateObject_8 || (templateObject_8 = __makeTemplateObject(["/sessions/", ""], ["/sessions/", ""])), machineName))
            .then(function () { return null; });
    };
    // Account
    AccountManager.prototype.getAccountInfo = function () {
        return this.get(urlEncode(templateObject_9 || (templateObject_9 = __makeTemplateObject(["/account"], ["/account"]))))
            .then(function (res) { return res.body.account; });
    };
    // Apps
    AccountManager.prototype.getApps = function () {
        return this.get(urlEncode(templateObject_10 || (templateObject_10 = __makeTemplateObject(["/apps"], ["/apps"]))))
            .then(function (res) { return res.body.apps; });
    };
    AccountManager.prototype.getApp = function (appName) {
        return this.get(urlEncode(templateObject_11 || (templateObject_11 = __makeTemplateObject(["/apps/", ""], ["/apps/", ""])), this.appNameParam(appName)))
            .then(function (res) { return res.body.app; });
    };
    AccountManager.prototype.addApp = function (appName, appOs, appPlatform, manuallyProvisionDeployments) {
        if (manuallyProvisionDeployments === void 0) { manuallyProvisionDeployments = false; }
        var app = {
            name: appName,
            os: appOs,
            platform: appPlatform,
            manuallyProvisionDeployments: manuallyProvisionDeployments
        };
        return this.post(urlEncode(templateObject_12 || (templateObject_12 = __makeTemplateObject(["/apps/"], ["/apps/"]))), JSON.stringify(app), /*expectResponseBody=*/ false)
            .then(function () { return app; });
    };
    AccountManager.prototype.removeApp = function (appName) {
        return this.del(urlEncode(templateObject_13 || (templateObject_13 = __makeTemplateObject(["/apps/", ""], ["/apps/", ""])), this.appNameParam(appName)))
            .then(function () { return null; });
    };
    AccountManager.prototype.renameApp = function (oldAppName, newAppName) {
        return this.patch(urlEncode(templateObject_14 || (templateObject_14 = __makeTemplateObject(["/apps/", ""], ["/apps/", ""])), this.appNameParam(oldAppName)), JSON.stringify({ name: newAppName }))
            .then(function () { return null; });
    };
    AccountManager.prototype.transferApp = function (appName, email) {
        return this.post(urlEncode(templateObject_15 || (templateObject_15 = __makeTemplateObject(["/apps/", "/transfer/", ""], ["/apps/", "/transfer/", ""])), this.appNameParam(appName), email), /*requestBody=*/ null, /*expectResponseBody=*/ false)
            .then(function () { return null; });
    };
    // Collaborators
    AccountManager.prototype.getCollaborators = function (appName) {
        return this.get(urlEncode(templateObject_16 || (templateObject_16 = __makeTemplateObject(["/apps/", "/collaborators"], ["/apps/", "/collaborators"])), this.appNameParam(appName)))
            .then(function (res) { return res.body.collaborators; });
    };
    AccountManager.prototype.addCollaborator = function (appName, email) {
        return this.post(urlEncode(templateObject_17 || (templateObject_17 = __makeTemplateObject(["/apps/", "/collaborators/", ""], ["/apps/", "/collaborators/", ""])), this.appNameParam(appName), email), /*requestBody=*/ null, /*expectResponseBody=*/ false)
            .then(function () { return null; });
    };
    AccountManager.prototype.removeCollaborator = function (appName, email) {
        return this.del(urlEncode(templateObject_18 || (templateObject_18 = __makeTemplateObject(["/apps/", "/collaborators/", ""], ["/apps/", "/collaborators/", ""])), this.appNameParam(appName), email))
            .then(function () { return null; });
    };
    // Deployments
    AccountManager.prototype.addDeployment = function (appName, deploymentName) {
        var deployment = { name: deploymentName };
        return this.post(urlEncode(templateObject_19 || (templateObject_19 = __makeTemplateObject(["/apps/", "/deployments/"], ["/apps/", "/deployments/"])), this.appNameParam(appName)), JSON.stringify(deployment), /*expectResponseBody=*/ true)
            .then(function (res) { return res.body.deployment; });
    };
    AccountManager.prototype.clearDeploymentHistory = function (appName, deploymentName) {
        return this.del(urlEncode(templateObject_20 || (templateObject_20 = __makeTemplateObject(["/apps/", "/deployments/", "/history"], ["/apps/", "/deployments/", "/history"])), this.appNameParam(appName), deploymentName))
            .then(function () { return null; });
    };
    AccountManager.prototype.getDeployments = function (appName) {
        return this.get(urlEncode(templateObject_21 || (templateObject_21 = __makeTemplateObject(["/apps/", "/deployments/"], ["/apps/", "/deployments/"])), this.appNameParam(appName)))
            .then(function (res) { return res.body.deployments; });
    };
    AccountManager.prototype.getDeployment = function (appName, deploymentName) {
        return this.get(urlEncode(templateObject_22 || (templateObject_22 = __makeTemplateObject(["/apps/", "/deployments/", ""], ["/apps/", "/deployments/", ""])), this.appNameParam(appName), deploymentName))
            .then(function (res) { return res.body.deployment; });
    };
    AccountManager.prototype.renameDeployment = function (appName, oldDeploymentName, newDeploymentName) {
        return this.patch(urlEncode(templateObject_23 || (templateObject_23 = __makeTemplateObject(["/apps/", "/deployments/", ""], ["/apps/", "/deployments/", ""])), this.appNameParam(appName), oldDeploymentName), JSON.stringify({ name: newDeploymentName }))
            .then(function () { return null; });
    };
    AccountManager.prototype.removeDeployment = function (appName, deploymentName) {
        return this.del(urlEncode(templateObject_24 || (templateObject_24 = __makeTemplateObject(["/apps/", "/deployments/", ""], ["/apps/", "/deployments/", ""])), this.appNameParam(appName), deploymentName))
            .then(function () { return null; });
    };
    AccountManager.prototype.getDeploymentMetrics = function (appName, deploymentName) {
        return this.get(urlEncode(templateObject_25 || (templateObject_25 = __makeTemplateObject(["/apps/", "/deployments/", "/metrics"], ["/apps/", "/deployments/", "/metrics"])), this.appNameParam(appName), deploymentName))
            .then(function (res) { return res.body.metrics; });
    };
    AccountManager.prototype.getDeploymentHistory = function (appName, deploymentName) {
        return this.get(urlEncode(templateObject_26 || (templateObject_26 = __makeTemplateObject(["/apps/", "/deployments/", "/history"], ["/apps/", "/deployments/", "/history"])), this.appNameParam(appName), deploymentName))
            .then(function (res) { return res.body.history; });
    };
    AccountManager.prototype.release = function (appName, deploymentName, filePath, targetBinaryVersion, updateMetadata, uploadProgressCallback) {
        var _this = this;
        return Promise(function (resolve, reject, notify) {
            updateMetadata.appVersion = targetBinaryVersion;
            var request = superagent.post(_this._serverUrl + urlEncode(templateObject_27 || (templateObject_27 = __makeTemplateObject(["/apps/", "/deployments/", "/release"], ["/apps/", "/deployments/", "/release"])), _this.appNameParam(appName), deploymentName));
            if (_this._proxy)
                request.proxy(_this._proxy);
            _this.attachCredentials(request);
            var getPackageFilePromise = _this.packageFileFromPath(filePath);
            getPackageFilePromise.then(function (packageFile) {
                var file = fs.createReadStream(packageFile.path);
                request.attach("package", file)
                    .field("packageInfo", JSON.stringify(updateMetadata))
                    .on("progress", function (event) {
                    if (uploadProgressCallback && event && event.total > 0) {
                        var currentProgress = event.loaded / event.total * 100;
                        uploadProgressCallback(currentProgress);
                    }
                })
                    .end(function (err, res) {
                    if (packageFile.isTemporary) {
                        fs.unlinkSync(packageFile.path);
                    }
                    if (err) {
                        reject(_this.getCodePushError(err, res));
                        return;
                    }
                    try {
                        var body = JSON.parse(res.text);
                    }
                    catch (err) {
                        reject({ message: "Could not parse response: " + res.text, statusCode: AccountManager.ERROR_INTERNAL_SERVER });
                        return;
                    }
                    if (res.ok) {
                        resolve(body.package);
                    }
                    else {
                        reject({ message: body.message, statusCode: res && res.status });
                    }
                });
            });
        });
    };
    AccountManager.prototype.patchRelease = function (appName, deploymentName, label, updateMetadata) {
        updateMetadata.label = label;
        var requestBody = JSON.stringify({ packageInfo: updateMetadata });
        return this.patch(urlEncode(templateObject_28 || (templateObject_28 = __makeTemplateObject(["/apps/", "/deployments/", "/release"], ["/apps/", "/deployments/", "/release"])), this.appNameParam(appName), deploymentName), requestBody, /*expectResponseBody=*/ false)
            .then(function () { return null; });
    };
    AccountManager.prototype.promote = function (appName, sourceDeploymentName, destinationDeploymentName, updateMetadata) {
        var requestBody = JSON.stringify({ packageInfo: updateMetadata });
        return this.post(urlEncode(templateObject_29 || (templateObject_29 = __makeTemplateObject(["/apps/", "/deployments/", "/promote/", ""], ["/apps/", "/deployments/", "/promote/", ""])), this.appNameParam(appName), sourceDeploymentName, destinationDeploymentName), requestBody, /*expectResponseBody=*/ true)
            .then(function (res) { return res.body.package; });
    };
    AccountManager.prototype.rollback = function (appName, deploymentName, targetRelease) {
        return this.post(urlEncode(templateObject_30 || (templateObject_30 = __makeTemplateObject(["/apps/", "/deployments/", "/rollback/", ""], ["/apps/", "/deployments/", "/rollback/", ""])), this.appNameParam(appName), deploymentName, targetRelease || ""), /*requestBody=*/ null, /*expectResponseBody=*/ false)
            .then(function () { return null; });
    };
    AccountManager.prototype.packageFileFromPath = function (filePath) {
        var _this = this;
        var getPackageFilePromise;
        if (fs.lstatSync(filePath).isDirectory()) {
            getPackageFilePromise = Promise(function (resolve, reject) {
                var directoryPath = filePath;
                recursiveFs.readdirr(directoryPath, function (error, directories, files) {
                    if (error) {
                        reject(error);
                        return;
                    }
                    var baseDirectoryPath = path.dirname(directoryPath);
                    var fileName = _this.generateRandomFilename(15) + ".zip";
                    var zipFile = new yazl.ZipFile();
                    var writeStream = fs.createWriteStream(fileName);
                    zipFile.outputStream.pipe(writeStream)
                        .on("error", function (error) {
                        reject(error);
                    })
                        .on("close", function () {
                        filePath = path.join(process.cwd(), fileName);
                        resolve({ isTemporary: true, path: filePath });
                    });
                    for (var i = 0; i < files.length; ++i) {
                        var file = files[i];
                        var relativePath = path.relative(baseDirectoryPath, file);
                        // yazl does not like backslash (\) in the metadata path.
                        relativePath = slash(relativePath);
                        zipFile.addFile(file, relativePath);
                    }
                    zipFile.end();
                });
            });
        }
        else {
            getPackageFilePromise = Q({ isTemporary: false, path: filePath });
        }
        return getPackageFilePromise;
    };
    AccountManager.prototype.generateRandomFilename = function (length) {
        var filename = "";
        var validChar = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
        for (var i = 0; i < length; i++) {
            filename += validChar.charAt(Math.floor(Math.random() * validChar.length));
        }
        return filename;
    };
    AccountManager.prototype.get = function (endpoint, expectResponseBody) {
        if (expectResponseBody === void 0) { expectResponseBody = true; }
        return this.makeApiRequest("get", endpoint, /*requestBody=*/ null, expectResponseBody, /*contentType=*/ null);
    };
    AccountManager.prototype.post = function (endpoint, requestBody, expectResponseBody, contentType) {
        if (contentType === void 0) { contentType = "application/json;charset=UTF-8"; }
        return this.makeApiRequest("post", endpoint, requestBody, expectResponseBody, contentType);
    };
    AccountManager.prototype.patch = function (endpoint, requestBody, expectResponseBody, contentType) {
        if (expectResponseBody === void 0) { expectResponseBody = false; }
        if (contentType === void 0) { contentType = "application/json;charset=UTF-8"; }
        return this.makeApiRequest("patch", endpoint, requestBody, expectResponseBody, contentType);
    };
    AccountManager.prototype.del = function (endpoint, expectResponseBody) {
        if (expectResponseBody === void 0) { expectResponseBody = false; }
        return this.makeApiRequest("del", endpoint, /*requestBody=*/ null, expectResponseBody, /*contentType=*/ null);
    };
    AccountManager.prototype.makeApiRequest = function (method, endpoint, requestBody, expectResponseBody, contentType) {
        var _this = this;
        return Promise(function (resolve, reject, notify) {
            var request = superagent[method](_this._serverUrl + endpoint);
            if (_this._proxy)
                request.proxy(_this._proxy);
            _this.attachCredentials(request);
            if (requestBody) {
                if (contentType) {
                    request = request.set("Content-Type", contentType);
                }
                request = request.send(requestBody);
            }
            request.end(function (err, res) {
                if (err) {
                    reject(_this.getCodePushError(err, res));
                    return;
                }
                try {
                    var body = JSON.parse(res.text);
                }
                catch (err) {
                }
                if (res.ok) {
                    if (expectResponseBody && !body) {
                        reject({ message: "Could not parse response: " + res.text, statusCode: AccountManager.ERROR_INTERNAL_SERVER });
                    }
                    else {
                        resolve({
                            headers: res.header,
                            body: body
                        });
                    }
                }
                else {
                    if (body) {
                        reject({ message: body.message, statusCode: _this.getErrorStatus(err, res) });
                    }
                    else {
                        reject({ message: res.text, statusCode: _this.getErrorStatus(err, res) });
                    }
                }
            });
        });
    };
    AccountManager.prototype.getCodePushError = function (error, response) {
        if (error.syscall === "getaddrinfo") {
            error.message = "Unable to connect to the CodePush server. Are you offline, or behind a firewall or proxy?\n(" + error.message + ")";
        }
        return {
            message: this.getErrorMessage(error, response),
            statusCode: this.getErrorStatus(error, response)
        };
    };
    AccountManager.prototype.getErrorStatus = function (error, response) {
        return (error && error.status) || (response && response.status) || AccountManager.ERROR_GATEWAY_TIMEOUT;
    };
    AccountManager.prototype.getErrorMessage = function (error, response) {
        return response && response.text ? response.text : error.message;
    };
    AccountManager.prototype.attachCredentials = function (request) {
        if (this._customHeaders) {
            for (var headerName in this._customHeaders) {
                request.set(headerName, this._customHeaders[headerName]);
            }
        }
        request.set("Accept", "application/vnd.code-push.v" + AccountManager.API_VERSION + "+json");
        request.set("Authorization", "Bearer " + this._accessKey);
        request.set("X-CodePush-SDK-Version", packageJson.version);
    };
    // IIS and Azure web apps have this annoying behavior where %2F (URL encoded slashes) in the URL are URL decoded
    // BEFORE the requests reach node. That essentially means there's no good way to encode a "/" in the app name--
    // URL encoding will work when running locally but when running on Azure it gets decoded before express sees it,
    // so app names with slashes don't get routed properly. See https://github.com/tjanczuk/iisnode/issues/343 (or other sites
    // that complain about the same) for some more info. I explored some IIS config based workarounds, but the previous
    // link seems to say they won't work, so I eventually gave up on that.
    // Anyway, to workaround this issue, we now allow the client to encode / characters as ~~ (two tildes, URL encoded).
    // The CLI now converts / to ~~ if / appears in an app name, before passing that as part of the URL. This code below
    // does the encoding. It's hack, but seems like the least bad option here.
    // Eventually, this service will go away & we'll all be on Max's new service. That's hosted in docker, no more IIS,
    // so this issue should go away then.
    AccountManager.prototype.appNameParam = function (appName) {
        return appName.replace("/", "~~");
    };
    AccountManager.AppPermission = {
        OWNER: "Owner",
        COLLABORATOR: "Collaborator"
    };
    AccountManager.SERVER_URL = "https://codepush-management.azurewebsites.net";
    AccountManager.MOBILE_CENTER_SERVER_URL = "https://mobile.azure.com";
    AccountManager.API_VERSION = 2;
    AccountManager.ERROR_GATEWAY_TIMEOUT = 504; // Used if there is a network error
    AccountManager.ERROR_INTERNAL_SERVER = 500;
    AccountManager.ERROR_NOT_FOUND = 404;
    AccountManager.ERROR_CONFLICT = 409; // Used if the resource already exists
    AccountManager.ERROR_UNAUTHORIZED = 401;
    return AccountManager;
}());
var templateObject_1, templateObject_2, templateObject_3, templateObject_4, templateObject_5, templateObject_6, templateObject_7, templateObject_8, templateObject_9, templateObject_10, templateObject_11, templateObject_12, templateObject_13, templateObject_14, templateObject_15, templateObject_16, templateObject_17, templateObject_18, templateObject_19, templateObject_20, templateObject_21, templateObject_22, templateObject_23, templateObject_24, templateObject_25, templateObject_26, templateObject_27, templateObject_28, templateObject_29, templateObject_30;
module.exports = AccountManager;
