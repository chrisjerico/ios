//
//  MyPromotionMembersVC.m
//  ug
//
//  Created by xionghx on 2020/1/10.
//  Copyright © 2020 ug. All rights reserved.
//

#import "MyPromotionMembersVC.h"
#import "UGinviteLisModel.h"
#import <objc/runtime.h>
#import "PromotionMemberRechargeVC.h"
#import "YBPopupMenu.h"
#import "UGinviteInfoModel.h"

static NSString * promotionMemberItemKey = @"promotionMemberItemKey";
@interface UIStackView (bindText)
- (void)bindContent: (NSString *)content;
- (void)bindHandle: (void (^)(UIButton *)) handle;
@end
@interface UIButton (hasItem)
@property(nonatomic, strong) UGinviteLisModel* promotionMember;
@end
@interface MyPromotionMembersVC ()<YBPopupMenuDelegate,UITextFieldDelegate>
{
	NSInteger _levelindex;
	NSArray * _levelArray;
}
@property (weak, nonatomic) IBOutlet UIScrollView *rootScrollView;
@property (weak, nonatomic) IBOutlet UIStackView *nameStack;
@property (weak, nonatomic) IBOutlet UIStackView *handleStack;
@property (weak, nonatomic) IBOutlet UIStackView *levelStack;
@property (weak, nonatomic) IBOutlet UIStackView *statusStack;
@property (weak, nonatomic) IBOutlet UIStackView *ifWinStack;
@property (weak, nonatomic) IBOutlet UIStackView *lastLoginStack;
@property (weak, nonatomic) IBOutlet UIStackView *regTimeStack;
@property (weak, nonatomic) IBOutlet UIView *levelSelectView;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImage;
@property (weak, nonatomic) IBOutlet UIButton *levelSelectButton;
@property (weak, nonatomic) IBOutlet UILabel *inviteTotalCountLabel;


@property (weak, nonatomic) IBOutlet UITextField *searchTxt;
@property(nonatomic, strong) NSMutableArray *originalArr;
@property(nonatomic, strong) NSMutableArray *searchArr;


@property(nonatomic, strong) NSMutableArray * items;
@property (nonatomic, strong) UGinviteInfoModel* inviteInfo;

@end

@implementation MyPromotionMembersVC

- (void)viewDidLoad {
	[super viewDidLoad];
    FastSubViewCode(self.view);
    if (Skin1.isBlack) {
        [self.view setBackgroundColor:Skin1.CLBgColor];
        [self.levelSelectView setBackgroundColor:Skin1.textColor4];
        [self.levelSelectButton setTitleColor:Skin1.textColor1 forState:0];
        [self.arrowImage setImage: [[UIImage imageNamed:@"arrow_down"] qmui_imageWithTintColor:Skin1.textColor1] ];
        [subView(@"搜索View") setBackgroundColor:Skin1.textColor4];
        [subImageView(@"搜索Img") setImage:[[UIImage imageNamed:@"tg_sousuo"] qmui_imageWithTintColor:Skin1.textColor1]];
        [subView(@"下面View") setBackgroundColor:Skin1.textColor4];
        [subLabel(@"推荐会员Label") setTextColor:Skin1.textColor1];
        [_inviteTotalCountLabel setTextColor:Skin1.textColor1];
        
        [subView(@"用户名View") setBackgroundColor:Skin1.textColor4];
        [subLabel(@"用户名Label") setTextColor:Skin1.textColor1];
        
        [subView(@"操作View") setBackgroundColor:Skin1.textColor4];
        [subLabel(@"操作Label") setTextColor:Skin1.textColor1];
        
        [subView(@"分级View") setBackgroundColor:Skin1.textColor4];
        [subLabel(@"分级Label") setTextColor:Skin1.textColor1];
        
        [subView(@"状态View") setBackgroundColor:Skin1.textColor4];
        [subLabel(@"状态Label") setTextColor:Skin1.textColor1];
        
        [subView(@"下线盈亏View") setBackgroundColor:Skin1.textColor4];
        [subLabel(@"下线盈亏Label") setTextColor:Skin1.textColor1];
        
        [subView(@"最后登录时间View") setBackgroundColor:Skin1.textColor4];
        [subLabel(@"最后登录时间Label") setTextColor:Skin1.textColor1];
        
        [subView(@"注册时间View") setBackgroundColor:Skin1.textColor4];
        [subLabel(@"注册时间Label") setTextColor:Skin1.textColor1];
    }
    
    
	self.items = [NSMutableArray array];
	_levelArray = @[@"全部下线",@"1级下线",@"2级下线",@"3级下线",@"4级下线",@"5级下线",@"6级下线",@"7级下线",@"8级下线",@"9级下线",@"10级下线"];
	_levelindex = 0;
    _originalArr =[NSMutableArray new];
    _searchArr =[NSMutableArray new];
	WeakSelf;
	self.rootScrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
		[weakSelf loadData];
	}];
    [self getSystemConfig];
    
	[self cleanAllStack];
	[self loadInviteInfo];
    
    //UITextFieldDelegate
    _searchTxt.delegate = self;
    [self textFieldMethod];

	
}

- (void)loadData {
	if ([CMCommon stringIsNull:[UGUserModel currentUser].sessid]) {
		return;
	}
	if ([UGUserModel currentUser].isTest) {
		return;
	}
	NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid,
							 @"level":[NSString stringWithFormat:@"%ld",(long)_levelindex],
	};
	
	[SVProgressHUD showWithStatus:nil];
    __weak __typeof(self)weakSelf = self;
	[CMNetwork teamInviteListWithParams:params completion:^(CMResult<id> *model, NSError *err) {
		[CMResult processWithResult:model success:^{
			
			[SVProgressHUD dismiss];
			 self.originalArr =[NSMutableArray new];
			NSDictionary *data =  model.data;
			NSArray *list = [data objectForKey:@"list"];
			weakSelf.originalArr =  [UGinviteLisModel arrayOfModelsFromDictionaries:list error:nil];
			[weakSelf bind:weakSelf.originalArr];
			
			[self.rootScrollView.mj_header endRefreshing];
			
		} failure:^(id msg) {
			[SVProgressHUD showErrorWithStatus:msg];
			
		}];
		
	}];
}

// 获取系统配置
- (void)getSystemConfig {
    [CMNetwork getSystemConfigWithParams:@{} completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            NSLog(@"model = %@",model);
            UGSystemConfigModel *config = model.data;
            UGSystemConfigModel.currentConfig = config;
        } failure:^(id msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }];
}


- (void)loadInviteInfo {
    if ([UGUserModel currentUser].isTest) {
          return;
      }
      NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid};
      
      [SVProgressHUD showWithStatus:nil];
      WeakSelf;
      [CMNetwork teamInviteInfoWithParams:params completion:^(CMResult<id> *model, NSError *err) {
          [CMResult processWithResult:model success:^{
              [SVProgressHUD dismiss];
              [weakSelf loadData];
              weakSelf.inviteInfo = model.data;
              NSLog(@"rid = %@",weakSelf.inviteInfo.rid);
              [weakSelf bindInviteInfo];
          } failure:^(id msg) {
              [SVProgressHUD dismiss];
          }];
      }];
}
- (void)bindInviteInfo {
    NSArray * countArray = [[self.inviteInfo.total_member componentsSeparatedByString: @","] subarrayWithRange:NSMakeRange(0, 3)];
    self.inviteTotalCountLabel.text = [countArray componentsJoinedByString:@" "];
}
- (void)bind: (NSArray<UGinviteLisModel*> *) items {
	
	self.items = items.mutableCopy;
	[self cleanAllStack];
	for (NSInteger i = 0; i < items.count; i++) {
		UGinviteLisModel * item = items[i];
		[self.nameStack bindContent:[NSString stringWithFormat:@"%@\n%@", item.username,item.name]];
		[self.levelStack bindContent:item.level];
		[self.statusStack bindContent:item.enable];
		[self.ifWinStack bindContent:item.sunyi];
		[self.lastLoginStack bindContent:item.accessTime];
		[self.regTimeStack bindContent:item.regtime];
		WeakSelf
		[self.handleStack bindHandle:^(UIButton * button) {
			button.promotionMember = item;
			[button addTarget:weakSelf action:@selector(rechargeButtonTaped:) forControlEvents:UIControlEventTouchUpInside];
		}];
	}
}
- (void)cleanAllStack {
	
	NSArray * allStack = @[self.nameStack,
						   self.levelStack,
						   self.statusStack,
						   self.ifWinStack,
						   self.lastLoginStack,
						   self.regTimeStack,
						   self.handleStack,];
	for (UIStackView * stack in allStack) {
		for (UIView * view in stack.arrangedSubviews) {
			[stack removeArrangedSubview:view];
			[view removeFromSuperview];
		}
	}
}
-(void)rechargeButtonTaped: (UIButton *)sender {

    if (!SysConf.switchAgentRecharge) {
        [CMCommon showErrorTitle:@"充值功能已关闭"];
        return;
    }
    UGinviteLisModel * member = sender.promotionMember;
	PromotionMemberRechargeVC * vc = [[UIStoryboard storyboardWithName:@"MyPromotion" bundle:nil] instantiateViewControllerWithIdentifier:@"PromotionMemberRechargeVC"];
	vc.modalPresentationStyle = UIModalPresentationFullScreen;
	[self presentViewController: [[UGNavigationController alloc] initWithRootViewController:vc] animated:true completion:^{
		[vc bindMember:member];
	}];
	
}
- (IBAction)levelButtonTaped:(id)sender {
	CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI);
	self.arrowImage.transform = transform;
	
	YBPopupMenu *popView = [[YBPopupMenu alloc] initWithTitles:_levelArray icons:nil menuWidth:CGSizeMake(UGScreenW / _levelArray.count + 70, 180) delegate:self];
	popView.type = YBPopupMenuTypeDefault;
	popView.fontSize = 12;
	popView.textColor = [UIColor colorWithHex:0x484D52];
	[popView showRelyOnView:self.levelSelectView];
}

- (void)textFieldMethod {
    [self.searchTxt addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
}


- (void)textFieldDidChange {
    if (self.searchTxt.text != nil && self.searchTxt.text.length > 0) {
        _searchArr = [NSMutableArray array];//这里可以说是清空tableview的旧dataSource
        for (UGinviteLisModel * item in _originalArr) {
            
            if ([item.username rangeOfString:self.searchTxt.text options:NSCaseInsensitiveSearch].length > 0) {
                [_searchArr addObject:item];

                [self bind:_searchArr];
            }
        }
    }
    [self bind:_searchArr];
}

#pragma mark YBPopupMenuDelegate

- (void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu {
	if (index >= 0) {
		_levelindex = index;
		[self.levelSelectButton setTitle:_levelArray[index] forState:UIControlStateNormal];
		[self loadData];
	}
	
	CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI * 2);
	self.arrowImage.transform = transform;
}
@end


@implementation UIStackView (bindText)

- (void)bindContent: (NSString *)content {
	UIView * view = [UIView new];

	
	UILabel * label = [UILabel new];
	
	label.font = [UIFont systemFontOfSize:12];
	label.textAlignment = NSTextAlignmentCenter;
	label.numberOfLines = 0;
	[view addSubview:label];
	[label mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(view);
		make.height.equalTo(@52);
	}];
	label.text = content;
	[self addArrangedSubview:view];
    
    if (Skin1.isBlack) {
        view.backgroundColor = Skin1.textColor4;
        label.textColor = Skin1.textColor1;
    } else {
        view.backgroundColor = UIColor.whiteColor;
        label.textColor = [UIColor colorWithHex:0x484D52];
    }
}

- (void)bindHandle: (void (^)(UIButton *)) handle {
	UIView * view = [UIView new];
	UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
	[button setTitle:@"充值" forState:UIControlStateNormal];

	button.titleLabel.font = [UIFont systemFontOfSize:12];
	[view addSubview:button];
	[button mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(view);
		make.height.equalTo(@52);
	}];
	[self addArrangedSubview:view];
	handle(button);
    
    if (Skin1.isBlack) {
        view.backgroundColor = Skin1.textColor4;
        [button setTitleColor: Skin1.textColor1 forState:UIControlStateNormal];
    } else {
        view.backgroundColor = UIColor.whiteColor;
        [button setTitleColor: [UIColor colorWithHex:0xF15C5F] forState:UIControlStateNormal];
    }
}
@end

@implementation UIButton (hasItem)
-(void)setPromotionMember:(UGinviteLisModel *)promotionMember {
	objc_setAssociatedObject(self, &promotionMemberItemKey, promotionMember, OBJC_ASSOCIATION_COPY);
}
- (UGinviteLisModel *)promotionMember {
	return objc_getAssociatedObject(self, &promotionMemberItemKey);
}


@end
