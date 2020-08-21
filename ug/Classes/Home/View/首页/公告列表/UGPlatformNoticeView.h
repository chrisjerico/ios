//
//  UGPlatformNoticeView.h
//  ug
//
//  Created by ug on 2019/5/31.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UGNoticeModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface UGPlatformNoticeView : UIView
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (nonatomic, strong) NSArray <UGNoticeModel *> *dataArray;
@property (weak, nonatomic)  UIViewController *supVC;
- (void)show;

@end

NS_ASSUME_NONNULL_END
