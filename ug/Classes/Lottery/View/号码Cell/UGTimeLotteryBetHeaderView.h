//
//  UGTimeLotteryBetHeaderView.h
//  ug
//
//  Created by ug on 2019/5/11.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UGTimeLotteryBetHeaderView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *xxtitleLabel;//详细文本 默认隐藏
@property (nonatomic, assign) BOOL leftTitle;
@end

NS_ASSUME_NONNULL_END
