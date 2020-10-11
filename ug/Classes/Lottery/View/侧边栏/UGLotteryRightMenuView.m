//
//  UGLotteryRightMenuView.m
//  UGBWApp
//
//  Created by fish on 2020/9/25.
//  Copyright © 2020 ug. All rights reserved.
//

#import "UGLotteryRightMenuView.h"
#import "NewLotteryHeaderViewCollectionReusableView.h"
#import "NewLotteryRightCollectionViewCell.h"
@interface UGLotteryRightMenuView ()<UICollectionViewDelegate,UICollectionViewDataSource,WSLWaterFlowLayoutDelegate>
{
   
}

@property (weak, nonatomic) IBOutlet UIButton *returnHomeBtn;
@property (weak, nonatomic) IBOutlet UICollectionView *contentCollectionView;           /**<   彩票栏目*/
@property (nonatomic, strong) NSArray<UGAllNextIssueListModel *> *lotteryGamesArray;
@property (nonatomic) BOOL hasHeaderBtnClicked;///**<   栏目头被点击过*/
@end

static NSString *newLotteryCellID = @"NewLotteryRightCollectionViewCell";
static NSString *newheaderViewID = @"NewLotteryHeaderViewCollectionReusableView";
@implementation UGLotteryRightMenuView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:APP.Bounds];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"UGLotteryRightMenuView" owner:self options:nil].firstObject;
        [self initLHCollectionView];
    }
    return self;
    
}

#pragma mark - 显示

- (void)show {
    self.frame = APP.Bounds;
    [APP.Window addSubview:self];
    [self.returnHomeBtn setBackgroundColor:Skin1.navBarBgColor];
    self.returnHomeBtn.superview.superview.cc_constraints.left.constant = -APP.Width;
    [self layoutIfNeeded];
//    WeakSelf
//    self.contentCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [weakSelf getAllNextIssueData];
//    }];
    [self getAllNextIssueData];
    [UIView animateWithDuration:0.35 animations:^{
        self.returnHomeBtn.superview.superview.cc_constraints.left.constant = 0;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}
#pragma mark - 隐藏

- (IBAction)hiddenSelf {
    [UIView animateWithDuration:0.35 animations:^{
        self.returnHomeBtn.superview.superview.cc_constraints.left.constant = -APP.Width;
        [self layoutIfNeeded];

    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
#pragma mark - 去首页
- (IBAction)goHomeAction:(id)sender {
    
    [self hiddenSelf];
    if (self.backToHomeBlock)
        self.backToHomeBlock();
}

#pragma mark - 彩票栏目
- (void)getAllNextIssueData {
    WeakSelf;
    [CMNetwork getLotteryGroupGamesWithParams:@{} completion:^(CMResult<id> *model, NSError *err) {

        [CMResult processWithResult:model success:^{
            
            
            weakSelf.lotteryGamesArray =  model.data;
            [weakSelf.contentCollectionView reloadData];
        } failure:^(id msg) {
            [SVProgressHUD dismiss];
        }];
    }];
}


- (void)initLHCollectionView {
    //内容
    WSLWaterFlowLayout * _flow;
    _flow = [[WSLWaterFlowLayout alloc] init];
    _flow.delegate = self;
    _flow.flowLayoutStyle = WSLWaterFlowVerticalEqualHeight;
    
    
//    float itemW = (260-3)/ 2.0;
//    UICollectionViewFlowLayout *layout = ({
//        layout = [[UICollectionViewFlowLayout alloc] init];
//        layout.itemSize = CGSizeMake(itemW, 44);
//        layout.minimumInteritemSpacing = 1;
//        layout.minimumLineSpacing = 1;
//        layout.sectionInset = UIEdgeInsetsMake(1, 1, 1, 1);
//        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
//        layout.headerReferenceSize = CGSizeMake(260, 44);
//        layout;
//    });
    

    self.contentCollectionView.backgroundColor = [UIColor whiteColor];
    self.contentCollectionView.dataSource = self;
    self.contentCollectionView.delegate = self;
    self.contentCollectionView.tagString= @"内容";
    [self.contentCollectionView registerNib:[UINib nibWithNibName:@"NewLotteryRightCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:newLotteryCellID];
    [self.contentCollectionView registerNib:[UINib nibWithNibName:@"NewLotteryHeaderViewCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:newheaderViewID];
    [self.contentCollectionView setCollectionViewLayout:_flow];
 
}

#pragma mark - WSLWaterFlowLayoutDelegate

/** 头视图Size */
-(CGSize )waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout sizeForHeaderViewInSection:(NSInteger)section{
    return CGSizeMake(260, 44);
}
////返回每个item大小
- (CGSize)waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    float itemW = (260-1)/ 2.0;
    CGSize size = {itemW, 44};
    return size;
}
/** 列数*/
-(CGFloat)columnCountInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
    return 1;
}
/** 行数*/
//-(CGFloat)rowCountInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
//    return 5;
//}
/** 列间距*/
-(CGFloat)columnMarginInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
    return 0;
}
/** 行间距*/
-(CGFloat)rowMarginInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
    return 0;
}
/** 边缘之间的间距*/
-(UIEdgeInsets)edgeInsetInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{

    return UIEdgeInsetsMake(0, 0, 0,0);
}

#pragma mark UICollectionView datasource
////组个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.lotteryGamesArray.count;
    
}
//组内成员个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    UGAllNextIssueListModel *model = self.lotteryGamesArray[section];
    
    if (model.isOpen) {
        return model.lotteries.count;
    } else {
        return 0;
    }
   
}
//每个cell的具体内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NewLotteryRightCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:newLotteryCellID forIndexPath:indexPath];
    UGAllNextIssueListModel *model = self.lotteryGamesArray[indexPath.section];
    UGNextIssueModel *item = model.lotteries[indexPath.row];
    cell.titleLabel.text = item.title;

    if ([self.selectTitle isEqualToString:item.title]) {
        [cell setBackgroundColor:Skin1.navBarBgColor];
    } else {
        [cell setBackgroundColor:RGBA(235, 235, 235, 1)];
    }
    return cell;
    
    
}

-(BOOL)hasModel:(UGAllNextIssueListModel *)model{
    
    BOOL isOk = NO;
    for (UGNextIssueModel *item in model.lotteries) {
        if ([item.title isEqualToString:self.selectTitle]) {
            isOk = YES;
            break;
        }
    }
    return isOk;
}

-(BOOL)hasModelType:(UGAllNextIssueListModel *)model{
    BOOL isOk = NO;
    if ([model.name isEqualToString:@"全部彩种"]) {
        return isOk;
    }
    
    for (UGNextIssueModel *item in model.lotteries) {
        if ([item.gameType isEqualToString:self.gameType]) {
            isOk = YES;
            break;
        }
    }
    return isOk;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        NewLotteryHeaderViewCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:newheaderViewID forIndexPath:indexPath];
        UGAllNextIssueListModel *model = self.lotteryGamesArray[indexPath.section];
        headerView.titlelabel.text = model.name;
        NSLog(@"model = %@",model);
        NSLog(@"gameType = %@",self.gameType);//pk10
        //如果是第一次进来，全部菜种展开  全部彩种
        //否则，对应的系列展开
        if ([Global getInstanse].isAllLottery) {
            if ([model.name isEqualToString:@"全部彩种"]) {
                if (OBJOnceToken(self)) {
                    model.isOpen = YES;
                    //刷新Section
                    [UIView performWithoutAnimation:^{
                        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:indexPath.section];
                        [self.contentCollectionView reloadSections:indexSet];
                    }];
                }
            }
        }
        else {
            if ([self hasModelType:model] && !_hasHeaderBtnClicked) {
                if (OBJOnceToken(self)) {
                    model.isOpen = YES;
                    //刷新Section
                    [UIView performWithoutAnimation:^{
                        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:indexPath.section];
                        [self.contentCollectionView reloadSections:indexSet];
                    }];
                }
            }
        }
        
        
        if (model.isOpen) {
            [headerView.mBtn setImage:[UIImage imageNamed:@"jiantouxia"] forState:UIControlStateNormal];
        } else {
            [headerView.mBtn setImage:[UIImage imageNamed:@"jiantouyou"] forState:UIControlStateNormal];
        }
        WeakSelf;
        [headerView.mClickedBtn removeAllBlocksForControlEvents:UIControlEventTouchUpInside];

        [headerView.mClickedBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
            [[Global getInstanse] setIsAllLottery:NO];
            weakSelf.hasHeaderBtnClicked  = YES;
            [weakSelf headerBtnActionAtIndexPath:indexPath];
        }];//所有
        return headerView;
    }
    return nil;
}

-(void)headerBtnActionAtIndexPath:(NSIndexPath *)indexPath{
    
    UGAllNextIssueListModel *selModel = self.lotteryGamesArray[indexPath.section];
    selModel.isOpen = !selModel.isOpen;
    
    for (UGAllNextIssueListModel *model in self.lotteryGamesArray) {
        if (![selModel isEqual:model]) {
            model.isOpen = NO;
        }
    }
    [self.contentCollectionView reloadData];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];

    UGAllNextIssueListModel *listModel = self.lotteryGamesArray[indexPath.section];
     __block UGNextIssueModel *nextModel = listModel.lotteries[indexPath.row];
    
    if (self.didSelectedItemBlock) {
        self.didSelectedItemBlock(nextModel);
    }
    [self hiddenSelf];
}


@end
