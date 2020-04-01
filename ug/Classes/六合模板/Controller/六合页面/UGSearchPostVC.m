//
//  UGSearchPostVC.m
//  ug
//
//  Created by fish on 2019/10/27.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGSearchPostVC.h"  // 搜索帖子
#import "UGPostListVC.h"   // 帖子列表

#import "UGPostCell1.h"     // 帖子Cell
#import "LHPostPayView.h"   // 购买帖子弹框

@interface UGSearchPostVC ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic, strong) UGPostListVC *listVC;
@property (nonatomic, copy) NSString *searchKey;
@end

@implementation UGSearchPostVC

- (BOOL)允许游客访问   { return true; }
- (BOOL)允许未登录访问 { return true; }

- (void)viewDidLoad {
    [super viewDidLoad];
    
    FastSubViewCode(self.view);
    subView(@"搜索Button").backgroundColor = Skin1.navBarBgColor;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_textField becomeFirstResponder];
}

- (IBAction)onSearchBtnClick:(UIButton *)sender {
    if (![_textField.text stringByReplacingOccurrencesOfString:@" " withString:@""].length) {
        [HUDHelper showMsg:@"搜索内容不能为空"];
        return;
    }
    [_textField resignFirstResponder];
    _searchKey = _textField.text;
    
    if (OBJOnceToken(self)) {
        __weakSelf_(__self);
        UIView *listContentView = [self.view viewWithTagString:@"ListContentView"];
        UGPostListVC *vc = _LoadVC_from_storyboard_(@"UGPostListVC");
        vc.request = ^CCSessionModel * _Nonnull(NSInteger page) {
            return [NetworkManager1 lhcdoc_searchContent:__self.clm.alias content:__self.searchKey page:page];
        };
        _listVC = vc;
        [listContentView addSubview:vc.view];
        [vc.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(listContentView);
        }];
    } else {
        [_listVC refreshData];
    }
}


@end
