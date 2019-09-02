//
//  UGIntegralConvertRecordController.m
//  ug
//
//  Created by ug on 2019/5/17.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGIntegralConvertRecordController.h"
#import "UGIntegarlConvertRecordCell.h"
#import "YBPopupMenu.h"

@interface UGIntegralConvertRecordController ()<UITableViewDelegate,UITableViewDataSource,YBPopupMenuDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (weak, nonatomic) IBOutlet UIView *dateView;

@property (nonatomic, strong) NSArray *dateArray;

@end

static NSString *convertRecordCellid = @"UGIntegarlConvertRecordCell";
@implementation UGIntegralConvertRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UGBackgroundColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 44;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 120, 0);
    self.dateArray = @[@"全部日期",@"最近一天",@"最近七天",@"最近一个月"];

}

- (IBAction)datePicker:(id)sender {
    CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI);
    self.arrowImageView.transform = transform;
    YBPopupMenu *popView = [[YBPopupMenu alloc] initWithTitles:self.dateArray icons:nil menuWidth:CGSizeMake(self.dateView.width, 180) delegate:self];
    popView.fontSize = 14;
    popView.type = YBPopupMenuTypeDefault;
    [popView showRelyOnView:self.dateView];
}

- (void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu {
    if (index >= 0) {
        
    }
    CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI * 2);
    self.arrowImageView.transform = transform;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 13;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UGIntegarlConvertRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:convertRecordCellid forIndexPath:indexPath];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}

@end
