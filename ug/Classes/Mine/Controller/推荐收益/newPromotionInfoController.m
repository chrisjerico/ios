//
//  newPromotionInfoController.m
//  UGBWApp
//
//  Created by ug on 2020/12/3.
//  Copyright © 2020 ug. All rights reserved.
//

#import "newPromotionInfoController.h"
#import "UGinviteInfoModel.h"
#import "UGSystemConfigModel.h"
#import "HelpDocModel.h"
@interface newPromotionInfoController (){
    float btnH;
}
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;    /**<   最大图片*/
@property (weak, nonatomic) IBOutlet UIView *wm1View;                 /**<   2微码view1*/
@property (weak, nonatomic) IBOutlet UIView *wm2View;                 /**<   2微码view2*/
@property (nonatomic, assign) BOOL showHomeUrl;                       /**<   2微码view1 显示开关*/
@property (nonatomic, assign) BOOL showRegisterUrl;
//佣金比例
@property (weak, nonatomic) IBOutlet UIView *bigView;/**<  佣金比例View*/
@property (strong, nonatomic) NSMutableArray *buttons;/**<  btn数组**/
@property (weak, nonatomic) IBOutlet UILabel *mContentLbl;/**<  佣金比例内容*/
@property (weak, nonatomic) IBOutlet UIStackView *btnsView;/**<  btnView**/
@property (weak, nonatomic) IBOutlet UIView *btnsBgView;/**<  btn背景View**/
@property (nonatomic, strong) NSMutableArray <HelpDocModel *> * itemArry;//多个web文档
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stackHeight;
@end

@implementation newPromotionInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    设置样式
    
//    网络数据
//    佣金比例样式
    
    
}
//    设置样式
-(void)selfViewStyle{
    FastSubViewCode(self.view)
    self.view.backgroundColor = Skin1.textColor4;
    subButton(@"推荐复制btn").layer.cornerRadius = 3;
    subButton(@"推荐复制btn").layer.masksToBounds = YES;
    [subButton(@"推荐复制btn") setBackgroundColor:Skin1.navBarBgColor];
    
    subButton(@"注册复制btn").layer.cornerRadius = 3;
    subButton(@"注册复制btn").layer.masksToBounds = YES;
    [subButton(@"注册复制btn") setBackgroundColor:Skin1.navBarBgColor];
    
    [subView(@"用户名View") setBackgroundColor:Skin1.textColor4];
    [subView(@"推荐idView") setBackgroundColor:Skin1.textColor4];
    [subView(@"首页推荐View") setBackgroundColor:Skin1.textColor4];
    [subView(@"用户名View") setBackgroundColor:Skin1.textColor4];
    [subView(@"用户名View") setBackgroundColor:Skin1.textColor4];
    [subView(@"用户名View") setBackgroundColor:Skin1.textColor4];
    [subView(@"用户名View") setBackgroundColor:Skin1.textColor4];
    [subView(@"用户名View") setBackgroundColor:Skin1.textColor4];
    [subView(@"用户名View") setBackgroundColor:Skin1.textColor4];
    [subView(@"用户名View") setBackgroundColor:Skin1.textColor4];
    [subView(@"用户名View") setBackgroundColor:Skin1.textColor4];
    
    
}
//    佣金比例样式

//网络数据
//UI数据
//事件
- (IBAction)homeUrlCopy:(id)sender {

    
}
- (IBAction)homeSwitchClick:(id)sender {//====

}
- (IBAction)registerUrlCopy:(id)sender {

}
- (IBAction)registerSwitchClick:(id)sender {

}

@end
