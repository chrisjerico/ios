//
//  UGPromotionsListController.m
//  ug
//
//  Created by ug on 2020/2/22.
//  Copyright © 2020 ug. All rights reserved.
//

#import "UGPromotionsListController.h"
#import "UGPromoteModel.h"
#import "GameCategoryDataModel.h"
#import "UGPromoteDetailController.h"   // 优惠详情
#import "PromoteTitleCollectionViewCell.h"
#define CollectionViewW (APP.Width-2)

@interface UGPromotionsListController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSString *typeid;/**<   选中优惠图片分类信息类型*/
@property (nonatomic,strong)  NSMutableArray <UGPromoteTitleCellModel*> *itemArray;
@end

@implementation UGPromotionsListController

- (BOOL)允许未登录访问 { return ![@"c049,c008" containsString:APP.SiteId]; }
- (BOOL)允许游客访问 { return true; }

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"优惠活动";
    self.view.backgroundColor = Skin1.bgColor;
    self.tableView.backgroundColor = Skin1.bgColor;
    self.tableView.tableFooterView = ({
         UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP.Width, 15)];
         v.backgroundColor = [UIColor clearColor];
         v;
     });
    __weakSelf_(__self);
       self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
           [__self getPromoteList];
       }];
     [_collectionView registerNib:[UINib nibWithNibName:@"PromoteTitleCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"PromoteTitleCollectionViewCell"];
    UICollectionViewFlowLayout *layout = ({
            layout = [[UICollectionViewFlowLayout alloc] init];
            layout.minimumInteritemSpacing = 0;
            layout.minimumLineSpacing = 0;
            layout.sectionInset = UIEdgeInsetsMake(0, 2, 0, 2);
            layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            layout;
        });
    
    [_collectionView setCollectionViewLayout:layout];
    _itemArray =[NSMutableArray new];
    
    [self getPromotionsType];
    
    
}



// 获取优惠图片分类信息
- (void)getPromotionsType {
        __weakSelf_(__self);
    [CMNetwork getPromotionsTypeWithParams:@{} completion:^(CMResult<id> *model, NSError *err) {
        [SVProgressHUD showWithStatus:nil];
        [CMResult processWithResult:model success:^{
            NSLog(@"model = %@",model);
            [SVProgressHUD dismiss];
            NSDictionary *dic = model.data;
            
            NSDictionary *dicType = dic[@"typeArr"];
            
            [dicType enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                NSLog(@"key = %@ and obj = %@", key, obj);
                UGPromoteTitleCellModel *cModel = [UGPromoteTitleCellModel new];
                cModel.title = (NSString *)obj;
                cModel.key = (NSString *)key;
                
                [__self.itemArray addObject:obj ];

            }];
            
            NSNumber * number = dic[@"typeIsShow"];
            
            if ([number intValue] == 1) {
                [self.collectionView setHidden:NO];
            }
            else{
                [self.collectionView setHidden:YES];
                
            }
            

        } failure:^(id msg) {
            [self.collectionView setHidden:YES];
            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }];
}

- (void)getPromoteList {
    __weakSelf_(__self);
    [SVProgressHUD show];
    NSDictionary *params = [NSDictionary new];
    if (![CMCommon stringIsNull:_typeid]) {
        params = @{@"typeid":_typeid};
    }
    [CMNetwork getPromoteListWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [__self.tableView.mj_header endRefreshing];
        [SVProgressHUD dismiss];
        [CMResult processWithResult:model success:^{
            UGPromoteListModel *listModel = model.data;
            [__self.tableView.dataArray setArray:listModel.list];
            [__self.tableView reloadData];
        } failure:^(id msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return tableView.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if ([@"c190" containsString:APP.SiteId]) {
        cell  = [tableView dequeueReusableCellWithIdentifier:@"cell190" forIndexPath:indexPath];
    }
    else{
        cell  = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    }
    UGPromoteModel *pm = tableView.dataArray[indexPath.row];
    FastSubViewCode(cell);
    if ([@"c190" containsString:APP.SiteId]) {
        subView(@"StackView").cc_constraints.top.constant = pm.title.length ? 12 : 0;
        subView(@"StackView").cc_constraints.bottom.constant = 0;
    }
    if ([@"c199" containsString:APP.SiteId]) {
        subView(@"StackView").cc_constraints.top.constant = 0;
        subView(@"StackView").cc_constraints.left.constant = 0;
    }
    
    subView(@"cell背景View").backgroundColor = Skin1.isBlack ? Skin1.bgColor : Skin1.homeContentColor;
    subLabel(@"标题Label").textColor = Skin1.textColor1;
    subLabel(@"标题Label").text = pm.title;
    subLabel(@"标题Label").hidden = !pm.title.length;
    
    UIImageView *imgView = [cell viewWithTagString:@"图片ImageView"];
//    imgView.frame = cell.bounds;
    NSURL *url = [NSURL URLWithString:pm.pic];
    UIImage *image = [[SDImageCache sharedImageCache] imageFromCacheForKey:[[SDWebImageManager sharedManager] cacheKeyForURL:url]];
    if (image) {
        if ([@"c190" containsString:APP.SiteId]) {
            CGFloat w = APP.Width;
            CGFloat h = image.height/image.width * w;
            imgView.cc_constraints.height.constant = h;
        } else {
            CGFloat w = APP.Width - 48;
            CGFloat h = image.height/image.width * w;
            imgView.cc_constraints.height.constant = h;
            
        
        }
        [imgView sd_setImageWithURL:url];   // 由于要支持gif动图，还是用sd加载
    } else {
        __weakSelf_(__self);
        __weak_Obj_(imgView, __imgView);
        imgView.cc_constraints.height.constant = 60;
        [imgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (image) {
                [__self.tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
            }
        }];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UGPromoteModel *pm = tableView.dataArray[indexPath.row];
    BOOL ret = [NavController1 pushViewControllerWithLinkCategory:pm.linkCategory linkPosition:pm.linkPosition];
    if (!ret) {
        // 去优惠详情
        UGPromoteDetailController *detailVC = [[UGPromoteDetailController alloc] init];
        detailVC.item = pm;
        [NavController1 pushViewController:detailVC animated:YES];
    }
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _itemArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    UGPromoteTitleCellModel *listModel =  [_itemArray objectAtIndex:indexPath.row];
    PromoteTitleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PromoteTitleCollectionViewCell" forIndexPath:indexPath];
    cell.titleLabel.text = listModel.title;
    cell.backgroundColor = [UIColor clearColor];
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
     UGPromoteTitleCellModel *listModel =  [_itemArray objectAtIndex:indexPath.row];
    _typeid = listModel.key;
    [self getPromotionsType];
}

- (CGFloat)collectionViewCellWith:(NSInteger )row{
    CGFloat space = ({
        space = 20;
        CGFloat totalW = 0;
        for (UGPromoteTitleCellModel *gcm in _itemArray) {
            totalW += [gcm.title widthForFont:[UIFont systemFontOfSize:18]] + space;
        }
        if (totalW < CollectionViewW-4) {
            space += (CollectionViewW-4 - totalW)/_itemArray.count;
        }
        space;
    });
    UGPromoteTitleCellModel *gcm = _itemArray[row];
    CGFloat w = [gcm.title widthForFont:[UIFont systemFontOfSize:18]] + space;

    return w;
    
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat w = [self collectionViewCellWith:indexPath.row];
    return CGSizeMake(w,  50);
}
@end
