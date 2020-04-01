//
//  DocumentTypeList.m
//  UGBWApp
//
//  Created by fish on 2020/3/15.
//  Copyright © 2020 ug. All rights reserved.
//

#import "DocumentTypeList.h"


@interface DocumentTypeList()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation DocumentTypeList


static DocumentTypeList *_singleInstance = nil;

+ (instancetype)shareInstance {
    static DocumentTypeList *list = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        list = [[self alloc] initWithFrame:CGRectZero];
    });
    return list;
}


static NSMutableArray<GameModel *> *_allGames;

+ (void)setAllGames:(NSArray<GameModel *> *)allGames {
    if (!_allGames) {
        _allGames = @[].mutableCopy;
    }
    // 去除重复
    for (GameModel *gm in allGames) {
        if (![_allGames containsValue:gm.name keyPath:@"name"])
            [_allGames addObject:gm];
    }
}

+ (NSArray<GameModel *> *)allGames {
    return _allGames;
}

+ (BOOL)isShow:(UIView *)superview {
    return [DocumentTypeList shareInstance].superview == superview;
}

+ (void)showIn:(UIView *)supperView completionHandle:(void(^)(GameModel * model))block {
    DocumentTypeList *list = [DocumentTypeList shareInstance];
    [list removeFromSuperview];
    [supperView addSubview:list];
    [list mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(supperView);
    }];
    [list.collectionView reloadData];
    list.completionHandle = block;
}

+(void)hide {
    [[DocumentTypeList shareInstance] hide];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UICollectionViewFlowLayout *layout = ({
            layout = [[UICollectionViewFlowLayout alloc] init];
            layout.scrollDirection = UICollectionViewScrollDirectionVertical;
            layout.itemSize = CGSizeMake(UGScreenW /3, 50);
            layout.minimumLineSpacing = 0;
            layout.minimumInteritemSpacing = 0;
//            layout.estimatedItemSize = CGSizeMake(100, 50);
//            layout.itemSize = UICollectionViewFlowLayoutAutomaticSize;
            layout;
        });
        
        UICollectionView *collectionView = ({
            collectionView = [[UICollectionView alloc] initWithFrame: CGRectZero collectionViewLayout:layout];
            collectionView.backgroundColor = [UIColor whiteColor];
            collectionView.dataSource = self;
            collectionView.delegate = self;
            [collectionView registerClass: [DocumentTypeListCell class] forCellWithReuseIdentifier:@"DocumentTypeListCell"];
            [collectionView setShowsHorizontalScrollIndicator:NO];
            _collectionView = collectionView;
        });
        
        UIView * shadowView = [UIView new];
        shadowView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.9];
        [self addSubview:shadowView];
        [shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        [self addSubview:collectionView];
        [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self);
            make.height.equalTo(@(((_allGames.count - 1)/3 + 1) * 50));
        }];
        [shadowView addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)]];
    }
    return self;
}

- (void)hide {
    [self removeFromSuperview];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _allGames.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DocumentTypeListCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DocumentTypeListCell" forIndexPath:indexPath];
    cell.titleLabel.text = _allGames[indexPath.item].name;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.completionHandle) {
        self.completionHandle(_allGames[indexPath.item]);
    }
    [self removeFromSuperview];
}
@end






@interface DocumentTypeListCell()
@end
@implementation DocumentTypeListCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel = [UILabel new];
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self).inset(5);
            make.top.bottom.equalTo(self).inset(5);
        }];
        self.titleLabel.layer.borderWidth = 0.5;
        self.titleLabel.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1.0].CGColor;
        self.titleLabel.layer.cornerRadius = 3;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:12];
        self.titleLabel.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
@end
