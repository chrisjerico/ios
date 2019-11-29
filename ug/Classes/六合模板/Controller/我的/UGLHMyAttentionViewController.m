//
//  UGLHMyAttentionViewController.m
//  ug
//
//  Created by ug on 2019/10/29.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGLHMyAttentionViewController.h"

#import "UGLHFocusUserModel.h"
#import "UGLHPostModel.h"

@interface UGLHMyAttentionViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *mySegment;
@end

@implementation UGLHMyAttentionViewController

- (BOOL)允许游客访问 { return true; }

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的关注";
    
    {
        __weakSelf_(__self);
        [_tableView setupHeaderRefreshRequest:^CCSessionModel *(UITableView *tv) {
            return __self.mySegment.selectedSegmentIndex ? [NetworkManager1 lhdoc_favContentList:nil page:1] : [NetworkManager1 lhdoc_followList:nil];
        } completion:^NSArray *(UITableView *tv, CCSessionModel *sm) {
            NSArray *array = sm.responseObject[@"data"][@"list"];
            for (NSDictionary *dict in array)
                [tv.dataArray addObject:[UGLHPostModel mj_objectWithKeyValues:dict]];
            return array;
        }];
        [_tableView setupFooterRefreshRequest:^CCSessionModel *(UITableView *tv) {
            return __self.mySegment.selectedSegmentIndex ? [NetworkManager1 lhdoc_favContentList:nil page:tv.pageIndex] : nil;
        } completion:^NSArray *(UITableView *tv, CCSessionModel *sm) {
            NSArray *array = sm.responseObject[@"data"][@"list"];
            for (NSDictionary *dict in array)
                [tv.dataArray addObject:[UGLHPostModel mj_objectWithKeyValues:dict]];
            return array;
        }];
        [_tableView.mj_header beginRefreshing];
    }
}

- (IBAction)SegmentValueChanged:(UISegmentedControl *)sender {
    _tableView.willClearDataArray = true;
    [_tableView.mj_header beginRefreshing];
    _tableView.mj_footer.state = sender.selectedSegmentIndex ? MJRefreshStateIdle : MJRefreshStateNoMoreData;
}


#pragma mark tableview datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return tableView.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_mySegment.selectedSegmentIndex == 0) {
        UGLHFocusUserModel *model = tableView.dataArray[indexPath.row];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
        FastSubViewCode(cell);
        subLabel(@"标题Label").text = model.nickname;
        [subImageView(@"图片ImageView") sd_setImageWithURL:[NSURL URLWithString:model.headImg] placeholderImage:[UIImage imageNamed:@"touxiang-1"]];
        [subButton(@"取消专家Btn") addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
            NSLog(@"取消专家Btn ,id = %@",model.posterUid);
        }];
        return cell;
    } else {
        UGLHPostModel *model = tableView.dataArray[indexPath.row];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
        FastSubViewCode(cell);
        subLabel(@"标题Label").text = model.title;
        [subButton(@"取消帖子Btn") addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
            NSLog(@"取消帖子Btn ,id = %@",model.cid);
        }];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_mySegment.selectedSegmentIndex == 0) {
        
    } else {
        
    }
}

@end
