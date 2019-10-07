//
//  UGPromoteModel.h
//  ug
//
//  Created by ug on 2019/6/23.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol UGPromoteModel <NSObject>


@end

// 优惠活动Model
@interface UGPromoteModel : UGModel<UGPromoteModel>
@property (nonatomic, strong) NSString *promoteId;  /**<   优惠ID */
@property (nonatomic, strong) NSString *pic;        /**<   优惠图片 */
@property (nonatomic, strong) NSString *title;      /**<   优惠标题 */
@property (nonatomic, strong) NSString *content;    /**<   优惠内容 */
@property (nonatomic, assign) NSInteger category;   /**<   优惠分类:0=未分类;1=综合活动;2=棋牌活动;3=视讯活动;4=体育活动;5=电子活动;6=捕鱼活动 */

@end


// 优惠活动列表Model
@interface UGPromoteListModel : UGModel

@property (nonatomic, strong) NSString *style;      /**<   优惠图片样式。slide=折叠式,popup=弹窗式 */
@property (nonatomic, strong) NSArray<UGPromoteModel> *list;



@end

NS_ASSUME_NONNULL_END
