//
//  BetImgView.h
//  ug
//
//  Created by ug on 2020/2/14.
//  Copyright © 2020 ug. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BetImgView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *ballImgV;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
-(instancetype)initView;
@end

NS_ASSUME_NONNULL_END
