//
//  UGModifyLoginPlaceController.m
//  ug
//
//  Created by ug on 2019/5/7.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGModifyLoginPlaceController.h"
#import "YBPopupMenu.h"
#import "UGLoginAddressModel.h"
#import "UGAddressListModel.h"
#import "UGAddressCollectionViewCell.h"

@interface UGModifyLoginPlaceController ()<YBPopupMenuDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *countryLabel;
@property (weak, nonatomic) IBOutlet UILabel *provinceLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UIImageView *countryArrow;
@property (weak, nonatomic) IBOutlet UIImageView *provinceArrow;
@property (weak, nonatomic) IBOutlet UIImageView *cityArrow;
@property (weak, nonatomic) IBOutlet UIView *countryView;
@property (weak, nonatomic) IBOutlet UIView *provinceView;
@property (weak, nonatomic) IBOutlet UIView *cityView;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIView *addressListView;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *countryArray;
@property (nonatomic, strong) NSMutableArray *provinceArray;
@property (nonatomic, strong) NSMutableArray *cityArray;

@property (nonatomic, strong) YBPopupMenu *countryPopView;
@property (nonatomic, strong) YBPopupMenu *provincePopView;
@property (nonatomic, strong) YBPopupMenu *cityPopView;
@property (nonatomic, strong) NSMutableArray *addressArray;
@property (nonatomic, strong) NSMutableArray *loginAddressArray;
@property (nonatomic, assign) NSInteger countryIndex;


@end

static NSString *addressCellId = @"UGAddressCollectionViewCell";
@implementation UGModifyLoginPlaceController

-(void)skin{
    [self.view setBackgroundColor: [[UGSkinManagers shareInstance] setbgColor]];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor: [[UGSkinManagers shareInstance] setbgColor]];
    SANotificationEventSubscribe(UGNotificationWithSkinSuccess, self, ^(typeof (self) self, id obj) {
        
        [self skin];
    });
    self.submitButton.layer.cornerRadius = 3;
    self.submitButton.layer.masksToBounds = YES;
    [self.submitButton setBackgroundColor:UGNavColor];
    self.countryArray = @[@"中国",@"国外"];
    self.countryIndex = 0;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"address" ofType:@"json"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    self.addressArray = [[JSONModelArray alloc] initWithArray:dict[@"data"] modelClass:[UGAddressListModel class]].mutableCopy;
    for (UGAddressListModel *model in self.addressArray) {
        [self.provinceArray addObject:model.name];
    }
    UGAddressListModel *listModel = self.addressArray.firstObject;
    if (listModel.city.count) {
        for (UGAddressModel *model in listModel.city) {
            [self.cityArray addObject:model.name];
        }
    }else {
        [self.cityArray addObject:listModel.name];
    }
    
    [self getAddressList];
    [self.addressListView addSubview:self.collectionView];
    
}

- (void)getAddressList {
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid};
    [CMNetwork getLoginAddressWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
    
            self.loginAddressArray = model.data;
            [self.collectionView reloadData];
            
        } failure:^(id msg) {
            
        }];
    }];
    
}

- (void)changAddress {
    NSDictionary *dict = @{@"token":[UGUserModel currentUser].sessid
                             };
    NSMutableDictionary *mutDict = [[NSMutableDictionary alloc] initWithDictionary:dict];
    
//    已添加
    for (int i = 0; i < self.loginAddressArray.count; i++) {
        NSString *addressId = [NSString stringWithFormat:@"address[%d][id]",i];
        NSString *country = [NSString stringWithFormat:@"address[%d][country]",i];
        NSString *province = [NSString stringWithFormat:@"address[%d][province]",i];
        NSString *city = [NSString stringWithFormat:@"address[%d][city]",i];
        UGLoginAddressModel *model = self.loginAddressArray[i];
        [mutDict setValue:model.addressId forKey:addressId];
        [mutDict setValue:model.country forKey:country];
        [mutDict setObject:model.province forKey:province];
        [mutDict setObject:model.city forKey:city];
    
    }
    
//    新增
    NSString *country = [NSString stringWithFormat:@"address[%ld][country]",self.loginAddressArray.count];
    NSString *province = [NSString stringWithFormat:@"address[%ld][province]",self.loginAddressArray.count];
    NSString *city = [NSString stringWithFormat:@"address[%ld][city]",self.loginAddressArray.count];
    [mutDict setValue:@(self.countryIndex) forKey:country];
    if (self.countryIndex) {
        [mutDict setObject:@"" forKey:province];
        [mutDict setObject:@"" forKey:city];
    }else {
        
        [mutDict setObject:self.provinceLabel.text forKey:province];
        [mutDict setObject:self.cityLabel.text forKey:city];
    }
    
    [SVProgressHUD showWithStatus:nil];
    [CMNetwork modifyLoginAddressWithParams:mutDict completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            [SVProgressHUD showSuccessWithStatus:model.msg];
            [self getAddressList];
        } failure:^(id msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }];
    
}

- (void)delAddress:(UGLoginAddressModel *)item {
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid,
                             @"id":item.addressId
                             };
    [SVProgressHUD showWithStatus:nil];
    [CMNetwork delLoginAddressWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            [SVProgressHUD showSuccessWithStatus:model.msg];
            [self.loginAddressArray removeObject:item];
            [self.collectionView reloadData];
        } failure:^(id msg) {
            [SVProgressHUD showErrorWithStatus:msg];
            
        }];
    }];
    
}

- (IBAction)countryClick:(id)sender {
    CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI);
    self.countryArrow.transform = transform;
    self.countryPopView = [[YBPopupMenu alloc] initWithTitles:self.countryArray icons:nil menuWidth:CGSizeMake((UGScreenW - 40) / 3, 80) delegate:self];
    self.countryPopView.fontSize = 14;
    self.countryPopView.type = YBPopupMenuTypeDefault;
    
    [self.countryPopView showRelyOnView:self.countryView];

    
}

- (IBAction)provinceClick:(id)sender {
    CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI);
    self.provinceArrow.transform = transform;
    self.provincePopView = [[YBPopupMenu alloc] initWithTitles:self.provinceArray icons:nil menuWidth:CGSizeMake((UGScreenW - 40) / 3, 300) delegate:self];
    self.provincePopView.fontSize = 14;
    self.provincePopView.type = YBPopupMenuTypeDefault;
    [self.provincePopView showRelyOnView:self.provinceView];
    
}
- (IBAction)cityClick:(id)sender {
    CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI);
    self.cityArrow.transform = transform;
    self.cityPopView = [[YBPopupMenu alloc] initWithTitles:self.cityArray icons:nil menuWidth:CGSizeMake((UGScreenW - 40) / 3, 300) delegate:self];
    self.cityPopView.fontSize = 14;
    self.cityPopView.type = YBPopupMenuTypeDefault;
    [self.cityPopView showRelyOnView:self.cityView];
    
}

- (IBAction)submit:(id)sender {
    
    [self changAddress];
    
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.loginAddressArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UGAddressCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:addressCellId forIndexPath:indexPath];
    UGLoginAddressModel *item = self.loginAddressArray[indexPath.row];
    cell.item = item;
    WeakSelf
    cell.delBlock = ^{
        [weakSelf delAddress:item];
    };
    
    return cell;
}

#pragma mark YBPopupMenu delegate

- (void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu {
    
   
    if (ybPopupMenu == self.countryPopView) {
        CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI * 2);
        self.countryArrow.transform = transform;
        if (index == -1) {
            
            return;
        }
        if (index == 1) {
            self.provinceView.hidden = YES;
            self.cityView.hidden = YES;
        }else {
            self.provinceView.hidden = NO;
            self.cityView.hidden = NO;
        }
        self.countryLabel.text = self.countryArray[index];
        self.countryIndex = index;
    }else if (ybPopupMenu == self.provincePopView) {
        CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI * 2);
        self.provinceArrow.transform = transform;
        if (index == -1) {
            
            return;
        }
        self.provinceLabel.text = self.provinceArray[index];
        UGAddressListModel *listModel = self.addressArray[index];
        UGAddressModel *model = listModel.city.firstObject;
        self.cityLabel.text = model.name;
        [self.cityArray removeAllObjects];
        if (listModel.city.count) {
            for (UGAddressModel *model in listModel.city) {
                [self.cityArray addObject:model.name];
            }
        }else {
            [self.cityArray addObject:listModel.name];
        }
        
    }else {
        CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI * 2);
        self.cityArrow.transform = transform;
        if (index == -1) {
            
            return;
        }
        self.cityLabel.text = self.cityArray[index];
    }
   
    
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 5;
        layout.minimumInteritemSpacing = 5;
        layout.itemSize = CGSizeMake(90, 30);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(60, 0, self.addressListView.width - 65, self.addressListView.height) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerNib:[UINib nibWithNibName:@"UGAddressCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:addressCellId];
        
    }
    return _collectionView;
}

- (NSMutableArray *)addressArray {
    if (_addressArray == nil) {
        _addressArray = [NSMutableArray array];
    }
    return _addressArray;
}

- (NSMutableArray *)loginAddressArray {
    if (_loginAddressArray == nil) {
        _loginAddressArray = [NSMutableArray array];
    }
    return _loginAddressArray;
}

- (NSMutableArray *)provinceArray {
    if (_provinceArray == nil) {
        _provinceArray = [NSMutableArray array];
    }
    return _provinceArray;
}

- (NSMutableArray *)cityArray {
    if (_cityArray == nil) {
        _cityArray = [NSMutableArray array];
    }
    return _cityArray;
}

@end
