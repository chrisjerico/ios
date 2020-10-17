//
//  YNQuickListView.m
//  UGBWApp
//
//  Created by andrew on 2020/8/2.
//  Copyright © 2020 ug. All rights reserved.
//

#import "YNQuickListView.h"
#import "YNQuickListCollectionViewCell.h"
#import "NSMutableArray+KVO.h"

@interface YNQuickListView()<UICollectionViewDelegate, UICollectionViewDataSource,WSLWaterFlowLayoutDelegate,NSMutableArrayDidChangeDelegate>
{
}
@property (nonatomic, strong) WSLWaterFlowLayout *flow;


@end
static NSString *ID=@"YNQuickListCollectionViewCell";
@implementation YNQuickListView

-(void)dealloc{
//    [self xw_removeAllNotification];
    self.selecedDataArry  = nil;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    {
        self.flow = [[WSLWaterFlowLayout alloc] init];
        self.flow.delegate = self;
        self.flow.flowLayoutStyle = WSLWaterFlowVerticalEqualHeight;
        self = [super initWithFrame:frame collectionViewLayout:self.flow];
    }
    if (self) {
        [self registerNib:[UINib nibWithNibName:@"YNQuickListCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:ID];
        self.delegate = self;
        self.dataSource = self;
        self.selecedDataArry = [NSMutableArray new];
   
        [self.selecedDataArry addObserver:self];
        
        

        
        if (APP.betBgIsWhite && !Skin1.isGPK && !Skin1.isBlack && !Skin1.is23) {
            self.backgroundColor =  [UIColor whiteColor];
        } else {
            if (APP.isLight) {
                self.backgroundColor = [Skin1.skitString containsString:@"六合"] ? [Skin1.navBarBgColor colorWithAlphaComponent:0.8] :[Skin1.bgColor colorWithAlphaComponent:0.8];
                
            }
            else{
                self.backgroundColor = [Skin1.skitString containsString:@"六合"] ? Skin1.navBarBgColor : Skin1.bgColor;
                
            }
        }
    }
    return self;
    
}

//回调方法


- (void)array:(NSMutableArray *)array didChange:(NSDictionary<NSString *,id> *)change {
    NSLog(@"%ld", array.count);
    
    if (self.seleced) {
        if (array.count >= self.selecedCount ) {
            [Global getInstanse].hasBgColor = YES;
        }
        else{
            [Global getInstanse].hasBgColor = NO;
        }
        [self reloadData];
    }
   
}

-(void)setDataArry:(NSMutableArray<UGGameBetModel *> *)dataArry{
    _dataArry = dataArry;
    [self reloadData];
}

#pragma mark - UICollectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArry.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    YNQuickListCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    UGGameBetModel *model = [_dataArry objectAtIndex:indexPath.row];
    cell.hasSelected = self.seleced;
    cell.item = model;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    if (self.collectIndexBlock) {
      

        UGGameBetModel *game = [_dataArry objectAtIndex:indexPath.row];
        if (!game.enable) {
            return;
        }
      

        //如果selected 是yes
        
        //如果选中的数组 数量 >= selectedNumber:==>选中的数组里面的可以取消，其他的不能操作（颜色变化）
        
        //否则   ==》随便选择==》//如果选中，保存到选中的数组
        
        if (self.seleced) {
            if (self.selecedDataArry.count >= self.selecedCount ) {
                
               
                
               BOOL isbool = [self.selecedDataArry containsObject:game.name];
                
                if (isbool) {
                    game.select = NO;
                    [self.selecedDataArry  removeObject:game.name];
                } else {
                    //啥都不做,除了选中的数组的其他cell 背景都改颜色
                }
                
            }
            else {
               
                 game.select = !game.select;
                if (game.select) {
                    [self.selecedDataArry  addObject:game.name];
                }
                else{
                    if ([self.selecedDataArry containsObject:game.name]) {
                        [self.selecedDataArry  removeObject:game.name];
                    }
                }
            }
        }
        else {
            game.select = !game.select;
        }

        [self reloadData];
        
        self.collectIndexBlock(collectionView,indexPath);
    }
    
}

#pragma mark - WSLWaterFlowLayoutDelegate

//返回每个item大小
- (CGSize)waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return  CGSizeMake((self.frame.size.width-10) / 5, 40);
}

/** 头视图Size */
-(CGSize )waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout sizeForHeaderViewInSection:(NSInteger)section {
    return CGSizeMake(self.frame.size.width - 1, 1);
}

/** 列间距*/
-(CGFloat)columnMarginInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout {

    return 1;
}
/** 行间距*/
-(CGFloat)rowMarginInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout {

    return 1;
}
/** 边缘之间的间距*/
-(UIEdgeInsets)edgeInsetInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout {

    return UIEdgeInsetsMake(1, 1, 1, 1);
}

@end
