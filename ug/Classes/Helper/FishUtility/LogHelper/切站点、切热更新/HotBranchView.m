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
#import "RegExCategories.h"

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
    sv.currentBranchLabel.text = _NSString(@"当前环境：%@", [sv getCurrentEnvTitle]);
    [sv.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    sv.tableView.rowHeight = 35;
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

- (NSString *)getCurrentEnvTitle {
    NSString *env = [[ReactNativeHelper allCodePushKey] allKeysForObject:[ReactNativeHelper currentCodePushKey]].firstObject;
    if ([env isMatch:RX(@"^[A-Za-z0-9_]+$")]) {
        if ([env hasSuffix:@"_t"]) {
            return [env stringByReplacingOccurrencesOfString:@"_t" withString:@"(未审)"];
        } else {
            return [env stringByAppendingString:@"(线上)"];
        }
    } else {
        return env.length ? env : @"无";
    }
}


#pragma mark - IBAction

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
    NSString *t = _dataArray[indexPath.section][indexPath.row];
    
    if (OBJOnceToken(cell)) {
        cell.textLabel.font = [UIFont boldSystemFontOfSize:13];
        cell.textLabel.textColor = UIColor.blackColor;
    }
    cell.textLabel.text = t;
    
    __weakSelf_(__self);
    UIButton *btn = [cell viewWithTagString:@"切换ipButton"];
    if (!btn) {
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tagString = @"切换ipButton";
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        btn.backgroundColor = APP.LoadingColor;
//        btn.frame = CGRectMake(0, 4, 80, 30);
        [btn setTitleColor:APP.ThemeColor1 forState:UIControlStateNormal];
        [btn setTitle:@"切换ip" forState:UIControlStateNormal];
        [btn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            UIAlertController *ac = [AlertHelper showAlertView:@"请选择ip" msg:nil btnTitles:@[@"192.168.2.1", @"手动输入", @"取消"]];
            [ac setActionAtTitle:@"192.168.2.1" handler:^(UIAlertAction *aa) {
                [[NSUserDefaults standardUserDefaults] setObject:@"192.168.2.1" forKey:@"LocalRnCodeIP"];
                [__self.tableView reloadData];
            }];
            __block  UITextField *__tf = nil;
            [ac setActionAtTitle:@"手动输入" handler:^(UIAlertAction *aa) {
                [LEEAlert alert].config
                .LeeTitle(@"请输入ip")
                .LeeAddTextField(^(UITextField *textField) {
                    __tf = textField; //赋值
                })
                .LeeCancelAction(@"取消", nil) // 点击事件的Block如果不需要可以传nil
                .LeeAction(@"确定", ^{
                    [[NSUserDefaults standardUserDefaults] setObject:__tf.text forKey:@"LocalRnCodeIP"];
                    [__self.tableView reloadData];
                })
                .LeeShow();
            }];
        }];
        [cell.contentView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(cell.contentView);
            make.right.equalTo(cell.contentView).offset(-10);
        }];
    }
    btn.hidden = TARGET_IPHONE_SIMULATOR || ![t containsString:@"本地代码"];
    
    UILabel *lb = [cell viewWithTagString:@"二级标题"];
    if (!lb) {
        lb = [[UILabel alloc] initWithFrame:CGRectMake(75, 0, 100, cell.height)];
        lb.tagString = @"二级标题";
        lb.textColor = APP.TextColor3;
        lb.font = [UIFont systemFontOfSize:11];
        [cell.contentView addSubview:lb];
    }
    if ([t isMatch:RX(@"^[A-Za-z0-9_]+$")]) {
        lb.text = @"(线上)";
        lb.x = 75;
    } else if ([t containsString:@"本地代码"]) {
        lb.text = TARGET_IPHONE_SIMULATOR ? @"" : ([[NSUserDefaults standardUserDefaults] stringForKey:@"LocalRnCodeIP"] ? : @"192.168.2.1");
        lb.x = 115;
    } else {
        lb.text = @"";
    }
    return cell;
}

@end
