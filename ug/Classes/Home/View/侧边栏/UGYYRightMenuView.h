//
//  UGYYRightMenuView.h
//  ug
//
//  Created by ug on 2019/9/27.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^YYRightMenuBlock)();

@interface UGYYRightMenuView : UIView

@property (nonatomic, copy) YYRightMenuBlock backToHomeBlock;
@property (nonatomic, strong) NSArray *lotteryGamesArray;
@property (nonatomic, strong) NSString *gameId;
@property (nonatomic, strong) NSString *gameName;
@property (nonatomic, strong) NSString *titleType;//1 为首页，2 为彩种

- (void)show;

@end

NS_ASSUME_NONNULL_END
