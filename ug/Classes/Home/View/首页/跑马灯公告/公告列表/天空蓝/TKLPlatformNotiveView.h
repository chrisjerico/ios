//
//  TKLPlatformNotiveView.h
//  UGBWApp
//
//  Created by ug on 2020/9/6.
//  Copyright © 2020 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UGNoticeModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface TKLPlatformNotiveView : UIView
@property (nonatomic, strong) NSArray <UGNoticeModel *> *dataArray;
@end

NS_ASSUME_NONNULL_END
