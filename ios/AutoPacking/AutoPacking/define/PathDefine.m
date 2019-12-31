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
        _username = [NSUserName() isEqualToString:@"fish"] ? @"fish" : @"andrew";
        
        _projectDir = [NSUserName() isEqualToString:@"fish"] ? @"/Users/fish/自动打包/pack" : @"/Users/ug/pack";
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

@end





@implementation SiteModel (Helper)

_CCRuntimeProperty_Copy(NSString *, siteUrl, setSiteUrl)

- (NSString *)ipaPath       { return _NSString(@"%@/%@/%@/%@.ipa",         Path.exportDir, Path.commitId, self.type, self.siteId); }
- (NSString *)plistPath     { return _NSString(@"%@/%@/%@/%@.plist",       Path.exportDir, Path.commitId, self.type, self.siteId); }
- (NSString *)xcarchivePath { return _NSString(@"%@/%@/%@/%@.xcarchive",   Path.exportDir, Path.commitId, self.type, self.siteId); }
- (NSString *)logPath       { return _NSString(@"%@/%@/%@/%@.txt",         Path.exportDir, Path.commitId, self.type, self.siteId); }

@end
