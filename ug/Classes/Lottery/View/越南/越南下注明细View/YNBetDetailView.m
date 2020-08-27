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
#import "YNQuickListCollectionViewCell.h"

@interface YNBetDetailView ()<UICollectionViewDelegate, UICollectionViewDataSource,WSLWaterFlowLayoutDelegate>{
    
    NSInteger count;  /**<   总注数*/
    UIScrollView* maskView;
}
@property (nonatomic, strong) WSLWaterFlowLayout *flow;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) CountDown *countDown;
@property (nonatomic, strong) NSMutableArray <UGBetModel *> *betArray;

@property (weak, nonatomic) IBOutlet UILabel *titellabel;           /**<   标题*/
@property (weak, nonatomic) IBOutlet UILabel *BatchNumberLabel;   /**<   批号*/
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;        /**<  组合数*/
@property (weak, nonatomic) IBOutlet UITextField *multipleTF;     /**<  倍数*/
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel; /**<   总金额Label */

@property (weak, nonatomic) IBOutlet UIButton *submitButton;    /**<   确认下注Button */
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;    /**<   取消Button */
@end


static NSString *ID=@"YNQuickListCollectionViewCell";
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
        [self.collectionView registerNib:[UINib nibWithNibName:@"YNQuickListCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:ID];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        
   
        
        self.countDown = [[CountDown alloc] init];
        SANotificationEventSubscribe(UGNotificationloginTimeout, self, ^(typeof (self) self, id obj) {
            [self hiddenSelf];
        });
        
       
        
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
}

- (IBAction)cancelClick:(id)sender {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
    [self hiddenSelf];
}

- (IBAction)submitClick:(id)sender {
    
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
    
    float h = 0;
    if (self.dataArray.count < 5) {
        h = 400;
    } else {
        h = 440 + 40 * self.dataArray.count/5;
    }
    self.size = CGSizeMake(UGScreenW - 50, h);
    self.center = CGPointMake(UGScreenW / 2 , UGScerrnH / 2);

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
    
    YNQuickListCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    UGGameBetModel *model = [_dataArray objectAtIndex:indexPath.row];
    cell.item = model;
    return cell;
}



#pragma mark - WSLWaterFlowLayoutDelegate

//返回每个item大小
- (CGSize)waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return  CGSizeMake((self.frame.size.width-30) / 5, 26);
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

@end
