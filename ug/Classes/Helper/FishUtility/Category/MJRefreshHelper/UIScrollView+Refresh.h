//
//  UITableView+Refresh.h
//  C
//
//  Created by fish on 2018/3/15.
//  Copyright © 2018年 fish. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CCSessionModel;

@interface UIScrollView (RefreshRequest)

@property (nonatomic, readonly) NSMutableArray *dataArray;
@property (nonatomic, readonly) UILabel *noDataTipsLabel;   /**<    无数据提示Label */
@property (nonatomic, readonly) NSInteger pageIndex;        /**<    页码 */
@property (nonatomic) NSInteger willClearDataArray;         /**<    下次mj_footer刷新时会先清空旧的dataArray数据 */

- (void)setupHeaderRefreshRequest:(CCSessionModel *(^)(__kindof UIScrollView *tv))request completion:(NSArray *(^)(__kindof UIScrollView *tv, CCSessionModel *sm))completion;
- (void)setupFooterRefreshRequest:(CCSessionModel *(^)(__kindof UIScrollView *tv))request completion:(NSArray *(^)(__kindof UIScrollView *tv, CCSessionModel *sm))completion;

@end
