//
//  SlideSegmentView2.h
//  MediaViewer
//
//  Created by fish on 2018/1/6.
//  Copyright © 2018年 fish. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SlideSegmentBar2 : UIView

@property (nonatomic) CGFloat insetVertical;    /**<   首部、尾部边距 */

@property (nonatomic, assign) CGFloat barHeight;

@property (nonatomic, strong) UIColor *underlineColor;  /**<    下划线颜色 */
@property (nonatomic, strong) CGRect (^underlineFrameForItemAtIndex)(CGSize cellSize, CGFloat labelWidth, NSUInteger idx);
@property (nonatomic, strong) void (^updateCellForItemAtIndex)(SlideSegmentBar2 *titleBar, UICollectionViewCell *cell, UILabel *label, NSUInteger idx, BOOL selected); // 配置Cell样式

@property (nonatomic, strong) CGFloat (^widthForItemAtIndex)(NSUInteger idx);
- (void)cellWidthAdaptiveTitleWithFontSize:(CGFloat)fontSize space:(CGFloat)space;  /**<   根据标题自适应Cell宽度 */

- (void)reloadData; /**<    刷新数据 */
@end


@interface SlideSegmentView2 : UIView

@property (nonatomic) UIView *headerView;                   /**<    default is nil */
@property (nonatomic) NSUInteger selectedIndex;
@property (nonatomic) void (^didSelectedIndexChange)(SlideSegmentView2 *ssv2, NSUInteger idx);    //选中回调

- (void)setupTitles:(NSArray <NSString *>*)titles contents:(NSArray *)viewsOrViewControllers;
- (void)setSelectedIndex:(NSUInteger)selectedIndex animated:(BOOL)animated;


// Readonly
@property (nonatomic, readonly) SlideSegmentBar2 *titleBar;
@property (nonatomic, readonly) UIScrollView *bigScrollView;
@property (nonatomic, readonly) NSMutableArray <UIScrollView *>*scrollViews;
@property (nonatomic, readonly) NSArray<__kindof UIView *> *contentViews;
@property (nonatomic, readonly) NSArray<__kindof UIViewController *> *viewControllers;

@end
