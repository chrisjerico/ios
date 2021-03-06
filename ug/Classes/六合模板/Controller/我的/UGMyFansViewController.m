//
//  UGMyFansViewController.m
//  ug
//
//  Created by ug on 2019/10/29.
//  Copyright © 2019 ug. All rights reserved.
//  六合我的粉丝
#import "UGLHPostModel.h"
#import "UGMyFansViewController.h"

@interface UGMyFansViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *mySegment;

@property(strong,nonatomic)NSMutableArray *fansListArray;/**<   我的粉丝列表数组" */
@property(strong,nonatomic)NSMutableArray *tiezfansListArray;/**<   帖子粉丝列表数组" */
@end

@implementation UGMyFansViewController

- (BOOL)允许游客访问 { return true; }

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的粉丝";
    _fansListArray = [NSMutableArray new];
    _tiezfansListArray = [NSMutableArray new];
    [_tableView setRowHeight:70.0];
    
    UITableView *tv = _tableView;
    if (UserI.isTest) {
        tv.noDataTipsLabel.text = @"";
        tv.noDataTipsLabel.height = 270;
        [tv.noDataTipsLabel addSubview:({
            UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pl"]];
            imgView.center = CGPointMake(APP.Width/2, 140);
            imgView;
        })];
        [tv.noDataTipsLabel addSubview:({
            UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 250, APP.Width, 20)];
            lb.textAlignment = NSTextAlignmentCenter;
            lb.font = [UIFont systemFontOfSize:14];
            lb.textColor = APP.TextColor2;
            lb.text = @"暂无数据！";
            lb;
        })];
        tv.tableFooterView = _tableView.noDataTipsLabel;
    } else {
        __weakSelf_(__self);
        [tv setupHeaderRefreshRequest:^CCSessionModel *(UITableView *tv) {
            return __self.mySegment.selectedSegmentIndex ? [NetworkManager1 lhdoc_contentFansList:__self.uid alias:nil] : [NetworkManager1 lhdoc_fansList:__self.uid page:1];
        } completion:^NSArray *(UITableView *tv, CCSessionModel *sm) {
            NSArray *array;
            if (__self.mySegment.selectedSegmentIndex) {
                array = sm.resObject[@"data"][@"list"];
                [self->_tiezfansListArray removeAllObjects];
                for (NSDictionary *dict in array)
                    [self->_tiezfansListArray addObject:[UGLHPostModel mj_objectWithKeyValues:dict]];
            } else {
                array = sm.resObject[@"data"][@"list"];
                [self->_fansListArray removeAllObjects];
                for (NSDictionary *dict in array)
                    [self->_fansListArray addObject:[UGLHPostModel mj_objectWithKeyValues:dict]];
            }
            return array;
        }];
        [tv setupFooterRefreshRequest:^CCSessionModel *(UITableView *tv) {
            return __self.mySegment.selectedSegmentIndex ? nil: [NetworkManager1 lhdoc_fansList:nil page:tv.pageIndex];
        } completion:^NSArray *(UITableView *tv, CCSessionModel *sm) {
            NSArray *array;
            if (__self.mySegment.selectedSegmentIndex==0) {
                array = sm.resObject[@"data"][@"list"];
                [self->_fansListArray removeAllObjects];
                for (NSDictionary *dict in array)
                    [self->_fansListArray addObject:[UGLHPostModel mj_objectWithKeyValues:dict]];
            }
            return array;
        }];
        [tv.mj_header beginRefreshing];
    }
}


- (IBAction)SegmentValueChanged:(id)sender {
    _tableView.willClearDataArray = true;
    [_tableView.mj_header beginRefreshing];
}


#pragma mark tableview datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_mySegment.selectedSegmentIndex == 0) {
        return _fansListArray.count;
    } else {
        return _tiezfansListArray.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UGLHPostModel *model =nil;
    if (_mySegment.selectedSegmentIndex == 0) {
        model = _fansListArray[indexPath.row];
        
    } else {
        model = _tiezfansListArray[indexPath.row];
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    FastSubViewCode(cell);
    subLabel(@"标题Label").text = model.nickname;
    [subImageView(@"图片ImageView") sd_setImageWithURL:[NSURL URLWithString:model.headImg] placeholderImage:[UIImage imageNamed:@"touxiang-1"]];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_mySegment.selectedSegmentIndex == 0) {
        
    } else {
        
    }
  
}

@end

