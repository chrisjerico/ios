//
//  SitesView.m
//  UGBWApp
//
//  Created by fish on 2020/6/24.
//  Copyright © 2020 ug. All rights reserved.
//

#import "SitesView.h"

@interface SitesView()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray <NSString *>*sectionTitles;
@property (nonatomic, strong) NSMutableArray <NSMutableArray <NSString *>*>*dataArray;
@end


@implementation SitesView

+ (SitesView *)show {
    SitesView *sv = _LoadView_from_nib_(@"SitesView");
    sv.frame = APP.Bounds;
    sv.tableView.delegate = sv;
    sv.tableView.dataSource = sv;
    [sv.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [APP.Window addSubview:sv];
    
    // 取出标题
    NSMutableArray *titles = @[].mutableCopy;
    for (SiteModel *sm in APP.allSites) {
        if (sm.host.length) {
            [titles addObject:sm.siteId];
        }
    }
    // 按首字母归类
    NSMutableDictionary <NSString *, NSMutableArray *>*groupDict = @{}.mutableCopy;
    for (NSString *title in titles) {
        NSString *key = title[0];
        groupDict[key] = groupDict[key] ? : @[].mutableCopy;
        [groupDict[key] addObject:title];
    }
    // 排序
    sv.sectionTitles = groupDict.allKeys.mutableCopy;
    sv.dataArray = @[].mutableCopy;
    [sv.sectionTitles sortUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        return [obj1 compare:obj2];
    }];
    for (NSString *key in sv.sectionTitles) {
        [groupDict[key] sortUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
            return [obj1 compare:obj2];
        }];
        [sv.dataArray addObject:groupDict[key]];
    }
    return sv;
}

- (IBAction)onHideBtnClick:(UIButton *)sender {
    [self removeFromSuperview];
}

- (IBAction)exit:(UIButton *)sender {
    exit(0);
}


#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return _sectionTitles[section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = _dataArray[indexPath.section][indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *key = _dataArray[indexPath.section][indexPath.row];
    if (_didClick)
        _didClick(key);
}

@end
