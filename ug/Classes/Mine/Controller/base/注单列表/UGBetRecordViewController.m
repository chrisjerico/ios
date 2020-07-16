//
//  UGBetRecordViewController.m
//  ug
//
//  Created by ug on 2019/5/6.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGBetRecordViewController.h"
#import "UGRecordFilterCollectionViewCell.h"
#import "STBarButtonItem.h"
#import "SRActionSheet.h"
#import "UGBetRecordTableViewController.h"
#import "STButton.h"
#import "MOFSPickerManager.h"
#import "YBPopupMenu.h"
#import "UGNotDetailViewController.h"
@implementation SModel


@end
@interface UGBetRecordViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,XYYSegmentControlDelegate,YBPopupMenuDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UGNotDetailViewController *detailVC;

@property (nonatomic,strong)  NSArray <NSString *> *filterItemArray; /**<   筛选时间 */
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UILabel *amountLabel;     /**<   金额 */
@property (nonatomic, strong) NSArray <NSString *> *itemArray;
@property (nonatomic, strong) NSMutableArray <NSString *> *dateArray;
@property (nonatomic, strong) NSMutableArray <UIViewController *> *controllersArray;
@property (nonatomic, assign) NSInteger dateIndex;
@property (nonatomic, assign) NSInteger controllerIndex;
@end

static NSString *recordFilterCellid = @"UGRecordFilterCollectionViewCell";
@implementation UGBetRecordViewController

- (void)skin {
    [self.view setBackgroundColor: Skin1.bgColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    if (!self.title) {
        self.title = @"投注记录";
    }
    [self.view setBackgroundColor: Skin1.bgColor];
    SANotificationEventSubscribe(UGNotificationWithSkinSuccess, self, ^(typeof (self) self, id obj) {
        
        [self skin];
    });
    self.dateIndex = 0;
    self.filterItemArray = @[@"今日",@"最近三天",@"最近一周",@"最近一月"];
    self.navigationItem.rightBarButtonItem = [STBarButtonItem barButtonItemWithImageName:@"riqi" target:self action:@selector(rightBarButtonItemClick)];
    
    _detailVC = _LoadVC_from_storyboard_(@"UGNotDetailViewController");
    [self buildSegment];

    [self setupAmountLabelTextColor];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.slideSwitchView changeSlideAtSegmentIndex:_selectIndex];
}

- (void)rightBarButtonItemClick {
    
    YBPopupMenu *popView = [[YBPopupMenu alloc] initWithTitles:self.filterItemArray icons:nil menuWidth:CGSizeMake(120, 180) delegate:self];
    popView.fontSize = 14;
 
    float y = 0;
    if ([CMCommon isPhoneX]) {
        y = 88;
    }else {
        y = 64;
    }
    

    [popView showAtPoint:CGPointMake(UGScreenW - 75, y + 5)];
    
}

- (void)initCollectionView {
    
    float itemW = (UGScreenW - 5 * 5) / 4;
    UICollectionViewFlowLayout *layout = ({
        
        layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(itemW, 40);
        layout.minimumInteritemSpacing = 5;
        layout.minimumLineSpacing = 5;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout;
        
    });
    
    UICollectionView *collectionView = ({
        
        collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(5, 10, UGScreenW - 10, 40) collectionViewLayout:layout];
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        [collectionView registerNib:[UINib nibWithNibName:@"UGRecordFilterCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:recordFilterCellid];
        
        [collectionView setShowsHorizontalScrollIndicator:NO];
        collectionView;
        
    });
    
    self.collectionView = collectionView;
    [self.view addSubview:collectionView];
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.filterItemArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UGRecordFilterCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:recordFilterCellid forIndexPath:indexPath];
    cell.filterTime = self.filterItemArray[indexPath.row];
    
    return cell;
}

#pragma mark - YBPopupMenuDelegate

- (void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu {
    if (index >= 0) {
        if (index != self.dateIndex) {
            self.dateIndex = index;
            for (UGBetRecordTableViewController *recordVC in self.controllersArray) {
                recordVC.startDate = self.dateArray[index];
            }
            UGBetRecordTableViewController *recordVC = self.controllersArray[self.controllerIndex];
            recordVC.loadData = YES;
        }
    }
}


#pragma mark - 配置segment

- (void)buildSegment {
    if (!self.slideSwitchView) {
        if ([APP.SiteId isEqualToString:@"c084"]) {
            self.itemArray = @[@"已中奖", @"未中奖", @"等待开奖",@"注单统计"];
//            self.itemArray = @[@"已中奖", @"未中奖", @"等待开奖"];
        } else {
            self.itemArray = @[@"已中奖", @"未中奖", @"等待开奖", @"已撤单",@"注单统计"];
//            self.itemArray = @[@"已中奖", @"未中奖", @"等待开奖", @"已撤单"];
        }
        self.slideSwitchView = [[XYYSegmentControl alloc] initWithFrame:CGRectMake(0 , 0, self.view.width, self.view.height) channelName:self.itemArray source:self];
        [self.slideSwitchView setUserInteractionEnabled:YES];
        self.slideSwitchView.segmentControlDelegate = self;
        
        //设置tab 颜色(可选)
        self.slideSwitchView.tabItemNormalColor = Skin1.textColor2;
        self.slideSwitchView.tabItemNormalFont = 13;
        //设置tab 被选中的颜色(可选)
        self.slideSwitchView.tabItemSelectedColor = Skin1.textColor1;
        //设置tab 背景颜色(可选)
        self.slideSwitchView.tabItemNormalBackgroundColor = Skin1.textColor4;
        //设置tab 被选中的标识的颜色(可选)
        self.slideSwitchView.tabItemSelectionIndicatorColor = Skin1.textColor1;
        [self.view addSubview:self.slideSwitchView];
    }
}


#pragma mark - XYYSegmentControlDelegate

- (NSUInteger)numberOfTab:(XYYSegmentControl *)view {
    return [self.itemArray count];//items决定
}

///待加载的控制器
- (UIViewController *)slideSwitchView:(XYYSegmentControl *)view viewOfTab:(NSUInteger)number {
    
    if ([[self.itemArray objectAtIndex:number] isEqualToString:@"注单统计"]) {
        [_detailVC setStartDate:self.dateArray[2]];
        [self.controllersArray addObject:_detailVC];
        return _detailVC;
        
    } else {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGBetRecordTableViewController" bundle:nil];
        UGBetRecordTableViewController *recordVC = [storyboard instantiateInitialViewController];
        recordVC.status = @[@"2", @"3", @"1", @"4"][number];
        recordVC.startDate = number==2 ? self.dateArray[1] : self.dateArray[0]; // 等待开奖页默认加载最近三天，其他页面默认加载今天
        recordVC.gameType = @"lottery";
        recordVC.showFooterView = NO;
        [self.controllersArray addObject:recordVC];
        return recordVC;
    }
}

- (void)slideSwitchView:(XYYSegmentControl *)view didselectTab:(NSUInteger)number {
    self.controllerIndex = number;
    if ([[self.itemArray objectAtIndex:number] isEqualToString:@"注单统计"]) {
        _detailVC.loadData = YES;
        _selectIndex =(int ) number;
    } else {
        UGBetRecordTableViewController *recordVC = self.controllersArray[number];
        recordVC.loadData = YES;
    }

}

-(void)setSelectIndex:(int)selectIndex{
    _selectIndex = selectIndex;
    self.controllerIndex = _selectIndex;
    if ([[self.itemArray objectAtIndex:selectIndex] isEqualToString:@"注单统计"]) {
        _detailVC.loadData = YES;
    } else {
        UGBetRecordTableViewController *recordVC = self.controllersArray[_selectIndex];
        recordVC.loadData = YES;
    }

}

- (void)setupAmountLabelTextColor {
    NSMutableAttributedString *abstr = [[NSMutableAttributedString alloc] initWithString:self.amountLabel.text];
    [abstr addAttribute:NSForegroundColorAttributeName value:UGRGBColor(244, 215, 87) range:NSMakeRange(5, self.amountLabel.text.length - 5)];
    self.amountLabel.attributedText = abstr;
}

#pragma mark - Getter

- (UIView *)bottomView {
    if (_bottomView == nil) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = UGRGBColor(73, 73, 73);
    }
    return _bottomView;
}

- (UILabel *)amountLabel {
    if (_amountLabel == nil) {
        _amountLabel = [UILabel new];
        _amountLabel.textColor = UGRGBColor(105, 172, 91);
        _amountLabel.font = [UIFont systemFontOfSize:15];
        _amountLabel.text = @"注单金额：¥90000";
    }
    return _amountLabel;
}

- (NSMutableArray<NSString *> *)dateArray {
    if (_dateArray == nil) {
        _dateArray = [NSMutableArray array];
        [_dateArray addObject:[CMCommon getDateStringWithLastDate:0]];
        [_dateArray addObject:[CMCommon getDateStringWithLastDate:3]];
        [_dateArray addObject:[CMCommon getDateStringWithLastDate:7]];
        [_dateArray addObject:[CMCommon getDateStringWithLastDate:30]];
    }
    return _dateArray;
    
}

- (NSMutableArray<UIViewController *> *)controllersArray {
    if (_controllersArray == nil) {
        _controllersArray = [NSMutableArray array];
    }
    return _controllersArray;
}

@end
