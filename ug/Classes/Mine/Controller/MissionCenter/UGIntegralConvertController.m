//
//  UGIntegralConvertController.m
//  ug
//
//  Created by ug on 2019/5/16.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGIntegralConvertController.h"
#import "UGConvertCollectionViewCell.h"
#import "UGMissionLevelModel.h"
#import "UGSystemConfigModel.h"


@interface UGIntegralConvertController ()<UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *convertView;
@property (weak, nonatomic) IBOutlet UITextField *inputTextF;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *dataArray;


@end

static NSString *integralCellid = @"UGConvertCollectionViewCell";
@implementation UGIntegralConvertController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.convertView.layer.cornerRadius = 3;
    self.convertView.layer.masksToBounds = YES;
    self.convertView.layer.borderColor = UGBackgroundColor.CGColor;
    self.convertView.layer.borderWidth = 1;
    self.submitButton.layer.cornerRadius = 3;
    self.submitButton.layer.masksToBounds = YES;
    self.inputTextF.delegate = self;
    [self initCollectionView];
    
//<<<<<<< HEAD
//     UGSystemConfigModel *config = [UGSystemConfigModel currentConfig];
//    NSString *str1 = [NSString stringWithFormat:@"%@%@:1元人民币",config.missionBili,config.missionName];
//    self.titleLabel.text = str1;
//=======
//     UGSystemConfigModel *config = [UGSystemConfigModel currentConfig];

//>>>>>>> bug
    
        [self getSystemConfig];
}

- (IBAction)submitButton:(id)sender {
    

        [self creditsExchangeData:self.inputTextF.text];

    
}


- (void)initCollectionView {
    
    float itemW = (UGScreenW - 5 * 6) / 5;
    UICollectionViewFlowLayout *layout = ({
        
        layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(itemW, 40);
        layout.minimumInteritemSpacing = 5;
        layout.minimumLineSpacing = 5;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout;
        
    });
    
    UICollectionView *collectionView = ({
        
        collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(5, 170, UGScreenW, 50) collectionViewLayout:layout];
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        [collectionView registerNib:[UINib nibWithNibName:@"UGConvertCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:integralCellid];
        
        collectionView;
        
    });
    
    self.collectionView = collectionView;
    [self.view addSubview:collectionView];
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UGConvertCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:integralCellid forIndexPath:indexPath];
    cell.item = self.dataArray[indexPath.row];
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UGMissionLevelModel *model = self.dataArray[indexPath.row];
    
    if ([model.integral isEqualToString:@"全部兑换"]) {
        UGUserModel *user = [UGUserModel currentUser];
        self.inputTextF.text = user.taskReward;
        UGSystemConfigModel *config = [UGSystemConfigModel currentConfig];
         double biliDouble = [ config.missionBili doubleValue];
        NSLog(@"biliDouble = %f",biliDouble);
         double taskRewardDouble = [ user.taskReward doubleValue];
        self.amountLabel.text = [NSString stringWithFormat:@"%.4lf",taskRewardDouble / biliDouble];
    } else {
        self.inputTextF.text = model.integral;
        UGSystemConfigModel *config = [UGSystemConfigModel currentConfig];
        double biliDouble = [ config.missionBili doubleValue];
        NSLog(@"biliDouble = %f",biliDouble);
        self.amountLabel.text = [NSString stringWithFormat:@"%.4lf",model.integral.doubleValue / biliDouble];
    }
  
    
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.text == nil) {
        self.amountLabel.text = @"获得人民币";
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        [self.inputTextF resignFirstResponder];
        return NO;
    }
    NSString *text =  [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (text) {
        UGSystemConfigModel *config = [UGSystemConfigModel currentConfig];
        double biliDouble = [ config.missionBili doubleValue];
        self.amountLabel.text = [NSString stringWithFormat:@"%.4lf",text.doubleValue / biliDouble];
    }else {
        self.amountLabel.text = @"获得人民币";
    }
    return YES;
}

- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
        UGMissionLevelModel *model0 =  [[UGMissionLevelModel alloc] init];
        model0.integral = @"10.0000";
        
        UGMissionLevelModel *model1 =  [[UGMissionLevelModel alloc] init];
        model1.integral = @"50.0000";
        
        UGMissionLevelModel *model2 =  [[UGMissionLevelModel alloc] init];
        model2.integral = @"100.0000";
        
        UGMissionLevelModel *model3 =  [[UGMissionLevelModel alloc] init];
        model3.integral = @"500.0000";
        
        UGMissionLevelModel *model4 =  [[UGMissionLevelModel alloc] init];
        model4.integral = @"全部兑换";
        
        [_dataArray addObject:model0];
        [_dataArray addObject:model1];
        [_dataArray addObject:model2];
        [_dataArray addObject:model3];
        [_dataArray addObject:model4];
    }
    return _dataArray;
}

#pragma mark -- 网络请求

//积分兑换
- (void)creditsExchangeData:(NSString *)money {
    
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid,
                             @"money":money
                             };
    
    [SVProgressHUD showWithStatus:nil];
    //    WeakSelf;
    [CMNetwork taskCreditsExchangeWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            
//            [SVProgressHUD showSuccessWithStatus:model.msg];
             [SVProgressHUD showSuccessWithStatus:@"兑换成功"];
            self.inputTextF.text =@"";
            self.amountLabel.text = @"";
            
            
        } failure:^(id msg) {
            
            [SVProgressHUD showErrorWithStatus:msg];
            
        }];
    }];
}

- (void)getSystemConfig {
    
    [CMNetwork getSystemConfigWithParams:@{} completion:^(CMResult<id> *model, NSError *err) {
       
        [CMResult processWithResult:model success:^{
            
            NSLog(@"model = %@",model);
            
            UGSystemConfigModel *config = model.data;
            UGSystemConfigModel.currentConfig = config;
            
            
            if ([config.isIntToMoney isEqualToString:@"0"]) {
                [self.submitButton setEnabled:NO];
                self.submitButton.alpha = 0.4;
                [self.submitButton setTitle:@"暂未开启" forState:UIControlStateNormal];
            } else {
                [self.submitButton setEnabled:YES];
                self.submitButton.alpha = 1;
                [self.submitButton setTitle:@"确认兑换" forState:UIControlStateNormal];
            }
            
            NSString *str1 = [NSString stringWithFormat:@"%@%@:1元人民币",config.missionBili,config.missionName];
            self.titleLabel.text = str1;
            self.inputTextF.placeholder = [NSString stringWithFormat:@"请输入%@",config.missionName];
            
        } failure:^(id msg) {
            
        }];
    }];
}
@end
