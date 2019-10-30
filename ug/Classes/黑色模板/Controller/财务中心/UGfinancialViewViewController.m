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
@interface UGfinancialViewViewController ()<SyyRadioButtonDelegate>{
    UGBMHeaderView *headView;
    UIView *contentView;
}

@end

@implementation UGfinancialViewViewController

- (BOOL)允许游客访问 { return true; }

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:UGBlackModelColor];
    self.fd_prefersNavigationBarHidden = YES;
    [self creatView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) { //数组额你不必须都是view
           make.top.equalTo(btnView.mas_bottom).with.offset(0);
           make.left.equalTo(self.view.mas_left).offset(0);
           make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
           make.width.equalTo([NSNumber numberWithFloat:UGScreenW]);
    }];
    //线上支付+快速充值
    
    
}

#pragma mark - Others Delegate 代理（其他）

#pragma mark - SyyRadioButtonDelegate
- (void)didSelectedRadioButton:(SyyRadioButton *)radio groupId:(NSString *)groupId{
    NSLog(@"did selected radio:%ld %@ groupId:%@",(long)radio.tag, radio.titleLabel.text, groupId);
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
