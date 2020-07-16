//
//  UGBMHeaderView.h
//  ug
//
//  Created by ug on 2019/10/30.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UUMarqueeView.h"
#import "UGNoticeModel.h"
#import "UGYYRightMenuView.h"
#import "UGNoticeTypeModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface UGBMHeaderView : UIView

@property (weak, nonatomic) IBOutlet UUMarqueeView *leftwardMarqueeView;    /**<   滚动公告 */
@property (nonatomic, strong) NSMutableArray <NSString *> *leftwardMarqueeViewData;      /**<   公告数据 */
@property (nonatomic, strong) UGNoticeTypeModel *noticeTypeModel;   /**<   公告提示数据 */
@property (nonatomic, strong) UGYYRightMenuView *yymenuView;   /**<   侧边栏 */
-(instancetype)initView;
@end

NS_ASSUME_NONNULL_END
