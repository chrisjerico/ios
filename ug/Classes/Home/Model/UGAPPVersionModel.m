//
//  UGAPPVersionModel.m
//  ug
//
//  Created by ug on 2019/8/19.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGAPPVersionModel.h"

@implementation UGAPPVersionModel

// 是否存在新版本
- (BOOL)hasUpdate {
    return [AppDefine hasUpdateWithCurrentVersion:APP.Version newVersion:_versionCode];
}

// 是否需要强制更新
- (BOOL)needForce {
    return _switchUpdate ? [AppDefine hasUpdateWithCurrentVersion:APP.Version newVersion:_versionName] : false;
}

@end
