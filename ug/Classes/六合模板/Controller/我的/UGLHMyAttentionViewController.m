//
//  UGLHMyAttentionViewController.m
//  ug
//
//  Created by ug on 2019/10/29.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGLHMyAttentionViewController.h"
#import "LHUserInfoVC.h"
#import "UGPostDetailVC.h"

#import "UGLHFocusUserModel.h"
#import "UGLHPostModel.h"
#import "UGLHFocusUserModel.h"

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
    [_tableView setRowHeight:70.0];
    
    {
        if (self.selectIndex) {
            [self.mySegment setSelectedSegmentIndex:self.selectIndex];
        }
        __weakSelf_(__self);
        [_tableView setupHeaderRefreshRequest:^CCSessionModel *(UITableView *tv) {
            return __self.mySegment.selectedSegmentIndex ? [NetworkManager1 lhdoc_favContentList:__self.uid page:1] : [NetworkManager1 lhdoc_followList:__self.uid page:1];
        } completion:^NSArray *(UITableView *tv, CCSessionModel *sm) {
            if (__self.mySegment.selectedSegmentIndex) {//帖
                NSArray *array = sm.responseObject[@"data"];
                for (NSDictionary *dict in array) {
                    [__self.tableView.dataArray addObject:[UGLHPostModel mj_objectWithKeyValues:dict]];
                }
                return array;
            } else {
                NSArray *array = sm.responseObject[@"data"][@"list"];
                for (NSDictionary *dict in array) {
                    [__self.tableView.dataArray addObject:[UGLHFocusUserModel mj_objectWithKeyValues:dict]];
                }
                return array;
            }
        }];
        [_tableView setupFooterRefreshRequest:^CCSessionModel *(UITableView *tv) {
            return __self.mySegment.selectedSegmentIndex ? [NetworkManager1 lhdoc_favContentList:__self.uid page:tv.pageIndex] : [NetworkManager1 lhdoc_followList:__self.uid page:tv.pageIndex];
        } completion:^NSArray *(UITableView *tv, CCSessionModel *sm) {
            if (__self.mySegment.selectedSegmentIndex) {//帖
                NSArray *array = sm.responseObject[@"data"];
                for (NSDictionary *dict in array) {
                    [__self.tableView.dataArray addObject:[UGLHPostModel mj_objectWithKeyValues:dict]];
                }
                return array;
            } else {
                NSArray *array = sm.responseObject[@"data"][@"list"];
                for (NSDictionary *dict in array) {
                    [__self.tableView.dataArray addObject:[UGLHFocusUserModel mj_objectWithKeyValues:dict]];
                }
                return array;
            }
        }];
        [_tableView.mj_footer beginRefreshing];
    }
}

- (IBAction)SegmentValueChanged:(UISegmentedControl *)sender {
    if (_tableView.mj_header.state == MJRefreshStateRefreshing) {
        _tableView.willClearDataArray = true;
        if (_tableView.mj_header.refreshingBlock) {
            _tableView.mj_header.refreshingBlock();
        }
    } else {
        [_tableView.mj_header beginRefreshing];
    }
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
            __weakSelf_(__self);
              [NetworkManager1 lhcdoc_followPoster:model.posterUid followFlag:NO].successBlock = ^(id responseObject) {[__self.tableView.mj_header beginRefreshing];
              };
        }];
        return cell;
    } else {
        UGLHPostModel *model = tableView.dataArray[indexPath.row];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
        FastSubViewCode(cell);
        subLabel(@"帖子标题Label").text = model.title;
        [subButton(@"取消帖子Btn") addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
            NSLog(@"取消帖子Btn ,id = %@",model.cid);
            __weakSelf_(__self);
              [NetworkManager1 lhcdoc_doFavorites:model.cid type:2 favFlag:NO].successBlock = ^(id responseObject) {[__self.tableView.mj_header beginRefreshing];
              };
        }];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_mySegment.selectedSegmentIndex == 0) {
        LHUserInfoVC *vc = _LoadVC_from_storyboard_(@"LHUserInfoVC");
        vc.uid = ((UGLHFocusUserModel *)tableView.dataArray[indexPath.row]).posterUid;
        [NavController1 pushViewController:vc animated:true];
    } else {
        UGPostDetailVC *vc = _LoadVC_from_storyboard_(@"UGPostDetailVC");
        vc.pm = tableView.dataArray[indexPath.row];
        [NavController1 pushViewController:vc animated:true];
    }
}

@end
