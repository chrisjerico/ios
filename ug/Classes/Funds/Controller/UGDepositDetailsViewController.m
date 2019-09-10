//
//  UGDepositDetailsViewController.m
//  ug
//
//  Created by ug on 2019/9/10.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGDepositDetailsViewController.h"
#import "UGDepositDetailsCollectionViewCell.h"
#import "UGdepositModel.h"
@interface UGDepositDetailsViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong)UITextField *textField;
@property (nonatomic, strong) UICollectionView *collectionView ;
@property (nonatomic, strong) NSArray *channelDataArray;
@property (nonatomic, strong) NSMutableArray *amountDataArray;

@end

@implementation UGDepositDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _amountDataArray = [NSMutableArray new];
    _channelDataArray = [NSArray new];
    [self creatUI];
    
    if (self.item) {
        [self setUIData];
    }

    
}
#pragma mark -UIData
- (void)setUIData{

    
    self.item.quickAmount;//当fixedAmount为空时，用这个
    
    self.item.prompt;//==>提示用
    _item.transferPrompt ;//==>提示用
    _channelDataArray = _item.channel;
    
    if (_channelDataArray.count) {
    
//        for (int i = 0; i<_channelDataArray.count; i++) {
//            UGchannelModel *channelModel = [_channelDataArray objectAtIndex:i];
//
//            //单选按钮显示用
//            channelModel.name;//支付宝（安亿支付原生通道）",
//
//            UGparaModel *bankModel= channelModel.para;
//
//             bankModel.bankList;//显示银行数据
//            bankModel.fixedAmount;// 判断是否为空，为空用
//
//        }
        UGchannelModel *channelModel = [_channelDataArray objectAtIndex:0];

        //单选按钮显示用
        channelModel.name;//支付宝（安亿支付原生通道）",

        UGparaModel *bankModel= channelModel.para;

         bankModel.bankList;//显示银行数据
        bankModel.fixedAmount;// 判断是否为空，为空用
        
        if ([CMCommon stringIsNull:bankModel.fixedAmount]) {
            
            self.amountDataArray = [[NSMutableArray alloc] initWithArray:_item.quickAmount];
        }
        else{
            
            NSArray  *array = [bankModel.fixedAmount componentsSeparatedByString:@" "];
             self.amountDataArray = [[NSMutableArray alloc] initWithArray:array];
        }
        int height ;
        
        if ([CMCommon judgeStr:(int)self.amountDataArray.count with:3]) {
            //能整除   高度
            int verticalCount = (int)self.amountDataArray.count/3;
            height = 20*2+verticalCount*40 + (verticalCount -1)*10;
        } else {
            int verticalCount = (int)self.amountDataArray.count/3  +1;
             height = 20*2+verticalCount*40 + (verticalCount -1)*10;
        }
        
        [self.collectionView  mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.left.equalTo(self.view.mas_left).with.offset(0);
             make.right.equalTo(self.view.mas_right).with.offset(0);
             make.width.equalTo(self.view.mas_width);
             make.height.mas_equalTo(height);
             make.top.equalTo(self.textField.mas_bottom).offset(0);
             
         }];
        [self.collectionView reloadData];
        
    }
    
}


#pragma mark: - 判断是否能够被整除

-(BOOL)judgeStr:(int )number1 with:(int )number2
{
    
    
    if (fmod(number1, number2)== 0) {
        
        return YES;
    }
    else{
         return NO;
    }
   
}

#pragma mark -UI
-(void)creatUI{
    
    if (self.textField==nil) {
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 10, UGScreenW-40, 40)];
        textField.placeholder = @"请输入存款金额";
        textField.textColor = [UIColor blackColor];
        textField.font = [UIFont systemFontOfSize:14];
        textField.textAlignment = NSTextAlignmentLeft;
        textField.clearButtonMode = UITextFieldViewModeUnlessEditing;
        [self.view addSubview:textField];
        textField.keyboardType = UIKeyboardTypeDecimalPad;
        textField.borderStyle = UITextBorderStyleRoundedRect;
        self.textField = textField;
    }
    
    
    if (self.collectionView==nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake((self.view.frame.size.width-60 ) / 3, 40);
        layout.minimumLineSpacing = 10.0; // 竖
        layout.minimumInteritemSpacing = 10.0; // 横
        layout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
        
        UICollectionView *collectionView = ({
            
            collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0 , 50, UGScreenW  , 500) collectionViewLayout:layout];
            collectionView.backgroundColor = UGRGBColor(239, 239, 244);
            collectionView.dataSource = self;
            collectionView.delegate = self;
            [collectionView registerNib:[UINib nibWithNibName:@"UGDepositDetailsCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"UGDepositDetailsCollectionViewCell"];
            
            collectionView;
            
        });
        [self.view addSubview:collectionView ];
        self.collectionView = collectionView;
    }
    
   
}


#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _amountDataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  
    UGDepositDetailsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UGDepositDetailsCollectionViewCell" forIndexPath:indexPath];
    cell.myStr = [_amountDataArray objectAtIndex:indexPath.row];

    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%ld分区---%ldItem", indexPath.section, indexPath.row);
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
