//
//  LineConversionHeaderVC.m
//  ug
//
//  Created by ug on 2020/2/18.
//  Copyright © 2020 ug. All rights reserved.
//

#import "LineConversionHeaderVC.h"
#import "SlideSegmentView1.h"    /**<    分页布局View  fish */
#import "XYYSegmentControl.h"    /**<    分页布局View  */
@interface LineConversionHeaderVC ()<XYYSegmentControlDelegate>
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (nonatomic) SlideSegmentView1 *segmentView;                  /**<    分页布局View */
@property (nonatomic, strong)XYYSegmentControl *slideSwitchView;       /**<    分页布局View */
@property (nonatomic,strong)  NSArray <NSString *> *itemArray;
@end

@implementation LineConversionHeaderVC

- (void)fishSegmentView {
    NSArray *titles = @[@"额度转换", @"转换记录"];
    _segmentView = _LoadView_from_nib_(@"SlideSegmentView1");
    _segmentView.frame = CGRectMake(0, 0, APP.Width, APP.Height);
    UIViewController *vc1 = [UIViewController new];
    [vc1.view setBackgroundColor:[UIColor greenColor]];
    UIViewController *vc2 = [UIViewController new];
    [vc2.view setBackgroundColor:[UIColor yellowColor]];
    _segmentView.viewControllers = @[vc1, vc2];
    for (UIView *v in _segmentView.contentViews) {
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(APP.Width);
            make.height.mas_equalTo(self.view.height - NavController1.navigationBar.by - 40);
        }];
    }
    __weakSelf_(__self);
    _segmentView.titleBar.updateCellForItemAtIndex = ^(UICollectionViewCell *cell, UILabel *label, NSUInteger idx) {
        label.text = titles[idx];
        label.textColor = Skin1.textColor2;
        label.font =  [UIFont systemFontOfSize:14];
      
    };

    _segmentView.titleBar.didSelectItemAtIndexPath = ^(UICollectionViewCell *cell, UILabel *label, NSUInteger idx, BOOL selected) {
        
        label.textColor = selected ? [UIColor redColor] : Skin1.textColor2;
        label.font = selected ? [UIFont boldSystemFontOfSize:16] : [UIFont systemFontOfSize:14];
        __self.segmentView.titleBar.backgroundColor = [Skin1.navBarBgColor colorWithAlphaComponent:0.35];
        
        if (selected) {
            // 下划线的默认动画
            [UIView animateWithDuration:0.25 animations:^{
                __self.segmentView.titleBar.underlineView.frame = CGRectMake(cell.left, cell.height-2, cell.width, 2);
            }];
        }

    };
    [CMCommon setBorderWithView:self.segmentView.titleBar top:NO left:NO bottom:YES right:NO borderColor:[UIColor whiteColor] borderWidth:1];
    [self.view addSubview:_segmentView];
    [_segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    _segmentView.selectedIndex = 0;
}

- (void)xyySegmentView {
    self.itemArray = @[@"额度转换", @"转换记录"];
    self.slideSwitchView = [[XYYSegmentControl alloc] initWithFrame:CGRectMake(0 , 0, self.view.width, self.view.height) channelName:self.itemArray source:self];
    [self.view addSubview:self.slideSwitchView];
    
    [self.slideSwitchView setUserInteractionEnabled:YES];
    self.slideSwitchView.segmentControlDelegate = self;
    //设置tab 颜色(可选)
    self.slideSwitchView.tabItemNormalColor = Skin1.textColor2;
    self.slideSwitchView.tabItemNormalFont = 14;
    //设置tab 被选中的颜色(可选)
    self.slideSwitchView.tabItemSelectedColor = [UIColor redColor] ;
    //设置tab 背景颜色(可选)
    self.slideSwitchView.tabItemNormalBackgroundColor = [Skin1.navBarBgColor colorWithAlphaComponent:0.35];
    //设置tab 被选中的标识的颜色(可选)
    self.slideSwitchView.tabItemSelectionIndicatorColor = [UIColor redColor] ;
    
    [_slideSwitchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"额度转换";
    
    [_headView setBackgroundColor:[Skin1.navBarBgColor colorWithAlphaComponent:0.45]];
    
    [self fishSegmentView];
    
//    [self xyySegmentView];
}

#pragma mark - XYYSegmentControlDelegate

- (NSUInteger)numberOfTab:(XYYSegmentControl *)view {
    return [self.itemArray count];//items决定
}

///待加载的控制器
- (UIViewController *)slideSwitchView:(XYYSegmentControl *)view viewOfTab:(NSUInteger)number {
    // 存款
    if (number == 0) {
        UIViewController *vc1 = [UIViewController new];
        [vc1.view setBackgroundColor:[UIColor greenColor]];
        return vc1;
    }
    // 资金明细
    else {
        UIViewController *vc2 = [UIViewController new];
           [vc2.view setBackgroundColor:[UIColor yellowColor]];
        return vc2;
    }
}

- (void)slideSwitchView:(XYYSegmentControl *)view didselectTab:(NSUInteger)number {
    if (number != 1){
        
    }
        
    
    if (number == 2) {
        
    }
    
}

@end
