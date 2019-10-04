//
//  UGPlatformNoticeView.m
//  ug
//
//  Created by ug on 2019/5/31.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGPlatformNoticeView.h"
#import "UGPlatformNoticeCell.h"
#import "UGNoticeHeaderView.h"
#import "UGNoticeModel.h"

@interface UGPlatformNoticeView ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (nonatomic, assign) NSInteger selectSection;

@end

static NSString *platformNoticeCellid = @"UGPlatformNoticeCell";
static NSString *noticeHeaderViewid = @"noticeHeaderViewid";
@implementation UGPlatformNoticeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
       
        self = [[NSBundle mainBundle] loadNibNamed:@"UGPlatformNoticeView" owner:self options:0].firstObject;
        self.frame = frame;
        self.backgroundColor = [UIColor whiteColor];
       
         self.selectSection = 0;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        [self.tableView registerNib:[UINib nibWithNibName:@"UGPlatformNoticeCell" bundle:nil] forCellReuseIdentifier:platformNoticeCellid];
        [self.tableView registerNib:[UINib nibWithNibName:@"UGNoticeHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:noticeHeaderViewid];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.layer.cornerRadius = 5;
        

        
    }
    return self;
    
}

// 在自定义UITabBar中重写以下方法，其中self.button就是那个希望被触发点击事件的按钮
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (view == nil) {
        // 转换坐标系
        CGPoint newPoint = [self.closeButton convertPoint:point fromView:self];
        // 判断触摸点是否在button上
        if (CGRectContainsPoint(self.closeButton.bounds, newPoint)) {
            view = self.closeButton;
        }
    }
    
    return view;
} 

- (IBAction)close:(id)sender {
    [self hiddenSelf];
}

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    UGNoticeModel *model = dataArray.firstObject;
    model.hiddenBottomLine = YES;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.selectSection == -1) {
        return 0;
    }else {
        if (section == self.selectSection) {
            return 1;
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UGPlatformNoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:platformNoticeCellid forIndexPath:indexPath];
    cell.item = self.dataArray[indexPath.section];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UGNoticeModel *model = self.dataArray[indexPath.row];
    NSString *str = [NSString stringWithFormat:@"<head><style>img{width:%f !important;height:auto}</style></head>%@",self.width,model.content];
    NSAttributedString *attStr = [[NSAttributedString alloc] initWithData:[str dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    UILabel *content = [[UILabel alloc] init];
    content.attributedText = attStr;
    return content.intrinsicContentSize.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UGNoticeHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:noticeHeaderViewid];
    UGNoticeModel *item = self.dataArray[section];
    headerView.item = item;
    WeakSelf
    headerView.clickBllock = ^{
        if (weakSelf.selectSection == -1) {

            item.hiddenBottomLine = !item.hiddenBottomLine;
            weakSelf.selectSection = section;

        }else {

            if (section == weakSelf.selectSection) {
                weakSelf.selectSection = -1;
            }else {
                UGNoticeModel *lastItem = weakSelf.dataArray[weakSelf.selectSection];
                lastItem.hiddenBottomLine = NO;
                weakSelf.selectSection = section;
            }

            item.hiddenBottomLine = !item.hiddenBottomLine;
        }

        [weakSelf.tableView reloadData];
    };
    return headerView;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *headerView=(UITableViewHeaderFooterView *)view;
    [headerView.backgroundView setBackgroundColor:[UIColor whiteColor]];
}

- (void)show {
    
    [self.bgView setBackgroundColor: [[UGSkinManagers shareInstance] setNavbgColor]];

    
    UIWindow* window = UIApplication.sharedApplication.keyWindow;
    UIView* maskView = [[UIView alloc] initWithFrame:window.bounds];
    UIView* view = self;
    view.hidden = NO;
    
    maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    maskView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    
    [maskView addSubview:view];
    [window addSubview:maskView];
    
}

- (void)hiddenSelf {
    
    UIView* view = self;
    self.superview.backgroundColor = [UIColor clearColor];
    [view.superview removeFromSuperview];
    [view removeFromSuperview];
    
}

@end
