//
//  UGLHCategoryListModel.h
//  ug
//
//  Created by ug on 2019/11/26.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol UGLHCategoryListModel <NSObject>

@end

// 《栏目列表》
// c=lhcdoc&a=categoryList
@interface UGLHCategoryListModel : UGModel
@property (copy, nonatomic) NSString *icon;/**<   展示图" */
@property (copy, nonatomic) NSString *alias;/**<   栏目别名" */
@property (copy, nonatomic) NSString *cid;/**<   栏目ID" */
@property (copy, nonatomic) NSString *isHot;/**<   是否热门 1是 0否" */
@property (copy, nonatomic) NSString *link;/**<   跳转链接地址，有值，则跳转至设置的地址" */
@property (copy, nonatomic) NSString *name;/**<  栏目名称" */
@property (copy, nonatomic) NSString *desc;/**<  栏目简介" */
@property (nonatomic, assign) NSInteger appLinkCode;/**<   1存取款 2APP下载 3聊天室 4在线客服 5长龙助手 6推广收益 7开奖网 8利息宝 9优惠活动 10游戏记录 11QQ客服 13任务大厅 14站内信 15站内信 16投诉中心 */
@end

NS_ASSUME_NONNULL_END
