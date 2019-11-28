//
//  UGLHLhlModel.h
//  ug
//
//  Created by ug on 2019/11/22.
//  Copyright © 2019 ug. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UGModel.h"


NS_ASSUME_NONNULL_BEGIN


@protocol UGLHLhlInfoModel <NSObject>

@end
@interface UGLHLhlInfoModel : UGModel<UGLHLhlInfoModel>
@property (copy, nonatomic) NSString *ganZhi;/**<   癸亥    天干地支" */
@property (copy, nonatomic) NSString *jiShenYiQu;/**<   王日 续世 宝光    吉神宜趋" */
@property (copy, nonatomic) NSString *yi;/**<   祭祀 沐浴 馀事勿取    宜" */
@property (copy, nonatomic) NSString *xiongShaYiJi;/**<   月建 小时 土府 月刑 四废 九坎 九焦 血忌 重日 阳错    凶煞宜忌 " */
@property (copy, nonatomic) NSString *baiJi;/**<   癸不词讼理弱敌强 亥不嫁娶不利新郎     白忌" */
@property (copy, nonatomic) NSString *caiShen;/**<   正南     财神" */
@property (copy, nonatomic) NSString *chongSha;/**<   冲蛇(丁已)煞西      冲煞" */
@property (copy, nonatomic) NSString *dayCN;/**<   廿六    右边日期" */
@property (assign, nonatomic) int dayEN;/**<   22     中间最大的数字" */
@property (assign, nonatomic) int daysOfMonthCN;/**<   29   " */
@property (copy, nonatomic) NSString *fuShen;/**<   正西    福神" */
@property (copy, nonatomic) NSString *ji;/**<   诸事不宜     忌" */
@property (copy, nonatomic) NSString *jiShi;/**<  凶 吉 凶 凶 吉 凶 吉 吉 凶 凶 吉 凶     时辰吉凶" */
@property (copy, nonatomic) NSString *luckyColor;/**<   " */
@property (copy, nonatomic) NSString *luckyNumber;/**<   17 28 36 21 31      六合吉数" */
@property (copy, nonatomic) NSString *monthCN;/**<   十月        最右文字" */
@property (assign, nonatomic) int monthEN;/**<   11               最上月" */
@property (copy, nonatomic) NSString *riWuXing;/**<   大海水 建执位     日五行" */
@property (copy, nonatomic) NSString *weekCN;/**<   星期五" */
@property (copy, nonatomic) NSString *weekEN;/**<   Friday" */
@property (copy, nonatomic) NSString *xiShen;/**<   东南      喜神" */
@property (copy, nonatomic) NSString *yearCN;/**<   己亥      最右文字" */
@property (copy, nonatomic) NSString *yearEN;/**<  2019     年份" */
@end

@protocol UGLHLhlModel <NSObject>

@end
@interface UGLHLhlModel : UGModel <UGLHLhlModel>
@property (strong, nonatomic) UGLHLhlInfoModel *info;/**<   " */
@property (copy, nonatomic) NSString *cid;/**<   " */
@property (copy, nonatomic) NSString *date;/**<   " */
@end

NS_ASSUME_NONNULL_END
