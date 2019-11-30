//
//  LHGalleryListVC.m
//  ug
//
//  Created by fish on 2019/10/27.
//  Copyright © 2019 ug. All rights reserved.
//

#import "LHGalleryListVC.h"
#import "LHJournalDetailVC.h"   // 期刊详情

#import "UGLHGalleryModel.h"

@interface LHGalleryListVC ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@end

@implementation LHGalleryListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // TableView
    __weakSelf_(__self);
    {
        UITableView *tv = _tableView;
        [tv setupHeaderRefreshRequest:^CCSessionModel *(UITableView *tv) {
            return [NetworkManager1 lhdoc_tkList:__self.segmentedControl.selectedSegmentIndex];
        } completion:^NSArray *(UITableView *tv, CCSessionModel *sm) {
            NSArray *array = sm.responseObject[@"data"][@"list"];
            for (NSDictionary *dict in array) {
                [tv.dataArray addObject:[UGLHGalleryModel mj_objectWithKeyValues:dict]];
            }
            return array;
        }];
        [tv.mj_header beginRefreshing];
    }
}

- (IBAction)onSegmentedControlValueChanged:(UISegmentedControl *)sender {
    if (_tableView.mj_header.state == MJRefreshStateRefreshing) {
        _tableView.willClearDataArray = true;
        if (_tableView.mj_header.refreshingBlock) {
            _tableView.mj_header.refreshingBlock();
        }
    } else {
        [_tableView.mj_header beginRefreshing];
    }
}


#pragma mark - UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return tableView.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    FastSubViewCode(cell);
    UGLHGalleryModel *gm = tableView.dataArray[indexPath.row];
    [subImageView(@"图片ImageView") sd_setImageWithURL:[NSURL URLWithString:gm.cover] placeholderImage:[UIImage imageNamed:@"zwt"]];
    subLabel(@"标题Label").text = gm.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LHJournalDetailVC *vc = _LoadVC_from_storyboard_(@"LHJournalDetailVC");
    vc.clm = _clm;
    vc.gm = tableView.dataArray[indexPath.row];
    [NavController1 pushViewController:vc animated:true];
}

@end
