//
//  SlideSegmentView1.h
//  C
//
//  Created by fish on 2018/4/13.
//  Copyright © 2018年 fish. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SlideSegmentBar1 : UIView

@property (nonatomic) CGFloat insetLeft;

// 回调
@property (nonatomic) CGFloat (^widthForItemAtIndex)(NSUInteger idx);
@property (nonatomic) NSString *(^titleForItemAtIndex)(NSUInteger idx);
@property (nonatomic) void (^updateCellForItemAtIndex)(UICollectionViewCell *cell, UILabel *label, NSUInteger idx);
@property (nonatomic) void (^didSelectItemAtIndexPath)(UICollectionViewCell *cell, UILabel *label, NSUInteger idx, BOOL selected);

@property (nonatomic) UIView *underlineView;                /**<    下划线 */
- (void)reloadData;                                         /**<    刷新数据 */
@end


@interface SlideSegmentView1 : UIView

@property (weak, nonatomic) IBOutlet SlideSegmentBar1 *titleBar;
@property (weak, nonatomic) IBOutlet UIScrollView *bigScrollView;
@property (nonatomic) NSMutableArray <UIScrollView *>*scrollViews;

@property (nonatomic, copy) NSArray<__kindof UIView *> *contentViews;
@property (nonatomic, copy) NSArray<__kindof UIViewController *> *viewControllers;

@property (nonatomic) NSUInteger selectedIndex;

- (void)setSelectedIndex:(NSUInteger)selectedIndex animated:(BOOL)animated;

// Block
@property (nonatomic) void (^didSelectedIndex)(NSUInteger idx);
@end
