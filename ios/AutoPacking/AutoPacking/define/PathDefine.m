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

+ (instancetype)shared {
    static id obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [self new];
    });
    return obj;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _username = [NSUserName() isEqualToString:@"fish"] ? @"fish" : @"Andrew";
        
        _projectDir = [NSUserName() isEqualToString:@"fish"] ? @"/Users/fish/自动打包/pack/ios" : @"/Users/ug/pack/ios";
        _exportDir = @"/Library/WebServer/Documents/ipa";
        _shellDir = [_projectDir stringByAppendingPathComponent:@"AutoPacking/sh"];
        _logPath = [NSUserName() isEqualToString:@"fish"] ? @"/Users/fish/自动打包/log/PackingLog.txt" : @"/Users/ug/log/PackingLog.txt";
        
        _tempIpa        = [_projectDir stringByAppendingPathComponent:@"ug.ipa"];
        _tempXcarchive  = [_projectDir stringByAppendingPathComponent:@"ug.xcarchive"];
        _tempPlist      = [_shellDir stringByAppendingPathComponent:@"a.plist"];
        _tempCiphertext = [_shellDir stringByAppendingPathComponent:@"Ciphertext.txt"];
        _tempCommitId   = [_projectDir stringByAppendingPathComponent:@"CommitId.txt"];
        _tempLog        = [_projectDir stringByAppendingPathComponent:@"ShortLog.txt"];
    }
    return self;
}

- (NSString *)pwd {
    NSString *pwdPath = nil;
    if ([NSUserName() isEqualToString:@"fish"]) {
        pwdPath = @"/Users/fish/自动打包/pack/APP管理后台密码.txt";
    }
    return [NSString stringWithContentsOfFile:pwdPath encoding:NSUTF8StringEncoding error:nil];
}

- (NSString *)privateKey {
    NSString *path = nil;
    if ([NSUserName() isEqualToString:@"fish"]) {
        path = @"/Users/fish/自动打包/pack/私钥.txt";
    } else {
        path = @"/Users/ug/自动打包/pack/私钥.txt";
    }
    return [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
}

@end





@implementation SiteModel (Helper)

_CCRuntimeProperty_Copy(NSString *, siteUrl, setSiteUrl)

- (NSString *)ipaPath       { return _NSString(@"%@/%@/%@/%@.ipa",         Path.exportDir, Path.commitId, self.type, self.siteId); }
- (NSString *)plistPath     { return _NSString(@"%@/%@/%@/%@.plist",       Path.exportDir, Path.commitId, self.type, self.siteId); }
- (NSString *)xcarchivePath { return _NSString(@"%@/%@/%@/%@.xcarchive",   Path.exportDir, Path.commitId, self.type, self.siteId); }
- (NSString *)logPath       { return _NSString(@"%@/%@/%@/%@.txt",         Path.exportDir, Path.commitId, self.type, self.siteId); }

@end
