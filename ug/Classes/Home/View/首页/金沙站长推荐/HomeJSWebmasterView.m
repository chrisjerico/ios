//
//  HomeJSWebmasterView.m
//  UGBWApp
//
//  Created by andrew on 2020/11/10.
//  Copyright © 2020 ug. All rights reserved.
//

#import "HomeJSWebmasterView.h"
#import "JS_HomeGameColletionCell_1.h"
#import "GameCategoryDataModel.h"
@interface HomeJSWebmasterView ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *contentCollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightLayoutConstraint;        /**<  contentCollectionView 的约束高*/

@end
@implementation HomeJSWebmasterView
- (void)awakeFromNib {
    [super awakeFromNib];
    FastSubViewCode(self)
    _jsWebmasterList = [NSMutableArray<GameModel *> new];
    self.heightLayoutConstraint.constant = 0.1;
    UICollectionViewFlowLayout *layout = ({
        layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumInteritemSpacing = 1;
        layout.minimumLineSpacing = 1;
        layout;
    });
    self.contentCollectionView.backgroundColor = [UIColor colorWithHex:0xf2f2f2];
    self.contentCollectionView.dataSource = self;
    self.contentCollectionView.delegate = self;
    self.contentCollectionView.tagString= @"金沙站长推荐";
    [self.contentCollectionView registerNib:[UINib nibWithNibName:@"JS_HomeGameColletionCell_1" bundle:nil] forCellWithReuseIdentifier:@"JS_HomeGameColletionCell_1"];
    [self.contentCollectionView setCollectionViewLayout:layout];
}

-(void)setJsWebmasterList:(NSArray<GameModel *> *)jsWebmasterList{
    
    _jsWebmasterList = jsWebmasterList;
    if (_jsWebmasterList.count == 0) {
        self.heightLayoutConstraint.constant = 0.1;
    }
    else{
        self.heightLayoutConstraint.constant = 81 *  _jsWebmasterList.count ;
    }
    [self.contentCollectionView reloadData];
}


#pragma mark UICollectionView datasource
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
        return CGSizeMake(UGScreenW, 80);
}
//item偏移
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
        return UIEdgeInsetsZero;
}

//组内成员个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    int rows = (int)self.jsWebmasterList.count;
    return rows;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JS_HomeGameColletionCell_1 *cell =  [collectionView dequeueReusableCellWithReuseIdentifier:@"JS_HomeGameColletionCell_1" forIndexPath:indexPath];
    [cell bind:self.jsWebmasterList[indexPath.row]];
    return cell;

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    GameModel * game = self.jsWebmasterList[indexPath.item];
    [NavController1 pushViewControllerWithGameModel:game];
}
@end
