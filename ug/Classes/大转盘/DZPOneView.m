//
//  DZPOneView.m
//  UGBWApp
//
//  Created by ug on 2020/4/27.
//  Copyright © 2020 ug. All rights reserved.
//

#import "DZPOneView.h"
#import "DZPOneTableViewCell.h"

@interface DZPOneView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak)IBOutlet UITableView *tableView;                   /**<   列表TableView */
@end
@implementation DZPOneView

- (instancetype)DZPOneView {
    NSBundle *bundle=[NSBundle mainBundle];
    NSArray *objs=[bundle loadNibNamed:@"DZPOneView" owner:nil options:nil];
    
    
    return [objs firstObject];
}


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (!self.subviews.count) {
        DZPOneView *v = [[DZPOneView alloc] initWithFrame:CGRectZero];
        [self addSubview:v];
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self = [self DZPOneView];
    }
    
    [self tableViewInit];
    return self;
}


- (UITableView *)tableViewInit {
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"DZPOneTableViewCell" bundle:nil] forCellReuseIdentifier:@"DZPOneTableViewCell"];
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.rowHeight = 50;
    
    return _tableView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DZPOneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DZPOneTableViewCell" forIndexPath:indexPath];
    cell.titleLabel.text = self.dataArray[indexPath.row];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return  50.0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)setDataArray:(NSArray<NSString *> *)dataArray{
    _dataArray = dataArray;
    [_tableView reloadData];
}

@end
