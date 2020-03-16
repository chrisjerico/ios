//
//  DocumentTypeList.h
//  UGBWApp
//
//  Created by fish on 2020/3/15.
//  Copyright © 2020 ug. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// 切换资料类型
@interface DocumentTypeList : UIView

@property(nonatomic, assign)int selectedIndex;
@property(nonatomic, strong) void(^completionHandle)(GameModel * selectedModel);

+ (NSArray<GameModel *> *)allGames;
+ (void)setAllGames:(NSArray<GameModel *> *)allGames;

+ (BOOL)isShow:(UIView *)superview;
+ (void)showIn:(UIView *)supperView completionHandle:(void(^)(GameModel * model)) block;
+ (void)hide;
@end

@interface DocumentTypeListCell : UICollectionViewCell
@property(nonatomic, strong)UILabel * titleLabel;

@end

NS_ASSUME_NONNULL_END
