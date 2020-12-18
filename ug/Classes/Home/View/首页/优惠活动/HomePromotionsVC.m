//
//  HomePromotionsVC.m
//  UGBWApp
//
//  Created by fish on 2020/10/16.
//  Copyright © 2020 ug. All rights reserved.
//

#import "HomePromotionsVC.h"
#import "UGPromoteDetailController.h"

#import "UGPromoteModel.h"

#import "PromotePopView.h"
#import "UGCellHeaderView.h"
#import "UGCell190HeaderView.h"

// 首页优惠活动View
@interface HomePromotionsVC ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *promotionView;                         /**<   优惠活动 view*/
@property (weak, nonatomic) IBOutlet UIStackView *promotionsStackView;              /**<   优惠活动 */
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSString *style;                           /**<   优惠图片样式。slide=折叠式,popup=弹窗式 page = 内页*/
@end

@implementation HomePromotionsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weakSelf_(__self);
    // 获取系统配置成功
    SANotificationEventSubscribe(UGNotificationGetSystemConfigComplete, self, ^(typeof (self) self, id obj) {
        NSInteger cnt = 0;
        for (UIView *v in __self.promotionsStackView.arrangedSubviews) {
            cnt += !v.hidden;
        }
        __self.promotionView.hidden = !SysConf.m_promote_pos || !cnt;
    });
    
    [self.tableView xw_addObserverBlockForKeyPath:@"contentSize" block:^(id  _Nonnull obj, id  _Nonnull oldVal, id  _Nonnull newVal) {
        CGFloat ht = __self.tableView.contentSize.height;
        __self.tableView.cc_constraints.height.constant  = ht +2;
    }];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"header"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    FastSubViewCode(self.view);
    subImageView(@"优惠活动图标ImageView").image = [[UIImage imageNamed:@"礼品-(1)"] qmui_imageWithTintColor:Skin1.textColor1];
    subLabel(@"优惠活动标题Label").textColor = Skin1.textColor1;
    [subButton(@"查看更多优惠活动Button") setTitleColor:Skin1.textColor1 forState:UIControlStateNormal];

    _promotionsStackView.cc_constraints.top.constant = 0;
    _promotionsStackView.cc_constraints.left.constant = 0;
}

- (void)reloadData:(void (^)(BOOL))completion {
    __weakSelf_(__self);
    [CMNetwork getPromoteListWithParams:@{} completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            UGPromoteListModel *listModel = model.data;
            NSArray *smallArray = [NSArray new];
            
            __self.style = listModel.style;
            for (UGPromoteModel *obj in listModel.list) {
                obj.style = listModel.style;
            }
            if (![CMCommon arryIsNull:listModel.list]) {
                if (listModel.list.count>5) {
                    smallArray = [listModel.list subarrayWithRange:NSMakeRange(0, 5)];
                } else {
                    smallArray = listModel.list;
                }
            }
            [__self.tableView.dataArray setArray:smallArray];
            [__self.tableView reloadData];
            __self.promotionView.hidden = !SysConf.m_promote_pos || !listModel.list.count;
            
            if (completion)
                completion(true);
        } failure:^(id msg) {
            if (completion)
                completion(false);
        }];
    }];
}


#pragma mark - IBAction

// 查看更多优惠活动
- (IBAction)onShowMorePromoteBtnClick:(UIButton *)sender {
    [self.navigationController pushViewController:_LoadVC_from_storyboard_(@"UGPromotionsController") animated:YES];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([_style isEqualToString:@"slide"]) {
        NSLog(@"count = %lu",(unsigned long)_tableView.dataArray.count);
        return _tableView.dataArray.count;
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([_style isEqualToString:@"slide"]) {
        return ((UGPromoteModel *)tableView.dataArray[section]).selected;
    } else {
        return _tableView.dataArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_style isEqualToString:@"slide"]) {
        UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        UGPromoteModel *nm = _tableView.dataArray[indexPath.section];
        
        // 加载html
        {
            UIWebView *wv = [cell viewWithTagString:@"WebView"];
            [wv stopLoading];
            [wv removeFromSuperview];
            wv = [UIWebView new];
            wv.backgroundColor = [UIColor clearColor];
            wv.tagString = @"WebView";
            [wv xw_removeObserverBlockForKeyPath:@"scrollView.contentSize"];
            [wv xw_addObserverBlockForKeyPath:@"scrollView.contentSize" block:^(UIWebView *obj, id  _Nonnull oldVal, id  _Nonnull newVal) {
                CGFloat h = nm.webViewHeight = [newVal CGSizeValue].height;
                [obj mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(h);
                }];
                [self->_tableView beginUpdates];
                [self->_tableView endUpdates];
            }];
            [cell.contentView addSubview:wv];
            [wv mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(cell.contentView).offset(-2);
                make.top.bottom.equalTo(cell.contentView).offset(2);
                make.height.mas_equalTo(60);
            }];
            if ([@"c200" containsString:APP.SiteId]) {
                [wv loadHTMLString:_NSString(@"<head><style>p{margin:0}img{width:auto !important;max-width:100%%;height:auto !important}</style></head>%@", nm.content) baseURL:nil];
            } else {
                [wv loadHTMLString:[APP htmlStyleString:nm.content] baseURL:nil];
            }
        }
        
        
        // webview 上下各一条线
        UIView *topLineView = [cell viewWithTagString:@"topLineView"];
        if (!topLineView) {
            topLineView = [UIView new];
            topLineView.backgroundColor = Skin1.navBarBgColor;
            topLineView.tagString = @"topLineView";
            [cell addSubview:topLineView];
            
            [topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.right.equalTo(cell);
                make.height.mas_equalTo(1);
            }];
        }
        UIView *bottomLineView = [cell viewWithTagString:@"bottomLineView"];
        if (!bottomLineView) {
            bottomLineView = [UIView new];
            bottomLineView.backgroundColor = Skin1.navBarBgColor;
            bottomLineView.tagString = @"bottomLineView";
            [cell addSubview:bottomLineView];
            
            [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.bottom.right.equalTo(cell);
                make.height.mas_equalTo(1);
            }];
        }
        return cell;
    } else {
        UITableViewCell *cell;
        if (APP.isC190Cell) {
            cell  = [tableView dequeueReusableCellWithIdentifier:@"cell190" forIndexPath:indexPath];
        }
        else{
            cell  = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
        }
     
        UGPromoteModel *pm = tableView.dataArray[indexPath.row];
        FastSubViewCode(cell);
        if (APP.isC190Cell) {
            subView(@"StackView").cc_constraints.top.constant = pm.title.length ? 12 : 0;
            
//            if ([@"c012" containsString:APP.SiteId]) {
//                subView(@"StackView").cc_constraints.top.constant = 12 ;
//            }
            subView(@"StackView").cc_constraints.bottom.constant = 0;
        }
        if ([@"c199" containsString:APP.SiteId]) {
            subView(@"StackView").cc_constraints.top.constant = 0;
            subView(@"StackView").cc_constraints.left.constant = 0;
        }
        if (Skin1.isJY||Skin1.isTKL) {
             subView(@"cell背景View").backgroundColor = Skin1.isBlack ? Skin1.bgColor :  RGBA(242, 242, 242, 1);
        }
        else{
             subView(@"cell背景View").backgroundColor = Skin1.isBlack ? Skin1.bgColor : Skin1.homeContentColor;
        }
        
        
        subView(@"cell背景View").layer.cornerRadius = 8;
        subView(@"cell背景View").layer.masksToBounds = YES;
        
        if (APP.isWihiteBorder) {
            subView(@"cell背景View").layer.borderWidth = 1;
            subView(@"cell背景View").layer.borderColor = [[UIColor whiteColor] CGColor];
        }
       
        subLabel(@"标题Label").textColor = Skin1.textColor1;
        subLabel(@"标题Label").text = pm.title;
        subLabel(@"标题Label").hidden = !pm.title.length;
        
        UIImageView *imgView = [cell viewWithTagString:@"图片ImageView"];
        //    imgView.frame = cell.bounds;
        NSURL *url = [NSURL URLWithString:pm.pic];
        UIImage *image = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:[[SDWebImageManager sharedManager] cacheKeyForURL:url]];
        if (image) {
            if (APP.isC190Cell) {
                CGFloat w;
                w = APP.Width-88;
                CGFloat h = image.height/image.width * w;
                imgView.cc_constraints.height.constant = h;
            } else {
                CGFloat w = APP.Width-88;
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
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UGPromoteModel *pm = tableView.dataArray[indexPath.row];
    BOOL ret = [NavController1 pushViewControllerWithLinkCategory:pm.linkCategory linkPosition:pm.linkPosition];
    if (!ret) {
        // 去优惠详情
        
        NSLog(@"style = %@",pm.style);//slide=折叠式,popup=弹窗式 page = 内页*/
        
        if ([pm.style isEqualToString:@"slide"]) {
            
        }
        else if([pm.style isEqualToString:@"popup"]) {
            PromotePopView *popView = [[PromotePopView alloc] initWithFrame:CGRectMake(20, 60, UGScreenW - 40, UGScerrnH - APP.StatusBarHeight - APP.BottomSafeHeight - 100)];
            popView.item = pm;
            [popView show];
        }
        else if([pm.style isEqualToString:@"page"]) {
            UGPromoteDetailController *detailVC = [[UGPromoteDetailController alloc] init];
            detailVC.item = pm;
            [NavController1 pushViewController:detailVC animated:YES];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if ([_style isEqualToString:@"slide"]) {
        return 0;
    } else {
        return 0;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([_style isEqualToString:@"slide"]) {
        UGPromoteModel *item = tableView.dataArray[section];
        if (APP.isC190Cell) {
               return [UGCell190HeaderView heightWithModel:item];
          }
          else{
               return [UGCellHeaderView heightWithModel:item];
          }
       
    } else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSLog(@"section = %ld",(long)section);
    UIView *contentView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    [contentView setBackgroundColor:[UIColor clearColor]];
    
    UGCellHeaderView *headerView = [contentView viewWithTagString:@"headerView"];
    if (!headerView) {
        
        if (APP.isC190Cell) {
             headerView = _LoadView_from_nib_(@"UGCell190HeaderView");
         }
         else{
             headerView = _LoadView_from_nib_(@"UGCellHeaderView");
         }
       
        headerView.tagString = @"headerView";
        [contentView addSubview:headerView];
        [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(contentView);
        }];
    }
    UGPromoteModel *item = tableView.dataArray[section];
    headerView.item = item;
    WeakSelf
    headerView.clickBllock = ^{
        
        BOOL ret = [NavController1 pushViewControllerWithLinkCategory:item.linkCategory linkPosition:item.linkPosition];
        if (!ret) {
            if ([item.style isEqualToString:@"slide"]) {
                // 去优惠详情
                item.selected = !item.selected;
                for (UGPromoteModel *pm in weakSelf.tableView.dataArray) {
                    if (pm != item) {
                        pm.selected = false;
                    }
                }
                [weakSelf.tableView reloadData];
            }
        }
    };
    headerView.hBllock = ^{
        [weakSelf.tableView reloadSection:section withRowAnimation:(UITableViewRowAnimationNone)];
    };
    return contentView;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *headerView=(UITableViewHeaderFooterView *)view;
    headerView.backgroundView = ({
        UIView * view = [[UIView alloc] initWithFrame:headerView.bounds];
        view.backgroundColor = [UIColor clearColor];
        view;
    });
}

@end
