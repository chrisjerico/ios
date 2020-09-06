//
//  JYLotteryTitleCollectionView.m
//  ug
//
//  Created by ug on 2020/2/12.
//  Copyright © 2020 ug. All rights reserved.
//

#import "JYLotteryTitleCollectionView.h"
#import "JYLotteryCollectionViewCell.h"
#define CollectionViewW (APP.Width-16)
@interface JYLotteryTitleCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource>{

}
@property (nonatomic, strong) UICollectionView *collectionView;

@end
@implementation JYLotteryTitleCollectionView

- (void)layoutSubviews {
    [super layoutSubviews];
    [_collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:self.selectIndex inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        UICollectionViewFlowLayout *layout = ({
            layout = [[UICollectionViewFlowLayout alloc] init];
            layout.minimumInteritemSpacing = 0;
            layout.minimumLineSpacing = 0;
            layout.sectionInset =  UIEdgeInsetsMake(0, 2, 0, 2);
            layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            layout;
        });
        UICollectionView *collectionView = ({
            collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CollectionViewW, 40) collectionViewLayout:layout];
            collectionView.backgroundColor =  RGBA(246, 246, 246, 1);
            collectionView.dataSource = self;
            collectionView.delegate = self;
            [collectionView registerNib:[UINib nibWithNibName:@"JYLotteryCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"JYLotteryCollectionViewCell"];
            [collectionView setShowsHorizontalScrollIndicator:NO];
            collectionView;
            
  
        });
        
        self.collectionView = collectionView;
        [self addSubview:collectionView];
        self.backgroundColor =   RGBA(246, 246, 246, 1);

        
        [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.width.mas_equalTo(CollectionViewW);
            make.left.equalTo(self.mas_left);
            make.height.mas_equalTo(self.mas_height);
        }];
    }
    return self;
}

- (void)setSelectIndex:(NSInteger)selectIndex {
    _selectIndex = selectIndex;
    NSIndexPath *ip = [NSIndexPath indexPathForRow:selectIndex inSection:0];
    [self.collectionView scrollToItemAtIndexPath:ip atScrollPosition:UICollectionViewScrollPositionNone animated:true];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.collectionView selectItemAtIndexPath:ip animated:true scrollPosition:UICollectionViewScrollPositionNone];
    });
}

- (void)setList:(NSArray<GameCategoryModel> *)list {
    _list = list;

    for (GameCategoryModel *model in _list) {
       NSLog(@"model.game_id = %@===========名字：%@ ",model.iid,model.name);
    }
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.list.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    JYLotteryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JYLotteryCollectionViewCell" forIndexPath:indexPath];
    cell.item = _list[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView setContentOffset:({
        CGFloat x = 2;
        for (int i=0; i<indexPath.item; i++) {
            x += [self collectionView:collectionView layout:collectionView.collectionViewLayout sizeForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]].width;
        }
        CGFloat w = [self collectionView:collectionView layout:collectionView.collectionViewLayout sizeForItemAtIndexPath:indexPath].width;;
        x = x - collectionView.width/2 + w/2;
        x = MAX(x, 0);
        x = MIN(x, collectionView.contentSize.width - collectionView.width);
        CGPointMake(x, 0);
    }) animated:true];
    
    
    
    GameCategoryModel *model = [_list objectAtIndex:indexPath.row];
    if (self.jygameTypeSelectBlock)
        self.jygameTypeSelectBlock( model.list);
    

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    GameCategoryModel *gcm = _list[indexPath.row];
    CGFloat w = [gcm.name widthForFont:[UIFont systemFontOfSize:16]] + 10;
    return CGSizeMake(MAX(APP.Width/_list.count, w),40);
}


-(void)setListDateforRow:(int)row{
    GameCategoryModel *model = [_list objectAtIndex:row];
    if (self.jygameTypeSelectBlock)
        self.jygameTypeSelectBlock( model.list);
}
@end

