//
//  HomeBannerView.m
//  UGBWApp
//
//  Created by fish on 2020/10/21.
//  Copyright © 2020 ug. All rights reserved.
//

#import "HomeBannerView.h"
#import "SDCycleScrollView.h"

#import "SLWebViewController.h"

#import "UGBannerModel.h"
#import "UGonlineCount.h"

@interface HomeBannerView ()<SDCycleScrollViewDelegate>
@property (nonatomic, strong) UILabel *nolineLabel;             /**<   在线人数Label */
@property (nonatomic, strong) UGonlineCount *mUGonlineCount;    /**<   在线人数数据 */

@property (nonatomic, strong) SDCycleScrollView *bannerView;                /**<   横幅View */
@property (nonatomic, strong) NSArray <UGBannerCellModel *> *bannerArray;   /**<   横幅数据 */
@end

@implementation HomeBannerView

- (void)awakeFromNib {
    [super awakeFromNib];
    //    self.bannerView =  [SDCycleScrollView cycleScrollViewWithFrame:self.bannerBgView.bounds delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.bannerView =  [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, UGScreenW, 280/640.0 * APP.Width) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.bannerView.backgroundColor = [UIColor clearColor];
    self.bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    self.bannerView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.bannerView.autoScrollTimeInterval = 3.0;
    self.bannerView.delegate = self;
    self.bannerView.pageDotColor = RGBA(210, 210, 210, 0.4);
    [self addSubview:self.bannerView];
    
    
    if (self.nolineLabel == nil) {
        UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(UGScreenW-140, 10, 140, 30)];
        text.backgroundColor = RGBA(27, 38, 116,0.5);
        text.textColor = [UIColor whiteColor];
        text.font = [UIFont systemFontOfSize:12];
        text.numberOfLines = 1;
        text.text = @"当前在线人数:10000";
        text.textAlignment= NSTextAlignmentCenter;
        text.layer.cornerRadius = 15;
        text.layer.masksToBounds = YES;
        text.hidden = true;
        [self addSubview:(_nolineLabel = text)];
    }
}


//查询轮播图
- (void)reloadData:(void (^)(BOOL succ))completion {
    [self systemOnlineCount];
    
    WeakSelf;
    [CMNetwork getBannerListWithParams:@{} completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // 需要在主线程执行的代码
                weakSelf.bannerArray = ((UGBannerModel*)model.data).list;
                NSMutableArray *mutArr = [NSMutableArray array];
                if (weakSelf.bannerArray.count) {
                    for (UGBannerCellModel *banner in self.bannerArray) {
                        [mutArr addObject:banner.pic];
                    }
                    weakSelf.bannerView.imageURLStringsGroup = mutArr.mutableCopy;
                    NSLog(@"轮播时间：%f",((UGBannerModel*)model.data).interval.floatValue);
                    weakSelf.bannerView.autoScrollTimeInterval = ((UGBannerModel*)model.data).interval.floatValue;
                    if (mutArr.count>1) {
                        weakSelf.bannerView.autoScroll = YES;
                    } else {
                         weakSelf.bannerView.autoScroll = NO;
                    }
                }
            });
            if (completion)
                completion(true);
        } failure:^(id msg) {
            [SVProgressHUD showErrorWithStatus:msg];
            if (completion)
                completion(false);
        }];
    }];
}

// APP在线人数
- (void)systemOnlineCount {
    WeakSelf;
    [CMNetwork systemOnlineCountWithParams:@{} completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                // 需要在主线程执行的代码
                
                weakSelf.mUGonlineCount = model.data;
                
                int intOnlineSwitch = [weakSelf.mUGonlineCount.onlineSwitch intValue];
                
                if (intOnlineSwitch == 1) {
                    [weakSelf.nolineLabel setHidden:NO];
                    [weakSelf.nolineLabel setText:[NSString stringWithFormat:@"当前在线人数：%@",self.mUGonlineCount.onlineUserCount]];
                } else {
                    [weakSelf.nolineLabel setHidden:YES];
                }
                
            });
            
        } failure:^(id msg) {
            
        }];
    }];
}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    UGBannerCellModel *banner = self.bannerArray[index];
    BOOL ret = [NavController1 pushViewControllerWithLinkCategory:banner.linkCategory linkPosition:banner.linkPosition];
    if (!ret) {
        if ([banner.url containsString:@"mobile"]) {
            // 若跳转地址包含mobile则不做跳转
            return;
        }
        // 去外部链接
        if ([banner.url stringByReplacingOccurrencesOfString:@" " withString:@""].length) {
            NSLog(@"url = %@",banner.url );
            //            if ([banner.url hasPrefix:@"http"]) {
            if ([banner.url isURL]) {
                SLWebViewController *webVC = [[SLWebViewController alloc] init];
                webVC.urlStr = banner.url;
                [NavController1 pushViewController:webVC animated:YES];
            }
        }
    }
}


@end
