//
//  YNBetDetailView.m
//  UGBWApp
//
//  Created by ug on 2020/8/24.
//  Copyright © 2020 ug. All rights reserved.
//

#import "YNBetDetailView.h"
#import "CountDown.h"
#import "Global.h"
#import "UGBetResultView.h" /**<   金杯的视图 */
#import "UGBetDetailModel.h"
#import "YNBetCollectionViewCell.h"

@interface YNBetDetailView ()<UICollectionViewDelegate, UICollectionViewDataSource,WSLWaterFlowLayoutDelegate>{
    
    NSInteger count;  /**<   总注数*/
    UIScrollView* maskView;
}
@property (nonatomic, strong) WSLWaterFlowLayout *flow;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) CountDown *countDown;
@property (nonatomic, strong) NSMutableArray <UGBetModel *> *betArray;

@property (nonatomic)int singleNote;/**<  总金/ 注数*/

@property (weak, nonatomic) IBOutlet UILabel *titellabel;           /**<   标题*/
@property (weak, nonatomic) IBOutlet UILabel *BatchNumberLabel;   /**<   批号*/
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;        /**<  组合数*/
@property (weak, nonatomic) IBOutlet UITextField *multipleTF;     /**<  倍、注数*/
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel; /**<   总金额Label */

@property (weak, nonatomic) IBOutlet UIButton *submitButton;    /**<   确认下注Button */
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;    /**<   取消Button */
@property (weak, nonatomic) IBOutlet UILabel *mxLabel;         /**<   组合明细lable*/

@property (nonatomic) float amount; /**<   总金额*/
@end


static NSString *ID=@"YNBetCollectionViewCell";
@implementation YNBetDetailView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];

}

- (instancetype)init {
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"YNBetDetailView" owner:self options:0].firstObject;
        
        float h = 0;
        h = UGScerrnH - 300;
        
        if (h<600) {
            h =600;
        }
 
        self.size = CGSizeMake(UGScreenW - 50, h);
        self.center = CGPointMake(UGScreenW / 2 , UGScerrnH / 2);
        self.submitButton.layer.cornerRadius = 3;
        self.submitButton.layer.masksToBounds = YES;
        
        self.cancelButton.layer.cornerRadius = 3;
        self.cancelButton.layer.masksToBounds = YES;
        self.cancelButton.layer.borderColor = Skin1.bgColor.CGColor;
        self.cancelButton.layer.borderWidth = 0.7;
        
        
        
        self.layer.cornerRadius = 6;
        self.layer.masksToBounds = YES;
        
        self.flow = [[WSLWaterFlowLayout alloc] init];
        self.flow.delegate = self;
        self.flow.flowLayoutStyle = WSLWaterFlowVerticalEqualHeight;
        [self.collectionView setCollectionViewLayout:self.flow];
        [self.collectionView registerNib:[UINib nibWithNibName:@"YNBetCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:ID];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;

        
        self.countDown = [[CountDown alloc] init];
        SANotificationEventSubscribe(UGNotificationloginTimeout, self, ^(typeof (self) self, id obj) {
            [self hiddenSelf];
        });
        
       
        [self.multipleTF addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
#pragma mark -键盘弹出添加监听事件
        // 键盘出现的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
        // 键盘消失的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHiden:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)show {
    FastSubViewCode(self)
    if (Skin1.isBlack||Skin1.is23) {
        [self setBackgroundColor:Skin1.bgColor];
        [self.collectionView setBackgroundColor:Skin1.bgColor];
        
        [self.BatchNumberLabel setTextColor:[UIColor whiteColor]];
        [self.numberLabel setTextColor:[UIColor whiteColor]];
        [self.totalAmountLabel setTextColor:[UIColor whiteColor]];
        [subLabel(@"批号lable")setTextColor:[UIColor whiteColor]];
        [subLabel(@"组合数label")setTextColor:[UIColor whiteColor]];
        [subLabel(@"倍数label")setTextColor:[UIColor whiteColor]];
        [subLabel(@"总金额label")setTextColor:[UIColor whiteColor]];
        [self.cancelButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        
        
    } else {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self.collectionView setBackgroundColor:[UIColor whiteColor]];
        [self.BatchNumberLabel setTextColor:[UIColor blackColor]];
        [self.numberLabel setTextColor:[UIColor blackColor]];
        [self.totalAmountLabel setTextColor:[UIColor blackColor]];
        
        [subLabel(@"批号lable")setTextColor:[UIColor blackColor]];
        [subLabel(@"组合数label")setTextColor:[UIColor blackColor]];
        [subLabel(@"倍数label")setTextColor:[UIColor blackColor]];
        [subLabel(@"总金额label")setTextColor:[UIColor blackColor]];
        [self.cancelButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    }
    
    [self.mxLabel setHidden:self.isHide];

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

- (void)setDataArray:(NSArray<UGGameBetModel *> *)dataArray {
    _dataArray = dataArray;
    NSMutableArray *array = [NSMutableArray array];
   
    for (UGGameBetModel *model in dataArray) {
        UGBetModel *bet = [[UGBetModel alloc] init];
        bet.money = model.money;
        bet.playId = model.playId;
        bet.title = model.title;
        bet.name = model.name;
        bet.odds = model.odds;
        bet.alias = model.alias;
        bet.typeName = model.typeName;
        bet.betInfo = model.betInfo;
        [array addObject:bet];
       
    }
    
    self.betArray = array.mutableCopy;
    

    [_collectionView reloadData];

    self.numberLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)array.count];
    

}

- (void)setNextIssueModel:(UGNextIssueModel *)nextIssueModel {
    _nextIssueModel = nextIssueModel;
    

    if (self.nextIssueModel.isInstant) {
        self.titellabel.text = [NSString stringWithFormat:@"%@ 下注明细", nextIssueModel.title];
    } else {
        if (![CMCommon stringIsNull:nextIssueModel.displayNumber]) {
            self.titellabel.text = [NSString stringWithFormat:@"第%@期 %@ 下注明细",nextIssueModel.displayNumber,nextIssueModel.title];
        } else {
            self.titellabel.text = [NSString stringWithFormat:@"第%@期 %@ 下注明细",nextIssueModel.curIssue,nextIssueModel.title];
        }
    }
    

    int multip = self.nextIssueModel.multipleStr.intValue;//倍数
    int totalAmount = self.nextIssueModel.totalAmountStr.intValue;//金额
    self.amount = totalAmount  * multip * 1.0 ;
    self.BatchNumberLabel.text = self.nextIssueModel.defnameStr;
    self.multipleTF.text = self.nextIssueModel.multipleStr;
    self.totalAmountLabel.text = [NSString stringWithFormat:@"%.2f",self.amount ];
    FastSubViewCode(self);
    [subLabel(@"批号lable") setText:[NSString stringWithFormat:@"%@:",self.nextIssueModel.defname]];
    
    self.singleNote =  totalAmount  /  multip;
 
}



- (void)hiddenSelf {
    
    UIView* view = self;
    self.superview.backgroundColor = [UIColor clearColor];
    [view.superview removeFromSuperview];
    [view removeFromSuperview];
}

- (IBAction)cancelClick:(id)sender {
    
    [self hiddenSelf];
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

- (IBAction)submitClick:(id)sender {
    if (!self.dataArray.count) {
        [SVProgressHUD showInfoWithStatus:@"投注信息有误"];
        return;
    }
    if (!self.multipleTF.text.length) {
        [SVProgressHUD showInfoWithStatus:@"倍数不能为空或者0"];
        return;
    }
    int multip = self.multipleTF.text.intValue;
    if (multip == 0) {
        [SVProgressHUD showInfoWithStatus:@"倍数不能为空或者0"];
        return;
    }

    NSInteger totalNum = 0;
    totalNum = self.betArray.count;
    
    NSString *amount = [NSString stringWithFormat:@"%.2f",self.amount ];
    if ([CMCommon stringIsNull:[UGUserModel currentUser].sessid]) {
        return;
    }
    
    NSDictionary *dict = @{
        @"token":[UGUserModel currentUser].sessid,
        @"gameId":self.nextIssueModel.gameId,
        @"betIssue":self.nextIssueModel.curIssue,
        @"endTime":[self.nextIssueModel.curCloseTime timeStrToTimeInterval],
        @"totalNum":[NSString stringWithFormat:@"%ld",totalNum],
        @"totalMoney":amount,
        @"betMultiple":self.multipleTF.text,
        @"turnNum":self.nextIssueModel.curIssue,
        @"betSrc":@"0",
    };
    
    NSMutableDictionary *mutDict = [[NSMutableDictionary alloc] initWithDictionary:dict];
    NSString *str = [self.nextIssueModel.defnameStr stringByReplacingOccurrencesOfString:@"【" withString:@""];
    NSString *str2 = [str stringByReplacingOccurrencesOfString:@"】" withString:@""];
    
    for (int i = 0; i < 1; i++) {
        NSString *playId = [NSString stringWithFormat:@"betBean[%d][playId]",i];
        NSString *money = [NSString stringWithFormat:@"betBean[%d][money]",i];
        NSString *betInfo = [NSString stringWithFormat:@"betBean[%d][betInfo]",i];
        NSString *name = [NSString stringWithFormat:@"betBean[%d][name]",i];
        NSString *odds = [NSString stringWithFormat:@"betBean[%d][odds]",i];
        NSString *rebate = [NSString stringWithFormat:@"betBean[%d][rebate]",i];
        UGBetModel *bet = self.betArray[i];
        [mutDict setValue:bet.playId forKey:playId];
        [mutDict setObject:str2 forKey:betInfo];
        [mutDict setObject:str2 forKey:name];
        [mutDict setValue:@"0" forKey:rebate];
        NSString *moneyStr = [NSString stringWithFormat:@"%.2f",bet.money.floatValue];
        [mutDict setObject:bet.money.length ? moneyStr : @"" forKey:money];
        [mutDict setObject:bet.odds.length ? bet.odds : @"" forKey:odds];
        
    }

    [self submitBet:mutDict];
        
}

- (void)submitBet:(NSDictionary *)params {
    [SVProgressHUD showWithStatus:nil];
    WeakSelf;
    [CMNetwork userBetWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            [SVProgressHUD dismiss];

            // 秒秒彩系列（即时开奖无需等待）
            if (weakSelf.nextIssueModel.isInstant) {
                BOOL showSecondLine = [@[@"11"] containsObject:weakSelf.nextIssueModel.gameId]; // 六合秒秒彩
                UGBetDetailModel *mod = (UGBetDetailModel *)model.data;
                mod.gameId = self.nextIssueModel.gameId;
                
                UGBetResultView *bet = [[UGBetResultView alloc] initWithShowSecondLine:showSecondLine];
                
                [bet showWith:mod showSecondLine:showSecondLine timerAction:^(dispatch_source_t  _Nonnull timer) {
                    [weakSelf submitBet:params];
                }];
            }
           
            [weakSelf hiddenSelf];
            [SVProgressHUD showSuccessWithStatus:model.msg];
            SANotificationEventPost(UGNotificationGetUserInfo, nil);
            if (weakSelf.betClickBlock) {
                weakSelf.betClickBlock();
            }
          
            
            
        } failure:^(id msg) {
            [SVProgressHUD dismiss];
            
            UIAlertController * alert = [UIAlertController alertWithTitle:@"投注失败" msg:msg btnTitles:@[@"确定"]];
            [NavController1 presentViewController:alert animated:true completion:nil];
            
            NSString *msgStr = (NSString *)msg;
            if ([msgStr containsString:@"已封盘"]) {
                [weakSelf hiddenSelf];
                if (weakSelf.betClickBlock) {
                    weakSelf.betClickBlock();
                
                }
            }
        }];
    }];
}


- (NSMutableArray<UGBetModel *> *)betArray {
    if (_betArray == nil) {
        _betArray = [NSMutableArray array];
    }
    return _betArray;
}

#pragma mark - UICollectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return _dataArray.count;
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    YNBetCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    UGGameBetModel *model = [_dataArray objectAtIndex:indexPath.row];
    

    cell.item = model;
    cell.numberLabel.text = [NSString stringWithFormat:@"%ld.",indexPath.row +1];
    
    [cell setHidden:self.isHide];
    
    return cell;
}



#pragma mark - WSLWaterFlowLayoutDelegate

//返回每个item大小
- (CGSize)waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return  CGSizeMake((self.frame.size.width-30)/3, 26);
}

/** 头视图Size */
-(CGSize )waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout sizeForHeaderViewInSection:(NSInteger)section {
    return CGSizeMake(self.frame.size.width - 1, 1);
}

/** 列间距*/
-(CGFloat)columnMarginInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout {

    return 5;
}
/** 行间距*/
-(CGFloat)rowMarginInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout {

    return 5;
}
/** 边缘之间的间距*/
-(UIEdgeInsets)edgeInsetInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout {

    return UIEdgeInsetsMake(1, 1, 1, 1);
}

#pragma mark -键盘监听方法
- (void)keyboardWasShown:(NSNotification *)notification
{
    maskView.contentOffset = CGPointMake(0,130);
}
- (void)keyboardWillBeHiden:(NSNotification *)notification
{
    maskView.frame = CGRectMake(0, 0, APP.Width, APP.Height);
}
#pragma mark -textfield添加事件，只要值改变就调用此函数
-(void)changedTextField:(UITextField *)textField
{

    int multip = textField.text.intValue;
    
    if (multip > 0) {
         float totalAmount = 0.0;
         for (UGBetModel *model in self.betArray) {
             
             NSLog(@"model.money = %.2f",model.money.floatValue);
             totalAmount += model.money.floatValue;
         }
        NSLog(@"multip值是---%d",multip);
        NSLog(@"值是---%.2f",totalAmount);
         self.amount = totalAmount * multip;
        NSLog(@"值是---%.2f",self.amount);
        self.totalAmountLabel.text = [NSString stringWithFormat:@"%.2lf",self.amount];
     }

}
@end
