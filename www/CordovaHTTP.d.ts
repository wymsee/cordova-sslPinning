// Typescript definition file for Cordova HTTP Plugin **Requires Phonegap/Cordova typescript definition**
/// <reference path="phonegap.d.ts" />
interface cordovaHTTPResponse {
    status:number;
    data:any;
}

interface cordovaHTTP {
    useBasicAuth(user:string, password:string, success:() => void, error:() => void);
    setHeader(header:string, value:string, success:() => void, error:() => void);
    enableSSLPinning(enable:boolean, success:() => void, error:() => void);
    acceptAllCerts(enable:boolean, success:() => void, error:() => void);
    post(url:string, parameters:any, headers:any, success:(response:cordovaHTTPResponse) => void, error:(response:cordovaHTTPResponse) => void);
    get(url:string, parameters:any, headers:any, success:(response:cordovaHTTPResponse) => void, error:(response:cordovaHTTPResponse) => void);
    uploadFile(url:string, parameters:any, headers:any, filePath:string, fileParameter:string, success:(response:cordovaHTTPResponse) => void, error:(response:cordovaHTTPResponse) => void);
    downloadFile(url:string, parameters:any, headers:any, filePath:string, success:(entry:FileEntry) => void, error:(response:cordovaHTTPResponse) => void);
}

declare var cordovaHTTP:cordovaHTTP;
