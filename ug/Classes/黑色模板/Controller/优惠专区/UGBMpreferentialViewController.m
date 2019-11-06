//
//  UGBMpreferentialViewController.m
//  ug
//
//  Created by ug on 2019/11/3.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGBMpreferentialViewController.h"
#import "UGBMHeaderView.h"
#import "LeeTagView.h"
#import "UGPromoteModel.h"
#import "UGPromoteDetailController.h"

@interface UGBMpreferentialViewController ()<LeeTagViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
     UGBMHeaderView *headView;                /**<   导航头 */
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet LeeTagView *radioTagView; /**<   单选标签组 */

@end

@implementation UGBMpreferentialViewController

- (BOOL)允许未登录访问 { return true; }
- (BOOL)允许游客访问 { return true; }

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [headView.leftwardMarqueeView start];
    [self.navigationController setNavigationBarHidden:YES];//强制隐藏NavBar

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [headView.leftwardMarqueeView pause];//fixbug  发热  掉电快
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"优惠活动";
    self.fd_prefersNavigationBarHidden = YES;
    [self creatView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.view.backgroundColor = Skin1.bgColor;
    self.tableView.backgroundColor = Skin1.bgColor;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getPromoteList];
    }];
    [self getPromoteList];
}

-(void)creatView{
    //===============导航头布局=================
       headView = [[UGBMHeaderView alloc] initView];
       [self.view addSubview:headView];
       [headView mas_makeConstraints:^(MASConstraintMaker *make) { //数组额你不必须都是view
           make.top.equalTo(self.view.mas_top).with.offset(k_Height_StatusBar);
           make.left.equalTo(self.view.mas_left).offset(0);
           make.height.equalTo([NSNumber numberWithFloat:110]);
           make.width.equalTo([NSNumber numberWithFloat:UGScreenW]);
       }];
    //=============== 单选标签组=================
    _radioTagView.delegate = self;
      _radioTagView.tagViewSelectionStyle = LeeTagViewStyleSelectSingle;
      _radioTagView.tagViewLineStyle = LeeTagViewLineStyleMulti;
      _radioTagView.tagViewPadding = UIEdgeInsetsMake(5, 5, 5, 5);
      _radioTagView.tagViewMaxWidth = self.view.frame.size.width;
      [[self tagDataArray] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
          LeeTagItemViewModel * tagModel = [[LeeTagItemViewModel alloc]init];
          tagModel.normalTitle = obj;
          tagModel.normalBorderWidth = 1.0f;
          tagModel.normalCornerRadius = 3.0f;
          tagModel.normalColor = [UIColor whiteColor];
          tagModel.normalBorderColor =  UGRGBColor(72, 122, 178);
          tagModel.normalBGColor = UGRGBColor(72, 122, 178);

          tagModel.selectedTitle = obj;
          tagModel.selectedColor = [UIColor whiteColor];
          tagModel.selectedBGColor = UGRGBColor(118, 181, 103);
          tagModel.selectedBorderColor =  UGRGBColor(72, 122, 178);
          [self.radioTagView addTag:tagModel];
      }];
    //=============== table布局=================
    
//    if ([self.tabBarController.tabBar isHidden]) {
//        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
//                     make.top.equalTo(_radioTagView.mas_bottom).with.offset(0);
//                     make.left.equalTo(self.view.mas_left).offset(0);
//                     make.bottom.equalTo(self.view.mas_bottom).offset(0);
//                     make.width.equalTo([NSNumber numberWithFloat:UGScreenW]);
//        }];
//    }
//    else{
//        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
//                     make.top.equalTo(_radioTagView.mas_bottom).with.offset(0);
//                     make.left.equalTo(self.view.mas_left).offset(0);
//                     make.bottom.equalTo(self.view.mas_bottom).offset(-k_Height_TabBar);
//                     make.width.equalTo([NSNumber numberWithFloat:UGScreenW]);
//        }];
//    }
    
    [self.tableView setFrame:CGRectMake(0, 0, UGScreenW, ({
        CGFloat h = APP.Height;
        if ([NavController1.viewControllers.firstObject isKindOfClass:[UGBMpreferentialViewController class]])
            h -= APP.Height - TabBarController1.tabBar.y;
        h;
    }))];
   
}

- (void)getPromoteList {
    __weakSelf_(__self);
    [SVProgressHUD show];
    [CMNetwork getPromoteListWithParams:@{} completion:^(CMResult<id> *model, NSError *err) {
        [__self.tableView.mj_header endRefreshing];
        [SVProgressHUD dismiss];
        [CMResult processWithResult:model success:^{
            UGPromoteListModel *listModel = model.data;
            [__self.tableView.dataArray setArray:listModel.list];
            [__self.tableView reloadData];
        } failure:nil];
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return tableView.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = Skin1.cellBgColor;
    UGPromoteModel *pm = tableView.dataArray[indexPath.row];
    FastSubViewCode(cell);
    NSLog(@"pm.title = %@", pm.title);
    subLabel(@"标题Label").textColor = Skin1.textColor1;
    subLabel(@"标题Label").text = pm.title;
    [subImageView(@"图片ImageView") sd_setImageWithURL:[NSURL URLWithString:pm.pic] placeholderImage:[UIImage imageNamed:@"placeholder"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (image) {
            subImageView(@"图片ImageView").cc_constraints.height.constant = image.height/image.width * (APP.Width - 48);
        }
    }];
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

-(NSArray *)tagDataArray{
    return @[
             @"所有优惠",
             @"棋牌游戏",
             @"捕鱼优惠",
             @"电子游艺",
             @"手机App专惠",
             @"真人视讯",
             @"其他优惠",
             @"亿元现金回馈",
             @"历史优惠"
             ];
}

#pragma mark - LeeTagView 点击
-(void)leeTagView:(LeeTagView *)tagView tapTagItem:(LeeTagItem *)tagItem atIndex:(NSInteger)index{
    NSLog(@"选择的=%@",[[self tagDataArray] objectAtIndex:index]);
}
@end
