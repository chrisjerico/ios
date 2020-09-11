//
//  YNInputView.h
//  UGBWApp
//
//  Created by andrew on 2020/7/27.
//  Copyright © 2020 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITextView+Extension.h"
NS_ASSUME_NONNULL_BEGIN
// （我的页包含的）功能页面
typedef NS_ENUM(NSInteger, TipsType) {
    Tip_十        = 1,
    Tip_百        = 2,
    Tip_千        = 3,
    Tip_偏斜2      = 4,
    Tip_偏斜3      = 5,
    Tip_偏斜4      = 6,
    Tip_串烧4      = 7,
    Tip_串烧8      = 8,
    Tip_串烧10     = 9,

};

@interface YNInputView : UIView
@property (weak, nonatomic) IBOutlet UITextView *inputTextView;
@property (nonatomic, assign) TipsType code; /**<    */

@end

NS_ASSUME_NONNULL_END
