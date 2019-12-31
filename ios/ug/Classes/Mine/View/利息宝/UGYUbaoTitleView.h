//
//  UGYUbaoTitleView.h
//  ug
//
//  Created by ug on 2019/10/13.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZCircleProgress.h"
NS_ASSUME_NONNULL_BEGIN

@interface UGYUbaoTitleView : UIView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet ZZCircleProgress *progressView;
@property (weak, nonatomic) IBOutlet UIButton *returnButton;

@end

NS_ASSUME_NONNULL_END
