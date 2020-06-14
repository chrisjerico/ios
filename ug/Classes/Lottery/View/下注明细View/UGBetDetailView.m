//
//  UGBetDetailView.m
//  ug
//
//  Created by ug on 2019/5/14.
//  Copyright © 2019 ug. All rights reserved.
//  adfdadsf

#import "UGBetDetailView.h"
#import "UGBetDetailTableViewCell.h"
#import "UGBetDetailModel.h"
#import "CountDown.h"
#import "UGAllNextIssueListModel.h"
#import "UGGameplayModel.h"
#import "UGBetResultView.h" /**<   金杯的视图 */
#import "UGbetModel.h"
#import "CMTimeCommon.h"
#import "C001BetErrorCustomView.h"
#import "CCNetworkRequests1+UG.h"
#import "CMLabelCommon.h"
#import "SGBrowserView.h"
@interface UGBetDetailView ()<UITableViewDelegate,UITableViewDataSource>{
    
    NSInteger count;  /**<   总注数*/
    NSString *amount; /**<   总金额*/
    
    UIScrollView* maskView;
}
@property (weak, nonatomic) IBOutlet UIButton *allUpButton;    /**<   批量修改金额Button */
@property (weak, nonatomic) IBOutlet UITextField *allUpText;    /**<  批量修改金额Label */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;       /**<   期数彩种Label */
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel; /**<   总金额Label */
@property (weak, nonatomic) IBOutlet UIButton *submitButton;    /**<   确认下注Button */
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;    /**<   取消Button */
@property (weak, nonatomic) IBOutlet UILabel *closeTimeLabel;   /**<   封盘时间Label */

@property (weak, nonatomic) IBOutlet UIView *plView;            /**<   批量修改View*/
@property (weak, nonatomic) IBOutlet UILabel *plTitleLab;       /**<  批量修改abel */
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;       /**<  合计Label */


@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) CountDown *countDown;
@property (nonatomic, strong) NSMutableArray <UGBetModel *> *betArray;

@end

static NSString *betDetailCellid = @"UGBetDetailTableViewCell";
@implementation UGBetDetailView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"UGBetDetailView" owner:self options:0].firstObject;
        
        float h = 0;
        if (self.dataArray.count < 3) {
            h = 400;
        } else if (self.dataArray.count > 7) {
            h = 550;
        } else {
            h = 230 + 44 * self.dataArray.count;
        }
        self.size = CGSizeMake(UGScreenW - 50, h);
        self.center = CGPointMake(UGScreenW / 2 , UGScerrnH / 2);
        self.submitButton.layer.cornerRadius = 3;
        self.submitButton.layer.masksToBounds = YES;
        self.allUpButton.layer.cornerRadius = 3;
        self.allUpButton.layer.masksToBounds = YES;
        
        self.cancelButton.layer.cornerRadius = 3;
        self.cancelButton.layer.masksToBounds = YES;
        self.cancelButton.layer.borderColor = Skin1.bgColor.CGColor;
        self.cancelButton.layer.borderWidth = 0.7;
        
        
        
        self.layer.cornerRadius = 6;
        self.layer.masksToBounds = YES;
        [self addSubview:self.tableView];
        
        self.countDown = [[CountDown alloc] init];
        SANotificationEventSubscribe(UGNotificationloginTimeout, self, ^(typeof (self) self, id obj) {
            [self hiddenSelf];
        });
        
        [self getSystemConfig];     // APP配置信息
        
#pragma mark -键盘弹出添加监听事件
        // 键盘出现的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
        // 键盘消失的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHiden:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

// 获取系统配置
- (void)getSystemConfig {
    [CMNetwork getSystemConfigWithParams:@{} completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            
            NSLog(@"model = %@",model);
            FastSubViewCode(self);
            UGSystemConfigModel *config = model.data;
            UGSystemConfigModel.currentConfig = config;
            if (SysConf.betAmountIsDecimal  == 1) {//betAmountIsDecimal  1=允许小数点，0=不允许，以前默认是允许投注金额带小数点的，默认为1
                [subTextView(@"下注TxtF") set仅数字:false];
                [subTextView(@"下注TxtF") set仅数字含小数:true];
            } else {
                [subTextView(@"下注TxtF") set仅数字:true];
            }
        } failure:^(id msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }];
}

- (IBAction)cancelClick:(id)sender {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
    [self hiddenSelf];
}

- (IBAction)submitClick:(id)sender {
    if (!self.dataArray.count) {
        [SVProgressHUD showInfoWithStatus:@"投注信息有误"];
    }
    NSMutableArray *dicArray = [UGGameBetModel mj_keyValuesArrayWithObjectArray:self.betArray];
    [CMCommon saveLastGengHao:dicArray.copy gameId:self.nextIssueModel.gameId selCode:self.code];
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"resetGengHaoBtn" object:nil userInfo:nil]];
    
    
    float totalAmount = 0.0;
    NSInteger totalNum = 0;
    for (UGBetModel *model in self.betArray) {
        if ([@"连码" isEqualToString:model.typeName]) {
            if ([@"三中二" isEqualToString:model.title] ||
                [@"三全中" isEqualToString:model.title]) {
                
                totalNum = [CMCommon pickNum:3 totalNum:self.dataArray.count];
                
            } else if ([@"二全中" isEqualToString:model.title] ||
                       [@"二中特" isEqualToString:model.title] ||
                       [@"特串" isEqualToString:model.title]) {
                
                totalNum = [CMCommon pickNum:2 totalNum:self.dataArray.count];
                
            } else if ([@"四全中" isEqualToString:model.title]) {
                
                totalNum = [CMCommon pickNum:4 totalNum:self.dataArray.count];
                
            } else if ([@"前二组选" isEqualToString:model.title]) {
                
                totalNum = [CMCommon pickNum:2 totalNum:self.dataArray.count];
            } else if ([@"前三组选" isEqualToString:model.title]) {
                
                totalNum = [CMCommon pickNum:3 totalNum:self.dataArray.count];
            } else if ([@"任选二" isEqualToString:model.title] ||
                       [@"选二连组" isEqualToString:model.title]) {
                
                totalNum = [CMCommon pickNum:2 totalNum:self.dataArray.count];
            } else if ([@"任选三" isEqualToString:model.title] ||
                       [@"选三前组" isEqualToString:model.title]) {
                
                totalNum = [CMCommon pickNum:3 totalNum:self.dataArray.count];
            } else if ([@"任选四" isEqualToString:model.title]) {
                totalNum = [CMCommon pickNum:4 totalNum:self.dataArray.count];
            } else if ([@"任选五" isEqualToString:model.title]) {
                totalNum = [CMCommon pickNum:5 totalNum:self.dataArray.count];
            } else {
                //                11选5 连码非组选等玩法
                totalNum = 1;
            }
            totalAmount = model.money.floatValue * totalNum;
        } else {
            totalNum = self.betArray.count;
            totalAmount += model.money.floatValue;
        }
    }
    NSString *amount = [NSString stringWithFormat:@"%.2lf",totalAmount];
    if ([CMCommon stringIsNull:[UGUserModel currentUser].sessid]) {
        return;
    }
    NSDictionary *dict = @{
        @"token":[UGUserModel currentUser].sessid,
        @"gameId":self.nextIssueModel.gameId,
        @"betIssue":self.nextIssueModel.curIssue,
        @"endTime":[self.nextIssueModel.curCloseTime timeStrToTimeInterval],
        @"totalNum":[NSString stringWithFormat:@"%ld",totalNum],
        @"totalMoney":amount
    };
    
    NSMutableDictionary *mutDict = [[NSMutableDictionary alloc] initWithDictionary:dict];
    for (int i = 0; i < self.betArray.count; i++) {
        NSString *playId = [NSString stringWithFormat:@"betBean[%d][playId]",i];
        NSString *money = [NSString stringWithFormat:@"betBean[%d][money]",i];
        NSString *betInfo = [NSString stringWithFormat:@"betBean[%d][betInfo]",i];
        NSString *playIds = [NSString stringWithFormat:@"betBean[%d][playIds]",i];
        NSString *odds = [NSString stringWithFormat:@"betBean[%d][odds]",i];
        UGBetModel *bet = self.betArray[i];
        [mutDict setValue:bet.playId forKey:playId];
        [mutDict setValue: [NSString stringWithFormat:@"%.2f", [bet.money floatValue]]  forKey:money];
        [mutDict setObject:bet.betInfo.length ? bet.betInfo : @"" forKey:betInfo];
        [mutDict setObject:bet.playIds.length ? bet.playIds : @"" forKey:playIds];
//        [mutDict setObject:bet.money.length ? bet.money : @"" forKey:money];
        [mutDict setObject:bet.odds.length ? bet.odds : @"" forKey:odds];
        
    }
    
    if (SysConf.activeReturnCoinStatus) {//是否開啟拉條模式
        float f =  [[Global getInstanse] rebate] *100;//拉條值為 4.5% , 則傳入 4.5
        NSLog(@"rebate = %f",f);
        NSString *strValue=[NSString stringWithFormat:@"%0.2f", f];
        
        [mutDict setValue:strValue  forKey:@"activeReturnCoinRatio"];
    }

      HJSonLog(@"mutDict = %@",mutDict);
    [self submitBet:mutDict];
    
}


//-(void)goChatRoom{
//    UGChatViewController *vc = [[UGChatViewController alloc] init];
//    vc.shareBetJson = [self shareBettingData];
//    [NavController1 pushViewController:vc animated:YES];
//}
-(void)selectChatRoom{
    NSMutableDictionary *jsDic = [self shareBettingData];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:jsDic,@"jsDic", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NSSelectChatRoom_share" object:nil userInfo:dic];
}

- (void)submitBet:(NSDictionary *)params {
    [SVProgressHUD showWithStatus:nil];
    [CMNetwork userBetWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            [SVProgressHUD dismiss];
            
            
            // 秒秒彩系列（即时开奖无需等待）
            if ([@[@"7", @"11", @"9"] containsObject:self.nextIssueModel.gameId]) {
                BOOL showSecondLine = [@[@"11"] containsObject:self.nextIssueModel.gameId]; // 六合秒秒彩
                UGBetDetailModel *mod = (UGBetDetailModel *)model.data;
                mod.gameId = self.nextIssueModel.gameId;
                
                UGBetResultView *bet = [[UGBetResultView alloc] initWithShowSecondLine:showSecondLine];
                
                [bet showWith:mod showSecondLine:showSecondLine timerAction:^(dispatch_source_t  _Nonnull timer) {
                    [self submitBet:params];
                }];
            } else {
                
                [self hiddenSelf];
                
                float amountfloat = [self->amount floatValue];
                float webAmountfloat = [SysConf.chatMinFollowAmount floatValue];
                
                if (!UserI.isTest && SysConf.chatFollowSwitch && (amountfloat >= webAmountfloat)) {
                    
                    if (Skin1.isBlack||Skin1.is23) {
                        [LEEAlert alert].config
                        .LeeAddTitle(^(UILabel *label) {
                            label.text = @"分享注单";
                            label.textColor = [UIColor whiteColor];
                        })
                        .LeeAddContent(^(UILabel *label) {
                            label.text = @"是否分享到聊天室";
                            label.textColor = [UIColor whiteColor];
                        })
                        .LeeAction(@"取消", nil)
                        .LeeAction(@"分享", ^{//跳到聊天界面，把分享数据传过去
                            [self selectChatRoom];
                        })
                        .LeeHeaderColor(Skin1.bgColor)
                        .LeeShow();
                    } else {
                        // ==> 弹出分享框
                        [LEEAlert alert].config
                        .LeeTitle(@"分享注单")
                        .LeeContent(@"是否分享到聊天室")
                        .LeeAction(@"取消", nil)
                        .LeeAction(@"分享", ^{//跳到聊天界面，把分享数据传过去
                            [self selectChatRoom];
                        })
                        
                        .LeeShow();
                    }
                    
                } else {
                    [SVProgressHUD showSuccessWithStatus:model.msg];
                }
            }
            
            SANotificationEventPost(UGNotificationGetUserInfo, nil);
            if (self.betClickBlock) {
                self.betClickBlock();
                [self hiddenSelf];
            }
            [self hiddenSelf];
            
            
        } failure:^(id msg) {
            [SVProgressHUD dismiss];
            
            UIAlertController * alert = [UIAlertController alertWithTitle:@"投注失败" msg:msg btnTitles:@[@"确定"]];
            [NavController1 presentViewController:alert animated:true completion:nil];
            
            NSString *msgStr = (NSString *)msg;
            if ([msgStr containsString:@"已封盘"]) {
                if (self.betClickBlock) {
                    self.betClickBlock();
                    [self hiddenSelf];
                }
            }
        }];
    }];
}

-(NSMutableDictionary *)shareBettingData{
    
    UGbetModel *betModel = [UGbetModel new];
    NSMutableArray *list = [NSMutableArray new];
    NSMutableArray<UGbetParamModel> *betParams = [NSMutableArray<UGbetParamModel> new];
    NSMutableArray<UGplayNameModel> *playNameArray = [NSMutableArray<UGplayNameModel> new];
    UGselectSubModel *subModel = [UGselectSubModel new];
    for (int i = 0; i< self.betArray.count; i++)  {
        UGGameBetModel *model = [self.betArray objectAtIndex:i];
        NSLog(@"model=%@",model);
        NSMutableString *name = [NSMutableString new];
        
        if (([self.nextIssueModel.gameType isEqualToString:@"cqssc"]&&[self.code isEqualToString:@"LHD"] )||
            ([self.nextIssueModel.gameType isEqualToString:@"lhc"]&&[self.code isEqualToString:@"ZM1-6"])) {
            if ([CMCommon stringIsNull:model.alias]) {
                [name appendString:@""];
            } else {
                [name appendString:model.alias];
            }
        }
        
        if ([CMCommon stringIsNull:model.betInfo]) {
            [name appendString:model.name];
        } else {
            [name appendString:model.betInfo];
        }
        
        {// 组装list
            UGbetListModel *betList = [UGbetListModel new];
            [betList setBetMoney:model.money];
            [betList setIndex:[NSString stringWithFormat:@"%d",i]];
            [betList setOdds:model.odds];
            [betList setName:name];
            NSDictionary* dict = [betList toDictionary];
            [list addObject:dict];
        }
        
        {// 组装betParams
            
            UGbetParamModel *betList = [UGbetParamModel new];
            [betList setMoney:model.money];
            [betList setName:name];
            [betList setOdds:model.odds];
            [betList setPlayId:model.playId];
            [betParams addObject:betList];
            NSLog(@"model.name = %@,model.money = %@",model.name,model.money);
            [betModel setBetParams:betParams];
        }
        
        {// 组装playNameArray
            UGplayNameModel *betList = [UGplayNameModel new];
            [betList setPlayName1:[NSString stringWithFormat:@"%@-%@",model.title,name]];
            [betList setPlayName2:name];
            [playNameArray addObject:betList];
            [betModel setPlayNameArray:playNameArray];
        }
        
        {//UGselectSubModel
            NSString *max = @"";
            NSString *min = @"";
            NSString *alias = model.alias;
            if ([self.nextIssueModel.gameType isEqualToString:@"lhc"]) {
                if ([alias containsString:@"三中二"]){
                    max = @"7";
                    min = @"3";
                }
                else if ([alias containsString:@"二全中"] ||[alias containsString:@"二中特"] ||[alias containsString:@"特串"] ) {
                    max = @"7";
                    min = @"2";
                }
                else if ([alias containsString:@"三全中"]) {
                    max = @"10";
                    min = @"3";
                }
                else if ([alias containsString:@"四全中"]) {
                    max = @"4";
                    min = @"4";
                }
                else {
                    
                }
            }
            else if([self.nextIssueModel.gameType isEqualToString:@"gd11x5"]){
                if ([alias containsString:@"二中二"]) {
                    max = @"2";
                    min = @"2";
                }
                else if ([alias containsString:@"三中三"]) {
                    max = @"3";
                    min = @"3";
                }
                else if ([alias containsString:@"四中四"]) {
                    max = @"4";
                    min = @"4";
                }
                else if ([alias containsString:@"五中五"]){
                    max = @"5";
                    min = @"5";
                }
                else if ([alias containsString:@"前二组选"]){
                    max = @"5";
                    min = @"2";
                }
                else if ([alias containsString:@"前三组选"]){
                    max = @"5";
                    min = @"3";
                }
                else if ([alias containsString:@"六中五"]) {
                    max = @"6";
                    min = @"5";
                }
                else if ([alias containsString:@"七中五"]) {
                    max = @"7";
                    min = @"5";
                }
                else if ([alias containsString:@"八中五"]) {
                    max = @"8";
                    min = @"5";
                }
                else {
                    
                }
            }
            else if([self.nextIssueModel.gameType isEqualToString:@"gdkl10"]){
                if ([alias containsString:@"任选二"] ||
                    [alias containsString:@"选二连组"]){
                    max = @"7";
                    min = @"2";
                }
                else if ([alias containsString:@"任选三"] ||[alias containsString:@"选三前组"]) {
                    max = @"7";
                    min = @"3";
                }
                else if ([alias containsString:@"任选四"]){
                    max = @"5";
                    min = @"4";
                }
                else if ([alias containsString:@"任选五"]){
                    max = @"5";
                    min = @"5";
                }
                else {
                    
                }
            }
            subModel.max = max;
            subModel.min = min;
            subModel.id = model.playId;
            subModel.text = model.name;
            subModel.type = self.code;
        }
        
    }
    
    {//其他数据
        NSLog(@"self.nextIssueModel = %@",self.nextIssueModel);
        betModel.gameName = self.nextIssueModel.title;
        betModel.gameId = self.nextIssueModel.gameId;
        betModel.totalNums = [NSString stringWithFormat:@"%ld",(long)count];
        betModel.totalMoney = amount;
        betModel.turnNum = self.nextIssueModel.curIssue;
        NSInteger timeInt =  [CMTimeCommon timeSwitchTimestamp:self.nextIssueModel.curCloseTime andFormatter:@"YYYY-MM-dd HH:mm:ss"];
        NSLog(@"time = %ld",(long)timeInt);
        betModel.ftime = [NSString stringWithFormat:@"%ld",(long)timeInt];
        betModel.code = self.code;
        if ([self.code isEqualToString:@"LMA"]&&([self.nextIssueModel.gameType isEqualToString:@"gdkl10"]||[self.nextIssueModel.gameType isEqualToString:@"gd11x5"]||[self.nextIssueModel.gameType isEqualToString:@"lhc"])) {
            betModel.selectSub = subModel;
        }
        
        if ([self.code isEqualToString:@"LMA"] ||[self.code isEqualToString:@"ZX"] ||[self.code isEqualToString:@"HX"] ||[self.code isEqualToString:@"LX"] ||[self.code isEqualToString:@"LW"] ||[self.code isEqualToString:@"ZXBZ"] ) {
            betModel.specialPlay = YES;
            
        } else {
            betModel.specialPlay = NO;
        }
        
    }
    
    
    
    NSMutableDictionary *jsDic = [NSMutableDictionary new];
    [jsDic setValue:betModel forKey:@"betModel"];
    [jsDic setValue:list forKey:@"list"];
    //以字符串形式导出
    NSString* paramsjsonString = [betModel toJSONString];
    
    NSLog(@"paramsjsonString = %@",paramsjsonString);
    
    NSString *listjsonString;
    {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:list options:NSJSONWritingPrettyPrinted error:&error];
        listjsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    
    NSLog(@"listjsonString = %@",listjsonString);
    
    NSString *jsonStr = [NSString stringWithFormat:@"shareBet(%@, %@)",listjsonString,paramsjsonString];
    
    NSLog(@"jsonStr = %@",jsonStr);
    [jsDic setValue:jsonStr forKey:@"jsonStr"];
    
    return jsDic;
    
}
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.betArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UGBetDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:betDetailCellid forIndexPath:indexPath];
    cell.item = self.betArray[indexPath.row];
    WeakSelf
    cell.delectBlock = ^{
        [weakSelf.betArray removeObjectAtIndex:indexPath.row];
        [weakSelf.tableView reloadData];
        [weakSelf updateTotalLabelText];
        
    };
    cell.amountEditedBlock = ^(float amount) {
        UGBetModel * betModel =  self.betArray[indexPath.row];
        betModel.money = [NSString stringWithFormat:@"%f", amount];
        self.betArray[indexPath.row] = betModel;
        [self updateTotalLabelText];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}

- (void)setDataArray:(NSArray<UGGameBetModel *> *)dataArray {
    _dataArray = dataArray;
    NSMutableArray *array = [NSMutableArray array];
    for (UGGameBetModel *model in dataArray) {
        UGBetModel *bet = [[UGBetModel alloc] init];
        bet.money = model.money;
        bet.playId = model.playId;
        bet.title = model.title;
        bet.name = model.name;
        
        if (SysConf.activeReturnCoinStatus) {//是否開啟拉條模式
            bet.odds = [[NSString stringWithFormat:@"%.4f",[CMCommon newOgOdds: [model.odds floatValue] rebate:[Global getInstanse].rebate]] removeFloatAllZero];
        } else {
            bet.odds = model.odds;
        }
        
        bet.alias = model.alias;
        bet.typeName = model.typeName;
        bet.betInfo = model.betInfo;
        if ([@"自选不中" isEqualToString:model.title]) {
            bet.betInfo = model.name;
        }
        if ([@"官方玩法" isEqualToString:model.title]) {
            bet.betInfo = model.name;
        }
        [array addObject:bet];
    }
    
    UGBetModel *bet = array.firstObject;
    if ([@"连尾" isEqualToString:bet.typeName] ||
        [@"连肖" isEqualToString:bet.typeName]) {
        
        NSArray *pickArrs = [[NSArray alloc] init];
        if ([@"二连尾" isEqualToString:bet.title] ||
            [@"二连肖" isEqualToString:bet.title]) {
            
            pickArrs = [CMCommon pickPermutation:2 totalNum:array.count];
        } else if ([@"三连尾" isEqualToString:bet.title] ||
                   [@"三连肖" isEqualToString:bet.title]){
            
            pickArrs = [CMCommon pickPermutation:3 totalNum:array.count];
            
        } else if ([@"四连尾" isEqualToString:bet.title] ||
                   [@"四连肖" isEqualToString:bet.title]){
            
            pickArrs = [CMCommon pickPermutation:4 totalNum:array.count];
            
        } else {
            
            pickArrs = [CMCommon pickPermutation:5 totalNum:array.count];
            
        }
        
        for (NSString *pickStr in pickArrs) {
            NSArray *arr = [pickStr componentsSeparatedByString:@","];
            NSString *firstIndex = arr.firstObject;
            NSInteger index = firstIndex.integerValue;
            UGBetModel *game = array[index];
            UGBetModel *bet = [[UGBetModel alloc] init];
            [bet setValuesForKeysWithDictionary:game.mj_keyValues];
            NSMutableString *pickName = [[NSMutableString alloc] init];
            NSMutableString *playIds = [[NSMutableString alloc] init];
            for (NSString *indexStr in arr) {
                NSInteger indexNum = indexStr.integerValue;
                UGBetModel *indexGame = array[indexNum];
                [playIds appendString:@","];
                [playIds appendString:indexGame.playId];
                [pickName appendString:@","];
                [pickName appendString:indexGame.alias];
            }
            bet.playIds = [playIds substringFromIndex:1];
            bet.name = [pickName substringFromIndex:1];
            bet.betInfo = [pickName substringFromIndex:1];
            [self.betArray addObject:bet];
        }
        
        return;
    }
    
    self.betArray = array.mutableCopy;
    //    连码等玩法对象去重
    for (int i = 0; i < array.count; i++) {
        UGBetModel *temp = array[i];
        if ([@"直选" isEqualToString:temp.typeName]) {
            break;
        }
        if ([@"一字定位" isEqualToString:temp.typeName]||[@"二字定位" isEqualToString:temp.typeName]||[@"三字定位" isEqualToString:temp.typeName]) {
            break;
        }
        NSMutableString *str = [[NSMutableString alloc] init];
        for (int y = i + 1; y < array.count; y++) {
            
            UGBetModel *model = array[y];
            if ([temp.playId isEqualToString:model.playId]) {
                temp.title = temp.alias;
                [str appendFormat:@",%@",model.name];
                [self.betArray removeObject:model];
            }
        }
        if (str.length) {
            NSInteger count = 0;
            if ([@"连码" isEqualToString:temp.typeName]) {
                if ([@"三中二" isEqualToString:temp.title] ||
                    [@"三全中" isEqualToString:temp.title]) {
                    
                    count = [CMCommon pickNum:3 totalNum:self.dataArray.count];
                    
                } else if ([@"二全中" isEqualToString:temp.title] ||
                           [@"二中特" isEqualToString:temp.title] ||
                           [@"特串" isEqualToString:temp.title]) {
                    
                    count = [CMCommon pickNum:2 totalNum:self.dataArray.count];
                    
                } else if ([@"四全中" isEqualToString:temp.title]) {
                    
                    count = [CMCommon pickNum:4 totalNum:self.dataArray.count];
                    
                } else if ([@"前二组选" isEqualToString:temp.title]) {
                    
                    count = [CMCommon pickNum:2 totalNum:self.dataArray.count];
                    
                } else if ([@"前三组选" isEqualToString:temp.title]) {
                    
                    count = [CMCommon pickNum:3 totalNum:self.dataArray.count];
                    
                } else if ([@"任选二" isEqualToString:temp.title] ||
                           [@"选二连组" isEqualToString:temp.title]) {
                    
                    count = [CMCommon pickNum:2 totalNum:self.dataArray.count];
                } else if ([@"任选三" isEqualToString:temp.title] ||
                           [@"选三前组" isEqualToString:temp.title]) {
                    
                    count = [CMCommon pickNum:3 totalNum:self.dataArray.count];
                } else if ([@"任选四" isEqualToString:temp.title]) {
                    count = [CMCommon pickNum:4 totalNum:self.dataArray.count];
                } else if ([@"任选五" isEqualToString:temp.title]) {
                    count = [CMCommon pickNum:5 totalNum:self.dataArray.count];
                } else {
                    //                11选5 连码非组选等玩法
                    count = 1;
                }
                temp.displayInfo = [NSString stringWithFormat:@"%@%@组合数：%ld",temp.name,str,count];
            }
            temp.betInfo = [NSString stringWithFormat:@"%@%@",temp.name,str];
        }
    }
}

- (void)setNextIssueModel:(UGNextIssueModel *)nextIssueModel {
    _nextIssueModel = nextIssueModel;
    
    WeakSelf
    [self.countDown countDownWithPER_SECBlock:^{
        [weakSelf updateCloseLabelText];
    }];
    
    [self updateTotalLabelText];
    if ([@[@"7", @"11", @"9"] containsObject: self.nextIssueModel.gameId]) {
        [self.closeTimeLabel setHidden:true] ;
        self.titleLabel.text = [NSString stringWithFormat:@"%@ 下注明细", nextIssueModel.title];
    } else {
        self.titleLabel.text = [NSString stringWithFormat:@"第%@期 %@ 下注明细",nextIssueModel.curIssue,nextIssueModel.title];
    }
}

- (void)updateCloseLabelText{
    NSString *timeStr = [CMCommon getNowTimeWithEndTimeStr:self.nextIssueModel.curCloseTime currentTimeStr:self.nextIssueModel.serverTime];
    if (timeStr == nil) {
        timeStr = @"已封盘";
        //		NSLog(@"betDetailView time nil ++++++++++++++++++++++++++++++++++++++++++++++++++")
        //		if (self.betClickBlock) {
        //
        //			self.betClickBlock();
        //			[self hiddenSelf];
        //		}
        [self hiddenSelf];
    }
    self.closeTimeLabel.text = [NSString stringWithFormat:@"封盘时间：%@",timeStr];
    [self updateCloseLabel];
}

- (void)updateCloseLabel {
    if (APP.isTextWhite) {
        return;
    }
    if (self.closeTimeLabel.text.length) {
        
        //        NSMutableAttributedString *abStr = [[NSMutableAttributedString alloc] initWithString:self.closeTimeLabel.text];
        //        [abStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(3, self.closeTimeLabel.text.length - 3)];
        //        self.closeTimeLabel.attributedText = abStr;
        
        [CMLabelCommon setRichNumberWithLabel:self.closeTimeLabel Color:[UIColor redColor] FontSize:15.0];
    }
}

- (void)updateTotalLabelText {
    float totalAmount = 0.0;
    NSInteger num = 0;
    for (UGGameBetModel *model in self.betArray) {
        if ([@"连码" isEqualToString:model.typeName]) {
            if ([@"三中二" isEqualToString:model.title] ||
                [@"三全中" isEqualToString:model.title]) {
                
                num = [CMCommon pickNum:3 totalNum:self.dataArray.count];
                
            } else if ([@"二全中" isEqualToString:model.title] ||
                       [@"二中特" isEqualToString:model.title] ||
                       [@"特串" isEqualToString:model.title]) {
                
                num = [CMCommon pickNum:2 totalNum:self.dataArray.count];
                
            } else if ([@"四全中" isEqualToString:model.title]) {
                
                num = [CMCommon pickNum:4 totalNum:self.dataArray.count];
                
            } else if ([@"前二组选" isEqualToString:model.title]) {
                num = [CMCommon pickNum:2 totalNum:self.dataArray.count];
            } else if ([@"前三组选" isEqualToString:model.title]) {
                num = [CMCommon pickNum:3 totalNum:self.dataArray.count];
            } else if ([@"任选二" isEqualToString:model.title] ||
                       [@"选二连组" isEqualToString:model.title]) {
                
                num = [CMCommon pickNum:2 totalNum:self.dataArray.count];
            } else if ([@"任选三" isEqualToString:model.title] ||
                       [@"选三前组" isEqualToString:model.title]) {
                
                num = [CMCommon pickNum:3 totalNum:self.dataArray.count];
            } else if ([@"任选四" isEqualToString:model.title]) {
                
                num = [CMCommon pickNum:4 totalNum:self.dataArray.count];
            } else if ([@"任选五" isEqualToString:model.title]) {
                
                num = [CMCommon pickNum:5 totalNum:self.dataArray.count];
            } else {
                //                11选5 连码非组选等玩法
                num = 1;
                
            }
            totalAmount = model.money.floatValue * num;
            
        }
        else {
            
            totalAmount += model.money.floatValue;
        }
    }
    count = 0;
    if (num) {
        count = num;
    } else {
        count = self.betArray.count;
    }
    amount = [NSString stringWithFormat:@"%.2lf",totalAmount];
    self.totalAmountLabel.text = [NSString stringWithFormat:@"合计注数：%ld，总金额：¥%@",count,amount];
    
    NSMutableAttributedString *abStr = [[NSMutableAttributedString alloc] initWithString:self.totalAmountLabel.text];
    [abStr addAttribute:NSForegroundColorAttributeName value:Skin1.navBarBgColor range:NSMakeRange(5, [NSString stringWithFormat:@"%ld",count].length)];
    [abStr addAttribute:NSForegroundColorAttributeName value:Skin1.navBarBgColor range:NSMakeRange(5 + 5 + [NSString stringWithFormat:@"%ld",count].length, amount.length + 1)];
    
    self.totalAmountLabel.attributedText = abStr;
}

- (void)show {
    FastSubViewCode(self)
    if (Skin1.isBlack||Skin1.is23) {
        [self setBackgroundColor:Skin1.bgColor];
        [self.tableView setBackgroundColor:Skin1.bgColor];
        [_plView setBackgroundColor:Skin1.bgColor];
        [self.titleLabel setTextColor:[UIColor whiteColor]];
        [self.closeTimeLabel setTextColor:[UIColor whiteColor]];
        [self.totalAmountLabel setTextColor:[UIColor whiteColor]];
        [subLabel(@"号码label")setTextColor:[UIColor whiteColor]];
        [subLabel(@"赔率label")setTextColor:[UIColor whiteColor]];
        [subLabel(@"金额label")setTextColor:[UIColor whiteColor]];
        [subLabel(@"操作label")setTextColor:[UIColor whiteColor]];
        [_plTitleLab setTextColor:[UIColor whiteColor]];
        [_totalLabel setTextColor:[UIColor whiteColor]];
        [self.cancelButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        
        
    } else {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self.tableView setBackgroundColor:[UIColor whiteColor]];
        [self.titleLabel setTextColor:[UIColor blackColor]];
        [self.closeTimeLabel setTextColor:[UIColor blackColor]];
        [self.totalAmountLabel setTextColor:[UIColor blackColor]];
        [subLabel(@"号码label")setTextColor:[UIColor blackColor]];
        [subLabel(@"赔率label")setTextColor:[UIColor blackColor]];
        [subLabel(@"金额label")setTextColor:[UIColor blackColor]];
        [subLabel(@"操作label")setTextColor:[UIColor blackColor]];
        [self.cancelButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    }
    
    UIWindow* window = UIApplication.sharedApplication.keyWindow;
    UIView* view = self;
    if (!maskView) {
        maskView = [[UIScrollView alloc] initWithFrame:window.bounds];
        maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        [maskView addSubview:view];
        [window addSubview:maskView];
    }
    
    view.hidden = NO;
    
}

- (void)hiddenSelf {
    
    UIView* view = self;
    self.superview.backgroundColor = [UIColor clearColor];
    [view.superview removeFromSuperview];
    [view removeFromSuperview];
//     [SGBrowserView hide];
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 100, self.frame.size.width, self.frame.size.height - 210-30) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"UGBetDetailTableViewCell" bundle:nil] forCellReuseIdentifier:betDetailCellid];
        _tableView.rowHeight = 70;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
    }
    return _tableView;
}

- (NSMutableArray<UGBetModel *> *)betArray {
    if (_betArray == nil) {
        _betArray = [NSMutableArray array];
    }
    return _betArray;
}
- (IBAction)allUpBtnAction:(id)sender {
    NSString *number = _allUpText.text;
    
    for (UGGameBetModel *model in _betArray) {
        model.money = number;
    }
    [_tableView reloadData];
    
    [self performSelector:@selector(updateTotalLabelText) withObject:nil afterDelay:1.5];
    
}


#pragma mark -键盘监听方法
- (void)keyboardWasShown:(NSNotification *)notification
{
    // 获取键盘的高度
    //    CGRect frame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    maskView.contentOffset = CGPointMake(0,130);
    //或者
    //    [self.scrollView scrollRectToVisible:CGRectMake(0, 0, 300, 400) animated:NO];
    
}
- (void)keyboardWillBeHiden:(NSNotification *)notification
{
    maskView.frame = CGRectMake(0, 0, APP.Width, APP.Height);
}

@end

