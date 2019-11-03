//
//  UGfinancialViewViewController.m
//  ug
//
//  Created by ug on 2019/10/30.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGfinancialViewViewController.h"
#import "SyyRadioButton.h"
#import "UGBMHeaderView.h"
#import "UGBMfinancialCollectionViewCell.h"
#import "UGfinancialView.h"
#import "UGOnlineWithdrawalsView.h"
#import "DLPickerView.h"

@interface UGfinancialViewViewController ()<SyyRadioButtonDelegate,UICollectionViewDelegate,UICollectionViewDataSource>{
    UGBMHeaderView *headView;                /**<   导航头 */
    UIView *contentView;                     /**<   导航按钮视图 */
    UGfinancialView *myView;      /**<   线上支付+快速充值+公司入款 视图 */
    UGOnlineWithdrawalsView *myOnlineView;      /**<   线上取款 视图 */
    
    NSMutableArray *myCollectArray;          /**<   myCollectionView数据*/
    NSString * selectNav;                     /**<  选中的按钮组的按钮标题*/
}


@end

@implementation UGfinancialViewViewController

- (BOOL)允许游客访问 { return true; }

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = Skin1.bgColor;
    self.fd_prefersNavigationBarHidden = YES;
    selectNav = @"线上支付";
    myCollectArray = [NSMutableArray new];
    [self initMyCollectionViewDateSource];
    [self creatView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

-(void)initMyCollectionViewDateSource{
    [myCollectArray removeAllObjects];
    if ([selectNav isEqualToString:@"线上支付"]) {
           [myCollectArray addObject:@{@"title" : @"Wap支付宝" , @"imgName" : @"BM_ali_payment" }];
           [myCollectArray addObject:@{@"title" : @"支付宝扫码" , @"imgName" : @"BM_ali_payment" }];
           [myCollectArray addObject:@{@"title" : @"Wap微信" , @"imgName" : @"BM_wechat_payment" }];
           [myCollectArray addObject:@{@"title" : @"微信扫码" , @"imgName" : @"BM_wechat_payment" }];
           [myCollectArray addObject:@{@"title" : @"QQ扫码" , @"imgName" : @"BM_qqwallet_payment" }];
           [myCollectArray addObject:@{@"title" : @"银联扫码" , @"imgName" : @"BM_unionscan_payment" }];
           [myCollectArray addObject:@{@"title" : @"网银" , @"imgName" : @"BM_online_payment" }];
           [myCollectArray addObject:@{@"title" : @"京东" , @"imgName" : @"BM_jd_payment" }];
           [myCollectArray addObject:@{@"title" : @"点卡" , @"imgName" : @"BM_pointcard_payment" }];
    }
    else if([selectNav isEqualToString:@"快速充值"]) {
           [myCollectArray addObject:@{@"title" : @"快速充值" , @"imgName" : @"BM_externalPayment" }];
    }
    else if([selectNav isEqualToString:@"公司入款"]) {
           [myCollectArray addObject:@{@"title" : @"银行转账" , @"imgName" : @"BM_online_payment" }];
           [myCollectArray addObject:@{@"title" : @"Wap微信" , @"imgName" : @"BM_wechat_payment" }];
           [myCollectArray addObject:@{@"title" : @"QQ扫码" , @"imgName" : @"BM_qqwallet_payment" }];
    }
}

-(void)creatView{
    
    //===============导航头布局=================
    headView = [[UGBMHeaderView alloc] initView];
    [self.view addSubview:headView];
    [headView mas_makeConstraints:^(MASConstraintMaker *make) { //数组额你不必须都是view
        make.top.equalTo(self.view.mas_top).with.offset(k_Height_StatusBar);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.height.equalTo([NSNumber numberWithFloat:100]);
        make.width.equalTo([NSNumber numberWithFloat:UGScreenW]);
    }];
    //===============按钮组布局=================
    UIView *btnView = [[UIView alloc] init];
    [btnView setBackgroundColor:UGRGBColor(26, 26, 26)];
    [self.view addSubview:btnView];
    [btnView mas_makeConstraints:^(MASConstraintMaker *make) { //数组额你不必须都是view
        make.top.equalTo(headView.mas_bottom).with.offset(0);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.height.equalTo([NSNumber numberWithFloat:45]);
        make.width.equalTo([NSNumber numberWithFloat:UGScreenW]);
    }];
    NSMutableArray *btnArray;
    btnArray =  [NSMutableArray new];
    NSMutableArray *titleArray;
    titleArray = [[NSMutableArray alloc] initWithObjects:@"线上支付",@"公司入款",@"快速充值",@"线上取款",nil];
    UIImage *image = [UIImage imageNamed:@"BM_Nav1"];
    [image resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height*0.5, image.size.width*0.5, image.size.height*0.5, image.size.width*0.5)];
    UIImage *image2 = [UIImage imageNamed:@"BM_Nav2"];
   [image2 stretchableImageWithLeftCapWidth:image2.size.width / 2 topCapHeight:image2.size.height / 2];
    for (int i = 0; i < titleArray.count; i ++) {
          SyyRadioButton *mbtn = [SyyRadioButton buttonWithType:UIButtonTypeCustom];
          [mbtn setTitle:[titleArray objectAtIndex:i] forState:UIControlStateNormal];
          [mbtn setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal];
           mbtn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
          [mbtn setBackgroundImage:image forState:UIControlStateNormal];
          [mbtn setBackgroundImage:image2 forState:UIControlStateHighlighted];
          [mbtn setBackgroundImage:image2 forState:UIControlStateSelected];
          mbtn.tag =  i;
          [mbtn initWithDelegate:self groupId:@"groupId1"];
          [btnView addSubview:mbtn];
          [btnArray addObject:mbtn]; //保存添加的控件
          if (i==0) {
              [mbtn setChecked:YES];
              selectNav = @"线上支付";
          }
      }
    float width = UGScreenW/4;
    float height = 45;
    //水平方向宽度固定等间隔
    [btnArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:width leadSpacing:0 tailSpacing:0];
    [btnArray mas_makeConstraints:^(MASConstraintMaker *make) { //数组额你不必须都是view
        make.top.equalTo(btnView.mas_top).with.offset(0);
        make.height.equalTo([NSNumber numberWithFloat:height]);
    }];
    //===============内容面板布局=================
    contentView = [UIView new];
    [contentView setBackgroundColor:UGRGBColor(17, 17, 17)];
    [self.view addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
           make.top.equalTo(btnView.mas_bottom).with.offset(0);
           make.left.equalTo(self.view.mas_left).offset(0);
           make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
           make.width.equalTo([NSNumber numberWithFloat:UGScreenW]);
    }];
    //线上支付+快速充值+公司入款
    [self initLHCollectionView];
    [contentView addSubview:myView];
    [myView mas_makeConstraints:^(MASConstraintMaker *make) {
          make.top.equalTo(contentView.mas_top).with.offset(0);
          make.left.equalTo(contentView.mas_left).offset(0);
          make.bottom.equalTo(contentView.mas_bottom).with.offset(0);
          make.width.equalTo([NSNumber numberWithFloat:UGScreenW]);
    }];
    FastSubViewCode(contentView);
    
     __block BOOL isOK = YES ;
    [subButton(@"按钮") handleControlEvents:UIControlEventTouchUpInside actionBlock:^(__kindof UIControl *sender) {
        if (isOK) {
            NSString *str = subLabel(@"内容").text;
            CGFloat height = [CMCommon getLabelWidthWithText:str stringFont:[UIFont systemFontOfSize:13.0] allowHeight:(UGScreenW-100)];
            CGFloat height_poor = height - 44;
            subView(@"内容View").cc_constraints.height.constant =  60.0 + height_poor;
            isOK = NO;
            CGAffineTransform transform= CGAffineTransformMakeRotation(M_PI*1);
            subImageView(@"箭头图片").transform = transform;//旋转

        } else {
            subView(@"内容View").cc_constraints.height.constant =  60;
            isOK = YES;
            CGAffineTransform transform= CGAffineTransformMakeRotation(M_PI*2);
            subImageView(@"箭头图片").transform = transform;//旋转
            
        }

    }];
     //线上取款
    myOnlineView = [[UGOnlineWithdrawalsView alloc] initView];
    [contentView addSubview:myOnlineView];
    [myOnlineView mas_makeConstraints:^(MASConstraintMaker *make) {
          make.top.equalTo(contentView.mas_top).with.offset(0);
          make.left.equalTo(contentView.mas_left).offset(0);
          make.bottom.equalTo(contentView.mas_bottom).with.offset(0);
          make.width.equalTo([NSNumber numberWithFloat:UGScreenW]);
    }];
    
    [subButton(@"在线View按钮") handleControlEvents:UIControlEventTouchUpInside actionBlock:^(__kindof UIControl *sender) {
          DLPickerView *pickerView = [[DLPickerView alloc] initWithDataSource:@[@"中国银行",@"工商银行"]
                                                             withSelectedItem:subTextView(@"在线银行Text").text
                                                            withSelectedBlock:^(id selectedItem) {
                                                                [subTextView(@"在线银行Text") setText:selectedItem];
                                                            }
          ];
          
          [pickerView show];
    }];
    
    [myView setHidden:NO];
    [myOnlineView setHidden:YES];
    
}

#pragma mark - 线上支付+快速充值+公司入款
- (void)initLHCollectionView {
    myView = [[UGfinancialView alloc] initView];
    myView.myCollectionView.dataSource = self;
    myView.myCollectionView.delegate = self;
    myView.myCollectionView.tagString= @"线上+充值";
    [myView.myCollectionView registerNib:[UINib nibWithNibName:@"UGBMfinancialCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
  
}
#pragma mark UICollectionView datasource
//collectionView有几个section
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
//每个section有几个item
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    int rows = 0;
    rows = (int)myCollectArray.count;
    return rows;
}
//每个cell的具体内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
   UGBMfinancialCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    NSDictionary *dic = [myCollectArray objectAtIndex:indexPath.row];
    FastSubViewCode(cell);
    [subImageView(@"图片") setImage:[UIImage imageNamed:[dic objectForKey:@"imgName"]]];
    [subLabel(@"内容") setText:[dic objectForKey:@"title"]];
    return cell;
}
//cell size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
         float itemW = (UGScreenW-1)/ 2.0;
         CGSize size = {itemW, 80};
         return size;
}
//item偏移
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
}
//行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 1.0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

#pragma mark - SyyRadioButtonDelegate
- (void)didSelectedRadioButton:(SyyRadioButton *)radio groupId:(NSString *)groupId{
    NSLog(@"did selected radio:%ld %@ groupId:%@",(long)radio.tag, radio.titleLabel.text, groupId);
    selectNav = radio.titleLabel.text;
    if ([selectNav isEqualToString:@"线上支付"]) {
        [self initMyCollectionViewDateSource];
        [myView.myCollectionView reloadData];
        [myView setHidden:NO];
        [myOnlineView setHidden:YES];
        [myView.myCollectionView setHidden:NO];
        [myView.titleView setHidden:YES];
    }
    else if([selectNav isEqualToString:@"公司入款"]) {
        [self initMyCollectionViewDateSource];
        [myView.myCollectionView reloadData];
        [myView setHidden:NO];
        [myOnlineView setHidden:YES];
        [myView.myCollectionView setHidden:NO];
        [myView.titleView setHidden:NO];
    }
    else if([selectNav isEqualToString:@"快速充值"]) {
        [self initMyCollectionViewDateSource];
        [myView.myCollectionView reloadData];
        [myView setHidden:NO];
        [myOnlineView setHidden:YES];
        [myView.myCollectionView setHidden:NO];
        [myView.titleView setHidden:YES];
    }
    else if([selectNav isEqualToString:@"线上取款"]) {
        [myView setHidden:YES];
        [myOnlineView setHidden:NO];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
