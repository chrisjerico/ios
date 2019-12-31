export declare module Http {
    const enum Verb {
        GET = 0,
        HEAD = 1,
        POST = 2,
        PUT = 3,
        DELETE = 4,
        TRACE = 5,
        OPTIONS = 6,
        CONNECT = 7,
        PATCH = 8
    }
    interface Response {
        statusCode: number;
        body?: string;
    }
    interface Requester {
        request(verb: Verb, url: string, callback: Callback<Response>): void;
        request(verb: Verb, url: string, requestBody: string, callback: Callback<Response>): void;
    }
}
export interface Package {
    deploymentKey: string;
    description: string;
    label: string;
    appVersion: string;
    isMandatory: boolean;
    packageHash: string;
    packageSize: number;
}
export interface RemotePackage extends Package {
    downloadUrl: string;
}
export interface NativeUpdateNotification {
    updateAppVersion: boolean;
    appVersion: string;
}
export interface LocalPackage extends Package {
    localPath: string;
}
export interface Callback<T> {
    (error: Error, parameter: T): void;
}
export interface Configuration {
    appVersion: string;
    clientUniqueId: string;
    deploymentKey: string;
    serverUrl: string;
    ignoreAppVersion?: boolean;
}
export declare class AcquisitionStatus {
    static DeploymentSucceeded: string;
    static DeploymentFailed: string;
}
export declare class AcquisitionManager {
    private _appVersion;
    private _clientUniqueId;
    private _deploymentKey;
    private _httpRequester;
    private _ignoreAppVersion;
    private _serverUrl;
    private _publicPrefixUrl;
    constructor(httpRequester: Http.Requester, configuration: Configuration);
    queryUpdateWithCurrentPackage(currentPackage: Package, callback?: Callback<RemotePackage | NativeUpdateNotification>): void;
    reportStatusDeploy(deployedPackage?: Package, status?: string, previousLabelOrAppVersion?: string, previousDeploymentKey?: string, callback?: Callback<void>): void;
    reportStatusDownload(downloadedPackage: Package, callback?: Callback<void>): void;
}
