//
//  UGRightMenuView.h
//  ug
//
//  Created by ug on 2019/5/9.
//  Copyright © 2019 ug. All rights reserved.
//
//gw ==》即时注单
//
//qk1==》今日输赢
//
//tzjl ==>投注记录
//
//kaijiangjieguo==》开奖结果
//
//changlong==》长龙
//
//lixibao==>利息宝
//
//zhanneixin==》邮箱
//
//tuichudenglu==》退出
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^RightMenuSelectBlock)(NSInteger index);
@interface UGRightMenuView : UIView
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) NSMutableArray *imageNameArray;



@property (nonatomic, copy) RightMenuSelectBlock menuSelectBlock;
- (void)show;

-(void)reloadTabViewDateWithTitleArray:(NSMutableArray *)titleArray withImgArray:(NSMutableArray *)imgArray;
@end

NS_ASSUME_NONNULL_END
