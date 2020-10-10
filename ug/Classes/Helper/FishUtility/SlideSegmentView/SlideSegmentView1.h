//
//  SlideSegmentView1.h
//  C
//
//  Created by fish on 2018/4/13.
//  Copyright © 2018年 fish. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SlideSegmentBar1 : UIView

@property (nonatomic) CGFloat insetVertical;    /**<   首部、尾部边距 */

@property (nonatomic, assign) CGFloat barHeight;

@property (nonatomic, strong) UIColor *underlineColor;  /**<    下划线颜色 */
@property (nonatomic, strong) CGRect (^underlineFrameForItemAtIndex)(NSUInteger idx, CGFloat titleWidth, CGFloat cellWidth, CGFloat cellHeight);
@property (nonatomic, strong) void (^updateCellForItemAtIndex)(SlideSegmentBar1 *titleBar, UICollectionViewCell *cell, UILabel *label, NSUInteger idx, BOOL selected); // 配置Cell样式

@property (nonatomic, strong) CGFloat (^widthForItemAtIndex)(NSUInteger idx);
- (void)cellWidthAdaptiveTitleWithFontSize:(CGFloat)fontSize space:(CGFloat)space;  /**<   根据标题自适应Cell宽度 */

- (void)reloadData; /**<    刷新数据 */
@end


@interface SlideSegmentView1 : UIView

@property (nonatomic, assign) NSUInteger selectedIndex;
@property (nonatomic, strong) void (^didSelectedIndexChange)(SlideSegmentView1 *ssv1, NSUInteger idx); //选中回调

- (void)setupTitles:(NSArray <NSString *>*)titles contents:(NSArray *)viewsOrViewControllers;
- (void)setSelectedIndex:(NSUInteger)selectedIndex animated:(BOOL)animated;


// Readonly
@property (nonatomic, readonly) IBOutlet SlideSegmentBar1 *titleBar;
@property (nonatomic, readonly) IBOutlet UIScrollView *bigScrollView;
@property (nonatomic, readonly) NSMutableArray <UIScrollView *>*scrollViews;
@property (nonatomic, readonly) NSArray<__kindof UIView *> *contentViews;
@property (nonatomic, readonly) NSArray<__kindof UIViewController *> *viewControllers;

@end
