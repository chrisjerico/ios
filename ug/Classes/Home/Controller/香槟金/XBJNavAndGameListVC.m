//
//  XBJNavAndGameListVC.m
//  UGBWApp
//
//  Created by fish on 2020/10/8.
//  Copyright © 2020 ug. All rights reserved.
//

#import "XBJNavAndGameListVC.h"
#import "UGMissionCenterViewController.h"

@interface XBJNavAndGameListVC ()<UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *navCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *gameCollectionView;
@property (weak, nonatomic) IBOutlet UITableView *gameTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navCollectionViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gameTableViewHeightConstraint;

@property (nonatomic, strong) NSArray<GameCategoryModel *> *icons;    /**<   游戏列表 */
@property (nonatomic, strong) NSArray<GameModel *> *navs;             /**<   导航按钮 */
@end

@implementation XBJNavAndGameListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _icons = [GameCategoryDataModel gameCategoryData].icons;
    _navs = [GameCategoryDataModel gameCategoryData].navs;
    _navCollectionViewHeightConstraint.constant = (_navs.count/4 + !!(_navs.count%4)) * 70;
    _gameTableViewHeightConstraint.constant = _icons.count * 64;
    
    __weakSelf_(__self);
    FastSubViewCode(self.view);
    subView(@"导航顶部提示View").backgroundColor = Skin1.menuHeadViewColor;
    subLabel(@"我的钱包Label").textColor = Skin1.textColor1;
    subLabel(@"¥Label").textColor = Skin1.isBlack ? [UIColor whiteColor] : UIColorFromHex(0xda4453);
    subLabel(@"余额Label").textColor = Skin1.isBlack ? [UIColor whiteColor] : UIColorFromHex(0xda4453);
    self.navCollectionView.superview.superview.backgroundColor = Skin1.homeContentColor;
    SANotificationEventSubscribe(UGNotificationWithSkinSuccess, self, ^(typeof (self) self, id obj) {
        subView(@"导航顶部提示View").backgroundColor = Skin1.menuHeadViewColor;
        self.navCollectionView.superview.superview.backgroundColor = Skin1.homeContentColor;
        [self.gameTableView reloadData];
        NSIndexPath *ip = [NSIndexPath indexPathForRow:0 inSection:0];
        [__self.gameTableView selectRowAtIndexPath:ip animated:true scrollPosition:UITableViewScrollPositionNone];
        [__self tableView:__self.gameTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    });
    SANotificationEventSubscribe(UGNotificationLoginComplete, self, ^(typeof (self) self, id obj) {
        [self refreshUIWithIsLogin:true];
    });
    SANotificationEventSubscribe(UGNotificationUserLogout, self, ^(typeof (self) self, id obj) {
        [self refreshUIWithIsLogin:false];
    });
    SANotificationEventSubscribe(UGNotificationGetUserInfoComplete, self, ^(typeof (self) self, id obj) {
        [self refreshUIWithIsLogin:UGLoginIsAuthorized()];
    });
    [self refreshUIWithIsLogin:UGLoginIsAuthorized()];
}

- (void)refreshUIWithIsLogin:(BOOL)isLogin {
    FastSubViewCode(self.view);
    subButton(@"点击登录Button").hidden = isLogin;
    subButton(@"退出登录Button").hidden = !isLogin;
    subButton(@"我的钱包Button").hidden = !isLogin;
    subButton(@"我的钱包Button").hidden = !isLogin;
    subView(@"钱包StackView").hidden = !isLogin;
    if (isLogin) {
        subLabel(@"晚上好Label").text = _NSString(@"晚上好！%@", UserI.username);
    } else {
        subLabel(@"晚上好Label").text = _NSString(@"晚上好，请登录。");
    }
    subLabel(@"余额Label").text = [UserI.balance removeFloatAllZero];
}

- (void)reloadData:(void (^)(BOOL succ))completion {
    // 自定义游戏列表
    [SVProgressHUD showWithStatus: nil];
    __weakSelf_(__self);
    [CMNetwork getCustomGamesWithParams:@{} completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            [SVProgressHUD dismiss];
            if (model.data) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"model.data = %@",model.data);
                    GameCategoryDataModel *customGameModel = GameCategoryDataModel.gameCategoryData = (GameCategoryDataModel *)model.data;
                    
                    // 首页导航
                    NSArray <GameModel *>*navs =__self.navs = customGameModel.navs;
                    __self.icons = customGameModel.icons;
                    __self.navCollectionViewHeightConstraint.constant = (navs.count/4 + !!(navs.count%4)) * 70;
                    __self.gameTableViewHeightConstraint.constant = __self.icons.count * 64;
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        UITableViewCell *cell = [__self.gameTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                        ((UIButton *)[cell viewWithTagString:@"Button"]).selected = true;
                    });
                    
                    // 设置任务大厅页的标题
                    GameModel *gm = [navs objectWithValue:@13 keyPath:@"subId"];
                    [UGMissionCenterViewController setTitle:gm.name.length ? gm.name : gm.title];
                    
                    // 游戏列表
                    [__self.navCollectionView reloadData];
                    [__self.gameCollectionView reloadData];
                    [__self.gameTableView reloadData];
                });
            }
            if (completion) {
                completion(true);
            }
        } failure:^(id msg) {
            [SVProgressHUD showErrorWithStatus:msg];
            if (completion)
                completion(false);
        }];
    }];
}

#pragma mark - IBAction

- (IBAction)onMyWalletBtnClick:(UIButton *)sender {
    [NavController1 pushVCWithUserCenterItemType:UCI_银行卡管理];
}

- (IBAction)onLoginBtnClick:(UIButton *)sender {
    [NavController1 pushViewController:_LoadVC_from_storyboard_(@"UGLoginViewController") animated:true];
}

- (IBAction)onLogoutBtnClick:(UIButton *)sender {
    [QDAlertView showWithTitle:@"温馨提示" message:@"确定退出账号" cancelButtonTitle:@"取消" otherButtonTitle:@"确定" completionBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [CMNetwork userLogoutWithParams:@{@"token":[UGUserModel currentUser].sessid} completion:nil];
                UGUserModel.currentUser = nil;
                SANotificationEventPost(UGNotificationUserLogout, nil);
            });
        }
    }];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView != _gameCollectionView) return;
    
    if (scrollView.isTracking || scrollView.isDecelerating) {
        __weakSelf_(__self);
        CGFloat cellH = [self collectionView:_gameCollectionView layout:_gameCollectionView.collectionViewLayout sizeForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]].height;

        int idx = 0;
        CGFloat current = 0;
        for (GameCategoryModel *gcm in _icons) {
            CGFloat next = current + (gcm.list.count/2 + gcm.list.count%2) * (cellH + 4) + 10;
            if (scrollView.contentOffset.y > next ) {
                current = next;
                idx++;
            } else {
                break;
            }
        }
        UITableViewCell *cell = [__self.gameTableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:idx inSection:0]];
        ((UIButton *)[cell viewWithTagString:@"Button"]).selected = true;
    }
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _icons.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    FastSubViewCode(cell);
    __weakSelf_(__self);
    GameCategoryModel *gcm = _icons[indexPath.row];
    subView(@"背景色View").backgroundColor = cell.selected ? Skin1.navBarBgColor : Skin1.homeContentColor;
    [subImageView(@"游戏分类图标ImageView") sd_setImageWithURL:[NSURL URLWithString:gcm.logo]];
    subLabel(@"游戏分类标题Label").text = gcm.name;
    subLabel(@"游戏分类标题Label").textColor = cell.selected ? UIColor.whiteColor : (Skin1.isBlack ? Skin1.textColor2 : UIColor.blackColor);
    [subButton(@"Button") removeAllBlocksForControlEvents:UIControlEventTouchUpInside];
    [subButton(@"Button") addBlockForControlEvents:UIControlEventTouchUpInside block:^(UIButton *sender) {
        sender.selected = true;
        
        CGFloat offsetY = 0;
        CGFloat cellH = [__self collectionView:__self.gameCollectionView layout:__self.gameCollectionView.collectionViewLayout sizeForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]].height;
        for (GameCategoryModel *temp in __self.icons) {
            if (temp == gcm) break;
            offsetY += (temp.list.count/2 + temp.list.count%2) * (cellH + 4) + 10;
        }
        [__self.gameCollectionView setContentOffset:CGPointMake(0, offsetY) animated:true];
    }];
    static UIButton *lastSelectedButton = nil;
    [subButton(@"Button") xw_addObserverBlockForKeyPath:@"selected" block:^(UIButton *obj, id  _Nonnull oldVal, id  _Nonnull newVal) {
        if (obj.selected && lastSelectedButton != obj) {
            lastSelectedButton.selected = false;
            lastSelectedButton = obj;
        }
        subView(@"背景色View").backgroundColor = obj.selected ? Skin1.menuHeadViewColor : Skin1.homeContentColor;
        subLabel(@"游戏分类标题Label").textColor = obj.selected ? UIColor.whiteColor : (Skin1.isBlack ? Skin1.textColor2 : UIColor.blackColor);
    }];
    
    if ([APP.SiteId isEqualToString:@"c245"]) {
        [subImageView(@"游戏分类大图ImageView") sd_setImageWithURL:[NSURL URLWithString:gcm.logo]];
    }
    return cell;
}


#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return collectionView == _gameCollectionView ? _icons.count : 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == _navCollectionView) {
        return CGSizeMake((APP.Width-24-100-4)/4-1, 70);
    } else {
        return CGSizeMake((APP.Width-24-100-8)/2-1, 92);
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == _gameCollectionView) {
        return _icons[section].list.count;
    }
    return _navs.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    FastSubViewCode(cell);
    if (collectionView == _navCollectionView) {
        GameModel *gm = _navs[indexPath.item];
        [subImageView(@"导航图标ImageView") sd_setImageWithURL:[NSURL URLWithString:gm.logo]];
        subLabel(@"导航标题Label").text = gm.name.length ? gm.name : gm.title;;
        
    } else if (collectionView == _gameCollectionView) {
        GameModel *gm = _icons[indexPath.section].list[indexPath.item];
        [subImageView(@"游戏图标ImageView") sd_setImageWithURL:[NSURL URLWithString:gm.logo]];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    GameModel *gm = nil;
    if (collectionView == _navCollectionView) {
        gm = _navs[indexPath.item];
    } else if (collectionView == _gameCollectionView) {
        gm = _icons[indexPath.section].list[indexPath.item];
    }
    [NavController1 pushViewControllerWithGameModel:gm];
}

@end
