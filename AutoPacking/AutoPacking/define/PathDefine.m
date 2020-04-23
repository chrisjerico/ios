//
//  PathDefine.m
//  AutoPacking
//
//  Created by fish on 2019/12/12.
//  Copyright © 2019 fish. All rights reserved.
//

#import "PathDefine.h"
#import "SiteModel.h"
#import "cc_runtime_property.h"


@implementation PathDefine

static BOOL isFish = false;

+ (instancetype)shared {
    static id obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        isFish = [NSUserName() isEqualToString:@"fish"];
        obj = [self new];
    });
    return obj;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _username = isFish ? @"fish" : @"Andrew";
        
        _ipaExportDir = @"/Library/WebServer/Documents/ipa";
        _jsExportDir = @"/Library/WebServer/Documents/js";
        _ipaLogPath = isFish ? @"/Users/fish/自动打包/log/PackingLog.txt" : @"/Users/ug/自动打包/log/PackingLog.txt";
        _jsLogPath = isFish ? @"/Users/fish/自动打包/log/热更新发包记录.txt" : @"/Users/ug/自动打包/log/热更新发包记录.txt";
        
        _rnProjectDir = isFish ? @"/Users/fish/自动打包/pack" : @"/Users/ug/自动打包/pack";
        _jspatchDir = _NSString(@"%@/js/jspatch", _rnProjectDir);
        _iosProjectDir = _NSString(@"%@/ios", _rnProjectDir);
        _shellDir = [_iosProjectDir stringByAppendingPathComponent:@"AutoPacking/sh"];
        
        _tempIpa        = [_iosProjectDir stringByAppendingPathComponent:@"ug.ipa"];
        _tempXcarchive  = [_iosProjectDir stringByAppendingPathComponent:@"ug.xcarchive"];
        _tempPlist      = [_shellDir stringByAppendingPathComponent:@"a.plist"];
        _tempCiphertext = [_shellDir stringByAppendingPathComponent:@"Ciphertext.txt"];
        _tempCommitId   = [_iosProjectDir stringByAppendingPathComponent:@"CommitId.txt"];
        _tempLog        = [_iosProjectDir stringByAppendingPathComponent:@"ShortLog.txt"];
        _tempIOSVersion = [_iosProjectDir stringByAppendingPathComponent:@"Version.txt"];
        _tempRNVersion  = [_rnProjectDir stringByAppendingPathComponent:@"Version.txt"];
    }
    return self;
}

- (NSString *)pwd {
    NSString *path = nil;
    if (isFish) {
        path = @"/Users/fish/自动打包/APP管理后台密码.txt";
    } else {
        path = @"/Users/ug/自动打包/APP管理后台密码.txt";
    }
    return [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
}

- (NSString *)privateKey {
    NSString *path = nil;
    if (isFish) {
        path = @"/Users/fish/自动打包/私钥.txt";
    } else {
        path = @"/Users/ug/自动打包/私钥.txt";
    }
    return path;
}

@end





@implementation SiteModel (Helper)

_CCRuntimeProperty_Copy(NSString *, siteUrl, setSiteUrl)

- (NSString *)ipaPath       { return _NSString(@"%@/%@/%@/%@.ipa",         Path.ipaExportDir, Path.commitId, self.type, self.siteId); }
- (NSString *)plistPath     { return _NSString(@"%@/%@/%@/%@.plist",       Path.ipaExportDir, Path.commitId, self.type, self.siteId); }
- (NSString *)xcarchivePath { return _NSString(@"%@/%@/%@/%@.xcarchive",   Path.ipaExportDir, Path.commitId, self.type, self.siteId); }
- (NSString *)logPath       { return _NSString(@"%@/%@/%@/%@.txt",         Path.ipaExportDir, Path.commitId, self.type, self.siteId); }

@end
