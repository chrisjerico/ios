//
//  UGPromotionTableController.m
//  ug
//
//  Created by ug on 2019/5/9.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGPromotionTableController.h"
#import "YBPopupMenu.h"

@interface UGPromotionTableController ()<YBPopupMenuDelegate>

@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *levelArray;
@property (nonatomic, strong) UIButton *levelButton;
@property (nonatomic, assign) PromotionTableType tableType;
@property (nonatomic, strong) UIImageView *arrowImageView;


@end

@implementation UGPromotionTableController

- (instancetype)initWithTableType:(PromotionTableType )tableType {
    self = [super init];
    if (self) {
        self.tableType = tableType;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UGBackgroundColor;
    switch (self.tableType) {
        case PromotionTableTypeMember:
            self.titleArray = @[@"分级",@"用户名",@"状态",@"最近登录",@"注册时间"];
            break;
        case PromotionTableTypeBettingReport:
            self.titleArray = @[@"分级",@"日期",@"投注金额",@"佣金"];
            break;
        case PromotionTableTypeBettingRecord:
            self.titleArray = @[@"分级",@"用户",@"日期",@"金额"];
            break;
        case PromotionTableTypeDomainBinding:
            self.titleArray = @[@"分级",@"日期",@"存款金额",@"提款记录"];
            break;
        case PromotionTableTypeDepositStatement:
            self.titleArray = @[@"分级",@"日期",@"存款金额",@"存款人数"];
            break;
        case PromotionTableTypeDepositRecord:
            self.titleArray = @[@"分级",@"用户",@"日期",@"存款金额"];
            break;
        case PromotionTableTypeWithdrawalReport:
            self.titleArray = @[@"分级",@"日期",@"提款金额",@"提款人数"];
            break;
        case PromotionTableTypeWithdrawalRcord:
            self.titleArray = @[@"分级",@"用户名",@"日期",@"提款金额"];
            break;
        default:
            break;
    }
    
    self.levelArray = @[@"1级下线",@"2级下线",@"3级下线"];
    [self.view addSubview:self.titleView];
}

- (void)levelClick {
    CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI);
    self.arrowImageView.transform = transform;
    
    YBPopupMenu *popView = [[YBPopupMenu alloc] initWithTitles:self.levelArray icons:nil menuWidth:CGSizeMake(UGScreenW / self.titleArray.count + 40, 140) delegate:self];
    popView.type = YBPopupMenuTypeDefault;
    popView.fontSize = 15;
    [popView showRelyOnView:self.levelButton];

}

#pragma mark YBPopupMenuDelegate

- (void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu {
    if (index >= 0) {
        
    }
    
    CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI * 2);
    self.arrowImageView.transform = transform;
    
}

- (UIView *)titleView {
    if (_titleView == nil) {
        _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UGScreenW, 44)];
        _titleView.backgroundColor = [UIColor clearColor];
        for (int i = 0; i < self.titleArray.count; i++) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(UGScreenW / self.titleArray.count * i, 0, UGScreenW / self.titleArray.count, 44)];
            if (i == 0) {
                UIButton *button = [[UIButton alloc] initWithFrame:view.bounds];
                button.backgroundColor = [UIColor clearColor];
                [button addTarget:self action:@selector(levelClick)];
                self.levelButton = button;
                [view addSubview:button];
                UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(view.width - 18, (view.height - 18) / 2, 18, 18)];
                imgView.image = [UIImage imageNamed:@"jiantou"];
                [view addSubview:imgView];
                self.arrowImageView = imgView;
            }
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:view.bounds];
            titleLabel.text = self.titleArray[i];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.textColor = [UIColor blackColor];
            titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightHeavy];
            [view addSubview:titleLabel];
            
            [_titleView addSubview:view];
        }
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0,_titleView.height - 0.6, _titleView.width, 0.6)];
        line.backgroundColor = [UIColor lightGrayColor];
        [_titleView addSubview:line];
        
    }
    return _titleView;
}

@end
