//
//  UGPlatformNoticeView.h
//  ug
//
//  Created by ug on 2019/5/31.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UGPlatformNoticeView : UGView

@property (nonatomic, strong) NSArray *dataArray;

- (void)show;

@end

NS_ASSUME_NONNULL_END
