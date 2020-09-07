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
//=====================
@property (weak, nonatomic) IBOutlet UIView *titlebgView;  /**<标题背景  */
@property (weak, nonatomic) IBOutlet UIView *btnbgView;    /**<按钮组背景  */
@property (weak, nonatomic) IBOutlet UIButton *allBtn;     /**<全部  */
@property (weak, nonatomic) IBOutlet UIButton *bigBtn;    /**<大  */
@property (weak, nonatomic) IBOutlet UIButton *smallBtn;  /**<小  */
@property (weak, nonatomic) IBOutlet UIButton *jiBtn;     /**<奇  */
@property (weak, nonatomic) IBOutlet UIButton *ouBtn;     /**<偶  */
@property (weak, nonatomic) IBOutlet UIButton *removeBtn; /**<移除  */
@end

NS_ASSUME_NONNULL_END
