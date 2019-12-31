//
//  MediaViewer.h
//  C
//
//  Created by fish on 2017/11/1.
//  Copyright © 2017年 fish. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MediaModel : NSObject
@property (nonatomic) UIImage *img;
@property (nonatomic) NSURL *imgUrl;
@property (nonatomic) NSURL *thumbUrl;
@end


// 媒体查看器（图片、视频）
@interface MediaViewer : UIView

@property (nonatomic) NSArray <MediaModel *>*models;    /**<    媒体Model */
@property (nonatomic) NSUInteger index;                 /**<    当前浏览第index张图片 */

@property (nonatomic) CGRect (^exitAnimationsBlock)(MediaViewer *mv); /**<    即将退出，返回CGRectZero则执行动画2 */

- (void)showEnterAnimations:(CGRect)rect image:(UIImage *)img;  /**<    显示入场动画 */
- (void)showExitAnimations1:(CGRect)rect;                       /**<    退场动画 - 缩放至rect位置 */
- (void)showExitAnimations2;                                    /**<    退场动画 - 淡出 */
- (void)exit;


- (void)refreshData:(NSArray <MediaModel *>*)models index:(NSUInteger)index; /**<    切换数据源 */
@end
