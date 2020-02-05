//
//  UGLotteryResultCollectionViewCell.h
//  ug
//
//  Created by ug on 2019/5/11.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UGLotteryResultCollectionViewCell : UICollectionViewCell

@property (nonatomic, assign) BOOL showAdd;
@property (nonatomic, assign) BOOL showIsequal;
@property (nonatomic, assign) BOOL showBorder;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *color;

@property (nonatomic, assign) BOOL showBall6;
@property (weak, nonatomic) IBOutlet UIImageView *ballImg;



@end

NS_ASSUME_NONNULL_END
