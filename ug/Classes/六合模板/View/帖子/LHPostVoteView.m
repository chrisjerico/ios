//
//  LHPostVoteView.m
//  ug
//
//  Created by fish on 2019/12/1.
//  Copyright © 2019 ug. All rights reserved.
//

#import "LHPostVoteView.h"


@interface LHPostVoteView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end


@implementation LHPostVoteView

- (void)setPm:(UGLHPostModel *)pm {
    _pm = pm;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    ((UICollectionViewFlowLayout *)_collectionView.collectionViewLayout).itemSize = CGSizeMake(250/3, 40);
    _collectionView.collectionViewLayout = _collectionView.collectionViewLayout;
    [_collectionView reloadData];
}

- (void)show {
    self.alpha = 0;
    self.frame = APP.Window.bounds;
    [TabBarController1.view addSubview:self];
    UIView *alertView = [self viewWithTagString:@"弹框AlertView"];
    alertView.transform = CGAffineTransformMakeScale(1.5, 1.5);
    
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1;
        alertView.transform = CGAffineTransformIdentity;
    }];
}

- (IBAction)onConfirmBtnClick:(UIButton *)sender {
    if (_didConfirmBtnClick) {
        _didConfirmBtnClick(self, [_pm.vote objectWithValue:@true keyPath:@"selected"]);
    }
}

- (IBAction)hide:(UIButton *)sender {
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _pm.vote.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    LHVoteModel *vm = _pm.vote[indexPath.item];
    FastSubViewCode(cell);
    UILabel *lb1 = [cell viewWithTagString:@"生肖Label"];
    if (!lb1) {
        lb1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 20, cell.height)];
        lb1.font = [UIFont systemFontOfSize:12];
        lb1.textColor = APP.AuxiliaryColor2;
        lb1.tagString = @"生肖Label";
        [cell addSubview:lb1];
    }
    
    UILabel *lb2 = [cell viewWithTagString:@"票数Label"];
    if (!lb2) {
        lb2 = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 40, cell.height)];
        lb2.font = [UIFont systemFontOfSize:12];
        lb2.textColor = Skin1.textColor2;
        lb2.tagString = @"票数Label";
        [cell addSubview:lb2];
    }
    cell.layer.masksToBounds = true;
    cell.layer.cornerRadius = 10;
    cell.layer.borderWidth = 2;
    cell.layer.borderColor = vm.selected ? APP.AuxiliaryColor2.CGColor : APP.LoadingColor.CGColor;
    lb1.text = vm.animal;
    lb2.text = _NSString(@"%d票", (int)vm.num);
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    for (LHVoteModel *vm in _pm.vote) {
        vm.selected = false;
    }
    _pm.vote[indexPath.item].selected = true;
    [collectionView reloadData];
}

@end
