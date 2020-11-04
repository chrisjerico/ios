//
//  HomeRankingView.m
//  UGBWApp
//
//  Created by fish on 2020/10/16.
//  Copyright © 2020 ug. All rights reserved.
//

#import "HomeRankingView.h"
#import "UUMarqueeView.h"

#import "UGRankModel.h"


@interface HomeRankingView ()<UUMarqueeViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;                    /**<   中奖排行标题Label */
@property (weak, nonatomic) IBOutlet UUMarqueeView *upwardMultiMarqueeView; /**<   中奖排行榜 */
@property (nonatomic, strong) UGRankListModel *rankListModel;               /**<   中奖排行榜数据 */
@property (nonatomic, strong) NSArray<UGRankModel *> *rankArray;            /**<   中奖排行榜数据 */

@end

@implementation HomeRankingView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setBackgroundColor:Skin1.navBarBgColor];
    [self.upwardMultiMarqueeView setBackgroundColor:Skin1.homeContentColor];
    
    self.upwardMultiMarqueeView.direction = UUMarqueeViewDirectionUpward;
    self.upwardMultiMarqueeView.timeIntervalPerScroll = 0.0f;
    self.upwardMultiMarqueeView.scrollSpeed = 10.f;
    self.upwardMultiMarqueeView.useDynamicHeight = YES;
    self.upwardMultiMarqueeView.touchEnabled = YES;
    self.upwardMultiMarqueeView.delegate = self;

    // c108站点定制需求
    if ([@"c108" containsString: APP.SiteId] || Skin1.isTKL || [Skin1.skitType isEqualToString:@"金沙主题"]) {
        self.backgroundColor = UIColor.whiteColor;
    } else {
        self.backgroundColor = Skin1.isGPK ? Skin1.bgColor : Skin1.navBarBgColor;
    }

}

- (void)start { [self.upwardMultiMarqueeView start];}
- (void)pause { [self.upwardMultiMarqueeView pause];}


// 中奖排行榜、投注排行榜
- (void)reloadData:(void (^)(BOOL succ))completion {
    WeakSelf;
    [CMNetwork getRankListWithParams:@{} completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // 需要在主线程执行的代码
                UGRankListModel *rank = model.data;
                weakSelf.rankListModel = rank;
                weakSelf.rankArray = ({
                    // 填充5条空数据，看起来就有一段空白形成翻页效果
                    NSMutableArray *temp = rank.list.mutableCopy;
                    for (int i=0; i<5; i++) {
                        UGRankModel *rm = [UGRankModel new];
                        [temp addObject:rm];
                    }
                    [temp copy];
                });
                
                
                UGSystemConfigModel * config = UGSystemConfigModel.currentConfig;
                if (config.rankingListSwitch == 0) {
                } else if (config.rankingListSwitch == 1) {
                    weakSelf.rankLabel.text = @"中奖排行榜";
                } else if (config.rankingListSwitch == 2) {
                    weakSelf.rankLabel.text = @"投注排行榜";
                }
                weakSelf.hidden = !config.rankingListSwitch;
           
                weakSelf.rankLabel.textColor = Skin1.textColor1;
                [weakSelf.upwardMultiMarqueeView reloadData];
                
                if (completion)
                    completion(true);
            });
        } failure:^(id msg) {
            if (completion)
                completion(false);
        }];
    }];
}


#pragma mark - UUMarqueeViewDelegate

- (NSUInteger)numberOfVisibleItemsForMarqueeView:(UUMarqueeView *)marqueeView {
    return 6;
}

- (NSUInteger)numberOfDataForMarqueeView:(UUMarqueeView *)marqueeView {
    return self.rankArray ? self.rankArray.count : 0;
}

- (void)createItemView:(UIView *)itemView forMarqueeView:(UUMarqueeView *)marqueeView {
    itemView.backgroundColor = [UIColor whiteColor];
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(20.0f, (CGRectGetHeight(itemView.bounds) - 16.0f) / 2.0f, 16.0f, 16.0f)];
    icon.tag = 1003;
    [itemView addSubview:icon];
    UILabel *userName = [[UILabel alloc] initWithFrame:CGRectMake(20.0f + 20.0f, 0.0f, CGRectGetWidth(itemView.bounds) - 20.0f - 20.0f - 75.0f, CGRectGetHeight(itemView.bounds))];
    userName.font = [UIFont systemFontOfSize:14.0f];
    userName.textColor = [UIColor redColor];
    userName.tag = 1001;
    [itemView addSubview:userName];
    
    UILabel *gameLabel = [[UILabel alloc] initWithFrame:CGRectMake((UGScreenW / 3), 0, (UGScreenW / 3), itemView.height)];
    gameLabel.textColor = [UIColor blackColor];
    gameLabel.textAlignment = NSTextAlignmentCenter;
    gameLabel.font = [UIFont systemFontOfSize:14];
    gameLabel.tag = 1004;
    [itemView addSubview:gameLabel];
    
    UILabel *amountLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(gameLabel.frame), 0, (UGScreenW / 3)-20, itemView.height)];
    amountLable.textColor = [UIColor redColor];
    amountLable.font = [UIFont systemFontOfSize:14];
    amountLable.textAlignment = NSTextAlignmentCenter;
    amountLable.tag = 1002;
    [itemView addSubview:amountLable];
}

- (void)updateItemView:(UIView *)itemView atIndex:(NSUInteger)index forMarqueeView:(UUMarqueeView *)marqueeView {
    UGRankModel *rank = self.rankArray[index];
    UILabel *content = [itemView viewWithTag:1001];
    content.text = rank.username;
    content.textColor = Skin1.textColor1;
    
    UILabel *coin = [itemView viewWithTag:1002];
    coin.text = rank.coin.length ? _NSString(@"%@元",rank.coin) : nil;
    
    UILabel *game = [itemView viewWithTag:1004];
    game.text = rank.type;
    game.textColor = Skin1.textColor1;
    
    UIImageView *icon = [itemView viewWithTag:1003];
    NSString *imgName = nil;
    icon.hidden = NO;
    if (!rank.coin.length) {
        imgName = @"yuandian";
        icon.hidden = YES;
    } else if (index == 0) {
        imgName = @"diyiming";
    } else if (index == 1) {
        imgName = @"dierming";
    } else if (index == 2) {
        imgName = @"disanming";
    } else {
        imgName = @"yuandian";
        icon.hidden = YES;
    }
    icon.image = [UIImage imageNamed:imgName];
    
    [itemView setBackgroundColor:Skin1.homeContentColor];
}

- (CGFloat)itemViewHeightAtIndex:(NSUInteger)index forMarqueeView:(UUMarqueeView*)marqueeView {
    return self.upwardMultiMarqueeView.height / 6;
}

@end
