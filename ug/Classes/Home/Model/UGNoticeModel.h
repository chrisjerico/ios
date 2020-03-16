//
//  UGNoticeModel.h
//  ug
//
//  Created by ug on 2019/6/23.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol UGNoticeModel <NSObject>

@end
// 网站公告
// {{LOCAL_HOST}}?c=notice&a=latest
@interface UGNoticeModel : UGModel<UGNoticeModel>
@property (nonatomic, strong) NSString *noticeId;   /**<   公告id */
@property (nonatomic, strong) NSString *title;      /**<   公告标题 */
@property (nonatomic, assign) NSInteger nodeId;     /**<   公告类型：1=滚动，2=弹窗 */
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSString *content;    /**<   公告内容 */
@property (nonatomic, strong) NSString *channel;
@property (nonatomic, strong) NSString *addTime;    /**<   添加时间 */
@property (nonatomic, strong) NSString *updateTime;

@property (nonatomic, assign) BOOL hiddenBottomLine;

// 自定义参数
@property (nonatomic) NSAttributedString *attrString;
@property (nonatomic, assign) CGFloat cellHeight;
@end


@interface UGNoticeTypeModel : UGModel

@property (nonatomic, strong) NSArray<UGNoticeModel> *popup;    /**<   弹窗公告 */
@property (nonatomic, strong) NSArray<UGNoticeModel> *scroll;   /**<   滚动公告 */

@end

NS_ASSUME_NONNULL_END
