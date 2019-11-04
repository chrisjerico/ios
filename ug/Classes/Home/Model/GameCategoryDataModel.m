//
//  CustomGameModel.m
//  ug
//
//  Created by xionghx on 2019/9/19.
//  Copyright © 2019 ug. All rights reserved.
//

#import "GameCategoryDataModel.h"
#import "UGPlatformGameModel.h"

#import "UGDocumentVC.h"                // 资料
#import "UGCommonLotteryController.h"   // 下注页基类
#import "UGSSCLotteryController.h"      // 时时彩
#import "UGBJPK10LotteryController.h"
#import "UGQXCLotteryController.h"
#import "UGPCDDLotteryController.h"
#import "UGJSK3LotteryController.h"
#import "UGHKLHCLotteryController.h"
#import "UGGD11X5LotteryController.h"
#import "UGXYNCLotteryController.h"
#import "UGBJKL8LotteryController.h"
#import "UGGDKL10LotteryController.h"
#import "UGFC3DLotteryController.h"
#import "UGPK10NNLotteryController.h"
#import <SafariServices/SafariServices.h>
#import "UGGameListViewController.h"


@implementation GameSubModel
@end


@implementation GameModel
+ (JSONKeyMapper *)keyMapper {
	return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"gameId",@"gameId":@"game_id"}];
}

+ (instancetype)gameWithId:(NSString *)gameId {
    return nil;
}

- (NSString *)logo { return _logo.length ? _logo : _icon; }
- (NSString *)icon { return _logo.length ? _logo : _icon; }
- (NSString *)hotIcon  { return _hotIcon.length ? _hotIcon : _hot_icon; }
- (NSString *)hot_icon { return _hotIcon.length ? _hotIcon : _hot_icon; }

- (void)pushViewController {
    GameModel *model = self;
    if (!UGLoginIsAuthorized()) {
        SANotificationEventPost(UGNotificationShowLoginView, nil);
        return;
    }
    if ([model.docType intValue] == 1) {
        [NavController1 pushViewController:[[UGDocumentVC alloc] initWithModel:model] animated:true];
        return;
    }
    if (model.game_id) {
        model.gameId = model.game_id;
    }
    
    BOOL ret = [UGCommonLotteryController pushWithModel:({
        UGNextIssueModel *nim = [UGNextIssueModel new];
        [nim setValuesWithObject:model];
        nim;
    })];
    
    if (!ret) {
        // 进入第三方游戏
        if (model.url && ![model.url isEqualToString:@""]) {
            NSURL * url = [NSURL URLWithString:model.url];
            if (url.scheme == nil) {
                url = [NSURL URLWithString:_NSString(@"http://%@", model.url)];
            }
            SFSafariViewController *sf = [[SFSafariViewController alloc] initWithURL:url];
            [NavController1 presentViewController:sf animated:YES completion:nil];
        } else if (model.subType.count > 0) {
            UGGameListViewController *gameListVC = [[UGGameListViewController alloc] init];
            gameListVC.game = model;
            [NavController1 pushViewController:gameListVC animated:YES];
        } else {
            if (![UGUserModel currentUser].sessid.length) {
                return;
            }
            NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid,
                                     @"id":model.gameId,
            };
            [SVProgressHUD showWithStatus:nil];
            [CMNetwork getGotoGameUrlWithParams:params completion:^(CMResult<id> *model, NSError *err) {
                [CMResult processWithResult:model success:^{
                    [SVProgressHUD dismiss];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        QDWebViewController *qdwebVC = [[QDWebViewController alloc] init];
                        
                        NSLog(@"网络链接：model.data = %@",model.data);
                        qdwebVC.urlString = [CMNetwork encryptionCheckSignForURL:model.data];
                        qdwebVC.enterGame = YES;
                        [NavController1 pushViewController:qdwebVC  animated:YES];
                    });
                } failure:^(id msg) {
                    [SVProgressHUD showErrorWithStatus:msg];
                }];
            }];
        }
    }
}

@end


@implementation GameCategoryModel
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"iid"}];
}
@end


@implementation GameCategoryDataModel

@end
