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
#import "UGLHFocusUserModel.h"

@interface UGLHMyAttentionViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *mySegment;

@property(strong,nonatomic)NSMutableArray *zhuangjialistArray;/**<   关注专家列表数组" */
@property(strong,nonatomic)NSMutableArray *tiezListArray;/**<   关注帖子列表数组" */
@end

@implementation UGLHMyAttentionViewController

- (BOOL)允许游客访问 { return true; }

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的关注";
    _zhuangjialistArray = [NSMutableArray new];
    _tiezListArray = [NSMutableArray new];
    [_tableView setRowHeight:70.0];
    
    {
        __weakSelf_(__self);
        [_tableView setupHeaderRefreshRequest:^CCSessionModel *(UITableView *tv) {
            return __self.mySegment.selectedSegmentIndex ? [NetworkManager1 lhdoc_favContentList:nil page:1] : [NetworkManager1 lhdoc_followList:nil];
        } completion:^NSArray *(UITableView *tv, CCSessionModel *sm) {
            NSArray *array = sm.responseObject[@"data"];
            if (__self.mySegment.selectedSegmentIndex) {
                [self->_tiezListArray removeAllObjects];
                for (NSDictionary *dict in array)
                    [self->_tiezListArray addObject:[UGLHPostModel mj_objectWithKeyValues:dict]];
            } else {
                [self->_zhuangjialistArray removeAllObjects];
                for (NSDictionary *dict in array)
                    [self->_zhuangjialistArray addObject:[UGLHFocusUserModel mj_objectWithKeyValues:dict]];
            }
            return array;
        }];
        [_tableView setupFooterRefreshRequest:^CCSessionModel *(UITableView *tv) {
            return __self.mySegment.selectedSegmentIndex ? [NetworkManager1 lhdoc_favContentList:nil page:tv.pageIndex] : nil;
        } completion:^NSArray *(UITableView *tv, CCSessionModel *sm) {
            NSArray *array = sm.responseObject[@"data"];
            if (__self.mySegment.selectedSegmentIndex) {
                for (NSDictionary *dict in array)
                    [self->_tiezListArray addObject:[UGLHPostModel mj_objectWithKeyValues:dict]];
            } 
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
    if (_mySegment.selectedSegmentIndex == 0) {
        return _zhuangjialistArray.count;
    } else {
        return _tiezListArray.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_mySegment.selectedSegmentIndex == 0) {
        UGLHFocusUserModel *model = _zhuangjialistArray[indexPath.row];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
        FastSubViewCode(cell);
        subLabel(@"标题Label").text = model.nickname;
        [subImageView(@"图片ImageView") sd_setImageWithURL:[NSURL URLWithString:model.headImg] placeholderImage:[UIImage imageNamed:@"touxiang-1"]];
        [subButton(@"取消专家Btn") addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
            NSLog(@"取消专家Btn ,id = %@",model.posterUid);
        }];
        return cell;
    } else {
        UGLHPostModel *model = _tiezListArray[indexPath.row];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
        FastSubViewCode(cell);
        subLabel(@"帖子标题Label").text = model.title;
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
