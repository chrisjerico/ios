//
//  UGSignInScrHeaderView.h
//  ug
//
//  Created by ug on 2019/9/5.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UGSignInScrHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIView *titleBgView;
@property (nonatomic, strong) NSString *signInNumberStr;
@property (weak, nonatomic) IBOutlet UILabel *title1Label;//已连续
@property (weak, nonatomic) IBOutlet UILabel *title2Label;//天签到

-(instancetype)initView;

@end

NS_ASSUME_NONNULL_END
