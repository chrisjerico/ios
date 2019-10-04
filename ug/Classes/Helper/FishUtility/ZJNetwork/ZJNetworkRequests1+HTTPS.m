//
//  ZJNetworkRequests1+HTTPS.m
//  C
//
//  Created by fish on 2018/5/11.
//  Copyright © 2018年 fish. All rights reserved.
//

#import "ZJNetworkRequests1+HTTPS.h"
#import "AFSecurityPolicy.h"
#import "AFHTTPSessionManager.h"

@implementation ZJNetworkRequests1 (HTTPS)

+ (AFHTTPSessionManager *)authSessionManager:(NSString *)urlString {
    NSString *cerName = @"pkserver";
    NSString *p12Name = @"pkclient";
    NSString *p12Pwd = @"ox0sPL3";
    
    if ([urlString containsString:@"www.pptdaka.com"]) {}
#if defined(DEBUG) || defined(APP_TEST)
    else if ([urlString containsString:@"120.78.170.223:8090"]) {
        cerName = @"test_server";
        p12Name = @"test_client";
        p12Pwd = @"123456";
    }
#endif
    // cer文件错误：Code=-999 "已取消"
    // p12文件密码错误：伪装成“服务器ip地址"
    // p12文件错误：服务器“服务器ip地址"要求客户端证书
    
    else {
        static AFHTTPSessionManager *m = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            m = [[AFHTTPSessionManager manager]initWithBaseURL:[NSURL URLWithString:urlString]];
        });
        m.requestSerializer = [AFJSONRequestSerializer serializer];
        m.responseSerializer = [AFJSONResponseSerializer serializer];
        m.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
        return m;
    }
    
    static AFHTTPSessionManager *sm = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sm = [[AFHTTPSessionManager manager] initWithBaseURL:[NSURL URLWithString:urlString]];
    });
    sm.requestSerializer = [AFJSONRequestSerializer serializer];
    sm.responseSerializer = [AFJSONResponseSerializer serializer];
    sm.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    sm.securityPolicy = ({
        // 验证服务器
        NSSet *certSet = [NSSet setWithObject:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:cerName ofType:@"cer"]]];
        // 安全策略
        AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate withPinnedCertificates:certSet];
        policy.allowInvalidCertificates = true;
        policy.validatesDomainName = false;
        policy;
    });
    
#ifdef DEBUG
    // 关闭缓存避免干扰测试r
    sm.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
#endif
    [sm setSessionDidBecomeInvalidBlock:^(NSURLSession * _Nonnull session, NSError * _Nonnull error) {
        NSLog(@"setSessionDidBecomeInvalidBlock");
    }];
    
    //客户端请求验证 重写 setSessionDidReceiveAuthenticationChallengeBlock 方法
    __weak_Obj_(sm, __sm);
    [sm setSessionDidReceiveAuthenticationChallengeBlock:^NSURLSessionAuthChallengeDisposition(NSURLSession*session, NSURLAuthenticationChallenge *challenge, NSURLCredential *__autoreleasing*_credential) {
        NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
        __autoreleasing NSURLCredential *credential =nil;
        if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
            if ([__sm.securityPolicy evaluateServerTrust:challenge.protectionSpace.serverTrust forDomain:challenge.protectionSpace.host]) {
                credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
                if(credential) {
                    disposition = NSURLSessionAuthChallengeUseCredential;
                } else {
                    disposition = NSURLSessionAuthChallengePerformDefaultHandling;
                }
            } else {
                disposition = NSURLSessionAuthChallengeCancelAuthenticationChallenge;
            }
        } else {
            // client authentication
            SecIdentityRef identity = NULL;
            SecTrustRef trust = NULL;
            NSData *PKCS12Data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:p12Name ofType:@"p12"]];
            if ([ZJNetworkRequests1 extractIdentity:&identity andTrust:&trust fromPKCS12Data:PKCS12Data pwd:p12Pwd]) {
                SecCertificateRef certificate = NULL;
                SecIdentityCopyCertificate(identity, &certificate);
                const void *certs[] = {certificate};
                CFArrayRef certArray = CFArrayCreate(kCFAllocatorDefault, certs, 1, NULL);
                credential = [NSURLCredential credentialWithIdentity:identity certificates:(__bridge NSArray *)certArray persistence:NSURLCredentialPersistencePermanent];
                disposition = NSURLSessionAuthChallengeUseCredential;
            }
        }
        *_credential = credential;
        return disposition;
    }];
    return sm;
}

+ (BOOL)extractIdentity:(SecIdentityRef *)outIdentity andTrust:(SecTrustRef *)outTrust fromPKCS12Data:(NSData *)inPKCS12Data pwd:(NSString *)pwd {
    OSStatus securityError = errSecSuccess;
    //client certificate password
    NSDictionary*optionsDictionary = [NSDictionary dictionaryWithObject:pwd//camrablive
                                                                 forKey:(__bridge id)kSecImportExportPassphrase];
    
    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
    securityError = SecPKCS12Import((__bridge CFDataRef)inPKCS12Data, (__bridge CFDictionaryRef)optionsDictionary, &items);
    
    if (securityError == 0) {
        CFDictionaryRef myIdentityAndTrust = CFArrayGetValueAtIndex(items,0);
        const void *tempIdentity = NULL;
        tempIdentity = CFDictionaryGetValue(myIdentityAndTrust, kSecImportItemIdentity);
        *outIdentity = (SecIdentityRef)tempIdentity;
        const void *tempTrust = NULL;
        tempTrust = CFDictionaryGetValue(myIdentityAndTrust, kSecImportItemTrust);
        *outTrust = (SecTrustRef)tempTrust;
        return true;
    }
    NSLog(@"Failedwith error code %d", (int)securityError);
    return false;
}

+ (NSString *)titleWithSessionModel:(ZJSessionModel *)sm {
    return nil;
}

@end
