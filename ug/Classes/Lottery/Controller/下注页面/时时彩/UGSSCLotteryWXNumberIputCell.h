//
//  UGSSCLotteryWXNumberIputCell.h
//  UGBWApp
//
//  Created by xionghx on 2020/9/23.
//  Copyright © 2020 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UGGameplayModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol UGSSCLotteryWXNumberIputCellDelegate <NSObject>

-(void)newNumberGenerated: (NSArray <NSString *> *)numbers;

@end

@interface UGSSCLotteryWXNumberIputCell : UICollectionViewCell<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *inputView;
@property (nonatomic, weak) id<UGSSCLotteryWXNumberIputCellDelegate> delegate;
@property (nonatomic, strong) UGGameBetModel *item;

@end

NS_ASSUME_NONNULL_END
