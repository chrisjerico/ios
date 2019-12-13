//
//  PathDefine.m
//  AutoPacking
//
//  Created by fish on 2019/12/12.
//  Copyright © 2019 fish. All rights reserved.
//

#import "PathDefine.h"
#import "SiteModel.h"


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
        _log = @"/Users/fish/自动打包/log/PackingLog.txt";
        
        _tempIpa        = [_projectDir stringByAppendingPathComponent:@"ug.ipa"];
        _tempXcarchive  = [_projectDir stringByAppendingPathComponent:@"ug.xcarchive"];
        _tempCommitId   = [_projectDir stringByAppendingPathComponent:@"CommitId.txt"];
        _tempPlist      = [_shellDir stringByAppendingPathComponent:@"a.plist"];
        _tempCiphertext = [_shellDir stringByAppendingPathComponent:@"Ciphertext.txt"];
    }
    return self;
}

@end





@implementation SiteModel (Helper)

- (NSString *)ipaPath       { return _NSString(@"%@/%@/%@/%@.ipa",         Path.exportDir, [NSString stringWithContentsOfFile:Path.tempCommitId encoding:NSUTF8StringEncoding error:nil], self.type, self.siteId); }
- (NSString *)plistPath     { return _NSString(@"%@/%@/%@/%@.plist",       Path.exportDir, [NSString stringWithContentsOfFile:Path.tempCommitId encoding:NSUTF8StringEncoding error:nil], self.type, self.siteId); }
- (NSString *)xcarchivePath { return _NSString(@"%@/%@/%@/%@.xcarchive",   Path.exportDir, [NSString stringWithContentsOfFile:Path.tempCommitId encoding:NSUTF8StringEncoding error:nil], self.type, self.siteId); }
@end
