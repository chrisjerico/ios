//
//  UGPromotionsController.m
//  ug
//
//  Created by ug on 2019/5/10.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGPromotionsController.h"
#import "UGPromoteDetailController.h"   // 优惠详情
#import "UGFundsViewController.h"       // 资金管理
#import "UGChangLongController.h"       // 长龙助手
#import "UGPromotionIncomeController.h" // 推广收益
#import "UGAgentViewController.h"       // 申请代理
#import "UGBetRecordViewController.h"   // 注单记录
#import "UGCommonLotteryController.h"   // 下注页基类

#import "UGAppVersionManager.h"         // 版本更新弹框

#import "UGPromoteModel.h"
#import "GameCategoryDataModel.h"


@interface UGPromotionsController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation UGPromotionsController

- (BOOL)允许未登录访问 { return true; }
- (BOOL)允许游客访问 { return true; }

- (void)skin {
    self.view.backgroundColor = Skin1.bgColor;
    self.tableView.backgroundColor = Skin1.bgColor;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    SANotificationEventSubscribe(UGNotificationWithSkinSuccess, self, ^(typeof (self) self, id obj) {
        [self skin];
    });
    self.navigationItem.title = @"优惠活动";
    self.view.backgroundColor = Skin1.bgColor;

    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getPromoteList];
        self.view.backgroundColor = Skin1.bgColor;
        self.tableView.backgroundColor = Skin1.bgColor;
    }];
    [self getPromoteList];
}

- (void)getPromoteList {
    __weakSelf_(__self);
    [SVProgressHUD show];
    [CMNetwork getPromoteListWithParams:@{} completion:^(CMResult<id> *model, NSError *err) {
        [__self.tableView.mj_header endRefreshing];
        [SVProgressHUD dismiss];
        [CMResult processWithResult:model success:^{
            UGPromoteListModel *listModel = model.data;
            [__self.tableView.dataArray setArray:listModel.list];
            [__self.tableView reloadData];
        } failure:nil];
    }];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return tableView.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = Skin1.cellBgColor;
    UGPromoteModel *pm = tableView.dataArray[indexPath.row];
    FastSubViewCode(cell);
    NSLog(@"pm.title = %@", pm.title);
    subLabel(@"标题Label").textColor = Skin1.textColor1;
    subLabel(@"标题Label").text = pm.title;
    [subImageView(@"图片ImageView") sd_setImageWithURL:[NSURL URLWithString:pm.pic] placeholderImage:[UIImage imageNamed:@"placeholder"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (image) {
            subImageView(@"图片ImageView").cc_constraints.height.constant = image.height/image.width * (APP.Width - 48);
        }
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UGPromoteModel *pm = tableView.dataArray[indexPath.row];
    
    // 去游戏页面
    switch (pm.linkCategory) {
        case 1:
        case 2:
        case 3:
        case 4:
        case 5:
        case 6: {
            [UGCommonLotteryController pushWithModel:[UGNextIssueModel modelWithGameId:@(pm.linkPosition).stringValue]];
            return;
        }
        default:;
    }
    
    // 去功能页面
    if (pm.linkCategory == 7) {
        switch (pm.linkPosition) {
            case 1: {
                // 资金管理
                [self.navigationController pushViewController:[UGFundsViewController new] animated:true];
                break;
            }
            case 2: {
                // APP下载
                [[UGAppVersionManager shareInstance] updateVersionApi:true];
                break;
            }
            case 3: {
                // 聊天室
                [self.navigationController pushViewController:[UGChatViewController new] animated:YES];
                break;
            }
            case 4: {
                // 在线客服
                TGWebViewController *webViewVC = [[TGWebViewController alloc] init];
                webViewVC.url = SysConf.zxkfUrl;
                webViewVC.webTitle = @"在线客服";
                [self.navigationController pushViewController:webViewVC animated:YES];
                break;
            }
            case 5: {
                // 长龙助手
                [self.navigationController pushViewController:[UGChangLongController new] animated:YES];
                break;
            }
            case 6: {
                // 推广收益
                if (UserI.isTest) {
                    [self.navigationController pushViewController:[UGPromotionIncomeController new] animated:YES];
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
                [self.navigationController pushViewController:_LoadVC_from_storyboard_(@"UGYubaoViewController")  animated:YES];
                break;
            }
            case 9: {
                // 优惠活动
                [self.navigationController pushViewController:_LoadVC_from_storyboard_(@"UGPromotionsController") animated:YES];
                break;
            }
            case 10: {
                // 注单记录
                UGBetRecordViewController *vc = [[UGBetRecordViewController alloc] init];
                [self.navigationController pushViewController:vc animated:true];
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
        }
        return;
    }
    
    // 去优惠详情
    UGPromoteDetailController *detailVC = [[UGPromoteDetailController alloc] init];
    detailVC.item = pm;
    [NavController1 pushViewController:detailVC animated:YES];
}

@end
