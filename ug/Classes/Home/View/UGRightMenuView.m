//
//  UGRightMenuView.m
//  ug
//
//  Created by ug on 2019/5/9.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGRightMenuView.h"
#import "UGRightMenuTableViewCell.h"


@interface UGRightMenuView ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UIButton *refreshButton;
@property (weak, nonatomic) IBOutlet UIView *rechargeView;
@property (weak, nonatomic) IBOutlet UIView *withdrawlView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, assign) CGRect oldFrame;

@property (nonatomic, assign) BOOL refreshing;

@end

static NSString *menuCellid = @"UGRightMenuTableViewCell";
@implementation UGRightMenuView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"UGRightMenuView" owner:self options:nil].firstObject;
        self.frame = frame;
        self.oldFrame = frame;
        self.rechargeView.layer.cornerRadius = 5;
        self.rechargeView.layer.masksToBounds = YES;
        self.withdrawlView.layer.cornerRadius = 5;
        self.withdrawlView.layer.masksToBounds = YES;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView registerNib:[UINib nibWithNibName:@"UGRightMenuTableViewCell" bundle:nil] forCellReuseIdentifier:menuCellid];
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        self.userNameLabel.text = [UGUserModel currentUser].username;
        self.balanceLabel.text = [NSString stringWithFormat:@"¥%@",[[UGUserModel currentUser].balance removeFloatAllZero]];
        SANotificationEventSubscribe(UGNotificationGetUserInfoComplete, self, ^(typeof (self) self, id obj) {
            [self.refreshButton.layer removeAllAnimations];
            self.balanceLabel.text = [NSString stringWithFormat:@"¥%@",[UGUserModel currentUser].balance];
        });
        SANotificationEventSubscribe(UGNotificationloginTimeout, self, ^(typeof (self) self, id obj) {
            [self hiddenSelf];
        });
    }
    return self;
    
}

-(void)reloadTabViewDateWithTitleArray:(NSMutableArray *)titleArray withImgArray:(NSMutableArray *)imgArray{
    
    self.imageNameArray = imgArray;
    self.titleArray = titleArray;
    
    [self.tableView reloadData ];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (CGRectContainsPoint(self.bounds, point)) {
        
    }else {
        [self hiddenSelf];
    }
    
    return view;
}

- (IBAction)refreshBalance:(id)sender {
    
    [self startAnimation];
    SANotificationEventPost(UGNotificationGetUserInfo, nil);
}

- (IBAction)rechregeClick:(id)sender {
    [self hiddenSelf];
    if (self.menuSelectBlock) {
        self.menuSelectBlock(7);
    }
}

- (IBAction)withdraw:(id)sender {
    [self hiddenSelf];
    if (self.menuSelectBlock) {
        self.menuSelectBlock(8);
    }
}

//刷新余额动画
-(void)startAnimation
{
    CABasicAnimation *ReFreshAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    ReFreshAnimation.toValue = [NSNumber numberWithFloat:M_PI*2.0];
    ReFreshAnimation.duration = 1;
    ReFreshAnimation.repeatCount = HUGE_VALF;
    [self.refreshButton.layer addAnimation:ReFreshAnimation forKey:@"rotationAnimation"];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UGRightMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:menuCellid forIndexPath:indexPath];
    cell.title = self.titleArray[indexPath.row];
    cell.imageName = self.imageNameArray[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self hiddenSelf];
    if (self.menuSelectBlock) {
        self.menuSelectBlock(indexPath.row);
        
    }
    
}
- (void)show {
    
    UIWindow* window = UIApplication.sharedApplication.keyWindow;
    UIView* maskView = [[UIView alloc] initWithFrame:window.bounds];
    UIView* view = self;
    view.hidden = NO;
    
    maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    maskView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);

    view.x = UGScreenW;
    [maskView addSubview:view];
    [window addSubview:maskView];
    [UIView animateWithDuration:0.35 animations:^{
        view.x = self.oldFrame.origin.x;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hiddenSelf {
    
    UIView* view = self;
    self.superview.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.35 animations:^{
//        view.x = UGScreenW;
        self.superview.x = UGScreenW - self.oldFrame.size.width;
    } completion:^(BOOL finished) {
        [view.superview removeFromSuperview];
        [view removeFromSuperview];
    }];
    
}

@end
