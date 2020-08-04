//
//  UGSecurityCenterViewController.m
//  ug
//
//  Created by ug on 2019/5/7.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGSecurityCenterViewController.h"
#import "XYYSegmentControl.h"
#import "UGModifyPayPwdController.h"
#import "UGModifyLoginPwdController.h"
#import "UGModifyLoginPlaceController.h"
#import "UGSystemConfigModel.h"
#import "UGGoogleAuthenticationFirstViewController.h"
#import "UGBindCardViewController.h"
#import "UGSetupPayPwdController.h"
#import "UGgoBindViewController.h"
@interface UGSecurityCenterViewController ()<XYYSegmentControlDelegate>
@property (nonatomic, strong) XYYSegmentControl *slideSwitchView;
@property (nonatomic, strong) NSMutableArray <NSString *> *itemArray;
@property (nonatomic, strong) NSArray *vcs;
@end

@implementation UGSecurityCenterViewController
-(void)skin{
    [self buildSegment];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];//强制显示NavBar
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.title) {
        self.title = @"安全中心";
    }
    self.view.backgroundColor = Skin1.bgColor;
    SANotificationEventSubscribe(UGNotificationWithSkinSuccess, self, ^(typeof (self) self, id obj) {
        [self skin];
    });
    
    if ([self.fromVC  isEqualToString:@"fromLoginViewController"]) {

        UIImage *sureImage = [UIImage imageNamed:@"back_icon"];
        UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        float width = 10.0;
        if (sureImage.size.width<width) {
            sureButton.bounds = CGRectMake(0 , 0, width, sureImage.size.height );
            UIEdgeInsets e = UIEdgeInsetsMake(0, sureImage.size.width-width, 0, 0);// CGFloat top, left, bottom, right;
            [sureButton setImageEdgeInsets:e];
        }
        else if (sureImage.size.width >30.0){

            //压缩图片大小
            sureImage = [CMCommon imageWithImage:sureImage scaledToSize:CGSizeMake(20, 20)];
            sureButton.contentEdgeInsets =UIEdgeInsetsMake(0, -25, 0, 0);
            [sureButton setImage:sureImage forState:UIControlStateNormal];
            sureButton.frame = CGRectMake(0, 0, 60, 30);
        }
        else{
            sureButton.bounds = CGRectMake( 0, 0, sureImage.size.width, sureImage.size.height );
        }
        
        [sureButton setImage:sureImage forState:UIControlStateNormal];
        
        [sureButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *sureButtonItem = [[UIBarButtonItem alloc] initWithCustomView:sureButton];
        self.navigationItem.leftBarButtonItem = sureButtonItem;
    }
    
    [self buildSegment];
    
    [self getSystemConfig];
}


#pragma mark - 配置segment

-(void)buildSegment {
    self.itemArray = [NSMutableArray new];
    [self.itemArray addObject:@"登录密码"];
    [self.itemArray addObject:@"取款密码"];
    
    UGSystemConfigModel *config = [UGSystemConfigModel currentConfig];
    if ([config.oftenLoginArea isEqualToString: @"0"]) {
        [self.itemArray addObject:@"常用登录地"];
    }

    if (config.googleVerifier == 1) {
        [self.itemArray addObject:@"二次验证"];
    }
    
//    self.slideSwitchView = [[XYYSegmentControl alloc] initWithFrame:CGRectMake(0 , 0, self.view.width, self.view.height) channelName:self.itemArray source:self];
//    [self.slideSwitchView setUserInteractionEnabled:YES];
//    self.slideSwitchView.segmentControlDelegate = self;
//    //设置tab 颜色(可选)
//    self.slideSwitchView.tabItemNormalColor = [UIColor grayColor];
//    self.slideSwitchView.tabItemNormalFont = 13;
//    //设置tab 被选中的颜色(可选)
//    self.slideSwitchView.tabItemSelectedColor = Skin1.navBarBgColor;
//    //设置tab 背景颜色(可选)
//    self.slideSwitchView.tabItemNormalBackgroundColor = [UIColor whiteColor];
//    //设置tab 被选中的标识的颜色(可选)
//    self.slideSwitchView.tabItemSelectionIndicatorColor = Skin1.navBarBgColor;
//    [self.view addSubview:self.slideSwitchView];
    
    self.slideSwitchView = [[XYYSegmentControl alloc] initWithFrame:CGRectMake(0 , 0, self.view.width, self.view.height) channelName:self.itemArray source:self];
    [self.slideSwitchView setUserInteractionEnabled:YES];
    self.slideSwitchView.segmentControlDelegate = self;
    //设置tab 颜色(可选)
    self.slideSwitchView.tabItemNormalColor = Skin1.textColor2;
    self.slideSwitchView.tabItemNormalFont = 13;
    //设置tab 被选中的颜色(可选)
    self.slideSwitchView.tabItemSelectedColor = Skin1.textColor1;
    //设置tab 背景颜色(可选)
    self.slideSwitchView.tabItemNormalBackgroundColor = Skin1.textColor4;
    //设置tab 被选中的标识的颜色(可选)
    self.slideSwitchView.tabItemSelectionIndicatorColor = Skin1.textColor1;
    [self.view addSubview:self.slideSwitchView];
}


#pragma mark - XYYSegmentControlDelegate

- (NSUInteger)numberOfTab:(XYYSegmentControl *)view {
    return [self.itemArray count];//items决定
}

///待加载的控制器
- (UIViewController *)slideSwitchView:(XYYSegmentControl *)view viewOfTab:(NSUInteger)number {
    if (!_vcs.count) {
        _vcs = @[_LoadVC_from_storyboard_(@"UGModifyLoginPwdController"),   // 登录密码
                 UserI.hasFundPwd ? _LoadVC_from_storyboard_(@"UGModifyPayPwdController") : [UGgoBindViewController new],   // 取款密码
                 SysConf.oftenLoginArea.intValue ? nil : _LoadVC_from_storyboard_(@"UGModifyLoginPlaceController"), // 常用登录地
                 [UGGoogleAuthenticationFirstViewController new],   // 二次验证
        ];
    }
    return _vcs[number] ? : _vcs.lastObject;
}

- (void)slideSwitchView:(XYYSegmentControl *)view didselectTab:(NSUInteger)number {
    NSString *titleStr = [self.itemArray objectAtIndex:number];
    if ([titleStr isEqualToString:@"常用登录地" ]) {

        
        if (Skin1.isBlack) {
            [LEEAlert alert].config
            .LeeAddTitle(^(UILabel *label) {
                label.text = @"⚠️为了您的账号安全，现在可以绑定常用登录地";
                label.textColor = [UIColor redColor];
                label.textAlignment = NSTextAlignmentCenter;
            })
            .LeeAddContent(^(UILabel *label) {
                label.text = @"1、绑定后，只有在常用地范围内，才能正常登录\n2、可以绑定多个常用地\n3、绑定后，可选择默认选项（请选择国家-请选择省-请选择市）即可自行解除绑定";
                label.textColor = Skin1.textColor2 ;
                label.textAlignment = NSTextAlignmentLeft;
            })
            .LeeHeaderColor(Skin1.bgColor)
            .LeeAction(@"我知道了", nil)
            .LeeShow();
        } else {
            [LEEAlert alert].config
            .LeeAddTitle(^(UILabel *label) {
                label.text = @"⚠️为了您的账号安全，现在可以绑定常用登录地";
                label.textColor = [UIColor redColor];
                label.textAlignment = NSTextAlignmentCenter;
            })
            .LeeAddContent(^(UILabel *label) {
                label.text = @"1、绑定后，只有在常用地范围内，才能正常登录\n2、可以绑定多个常用地\n3、绑定后，可选择默认选项（请选择国家-请选择省-请选择市）即可自行解除绑定";
                label.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
                label.textAlignment = NSTextAlignmentLeft;
            })
            .LeeAction(@"我知道了", nil)
            .LeeShow();
        }
    }
}

- (void)back {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)getSystemConfig {
    WeakSelf;
    [CMNetwork getSystemConfigWithParams:@{} completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            UGSystemConfigModel *config = model.data;
            UGSystemConfigModel.currentConfig = config;
           
           [weakSelf buildSegment];
            SANotificationEventPost(UGNotificationGetSystemConfigComplete, nil);
        } failure:nil];
    }];
}

@end
