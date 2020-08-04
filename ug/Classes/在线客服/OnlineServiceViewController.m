//
//  OnlineServiceViewController.m
//  UGBWApp
//
//  Created by ug on 2020/3/14.
//  Copyright © 2020 ug. All rights reserved.
//

#import "OnlineServiceViewController.h"

@interface OnlineServiceViewController ()

@end

@implementation OnlineServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.leftBarButtonItems = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getSystemConfig];     // APP配置信息
}

-(void)reSetUrlStr{
    NSString *urlStr = [SysConf.zxkfUrl stringByTrim];
       if (!urlStr.length) {
           [self.navigationController.view makeToast:@"请检查您的在线客户的地址是否正确"
                                                     duration:1.5
                                                     position:CSToastPositionCenter];
           return;
       }
       NSURL *url = [NSURL URLWithString:urlStr];
       if (!url.host.length) {
           urlStr = _NSString(@"%@%@", APP.Host, SysConf.zxkfUrl);
       }
       else if (!url.scheme.length) {
           urlStr = _NSString(@"http://%@", SysConf.zxkfUrl);
       }
       self.urlStr = urlStr;
}

// 获取系统配置
- (void)getSystemConfig {
    WeakSelf;
    [CMNetwork getSystemConfigWithParams:@{} completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            
            NSLog(@"model = %@",model);
            FastSubViewCode(weakSelf.view);
            UGSystemConfigModel *config = model.data;
            UGSystemConfigModel.currentConfig = config;
            [weakSelf reSetUrlStr];
        } failure:^(id msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }];
}



@end
