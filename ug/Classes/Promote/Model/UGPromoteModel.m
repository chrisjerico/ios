//
//  UGPromoteModel.m
//  ug
//
//  Created by ug on 2019/6/23.
//  Copyright © 2019 ug. All rights reserved.
//

// Model
#import "UGPromoteModel.h"
#import "UGAllNextIssueListModel.h"

// Tools
#import "UGAppVersionManager.h"

// ViewController
#import "UGCommonLotteryController.h"
#import "UGChangLongController.h"
#import "UGFundsViewController.h"
#import "UGAgentViewController.h"
#import "UGPromotionIncomeController.h"
#import "UGBetRecordViewController.h"

@implementation UGPromoteModel

+(JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"promoteId"}];
}

+ (BOOL)pushViewControllerWithLinkCategory:(NSInteger)linkCategory linkPosition:(NSInteger)linkPosition {
    // 去游戏页面
    switch (linkCategory) {
        case 1:
        case 2:
        case 3:
        case 4:
        case 5:
        case 6: {
            return [UGCommonLotteryController pushWithModel:[UGNextIssueModel modelWithGameId:@(linkPosition).stringValue]];
        }
        default:;
    }
    
    // 去功能页面
    if (linkCategory != 7) {
        return false;
    }
    
    switch (linkPosition) {
        case 1: {
            // 资金管理
            [NavController1 pushViewController:[UGFundsViewController new] animated:true];
            break;
        }
        case 2: {
            // APP下载
            [[UGAppVersionManager shareInstance] updateVersionApi:true];
            break;
        }
        case 3: {
            // 聊天室
            [NavController1 pushViewController:[UGChatViewController new] animated:YES];
            break;
        }
        case 4: {
            // 在线客服
            TGWebViewController *webViewVC = [[TGWebViewController alloc] init];
            webViewVC.url = SysConf.zxkfUrl;
            webViewVC.webTitle = @"在线客服";
            [NavController1 pushViewController:webViewVC animated:YES];
            break;
        }
        case 5: {
            // 长龙助手
            [NavController1 pushViewController:[UGChangLongController new] animated:YES];
            break;
        }
        case 6: {
            // 推广收益
            if (UserI.isTest) {
                [NavController1 pushViewController:[UGPromotionIncomeController new] animated:YES];
            } else {
                [SVProgressHUD showWithStatus:nil];
                [CMNetwork teamAgentApplyInfoWithParams:@{@"token":[UGUserModel currentUser].sessid} completion:^(CMResult<id> *model, NSError *err) {
                    [CMResult processWithResult:model success:^{
                        [SVProgressHUD dismiss];
                        UGagentApplyInfo *obj  = (UGagentApplyInfo *)model.data;
                        int intStatus = obj.reviewStatus.intValue;
                        
                        //0 未提交  1 待审核  2 审核通过 3 审核拒绝
                        if (intStatus == 2) {
                            [NavController1 pushViewController:[UGPromotionIncomeController new] animated:YES];
                        } else {
                            if (![SysConf.agent_m_apply isEqualToString:@"1"]) {
                                [HUDHelper showMsg:@"在线注册代理已关闭"];
                                return ;
                            }
                            UGAgentViewController *vc = [[UGAgentViewController alloc] init];
                            vc.item = obj;
                            [NavController1 pushViewController:vc animated:YES];
                        }
                    } failure:^(id msg) {
                        [SVProgressHUD showErrorWithStatus:msg];
                    }];
                }];
            }
            break;
        }
        case 7: {
            // 开奖网
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_NSString(@"%@/Open_prize/index.php", baseServerUrl)]];
            break;
        }
        case 8: {
            // 利息宝
            [NavController1 pushViewController:_LoadVC_from_storyboard_(@"UGYubaoViewController")  animated:YES];
            break;
        }
        case 9: {
            // 优惠活动
            [NavController1 pushViewController:_LoadVC_from_storyboard_(@"UGPromotionsController") animated:YES];
            break;
        }
        case 10: {
            // 注单记录
            UGBetRecordViewController *vc = [[UGBetRecordViewController alloc] init];
            [NavController1 pushViewController:vc animated:true];
            break;
        }
        case 11: {
            // QQ客服
            NSString *qqstr;
            if ([CMCommon stringIsNull:SysConf.serviceQQ1]) {
                qqstr = SysConf.serviceQQ2;
            } else {
                qqstr = SysConf.serviceQQ1;
            }
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_NSString(@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web", qqstr)]];
            break;
        }
        case 13: {
            // 任务大厅
            [NavController1 pushViewController:_LoadVC_from_storyboard_(@"UGMissionCenterViewController") animated:true];
            break;
        }
        default: {
            return false;
        }
    }
    return true;
}
@end

@implementation UGPromoteListModel


@end
