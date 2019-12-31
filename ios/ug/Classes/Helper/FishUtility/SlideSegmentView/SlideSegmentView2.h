//
//  SlideSegmentView2.h
//  MediaViewer
//
//  Created by fish on 2018/1/6.
//  Copyright © 2018年 fish. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SlideSegmentBar2 : UIView

// 回调
@property (nonatomic) CGFloat (^widthForItemAtIndex)(NSUInteger idx);
@property (nonatomic) NSString *(^titleForItemAtIndex)(NSUInteger idx);
@property (nonatomic) void (^updateCellForItemAtIndex)(UICollectionViewCell *cell, UILabel *label, NSUInteger idx);
@property (nonatomic) void (^didSelectItemAtIndexPath)(UICollectionViewCell *cell, UILabel *label, BOOL selected);

@property (nonatomic) UIView *underlineView;                /**<    下划线 */

- (void)reloadData;                                         /**<    刷新数据 */
@end


@interface SlideSegmentView2 : UIView

@property (nonatomic) UIView *headerView;                   /**<    default is nil */
@property (nonatomic, readonly) SlideSegmentBar2 *titleBar;

@property (nonatomic, copy) NSArray<__kindof UIView *> *contentViews;
@property (nonatomic, copy) NSArray<__kindof UIViewController *> *viewControllers;

@property (nonatomic) NSUInteger selectedIndex;

- (void)setSelectedIndex:(NSUInteger)selectedIndex animated:(BOOL)animated;

@property (nonatomic) void (^didSelectedIndex)(NSUInteger idx);
@end
