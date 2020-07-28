//
//  HotBranchView.m
//  UGBWApp
//
//  Created by fish on 2020/6/24.
//  Copyright © 2020 ug. All rights reserved.
//

#import "HotBranchView.h"

#import <React/RCTRootView.h>
#import "CodePush.h"
#import "JSPatchHelper.h"

@interface HotBranchView()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *currentBranchLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray <NSString *>*sectionTitles;
@property (nonatomic, strong) NSMutableArray <NSMutableArray <NSString *>*>*dataArray;
@end


@implementation HotBranchView

+ (HotBranchView *)show {
    HotBranchView *sv = _LoadView_from_nib_(@"HotBranchView");
    sv.frame = APP.Bounds;
    sv.tableView.delegate = sv;
    sv.tableView.dataSource = sv;
    sv.currentBranchLabel.text = _NSString(@"当前环境：%@", [[ReactNativeHelper allCodePushKey] allKeysForObject:[ReactNativeHelper currentCodePushKey]].firstObject);
    [sv.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [APP.Window addSubview:sv];
    
    // 取出标题
    NSMutableArray *titles = @[].mutableCopy;
    for (NSString *title in ReactNativeHelper.allCodePushKey.allKeys) {
        if (ReactNativeHelper.allCodePushKey[title].length) {
            [titles addObject:title];
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
    // 切换热更新
    NSIndexPath *ip = _tableView.indexPathForSelectedRow;
    if (ip) {
        NSString *title = _dataArray[ip.section][ip.row];
        ReactNativeHelper.currentCodePushKey = ReactNativeHelper.allCodePushKey[title];
        
        UIAlertController *ac = [AlertHelper showAlertView:@"切换成功请重新启动APP" msg:nil btnTitles:@[@"确定"]];
        [ac setActionAtTitle:@"确定" handler:^(UIAlertAction *aa) {
            exit(0);
        }];
    }
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

@end
