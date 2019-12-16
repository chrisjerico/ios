//
//  MediaViewer.m
//  C
//
//  Created by fish on 2017/11/1.
//  Copyright © 2017年 fish. All rights reserved.
//

#import "MediaViewer.h"
#import "FLAnimatedImageView.h"

@implementation MediaModel

@end


@interface MediaViewer ()<UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *pageLabel;    /**<   页码 */
@property (nonatomic) CGFloat theInitialAngleOfTheZoom;     /**<    开始缩放时手指线的角度（开始缩放时，两根手指位置形成的线条 与垂直线之间的角度） */
@property (nonatomic) BOOL isNarrowing;                     /**<    正在缩小 */
@end

@implementation MediaViewer

- (void)dealloc {
    NSLog(@"%@ dealloc", self.class);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _collectionView.allowsSelection = false;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    if (self.superview) {
        UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)_collectionView.collectionViewLayout;
        layout.itemSize = APP.Size;
        
        [_collectionView reloadData];
        [_collectionView layoutIfNeeded];
        
        self.index = _index;
        [APP.Window endEditing:true];
    }
}

- (void)setIndex:(NSUInteger)index {
    _index = index;
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:false];
    _pageLabel.text = _NSString(@"%d/%d", (int)(index+1), (int)_models.count);
}

// 进场动画
- (void)showEnterAnimations:(CGRect)rect image:(UIImage *)img {
    self.hidden = true;
    
    if (!img)
        img = [UIImage imageNamed:@"black_bg"];
    
    // 做一个进入相册的动画
    UIView *bgView = [[UIView alloc] initWithFrame:APP.Bounds];
    UIView *frameView = [[UIView alloc] initWithFrame:rect];
    UIImageView *imgView = [UIImageView new];
    
    [self.superview addSubview:({
        bgView.backgroundColor = [UIColor clearColor];
        [bgView addSubview:({
            frameView.backgroundColor = [UIColor clearColor];
            frameView.clipsToBounds = true;
            frameView.layer.masksToBounds = true;
            [frameView addSubview:({
                imgView.image = img;
                imgView.contentMode = UIViewContentModeScaleAspectFit;
                
                CGSize size = frameView.size;
                if (img.width > img.height)
                    size.width = img.width/img.height * size.height;
                else
                    size.height = img.height/img.width * size.width;
                
                imgView.frame = CGRectMake(0, 0, size.width, size.height);
                imgView.center = CGPointMake(frameView.width/2, frameView.height/2);
                imgView;
            })];
            frameView;
        })];
        bgView;
    })];
    
    [UIView animateWithDuration:0.25 animations:^{
        bgView.backgroundColor = [UIColor blackColor];
        frameView.frame = APP.Bounds;
        imgView.frame = APP.Bounds;
    } completion:^(BOOL finished) {
        [bgView removeFromSuperview];
        self.hidden = false;
    }];
}

// 缩放退场动画
- (void)showExitAnimations1:(CGRect)rect {
    self.hidden = true;
    
    
    
    // 当前浏览的图片ImageView
    UICollectionViewCell *cell = [_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:_index inSection:0]];
    UIImageView *_imgV = [cell viewWithTagString:@"ImageView"];
    UIImage *img = _imgV.image;
    if (!img) {
        img = [(UIImageView *)[_imgV viewWithTagString:@"thumbImageView"] image];
        if (!img)
            img = [UIImage imageNamed:@"black_bg"];
    }
    
    // 初始化动画所需的临时View
    UIView *bgView = [[UIView alloc] initWithFrame:self.frame];
    UIView *frameView = [UIView new];
    UIImageView *imgView = [UIImageView new];
    
    [self.superview addSubview:({
        bgView.backgroundColor = self.backgroundColor;
        [bgView addSubview:({
            frameView.backgroundColor = [UIColor clearColor];
            frameView.clipsToBounds = true;
            frameView.layer.masksToBounds = true;
            frameView.size = CGSizeMake(self.width, img.height/img.width * self.width);
            frameView.center = _imgV.center;
            
            [frameView addSubview:({
                imgView.frame = frameView.bounds;
                imgView.image = img;
                imgView.contentMode = UIViewContentModeScaleAspectFit;
                imgView.transform = _imgV.transform;
                imgView;
            })];
            frameView;
        })];
        bgView;
    })];
    
    [UIView animateWithDuration:0.25 animations:^{
        bgView.backgroundColor = [UIColor clearColor];
        frameView.frame = rect;
        
        CGFloat scale = rect.size.width/self.width;
        if (img.height < img.width) {
            scale *= rect.size.height/(imgView.height * scale);
        }
        imgView.transform = CGAffineTransformScale(CGAffineTransformIdentity, scale, scale);
        
        imgView.center = CGPointMake(frameView.width/2, frameView.height/2);
        imgView.alpha = 0.8;
    } completion:^(BOOL finished) {
        [bgView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

// 淡出退场动画
- (void)showExitAnimations2 {
    [UIView animateWithDuration:0.45 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)exit {
    // 做退场动画，并退出
    if (_exitAnimationsBlock) {
        CGRect rect = _exitAnimationsBlock(self);
        if (!CGRectEqualToRect(rect, CGRectZero)) {
            [self showExitAnimations1:rect];
            return ;
        }
    }
    [self showExitAnimations2];
}

- (void)refreshData:(NSArray <MediaModel *>*)models index:(NSUInteger)index {
    _models = models;
    [_collectionView reloadData];
    [_collectionView layoutIfNeeded];
    
    self.index = index;
}


#pragma mark - About UICollectionView Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _models.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (!cell)
        cell = [UICollectionViewCell new];
    cell.backgroundColor = [UIColor clearColor];
    
    
    UIScrollView *scrollView = [cell viewWithTagString:@"ScrollView" ];
    if (!scrollView) {
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, collectionView.width, collectionView.height)];
        scrollView.maximumZoomScale = 10;
        scrollView.minimumZoomScale = 0;
        scrollView.zoomScale = 1;
        scrollView.bouncesZoom = false;
        scrollView.showsVerticalScrollIndicator = false;
        scrollView.showsHorizontalScrollIndicator = false;
        scrollView.tagString = @"ScrollView";
        scrollView.delegate = self;
        scrollView.panGestureRecognizer.enabled = false;
        if (@available(iOS 11.0, *)) {
            scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [cell addSubview:scrollView];
    }
    
    FLAnimatedImageView *imgView = [cell viewWithTagString:@"ImageView"];
    if (!imgView) {
        imgView = [[FLAnimatedImageView alloc] initWithFrame:scrollView.bounds];
        imgView.runLoopMode = NSDefaultRunLoopMode;
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        imgView.tagString = @"ImageView";
        imgView.userInteractionEnabled = true;
        [scrollView addSubview:imgView];
        
        // 添加点击手势✋
        __weakSelf_(__self);
        UITapGestureRecognizer *singleTap = nil;
        [imgView addGestureRecognizer:singleTap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id gr) {
            // 退出
            [__self exit];
        }]];
        
        // 双击手势
        [imgView addGestureRecognizer:({
            UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id gr) {
                CGFloat scale = scrollView.zoomScale < 1.5 ? 3:1;
                [__self scrollViewDidEndZooming:scrollView withView:imgView atScale:scale];
            }];
            [singleTap requireGestureRecognizerToFail:doubleTap];   // 当检测不到双击手势时执行再识别单击手势
            doubleTap.numberOfTapsRequired = 2;
            doubleTap;
        })];
        
        // 长按手势
        __weak_Obj_(imgView, __imgView);
        [imgView addGestureRecognizer:({
            __weak_Obj_(cell, __cell);
            UILongPressGestureRecognizer *longPress = [UILongPressGestureRecognizer gestureRecognizer:^(id gr) {
                if (![__cell viewWithTagString:@"thumbImageView"].hidden)
                    return ;
                
                UIAlertController *ac = [AlertHelper showActionSheet:nil msg:nil btnTitles:@[@"保存图片"] cancel:@"取消"];
                [ac setActionAtTitle:@"保存图片" handler:^(UIAlertAction *aa) {
                    UIImageWriteToSavedPhotosAlbum(__imgView.image, __self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
                }];
            }];
            longPress.minimumPressDuration = 0.3;
            longPress;
        })];
        
        // 添加拖拽手势✋
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPan:)];
        pan.delegate = self;
        [imgView addGestureRecognizer:pan];
    }
    
    UIImageView *thumbImgView = [cell viewWithTagString:@"thumbImageView"];
    if (!thumbImgView) {
        thumbImgView = [[UIImageView alloc] initWithFrame:scrollView.bounds];
        thumbImgView.contentMode = UIViewContentModeScaleAspectFit;
        thumbImgView.tagString = @"thumbImageView";
        [imgView addSubview:thumbImgView];
        
        [imgView aspect_hookSelector:@selector(setFrame:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aInfo) {
            UIImageView *imgView = aInfo.instance;
            [imgView viewWithTagString:@"thumbImageView"].frame = imgView.bounds;
            [imgView viewWithTagString:@"playerView"].frame = imgView.bounds;
        } error:nil];
    }
    
    // 加载图片
    {
        MediaModel *mm = _models[indexPath.item];
        [thumbImgView sd_setImageWithURL:mm.thumbUrl placeholderImage:[UIImage imageNamed:@"black_bg"]];
        
        // 如果已经
        if (mm.img) {
            [imgView sd_setImageWithURL:nil];
            imgView.image = mm.img;
            thumbImgView.hidden = true;
        } else {
            thumbImgView.hidden = false;
            [imgView sd_setImageWithURL:mm.imgUrl completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                thumbImgView.hidden = true;
                if (error) {
                    imgView.image = [UIImage imageNamed:@"err"];
                }
            }];
        }
    }
    return cell;
}

// 还原缩放比例
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    UIScrollView *sv = [cell viewWithTagString:@"ScrollView"];
    UIImageView *imgView = [cell viewWithTagString:@"ImageView"];
    [self scrollViewDidEndZooming:sv withView:imgView atScale:1];
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (scrollView != _collectionView)
        return;
    
    NSInteger index = _index = targetContentOffset->x/scrollView.width;
    _pageLabel.text = _NSString(@"%d/%d", (int)(index+1), (int)_models.count);
}

// 指定缩放的View为：ImageView
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return [scrollView viewWithTagString:@"ImageView"];
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
    // 保存初始角度
    view = scrollView.pinchGestureRecognizer.view;
    CGPoint p1 = [scrollView.pinchGestureRecognizer locationOfTouch:0 inView:view];
    CGPoint p2 = [scrollView.pinchGestureRecognizer locationOfTouch:1 inView:view];
    _theInitialAngleOfTheZoom = atan2(p2.y-p1.y, p2.x-p1.x);
}

// 在缩放时修改图片的中心点
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    if (scrollView.pinchGestureRecognizer.numberOfTouches < 2)
        return;
    
    // 若ScrollView 的 contentSize < scrollview.size，则表示缩小、否则表示放大
    // 缩小时，图片始终在两根手指的中心位置，且跟随手指角度旋转
    if (_isNarrowing || (scrollView.width > scrollView.contentSize.width || scrollView.height > scrollView.contentSize.height)) {
        _isNarrowing = true;
        
        // 获取手指两个点位置
        UIView *view = scrollView.pinchGestureRecognizer.view;
        CGPoint p1 = [scrollView.pinchGestureRecognizer locationOfTouch:0 inView:view];
        CGPoint p2 = [scrollView.pinchGestureRecognizer locationOfTouch:1 inView:view];
        
        UIImageView *imgView = [scrollView viewWithTagString:@"ImageView"];
        
        // 计算中心点
        {
            // 计算两个点的中心点
            CGPoint touchCenter = CGPointMake(fabs(p1.x-p2.x)/2 + MIN(p1.x, p2.x), fabs(p1.y-p2.y)/2 + MIN(p1.y, p2.y));
            // 减去scrollView的中心点，获得offset
            CGPoint touchOffset = CGPointMake(touchCenter.x - scrollView.width/2, touchCenter.y - scrollView.height/2);
            
            //
            CGPoint contentSizeOffset = CGPointMake(contentSizeOffset.x = (scrollView.width-scrollView.contentSize.width)/2,
                                                    contentSizeOffset.y = (scrollView.height-scrollView.contentSize.height)/2);
            
            // 添加偏移量
            CGPoint center = CGPointMake(scrollView.contentSize.width/2, scrollView.contentSize.height/2);
            center.x += touchOffset.x + contentSizeOffset.x;
            center.y += touchOffset.y + contentSizeOffset.y;
            
            imgView.center = center;
        }
        
        // 计算旋转角度
        {
            CGFloat currentAngleOfTheZoom = atan2(p2.y-p1.y, p2.x-p1.x);
            CGFloat angle = currentAngleOfTheZoom - _theInitialAngleOfTheZoom;
            imgView.transform = CGAffineTransformRotate(imgView.transform, angle);
        }
        
        // 改变背景色
        CGFloat alpha = (fabs(scrollView.zoomScale) - 0.3) / 0.7;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:alpha];
    } else {
        // 放大
        [scrollView viewWithTagString:@"ImageView"].center = CGPointMake(scrollView.contentSize.width/2, scrollView.contentSize.height/2);
    }
}

// 缩放结束后，做回弹动画，或退场动画
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    scale = fabs(scale);
    
    // 退出
    if (scale < 0.9)  {
        [self exit];
        return;
    }
    
    // 做回弹动画
    if (_isNarrowing || scale < 1) {
        _isNarrowing = false;
        scale = 1;
    }
    
    // 最大缩放倍数
    if (scale > 3)
        scale = 3;
    
    
    UIImageView *imgView = [scrollView viewWithTagString:@"ImageView"];
    [UIView animateWithDuration:0.15 animations:^{
        // 回弹动画
        {
            self.backgroundColor = [UIColor blackColor];
            scrollView.zoomScale = scale;
            imgView.center = CGPointMake(scrollView.contentSize.width/2, scrollView.contentSize.height/2);
        }
        
        // 若当前处于放大状态，则更新contentSize为图片大小，并修正contentOffset
        if (scrollView.width < scrollView.contentSize.width || scrollView.height < scrollView.contentSize.height) {
            UIImage *img = imgView.image;
            if (!img) {
                img = [(UIImageView *)[imgView viewWithTagString:@"thumbImageView"] image];
                if (!img)
                    img = [UIImage imageNamed:@"black_bg"];
            }
            
            CGFloat w=1, h=1;
            if (img.width/img.height > self.width/self.height) {
                w = imgView.width;
                h = MAX(scrollView.height, imgView.width * (img.height/img.width));
            } else {
                h = imgView.height;
                w = MAX(scrollView.width, imgView.height * (img.width/img.height));
            }
            
            CGFloat offsetY = scrollView.contentOffset.y;
            if (offsetY > h - scrollView.height)
                offsetY = h - scrollView.height;
            else if (scrollView.contentSize.height > h)
                offsetY -= (scrollView.contentSize.height - h) / 2;
            
            scrollView.contentSize = CGSizeMake(w, h);
            scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, offsetY);
            
            imgView.center = CGPointMake(w/2, h/2);
        }
    } completion:^(BOOL finished) {
        NSLog(@"%@", NSStringFromCGRect(imgView.frame));
    }];
}

#pragma mark - UIGestureRecognizerDelegate

// 只有当图片未缩放，且往下滑动时才触发拖拽手势✋
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    UIScrollView *scrollView = (UIScrollView *)gestureRecognizer.view.superview;
    if (scrollView.width < scrollView.contentSize.width || scrollView.height < scrollView.contentSize.height)
        return false;
    
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    if (translation.y > 0)
        return true;
    return false;
}

// 往下拖拽时的动画效果：图片跟着手指移动并缩小，背景透明度降低
- (void)onPan:(UIPanGestureRecognizer *)gr {
//    NSLog(@"触发手势 %@", gr);
    UIScrollView *scrollView = (UIScrollView *)gr.view.superview;
    
    
    // 手势进行时，做图片的拖拽缩放、背景渐变动画
    CGFloat (^getScale)(CGFloat centerY) = ^CGFloat (CGFloat centerY) {
        CGFloat offsetY = gr.view.center.y-scrollView.height/2;
        if (offsetY < 0)
            return 1.0;
        if (offsetY > scrollView.height/2)
            return 0.0;
        
        return 1 - (offsetY / (scrollView.height/2));
    };
    CGFloat zoomScale = getScale(gr.view.center.y) * 0.3 + 0.7;
    
    // 图片中心点跟随手指移动
    CGPoint center = ({
        CGPoint pt = [gr translationInView:gr.view];
        pt.x *= zoomScale;
        pt.y *= zoomScale;
        CGPointMake(scrollView.width/2 + pt.x , scrollView.height/2 + pt.y);
    });
    
    CGFloat scale = getScale(center.y);
    CGFloat alpha = (scale - 0.3) / 0.7;
    
    zoomScale = scale * 0.3 + 0.7;
    
    gr.view.center = center;
    gr.view.transform = CGAffineTransformMakeScale(zoomScale, zoomScale);
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:alpha];
    
    
    // 手势结束时
    if (gr.state == UIGestureRecognizerStateEnded) {
        BOOL willExit = gr.view.center.y/scrollView.height > 0.6;
        if (willExit) {
            // 退出
            [self exit];
            return;
        }
        
        // 还原拖拽的动画效果
        [UIView animateWithDuration:0.2 animations:^{
            gr.view.center = CGPointMake(scrollView.width/2, scrollView.height/2);
            gr.view.transform = CGAffineTransformIdentity;
            self.backgroundColor = [UIColor blackColor];
        }];
        return ;
    }
}


#pragma mark - UIImageWriteToSavedPhotosAlbum

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        [SVProgressHUD showErrorWithStatus:@"保存失败，请检查是否已开启照片写入权限"];
    } else {
        [SVProgressHUD showSuccessWithStatus:@"保存成功"];
    }
}

@end
