//
//  UGLotteryAssistantController.m
//  ug
//
//  Created by ug on 2019/5/11.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGLotteryAssistantController.h"
#import "UGLotteryAssistantTableViewCell.h"
#import "UGChanglongaideModel.h"
#import "CountDown.h"

@interface UGLotteryAssistantController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewConstraintHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewBottom;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UITextField *amountLabel;
@property (weak, nonatomic) IBOutlet UIButton *betButton;
@property (weak, nonatomic) IBOutlet UIView *betDetailView;
@property (weak, nonatomic) IBOutlet UILabel *betDetailLabel;

@property (nonatomic, strong) CountDown *countDown;
@property (nonatomic, strong) CountDown *dataCountDown;

@property (nonatomic, strong) UGChanglongaideModel *selAideModel;
@property (nonatomic, strong) UGBetItemModel *selBetItem;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign)BOOL isHaveDian;

@end

static NSString *lotteryAssistantCellid = @"UGLotteryAssistantTableViewCell";
@implementation UGLotteryAssistantController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UGBackgroundColor;
    self.navigationItem.title = @"长龙助手";
    
    self.betDetailView.layer.cornerRadius = 5;
    self.betDetailView.layer.masksToBounds = YES;
    self.betDetailView.hidden = YES;
    self.amountLabel.delegate = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.rowHeight = 90;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 60, 0);
    if ([CMCommon isPhoneX]) {
        self.bottomViewConstraintHeight.constant = 80;
        self.bottomViewBottom.constant = 86;
    }else {
        self.bottomViewConstraintHeight.constant = 50;
        self.bottomViewBottom.constant = 64;
    
    }
    [self updateSelectLabelWithCount:0];
    self.countDown = [[CountDown alloc] init];
    self.dataCountDown = [[CountDown alloc] init];
    WeakSelf
    [self.countDown countDownWithPER_SECBlock:^{
        [weakSelf updateTimeInVisibleCells];

    }];
    
    
    
    [self getChanglong];
   
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getChanglong];
    }];
    SANotificationEventSubscribe(UGNotificationGetChanglongBetRecrod, self, ^(typeof (self) self, id obj) {
        [self.amountLabel resignFirstResponder];
    });
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:20 target:self selector:@selector(getChanglong) userInfo:nil repeats:true];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
}

- (void)getChanglong {
    [CMNetwork getChanglongWithParams:@{@"id":@"60"} completion:^(CMResult<id> *model, NSError *err) {
        [self.tableView.mj_header endRefreshing];
        [CMResult processWithResult:model success:^{
            if (model.data) {
                
                self.dataArray = model.data;
                [self.tableView reloadData];
            }
        } failure:^(id msg) {
            
        }];
    }];
}

- (void)updateTimeInVisibleCells {
    NSArray  *cells = self.tableView.visibleCells; //取出屏幕可见ceLl
    for (UGLotteryAssistantTableViewCell *cell in cells) {
        UGChanglongaideModel *model = self.dataArray[cell.tag];
        cell.item = model;
        
    }
}

- (IBAction)clearClick:(id)sender {
    for (UGChanglongaideModel *aideModel in self.dataArray) {
        for (UGBetItemModel *bet in aideModel.betList) {
            bet.select = NO;
        }
    }
    
    [self.tableView reloadData];
    [self updateSelectLabelWithCount:0];
    self.amountLabel.text = nil;
    self.betDetailView.hidden = YES;
    
}
- (IBAction)betClick:(id)sender {
   
    NSInteger count = 0;
    for (UGChanglongaideModel *aideModel in self.dataArray) {
        for (UGBetItemModel *bet in aideModel.betList) {
            if (bet.select) {
                count += 1;
                break;
            }
        }
    }
    if (!count) {
        [SVProgressHUD showInfoWithStatus:@"请选择您的注单"];
        return;
    }
    if (!self.amountLabel.text.length) {
        [SVProgressHUD showInfoWithStatus:@"请输入投注金额"];
        return;
    }
    NSString *amount = @"";
    // 判断是否有小数点
   if ([self.amountLabel.text containsString:@"."]) {
       NSArray *amountArray = [self.amountLabel.text componentsSeparatedByString:@"."];
       NSString *a1 = [amountArray objectAtIndex:0];
       NSString *a2 = [amountArray objectAtIndex:1];
       if (a2.length==1) {
          amount = [NSString stringWithFormat:@"%@.%@0",a1,a2];
       } else if(a2.length==2){
           amount = self.amountLabel.text ;
       }
       else{
           [self.navigationController.view makeToast:@"金额格式有误"
                                            duration:1.5
                                            position:CSToastPositionCenter];
           return ;
       }
       

   }else{
       amount =[NSString stringWithFormat:@"%@.00",self.amountLabel.text];
   }
    
    
    if ([CMCommon arryIsNull:self.dataArray]) {
        [self.navigationController.view makeToast:@"请输入投注金额"
                                         duration:1.5
                                         position:CSToastPositionCenter];
        return ;
    }
    [self.amountLabel resignFirstResponder];
    UGChanglongaideModel *betModel;
    UGBetItemModel *betItem;
    for (UGChanglongaideModel *aideModel in self.dataArray) {
        for (UGBetItemModel *bet in aideModel.betList) {
            if (bet.select) {
//                bet.select = NO;
                betItem = bet;
                betModel = aideModel;
            }
        }
    }
    NSDictionary *dict = @{
                           @"token":[UGUserModel currentUser].sessid,
                           @"gameId":betModel.gameId,
                           @"betIssue":betModel.issue,
                           @"totalNum":@"1",
                           @"totalMoney":amount,
                           @"endTime":[betModel.closeTime timeStrToTimeInterval],
                           @"tag":@"1"
                           };
    
    NSMutableDictionary *mutDict = [[NSMutableDictionary alloc] initWithDictionary:dict];
    NSString *playId = @"betBean[0][playId]";
    NSString *money = @"betBean[0][money]";
    NSString *odds = @"betBean[0][betInfo]";
    NSString *rebate = @"betBean[0][playIds]";

    [mutDict setValue:betItem.playId forKey:playId];
    [mutDict setValue:amount forKey:money];
    [mutDict setObject:@"" forKey:odds];
    [mutDict setObject:@"" forKey:rebate];
    
    [SVProgressHUD showWithStatus:nil];
    [CMNetwork userBetWithParams:mutDict completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            [SVProgressHUD showSuccessWithStatus:model.msg];
            SANotificationEventPost(UGNotificationGetUserInfo, nil);
            betItem.select = NO;
            self.selBetItem = nil;
            [self.tableView reloadData];
            [self clearClick:nil];
        } failure:^(id msg) {
            [SVProgressHUD showErrorWithStatus:msg];
            
        }];
    }];
   
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UGLotteryAssistantTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lotteryAssistantCellid forIndexPath:indexPath];
    UGChanglongaideModel *model = self.dataArray[indexPath.row];
    cell.item = model;
    cell.tag = indexPath.row;
    WeakSelf
    cell.betItemSelectBlock = ^(NSInteger index) {
       
        UGBetItemModel *item = model.betList[index];
        item.select = !item.select;
        
        for (UGChanglongaideModel *aideModel in weakSelf.dataArray) {
            for (UGBetItemModel *bet in aideModel.betList) {
                if (bet != item) {
                    bet.select = NO;
                    
                }
            }
        }
        
        
        [weakSelf.tableView reloadData];
        if (item.select) {
            weakSelf.selAideModel = model;
            weakSelf.selBetItem = item;
            [weakSelf updateSelectLabelWithCount:1];
            if (!weakSelf.amountLabel.text.length) {
                return ;
            }
            weakSelf.betDetailView.hidden = NO;
            float total = weakSelf.amountLabel.text.floatValue * item.odds.floatValue;
            weakSelf.betDetailLabel.text = [NSString stringWithFormat:@"%@，%@，%@ 奖金:%.4f",weakSelf.selAideModel.title,weakSelf.selAideModel.playCateName,weakSelf.selBetItem.playName,total];
            [weakSelf updateBetDetailLabelTextColor];
            
        }else {
            weakSelf.betDetailView.hidden = YES;
            weakSelf.selAideModel = nil;
            [weakSelf updateSelectLabelWithCount:0];
        }
        
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.001f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}

- (void)updateSelectLabelWithCount:(NSInteger )count {
    self.countLabel.text = [NSString stringWithFormat:@"共 %ld 注",count];
    NSMutableAttributedString *abstr = [[NSMutableAttributedString alloc] initWithString:self.countLabel.text];
    [abstr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(2, self.countLabel.text.length - 4)];
    self.countLabel.attributedText = abstr;
    
}

- (void)updateBetDetailLabelTextColor {
    NSMutableAttributedString *abstr = [[NSMutableAttributedString alloc] initWithString:self.betDetailLabel.text];
    [abstr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(self.selAideModel.title.length + self.selAideModel.playCateName.length + self.selBetItem.playName.length + 3, self.betDetailLabel.text.length - self.selAideModel.title.length - self.selAideModel.playCateName.length - self.selBetItem.playName.length - 3)];
    self.betDetailLabel.attributedText = abstr;
}

#pragma mark - textfield delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == self.amountLabel) {
        /*
           * 不能输入.0-9以外的字符。
           * 设置输入框输入的内容格式
           * 只能有一个小数点
           * 小数点后最多能输入两位
           * 如果第一位是.则前面加上0.
           * 如果第一位是0则后面必须输入点，否则不能输入。
           */
            // 判断是否有小数点
          if ([textField.text containsString:@"."]) {
              self.isHaveDian = YES;
          }else{
              self.isHaveDian = NO;
          }
          
          if (string.length > 0) {
              
              //当前输入的字符
              unichar single = [string characterAtIndex:0];

          
              // 不能输入.0-9以外的字符
              if (!((single >= '0' && single <= '9') || single == '.'))
              {
                  [self.navigationController.view makeToast:@"您的输入格式不正确"
                                                                   duration:1.0
                                                                   position:CSToastPositionCenter];
                  return NO;
              }
          
              // 只能有一个小数点
              if (self.isHaveDian && single == '.') {
                  [self.navigationController.view makeToast:@"最多只能输入一个小数点"
                                                                                    duration:1.0
                                                                                    position:CSToastPositionCenter];
                  return NO;
              }
              
              // 如果第一位是.则前面加上0.
              if ((textField.text.length == 0) && (single == '.')) {
                  textField.text = @"0";
              }
              
              // 如果第一位是0则后面必须输入点，否则不能输入。
              if ([textField.text hasPrefix:@"0"]) {
                  if (textField.text.length > 1) {
                      NSString *secondStr = [textField.text substringWithRange:NSMakeRange(1, 1)];
                      if (![secondStr isEqualToString:@"."]) {
                          [self.navigationController.view makeToast:@"第二个字符需要是小数点"
                                                                                                            duration:1.0
                                                                                                            position:CSToastPositionCenter];
                          return NO;
                      }
                  }else{
                      if (![string isEqualToString:@"."]) {
                          [self.navigationController.view makeToast:@"第二个字符需要是小数点"
                                                                                                                                    duration:1.0
                                                                                                                                    position:CSToastPositionCenter];
                          return NO;
                      }
                  }
              }
              
              // 小数点后最多能输入两位
              if (self.isHaveDian) {
                  NSRange ran = [textField.text rangeOfString:@"."];
                  // 由于range.location是NSUInteger类型的，所以这里不能通过(range.location - ran.location)>2来判断
                  if (range.location > ran.location) {
                      if ([textField.text pathExtension].length > 1) {
                          [self.navigationController.view makeToast:@"小数点后最多有两位小数"
                          duration:1.0
                          position:CSToastPositionCenter];
                          return NO;
                      }
                  }
              }
        
          }

          return YES;
    }
    
    
    if ([string isEqualToString:@"\n"]) {
        [self.amountLabel resignFirstResponder];
        return NO;
    }
    if (!self.selBetItem) {
        return YES;
    }
    NSString *amount = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (amount.length) {
        self.betDetailView.hidden = NO;
        float total = amount.floatValue * self.selBetItem.odds.floatValue;
        self.betDetailLabel.text = [NSString stringWithFormat:@"%@，%@，%@ 奖金:%.4f",self.selAideModel.title,self.selAideModel.playCateName,self.selBetItem.playName,total];
        [self updateBetDetailLabelTextColor];
    }else {
        
        self.betDetailView.hidden = YES;
    }
    return YES;
}

- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];

    }
    return _dataArray;
}

@end
