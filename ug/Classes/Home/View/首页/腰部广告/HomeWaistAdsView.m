//
//  HomeWaistAdsView.m
//  UGBWApp
//
//  Created by fish on 2020/10/21.
//  Copyright © 2020 ug. All rights reserved.
//

#import "HomeWaistAdsView.h"
#import "SDCycleScrollView.h"

#import "UGhomeAdsModel.h"

@interface HomeWaistAdsView ()<SDCycleScrollViewDelegate>
@property (nonatomic, strong) NSArray <UGhomeAdsModel *> *homeAdsArray;   /**<   首页广告图片 */
@property (weak, nonatomic) IBOutlet UIView *homeAdsBgView;                  /**<   首页腰部广告图片背景View */
@property (nonatomic, strong) SDCycleScrollView *homeAdsView;                /**<   首页腰部广告图片View */
@end

@implementation HomeWaistAdsView

- (void)awakeFromNib {
    [super awakeFromNib];
    if (APP.isCornerRadius) {
        //只需要设置layer层的两个属性
        //设置圆角
        _homeAdsView.layer.cornerRadius =10;
        //将多余的部分切掉
        _homeAdsView.layer.masksToBounds = YES;
    }
    
    
    self.homeAdsView =  [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, UGScreenW-20, 250/1000.0 * (APP.Width-20)) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    self.homeAdsView.backgroundColor = [UIColor clearColor];
    self.homeAdsView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    self.homeAdsView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    if ([@"c018,c217" containsString:APP.SiteId]) {
            self.homeAdsView.autoScrollTimeInterval = 5.0;
    } else {
            self.homeAdsView.autoScrollTimeInterval = 3.0;
    }
    

    self.homeAdsView.delegate = self;
    self.homeAdsView.pageDotColor = RGBA(210, 210, 210, 0.4);
    [self.homeAdsBgView insertSubview:self.homeAdsView atIndex:0];
    
}


//首页广告图片
- (void)reloadData:(void (^)(BOOL succ))completion {
    [SVProgressHUD showWithStatus: nil];
    WeakSelf;
    [CMNetwork systemhomeAdsWithParams:@{} completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // 需要在主线程执行的代码
                [SVProgressHUD dismiss];
                weakSelf.homeAdsArray = model.data;
                
                NSMutableArray *mutArr = [NSMutableArray array];
                if (weakSelf.homeAdsArray.count) {
                    [weakSelf setHidden:NO];
                    for (UGhomeAdsModel *banner in self.homeAdsArray) {
                            [mutArr addObject:banner.image];
                    }

                    NSLog(@"SysConf.adSliderTimer = %d",SysConf.adSliderTimer);
                    weakSelf.homeAdsView.imageURLStringsGroup = mutArr.mutableCopy;
                    weakSelf.homeAdsView.autoScrollTimeInterval = SysConf.adSliderTimer;
                    if (mutArr.count>1) {
                        weakSelf.homeAdsView.autoScroll = YES;
                    } else {
                         weakSelf.homeAdsView.autoScroll = NO;
                    }
                }
                else{
                    [weakSelf setHidden:YES];
                }
            });
            if (completion)
                completion(true);
        } failure:^(id msg) {
            [SVProgressHUD showErrorWithStatus:msg];
            [weakSelf setHidden:YES];
            if (completion)
                completion(false);
        }];
    }];
}


#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    UGhomeAdsModel *banner = self.homeAdsArray[index];
    BOOL ret = [NavController1 pushViewControllerWithLinkCategory:[banner.linkCategory integerValue] linkPosition:[banner.linkPosition integerValue]];
}

@end
