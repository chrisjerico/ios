//
//  UGAPPVersionModel.h
//  ug
//
//  Created by ug on 2019/8/19.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGAPPVersionModel : UGModel
@property (nonatomic, strong) NSString *versionCode;
@property (nonatomic, strong) NSString *versionName;
@property (nonatomic, assign) BOOL switchUpdate;
@property (nonatomic, strong) NSString *updateContent;
@property (nonatomic, strong) NSString *file;

@end

NS_ASSUME_NONNULL_END
