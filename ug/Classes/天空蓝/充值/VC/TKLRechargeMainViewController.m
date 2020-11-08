//
//  TKLRechargeMainViewController.m
//  UGBWApp
//
//  Created by fish on 2020/11/7.
//  Copyright © 2020 ug. All rights reserved.
//

#import "TKLRechargeMainViewController.h"
#import "TKLRechargeListViewController.h"

@interface TKLRechargeMainViewController ()
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (retain, nonatomic)  TKLRechargeListViewController *view1;//转账充值
@property (retain, nonatomic)  TKLRechargeListViewController *view2;//在线充值
@end

@implementation TKLRechargeMainViewController

- (BOOL)允许游客访问 { return true; }
- (BOOL)允许未登录访问 { return true; }

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"充值";
    _view1 = _LoadVC_from_storyboard_(@"TKLRechargeListViewController");
    _view1.type = RT_转账;
//    [_view1 reLoadDate];
    _view2 = _LoadVC_from_storyboard_(@"TKLRechargeListViewController");
    _view2.type = RT_在线;
//    [_view2 reLoadDate];
//    [_contentView addSubview:_view2.view];
    [_contentView addSubview:_view1.view];
    [_view1.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_contentView);
    }];
//    [_view2.view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(_contentView);
//    }];
    //转账充值放到最前面
    [_contentView bringSubviewToFront:_view1.view];
    
}

- (IBAction)onSegmentedControlValueChanged:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        //转账充值放到最前面
        [_contentView bringSubviewToFront:_view1.view];
    } else {
        //转账充值放到最前面
        [_contentView bringSubviewToFront:_view2.view];
    }
}

@end
