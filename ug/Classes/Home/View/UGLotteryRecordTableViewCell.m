//
//  UGLotteryRecordTableViewCell.m
//  ug
//
//  Created by ug on 2019/6/2.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGLotteryRecordTableViewCell.h"
#import "UGTimeLotteryBetHeaderView.h"
#import "UGLotteryResultCollectionViewCell.h"
#import "UGLotterySubResultCollectionViewCell.h"
#import "WSLWaterFlowLayout.h"
#import "UGLotteryHistoryModel.h"
#import "UGPK10SubResultCollectionViewCell.h"
#import "UGFastThreeOneCollectionViewCell.h"

@interface UGLotteryRecordTableViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource,WSLWaterFlowLayoutDelegate>
@property (weak, nonatomic) IBOutlet UILabel *issueLabel;
@property (weak, nonatomic) IBOutlet UILabel *tiemLabel;
@property (weak, nonatomic) IBOutlet UIView *collectionBgView;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *numArray;
@property (nonatomic, strong) NSArray *resultArray;

@end

static NSString *headerViewID = @"UGTimeLotteryBetHeaderView";
static NSString *lotteryResultCellid = @"UGLotteryResultCollectionViewCell";
static NSString *lotterySubResultCellid = @"UGLotterySubResultCollectionViewCell";
static NSString *lotteryPK10ResultCellId = @"UGPK10SubResultCollectionViewCell";
static NSString *lotteryOneCellId = @"UGFastThreeOneCollectionViewCell";


@implementation UGLotteryRecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initcollectionView];
}

- (void)setItem:(UGLotteryHistoryModel *)item {
    _item = item;
    self.issueLabel.text = item.issue;
    self.tiemLabel.text = item.openTime;
    self.numArray = [item.num componentsSeparatedByString:@","];
    self.resultArray = [item.result componentsSeparatedByString:@","];
    [self.collectionView reloadData];
}


#pragma mark UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        if ([@"lhc" isEqualToString:self.item.gameType]) {
            return self.numArray.count + 1;
        }
        return self.numArray.count;
    } else {
        if ([@"lhc" isEqualToString:self.item.gameType]) {
            return self.resultArray.count + 1;
        }
        return self.resultArray.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if ([@"jsk3" isEqualToString:self.item.gameType]){
            UGFastThreeOneCollectionViewCell *oneCell = [collectionView dequeueReusableCellWithReuseIdentifier:lotteryOneCellId forIndexPath:indexPath];
            oneCell.num = self.numArray[indexPath.row];
            return oneCell;
        }
        
        UGLotteryResultCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:lotteryResultCellid forIndexPath:indexPath];
        cell.showAdd = NO;
        cell.showBorder = NO;
        
        if ([@"lhc" isEqualToString:self.item.gameType]) {
            cell.showBorder = NO;
            if (indexPath.row == 6) {
                cell.showAdd = YES;
            } else {
                cell.showAdd = NO;
            }
            if (indexPath.row < 6) {
                cell.title = self.numArray[indexPath.row];
                cell.color = [CMCommon getHKLotteryNumColorString:self.numArray[indexPath.row]];
            }
            if (indexPath.row == 7) {
                cell.title = self.numArray[indexPath.row - 1];
                cell.color = [CMCommon getHKLotteryNumColorString:self.numArray[indexPath.row - 1]];
            }
        } else if ([@"pk10" isEqualToString:self.item.gameType] || [@"pk10nn" isEqualToString:self.item.gameType]) {
            cell.backgroundColor = [CMCommon getPreNumColor:self.numArray[indexPath.row]];
            cell.title = self.numArray[indexPath.row];
        } else {
            cell.backgroundColor = [[UGSkinManagers shareInstance] setNavbgColor];
            cell.title = self.numArray[indexPath.row];
        }
        return cell;
    } else {
        if ([@"pk10nn" isEqualToString:self.item.gameType]){
            UGPK10SubResultCollectionViewCell *pk10cell = [collectionView dequeueReusableCellWithReuseIdentifier:lotteryPK10ResultCellId forIndexPath:indexPath];
            pk10cell.tag = indexPath.row;
            pk10cell.result = self.resultArray[indexPath.row];
            pk10cell.win = [self.item.winningPlayers containsObject:@(indexPath.row)];
            if (indexPath.row == 0) {
                pk10cell.win = !self.item.winningPlayers.count;
            }
            return pk10cell;
        }
        
        UGLotterySubResultCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:lotterySubResultCellid forIndexPath:indexPath];
        cell.showAdd = NO;
        if ([@"lhc" isEqualToString:self.item.gameType]) {
            if (indexPath.row == 6) {
                cell.showAdd = YES;
            } else {
                cell.showAdd = NO;
            }
            if (indexPath.row < 6) {
                cell.title = self.resultArray[indexPath.row];
            }
            if (indexPath.row == 7) {
                cell.title = self.resultArray[indexPath.row - 1];
            }
            return cell;
        } else {
            cell.title = self.resultArray[indexPath.row];
        }
        return cell;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UGTimeLotteryBetHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewID forIndexPath:indexPath];
        headerView.title = @"";
        return headerView;
    }
    return nil;
}


#pragma mark - WSLWaterFlowLayoutDelegate

- (CGSize)waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat AvailableWidth = APP.Width - 140;
    if ([@"pk10nn" isEqualToString:self.item.gameType] && indexPath.section == 1) {
        return CGSizeMake(((AvailableWidth - 10) / 6), ((AvailableWidth - 10) / 6));
    } else if ([@"cqssc" isEqualToString:self.item.gameType] && indexPath.section == 1){
        return CGSizeMake(((AvailableWidth - 5) / 9), ((AvailableWidth - 5) / 9));
    } else if ([@"bjkl8" isEqualToString:self.item.gameType] && indexPath.section == 1) {
         return CGSizeMake(((AvailableWidth - 2) / 6), ((AvailableWidth - 5) / 10));
    } else if ([@"jsk3" isEqualToString:self.item.gameType]) {
        if (indexPath.section == 0) {
            return CGSizeMake(((AvailableWidth - 2) / 6), ((AvailableWidth - 5) / 6));
        } else {
            return CGSizeMake(((AvailableWidth - 2) / 7), ((AvailableWidth - 5) / 7));
        }
    } else {
        CGFloat w = AvailableWidth / 10;
        return CGSizeMake(w, w);
    }
}

/** 头视图Size */
- (CGSize)waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout sizeForHeaderViewInSection:(NSInteger)section {
    return CGSizeMake(300, 3);
}

/** 列间距*/
- (CGFloat)columnMarginInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
    return 1;
}

/** 行间距*/
- (CGFloat)rowMarginInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
    return 1;
}

/** 边缘之间的间距*/
- (UIEdgeInsets)edgeInsetInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
    return UIEdgeInsetsMake(3, 1, 1, 1);
}

- (void)initcollectionView {
    WSLWaterFlowLayout *flow = [[WSLWaterFlowLayout alloc] init];
    flow.delegate = self;
    flow.flowLayoutStyle = WSLWaterFlowVerticalEqualHeight;
    
    UICollectionView *collectionView = ({
        collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(115, 5, UGScreenW - 115, self.height) collectionViewLayout:flow];
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        [collectionView registerNib:[UINib nibWithNibName:@"UGLotteryResultCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:lotteryResultCellid];
        [collectionView registerNib:[UINib nibWithNibName:@"UGLotterySubResultCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:lotterySubResultCellid];
        [collectionView registerNib:[UINib nibWithNibName:@"UGTimeLotteryBetHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewID];
        [collectionView registerNib:[UINib nibWithNibName:@"UGPK10SubResultCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:lotteryPK10ResultCellId];
        [collectionView registerNib:[UINib nibWithNibName:@"UGFastThreeOneCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:lotteryOneCellId];
        collectionView;
    });
    
    self.collectionView = collectionView;
    [self addSubview:collectionView];
    
}

@end
