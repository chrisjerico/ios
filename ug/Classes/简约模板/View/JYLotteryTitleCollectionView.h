//
//  JYLotteryTitleCollectionView.h
//  ug
//
//  Created by ug on 2020/2/12.
//  Copyright © 2020 ug. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^JYgameTypeSelectBlock)(NSArray *subType);
//typedef void(^JYgameItemSelectBlock)(GameModel *game);

@interface JYLotteryTitleCollectionView : UIView

@property (nonatomic) JYgameTypeSelectBlock jygameTypeSelectBlock;
//@property (nonatomic) JYgameItemSelectBlock jygameItemSelectBlock;
@property (nonatomic) NSInteger selectIndex;
@property (nonatomic, strong)  NSArray <GameModel *> * list;

@end

NS_ASSUME_NONNULL_END
