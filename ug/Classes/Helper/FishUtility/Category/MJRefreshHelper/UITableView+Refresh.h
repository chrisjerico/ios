//
//  UITableView+Refresh.h
//  C
//
//  Created by fish on 2018/3/15.
//  Copyright © 2018年 fish. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CCSessionModel;

@interface UITableView (RefreshRequest)

@property (nonatomic, readonly) NSMutableArray *dataArray;
@property (nonatomic, readonly) UILabel *noDataTipsLabel;   /**<    无数据提示Label */
@property (nonatomic, readonly) NSInteger pageIndex;        /**<    页码 */
@property (nonatomic) NSInteger willClearDataArray;         /**<    下次mj_footer刷新时会先清空旧的dataArray数据 */
@property (nonatomic) UIView *footerView;                   /**<    使用setup函数后设置tableFooterView将无效，如需设置请使用此参数 */

- (void)setupHeaderRefreshRequest:(CCSessionModel *(^)(UITableView *tv))request completion:(NSArray *(^)(UITableView *tv, CCSessionModel *sm))completion;
- (void)setupFooterRefreshRequest:(CCSessionModel *(^)(UITableView *tv))request completion:(NSArray *(^)(UITableView *tv, CCSessionModel *sm))completion;

@end
