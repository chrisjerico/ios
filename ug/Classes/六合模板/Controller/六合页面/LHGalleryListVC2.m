//
//  LHGalleryListVC2.m
//  ug
//
//  Created by fish on 2019/12/19.
//  Copyright © 2019 ug. All rights reserved.
//

#import "LHGalleryListVC2.h"
#import "LHJournalDetailVC.h"

#import "ChineseSortHelper.h"

#import "IndexesView.h"


#define RowHeight 44
#define SectionHeight 25



@interface LHGalleryListVC2 ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) IndexesView *idxView; /**<   索引View */

@property (nonatomic, strong) NSMutableArray <ChineseSortGroupModel *>*groups;  /**<   按首字母分类后的图库列表 */
@property (nonatomic, strong) NSMutableArray <UGLHGalleryModel *>*resultArray;  /**<   搜索结果 */
@end

@implementation LHGalleryListVC2

- (BOOL)允许游客访问 { return true; }
- (BOOL)允许未登录访问 { return true; }

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _clm.name;
    _groups = @[].mutableCopy;
    _resultArray = @[].mutableCopy;
    
    // TableView
    __weakSelf_(__self);
    {
        UITableView *tv = _tableView;
        tv.rowHeight = RowHeight;
        tv.footerView = [UIView new];
        tv.footerView.height = 60;
        [tv setupHeaderRefreshRequest:^CCSessionModel *(UITableView *tv) {
            return [NetworkManager1 lhdoc_tkList:false];
        } completion:^NSArray *(UITableView *tv, CCSessionModel *sm) {
            
            NSArray *array = sm.responseObject[@"data"][@"list"];
            for (NSDictionary *dict in array) {
                [tv.dataArray addObject:[UGLHGalleryModel mj_objectWithKeyValues:dict]];
            }
            
            [__self.groups setArray:[ChineseSortHelper sortedWithObjectArray:tv.dataArray keyPath:@"name"]];
            
            // 索引
            if (__self.groups.count) {
                __self.idxView.hidden = false;
                __self.idxView.titles = [__self.groups valuesWithKeyPath:@"key"];
                __self.idxView.cc_constraints.height.constant = __self.groups.count * 14 + 13;
            }
            tv.mj_footer = nil;
            return array;
        }];
        tv.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            if (tv.mj_header.refreshingBlock) {
                tv.mj_header.refreshingBlock();
            }
        }];
        [tv.mj_footer beginRefreshing];
    }
    
    
    // 索引
    {
        _idxView = _LoadView_from_nib_(@"IndexesView");
        _idxView.didSelectedIndex = ^(NSInteger idx) {
            UITableView *tv = __self.tableView;
            NSMutableArray <ChineseSortGroupModel *>*groups = __self.groups;
            
            if (idx < 0) {
                tv.contentOffset = CGPointZero;
            } else if (idx < groups.count) {
                CGFloat y2 = tv.tableHeaderView.height;
                for (int i=0; i<idx; i++) {
                    y2 += SectionHeight;
                    y2 += groups[i].array.count * RowHeight;
                }
                y2 -= tv.contentInset.top;
                tv.contentOffset = CGPointMake(0, y2);
            }
        };
        _idxView.hidden = true;
        [self.view addSubview:_idxView];
        [_idxView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.view);
            make.centerY.equalTo(self.view);
            make.width.mas_equalTo(30);
            make.height.mas_equalTo(380);
        }];
    }
    
    // 搜索
    [self xw_addNotificationForName:UITextFieldTextDidChangeNotification block:^(NSNotification * _Nonnull noti) {
        NSString *text = __self.textField.text.stringByTrim;
        [__self.resultArray removeAllObjects];
        for (UGLHGalleryModel *gm in __self.tableView.dataArray) {
            if ([gm.name rangeOfString:text options:NSCaseInsensitiveSearch].length) {
                [__self.resultArray addObject:gm];
            }
        }
        [__self.tableView reloadData];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_tableView reloadData];
    [_textField.superview sendSubviewToBack:_textField];
}

- (BOOL)isShowResult {
    return _textField.text.stringByTrim.length;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [self isShowResult] ? 0 : SectionHeight;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ([self isShowResult]) {
        return nil;
    }
    UIView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    UILabel *lb = [headerView viewWithTagString:@"label"];
    if (!headerView) {
        headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"header"];
        headerView.backgroundColor = APP.BackgroundColor;
        [headerView addSubview:({
            lb = [UILabel new];
            lb.tagString = @"label";
            lb.textColor = Skin1.navBarBgColor;
            lb.backgroundColor = APP.BackgroundColor;
            lb.font = [UIFont boldSystemFontOfSize:16];
            lb.内边距 = CGPointMake(20, 0);
            lb.frame = CGRectMake(0, 0, APP.Width, 25);
            lb;
        })];
    }
    lb.text = _groups[section].key;
//        NSLog(@"idx = %ld, title = %@", section, _friendArray[section].key);
    return headerView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self isShowResult] ? : _groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self isShowResult] ? _resultArray.count : _groups[section].array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    FastSubViewCode(cell);
    UGLHGalleryModel *gm = [self isShowResult] ? _resultArray[indexPath.row] : _groups[indexPath.section].array[indexPath.row];
    subLabel(@"标题Label").text = gm.name;
    subLabel(@"编号Label").text = gm.gid;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LHJournalDetailVC *vc = _LoadVC_from_storyboard_(@"LHJournalDetailVC");
    vc.clm = _clm;
    vc.gm = [self isShowResult] ? _resultArray[indexPath.row] : _groups[indexPath.section].array[indexPath.row];
    [NavController1 pushViewController:vc animated:true];
}

@end
