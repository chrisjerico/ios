//
//  NewLotteryHeaderViewCollectionReusableView.h
//  UGBWApp
//
//  Created by fish on 2020/9/27.
//  Copyright © 2020 ug. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewLotteryHeaderViewCollectionReusableView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UILabel *titlelabel;
@property (weak, nonatomic) IBOutlet UIButton *mBtn;
@property (weak, nonatomic) IBOutlet UIButton *mClickedBtn;

@end

NS_ASSUME_NONNULL_END
