//
//  UGPlatformCollectionView.m
//  ug
//
//  Created by xionghx on 2019/9/22.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGPlatformCollectionView.h"
#import "UGGameTypeColletionViewCell.h"
#import "UGPlatformGameModel.h"
#import "UGDocumentVC.h"
#import "JS_HomeGameCollectionCell.h"
#import "JS_HomeGameColletionCell_1.h"
#import "HSC_HomeGameCollectionCell.h"
#import "JYLotteryTitleCollectionView.h"
#import "JYGameCollectionViewCell.h"
#import "DocumentTypeList.h"
#import "UGLHHomeContentCollectionViewCell.h"

@interface UGPlatformCollectionView()<UICollectionViewDelegate, UICollectionViewDataSource,WSLWaterFlowLayoutDelegate>
{
    NSIndexPath * _selectedPath;
}

@property (nonatomic, strong) NSMutableArray <NSArray *> *sectionedDataArray;
@property (strong, nonatomic)  JYLotteryTitleCollectionView *tvHeaderView;
@end

static NSString *gameCellid = @"UGGameTypeColletionViewCell";
@implementation UGPlatformCollectionView

static NSString *const headerId = @"headerId";
static NSString *const footerId = @"footerId";

#pragma mark - 设置表头方式一

- (void)contentInsetHeaderView :(NSArray<GameCategoryModel *> *)  headArray{


    if (headArray.count) {
        CGFloat header_y = 40;
        // CGFloat top, left, bottom, right;
        self.contentInset = UIEdgeInsetsMake(header_y, 0, 0, 0);
        if (!_tvHeaderView) {
            _tvHeaderView = [[JYLotteryTitleCollectionView alloc] initWithFrame:CGRectMake(0, 0,APP.Width , 40.0)];
            _tvHeaderView.frame = CGRectMake(0, -header_y, [UIScreen mainScreen].bounds.size.width, header_y);
            _tvHeaderView.list = headArray;
            [self addSubview:_tvHeaderView];
            
            if (Skin1.isTKL) {
                [CMCommon setBorderWithView:_tvHeaderView top:YES left:NO bottom:NO right:NO borderColor:[UIColor whiteColor] borderWidth:2];
            }
        }
        __weakSelf_(__self);
        _tvHeaderView.jygameTypeSelectBlock = ^(NSArray* subType) {
            [__self jyLoadData: subType];
        };
        [self setContentOffset:CGPointMake(0, -header_y)];
        
        [_tvHeaderView setListDateforRow:0];
    }
}


- (instancetype)initWithFrame:(CGRect)frame
{
    
    
    {
        

            UICollectionViewFlowLayout *layout = ({
                layout = [[UICollectionViewFlowLayout alloc] init];
                layout.scrollDirection = UICollectionViewScrollDirectionVertical;
                layout.minimumInteritemSpacing = 1;
                layout.minimumLineSpacing = 1;
                
                layout;
            });
            self = [super initWithFrame:frame collectionViewLayout:layout];

       
    }
    
    if (self) {
        [self registerNib:[UINib nibWithNibName:@"UGLHHomeContentCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
        [self registerNib:[UINib nibWithNibName:@"UGGameTypeColletionViewCell" bundle:nil] forCellWithReuseIdentifier:gameCellid];
        [self registerNib:[UINib nibWithNibName:@"JS_HomeGameCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"JS_HomeGameCollectionCell"];
        [self registerNib:[UINib nibWithNibName:@"JS_HomeGameColletionCell_1" bundle:nil] forCellWithReuseIdentifier:@"JS_HomeGameColletionCell_1"];
        [self registerNib:[UINib nibWithNibName:@"HSC_HomeGameCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"HSC_HomeGameCollectionCell"];
        [self registerNib:[UINib nibWithNibName:@"JYGameCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"JYGameCollectionViewCell"];
        [self registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerId];
        [self registerClass:[CollectionFooter class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerId];
        self.delegate = self;
        self.dataSource = self;
        if ([Skin1.skitType isEqualToString:@"金沙主题"]) {
            self.backgroundColor = [UIColor colorWithHex:0xf2f2f2];
        } else if ([Skin1.skitType isEqualToString:@"火山橙"]) {
            self.backgroundColor = [UIColor colorWithHex:0xf2f2f2];
        }
        else if (Skin1.isJY||Skin1.isTKL||Skin1.isLH) {
            self.backgroundColor = UIColor.whiteColor;
        }
        else {
            self.backgroundColor = UIColor.clearColor;
        }
    }
    return self;
}


-(void)setStyle:(NSString *)style{
    _style  = style;
 
        if (Skin1.isJY||Skin1.isTKL) {

             if (self.style.intValue == 0) {
                 UICollectionViewFlowLayout *layout = ({
                     layout = [[UICollectionViewFlowLayout alloc] init];
                     layout.scrollDirection = UICollectionViewScrollDirectionVertical;
                     layout.minimumInteritemSpacing = 0;
                     layout.minimumLineSpacing = 0;

                     layout;
                 });
                 [self setCollectionViewLayout:layout];
                 

            } else {
                UICollectionViewFlowLayout *layout = ({
                    layout = [[UICollectionViewFlowLayout alloc] init];
                    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
                    layout.minimumInteritemSpacing = 10;
                    layout.minimumLineSpacing = 10;
                    
                    layout;
                });
                [self setCollectionViewLayout:layout];
            }
            
        }
    
}

-(void)jyLoadData:(NSArray<GameModel *> *)dataArray {
    [self.sectionedDataArray removeAllObjects];
    NSMutableArray * tempArray = [NSMutableArray array];
    if (dataArray.count) {
        for (int i=0; i<dataArray.count; i++) {
            [tempArray addObject:dataArray[i]];
            if (((i + 1) % 3 == 0) || (i == dataArray.count - 1)) {
                [self.sectionedDataArray addObject: [tempArray mutableCopy]];
                [tempArray removeAllObjects];
            }
        }
    }
    [self reloadData];
}

- (void)setDataArray:(NSArray<GameModel *> *)dataArray {
    _dataArray = dataArray;
    _selectedPath = nil;
    if (dataArray.count <= 0) {
        return;
    }
    
    [self.sectionedDataArray removeAllObjects];
    
    NSMutableArray * tempArray = [NSMutableArray array];
    if ([Skin1.skitType isEqualToString:@"金沙主题"] && self.typeIndex == 0) {
        for (int i=0; i<dataArray.count; i++) {
            [tempArray addObject:dataArray[i]];
            if (((i + 1) % 4 == 0) || (i == dataArray.count - 1)) {
                [self.sectionedDataArray addObject: [tempArray mutableCopy]];
                [tempArray removeAllObjects];
            }
        }
    } else if ([Skin1.skitType isEqualToString:@"金沙主题"] && self.typeIndex != 0) {
        for (GameModel * game in dataArray) {
            [self.sectionedDataArray addObject:@[game] ];
        }
    } else if ([Skin1.skitType isEqualToString:@"火山橙"] ) {
        for (int i=0; i<dataArray.count; i++) {
            [tempArray addObject:dataArray[i]];
            if (((i + 1) % 2 == 0) || (i == dataArray.count - 1)) {
                [self.sectionedDataArray addObject: [tempArray mutableCopy]];
                [tempArray removeAllObjects];
            }
        }
        
    }
    else if ( Skin1.isLH) {
        for (int i=0; i<dataArray.count; i++) {
            [tempArray addObject:dataArray[i]];
            if (((i + 1) % 2 == 0) || (i == dataArray.count - 1)) {
                [self.sectionedDataArray addObject: [tempArray mutableCopy]];
                [tempArray removeAllObjects];
            }
        }
    }
    else if (Skin1.isJY||Skin1.isTKL) {

        if(self.style.intValue == 0){
            for (int i=0; i<dataArray.count; i++) {
                [tempArray addObject:dataArray[i]];
                if (((i + 1) % 3 == 0) || (i == dataArray.count - 1)) {
                    [self.sectionedDataArray addObject: [tempArray mutableCopy]];
                    [tempArray removeAllObjects];
                }
            }
        }
        else{
            for (GameModel * game in dataArray) {
                [self.sectionedDataArray addObject:@[game] ];
            }
        }
        
    }
    else {
        for (int i=0; i<dataArray.count; i++) {
            [tempArray addObject:dataArray[i]];
            if (((i + 1) % 3 == 0) || (i == dataArray.count - 1)) {
                [self.sectionedDataArray addObject: [tempArray mutableCopy]];
                [tempArray removeAllObjects];
            }
        }
    }
    
    NSMutableArray *documentArray = [NSMutableArray array];
    for (GameModel *model in dataArray) {
        for (GameSubModel *sub in model.subType) {
            if ([sub.docType isEqualToString:@"1"]) {
                [documentArray addObject:sub];
            }
        }
        if ([model.docType isEqualToString:@"1"]) {
            [documentArray addObject:model];
        }
    }
    [DocumentTypeList setAllGames:documentArray];
}


-(void)setSubType:(NSArray<GameCategoryModel> *)subType{
    _subType = subType;
    
    if (subType.count <= 0) {
        return;
    }
    WeakSelf;
    dispatch_async(dispatch_get_main_queue(), ^{
        // UI更新代码
        [weakSelf contentInsetHeaderView :weakSelf.subType];
    });
    
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

        return self.sectionedDataArray.count;

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

        return ((NSArray *)self.sectionedDataArray[section]).count;

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([Skin1.skitType isEqualToString:@"金沙主题"] && self.typeIndex == 0) {
        JS_HomeGameCollectionCell *cell =  [collectionView dequeueReusableCellWithReuseIdentifier:@"JS_HomeGameCollectionCell" forIndexPath:indexPath];
        [cell bind:((NSArray *)self.sectionedDataArray[indexPath.section])[indexPath.row]];
        return cell;
    } else if ([Skin1.skitType isEqualToString:@"金沙主题"] && self.typeIndex != 0) {
        JS_HomeGameColletionCell_1 *cell =  [collectionView dequeueReusableCellWithReuseIdentifier:@"JS_HomeGameColletionCell_1" forIndexPath:indexPath];
        [cell bind:((NSArray *)self.sectionedDataArray[indexPath.section])[indexPath.row]];
        return cell;
    }else if ([Skin1.skitType isEqualToString:@"火山橙"]) {
        HSC_HomeGameCollectionCell *cell =  [collectionView dequeueReusableCellWithReuseIdentifier:@"HSC_HomeGameCollectionCell" forIndexPath:indexPath];
        [cell bind:((NSArray *)self.sectionedDataArray[indexPath.section])[indexPath.row]];
        
        return cell;
    }
    else if (Skin1.isLH) {
        UGLHHomeContentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        NSArray * arr = self.sectionedDataArray[indexPath.section];
        GameModel *model = (GameModel *)[arr objectAtIndex:indexPath.row];
        
        [cell setItem:model];
        [cell setBackgroundColor: [UIColor whiteColor]];
        cell.layer.borderWidth = 1;
        cell.layer.borderColor = [RGBA(221, 221, 221, 1) CGColor];
        return cell;

    }
    else if (Skin1.isJY||Skin1.isTKL) {
        if (self.style.intValue == 0 ) {
            UGGameTypeColletionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:gameCellid forIndexPath:indexPath];
            {
                cell.item = ((NSArray *)self.sectionedDataArray[indexPath.section])[indexPath.row];
            }
            [cell setBackgroundColor: [UIColor whiteColor]];
            cell.layer.borderWidth = 1;
            cell.layer.borderColor = [[UIColor colorWithHex:0xE4E4E4] CGColor];
            return cell;
        } else {
            JYGameCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JYGameCollectionViewCell" forIndexPath:indexPath];
            GameModel *ob = [[self.sectionedDataArray objectAtIndex:indexPath.section] objectAtIndex:0];
            cell.item = ob;
            
            return cell;
        }
    }
    else {
        UGGameTypeColletionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:gameCellid forIndexPath:indexPath];
        
        cell.item = ((NSArray *)self.sectionedDataArray[indexPath.section])[indexPath.row];
        
        return cell;
    }
    
}


////3.添加header&footer
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        
        {
            UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerId forIndexPath:indexPath];
            if(headerView == nil)
            {
                headerView = [[UICollectionReusableView alloc] init];
            }
            headerView.backgroundColor = [UIColor clearColor];
            
            return headerView;
        }
        
    }
    else if([kind isEqualToString:UICollectionElementKindSectionFooter])
    {
        CollectionFooter *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:footerId forIndexPath:indexPath];
        
        footerView.sourceData = ((GameModel*)self.sectionedDataArray[_selectedPath.section][_selectedPath.row]).subType;
        
        footerView.gameItemSelectBlock = self.gameItemSelectBlock;
        return footerView;
    }
    
    return nil;
}


#pragma mark ---- UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([Skin1.skitType isEqualToString:@"金沙主题"] && self.typeIndex == 0) {
        CGFloat itemW = (UGScreenW - 9)/4.0;
        return CGSizeMake(itemW, 150);
    } else if ([Skin1.skitType isEqualToString:@"金沙主题"] && self.typeIndex != 0) {
        return CGSizeMake(UGScreenW, 80);
    }else if ([Skin1.skitType isEqualToString:@"火山橙"] ) {
        return CGSizeMake((UGScreenW - 7)/2, 90);
    }
    else if (Skin1.isLH) {
        return CGSizeMake((UGScreenW - 6)/2, 80);
    }
    else if (Skin1.isJY||Skin1.isTKL) {
        if (self.style.intValue == 0 ) {
              CGFloat itemW = (UGScreenW -6)/3.0;
              return CGSizeMake(itemW, 110);
        } else {
              CGFloat itemW = (UGScreenW -7);
                  return CGSizeMake(itemW, 110);
        }
      
    }
    else {
        if (APP.isNoSubtitle) {
                 return CGSizeMake(UGScreenW/3-10, 95);
        } else {
                 return CGSizeMake(UGScreenW/3-10, 110);
        }
   
        
    }
}
//item偏移
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if ([Skin1.skitType isEqualToString:@"金沙主题"]) {
        return UIEdgeInsetsZero;
    } else if ([Skin1.skitType isEqualToString:@"火山橙"]) {
        return UIEdgeInsetsZero;
    }
    else if (Skin1.isLH) {
       return UIEdgeInsetsZero;
   }
    else if (Skin1.isJY||Skin1.isTKL) {
        if (self.style.intValue == 0) {
             return UIEdgeInsetsMake(0, 0, 0, 0);
        } else {
            return UIEdgeInsetsMake(0, 0, 0, 0);
        }
       
    }
    else {
        return UIEdgeInsetsMake(9, 5, 0, 5);
        
    }
}
//行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if ([Skin1.skitType isEqualToString:@"金沙主题"]) {
        return 1.0f;
    } else if ([Skin1.skitType isEqualToString:@"火山橙"]) {
        return 1.0f;
    }
    else if (Skin1.isLH) {
        return 0.0f;
    }
    else if (Skin1.isJY||Skin1.isTKL) {
        if (self.style.intValue == 0 ) {
            return 0.f;
        } else {
            return 10.0f;
        }
    }
    else {
        return 0.f;
        
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if ([Skin1.skitType isEqualToString:@"金沙主题"]) {
        return 1.0f;
    } else if ([Skin1.skitType isEqualToString:@"火山橙"]) {
        return 1.0f;
    }
    else if (Skin1.isLH) {
        return 0.0f;
    }
    else if (Skin1.isJY||Skin1.isTKL) {
        if (self.style.intValue == 0) {
            return 0.f;
        } else {
            return 10.0f;
        }
    }
    else {
        return 0.f;
        
    }
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if ([Skin1.skitType isEqualToString:@"火山橙"]) {
        return (CGSize){UGScreenW,1};
    } else {
        {
            return CGSizeMake(UGScreenW, 0);
        }
    
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    
    if (_selectedPath && _selectedPath.section == section) {
        GameModel * model = self.sectionedDataArray[section][_selectedPath.item];
        return (CGSize){UGScreenW,((model.subType.count - 1)/3 + 1) * 40};
    } else if ([Skin1.skitType isEqualToString:@"金沙主题"]) {
        return (CGSize){UGScreenW,1};
    } else if ([Skin1.skitType isEqualToString:@"火山橙"]) {
        return (CGSize){UGScreenW,0};
    }
    else {
        return (CGSize){UGScreenW,0};
    }
}



#pragma mark - WSLWaterFlowLayoutDelegate  end
    
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.gameTypeSelectBlock)
        self.gameTypeSelectBlock(indexPath.row);
    
    
    GameModel * model ;

    model = self.sectionedDataArray[indexPath.section][indexPath.item];

    if (_selectedPath == indexPath ) {
        _selectedPath = nil;
    } else if (model.subType.count > 0 ) {
        _selectedPath = indexPath;
    } else {
        self.gameItemSelectBlock(model);
    }
    [collectionView reloadData];
}

- (NSMutableArray<NSArray *> *)sectionedDataArray {
    if (!_sectionedDataArray) {
        _sectionedDataArray = [NSMutableArray array];
    }
    return  _sectionedDataArray;
}

@end


@implementation CollectionFooter

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.gameSubCollectionView];
        [self.gameSubCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}
- (UGGameSubCollectionView *)gameSubCollectionView {
    if (!_gameSubCollectionView) {
        _gameSubCollectionView = [[UGGameSubCollectionView alloc] initWithFrame:self.bounds];
        _gameSubCollectionView.backgroundColor = [UIColor clearColor];
        WeakSelf
        _gameSubCollectionView.gameItemSelectBlock = ^(GameModel * model) {
            weakSelf.gameItemSelectBlock(model);
        };
    }
    return _gameSubCollectionView;
}

-(void)setSourceData:(NSArray<GameSubModel *> *)sourceData {
    _sourceData = sourceData;
    self.gameSubCollectionView.sourceData = sourceData;
    [self.gameSubCollectionView reloadData];
}
@end
