//
//  UGbetModel.h
//  ug
//
//  Created by ug on 2019/10/18.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol UGbetListModel <NSObject>

@end
@interface UGbetListModel : UGModel<UGbetListModel>
@property (nonatomic, strong) NSString *betMoney;   /**<   下注金额*/
@property (nonatomic, strong) NSString *index;   /**<  索引*/
@property (nonatomic, strong) NSString *name;   /**<   鼠,牛 */
@property (nonatomic, strong) NSString *odds;   /**<   赔率*/
@end

@protocol UGbetParamModel <NSObject>

@end
@interface UGbetParamModel : UGModel<UGbetParamModel>
@property (nonatomic, strong) NSString *money;   /**<   下注金额*/
@property (nonatomic, strong) NSString *name;   /**<   鼠,牛*/
@property (nonatomic, strong) NSString *odds;   /**<   赔率*/
@property (nonatomic, strong) NSString *playId;   /**<   */
@end


@protocol UGplayNameModel <NSObject>

@end
@interface UGplayNameModel : UGModel<UGplayNameModel>
@property (nonatomic, strong) NSString *playName1;   /**<   二连肖-鼠,牛*/
@property (nonatomic, strong) NSString *playName2;   /**<   鼠,牛*/


@end


@interface UGbetModel : UGModel
@property (nonatomic, strong) NSString *gameName;    /**<   游戏名称*/
@property (nonatomic, strong) NSString *gameId;      /**<   游戏id*/
@property (nonatomic, strong) NSString *code;        /**<   游戏icode  */
@property (nonatomic, strong) NSString *ftime;       /**<   当期期封盘时间  时间挫*/

@property (nonatomic, assign) BOOL specialPlay;
@property (nonatomic, strong) NSString *totalMoney;     /**<   下注金额*/
@property (nonatomic, strong) NSString *totalNums;      /**<   下注数量*/
@property (nonatomic, strong) NSString *turnNum;        /**<   当前期号*/
@property (nonatomic, strong) NSArray<UGbetParamModel> *betParams;
@property (nonatomic, strong) NSArray<UGplayNameModel> *playNameArray;
@end

NS_ASSUME_NONNULL_END
