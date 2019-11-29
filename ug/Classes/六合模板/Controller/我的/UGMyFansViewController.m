//
//  UGMyFansViewController.m
//  ug
//
//  Created by ug on 2019/10/29.
//  Copyright © 2019 ug. All rights reserved.
//  六合我的粉丝

#import "UGMyFansViewController.h"

@interface UGMyFansViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *myTable;
@property (weak, nonatomic) IBOutlet UISegmentedControl *mySegment;

@property(strong,nonatomic)NSMutableArray *fansListArray;/**<   我的粉丝列表数组" */
@property(strong,nonatomic)NSMutableArray *tiezfansListArray;/**<   我的粉丝列表数组" */
@end

@implementation UGMyFansViewController

- (BOOL)允许游客访问 { return true; }

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的粉丝";
    _fansListArray = [NSMutableArray new];
    _tiezfansListArray = [NSMutableArray new];
    [self.mySegment setSelectedSegmentIndex:0];
    [self getFansList];
}

//------------六合------------------------------------------------------
// 我粉丝列表
- (void)getFansList {
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid};
//    [CMNetwork followListWithParams:params completion:^(CMResult<id> *model, NSError *err) {
//        [SVProgressHUD showWithStatus:nil];
//        [CMResult processWithResult:model success:^{
//            [SVProgressHUD showWithStatus:nil];
//            NSLog(@"model= %@",model.data);
//            //            NSArray *modelArr = (NSArray *)model.data;         //数组转模型数组
//
//
//            //            if (modelArr.count) {
//            //                for (int i = 0 ;i<modelArr.count;i++) {
//            //                    UGLHCategoryListModel *obj = [modelArr objectAtIndex:i];
//            //
//            //                    [self->_lHCategoryList addObject:obj];
//            //                    NSLog(@"obj= %@",obj);
//            //                }
//            //            }
//            //数组转模型数组
//
//            [self->_myTable reloadData];
//
//        } failure:^(id msg) {
//            [SVProgressHUD showErrorWithStatus:msg];
//        }];
//    }];
}

//帖子粉丝列表
- (void)gettiezFansList {
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid};
//    [CMNetwork followListWithParams:params completion:^(CMResult<id> *model, NSError *err) {
//        [SVProgressHUD showWithStatus:nil];
//        [CMResult processWithResult:model success:^{
            [SVProgressHUD dismiss];
//            NSLog(@"model= %@",model.data);
//            //            NSArray *modelArr = (NSArray *)model.data;         //数组转模型数组
//
//
//            //            if (modelArr.count) {
//            //                for (int i = 0 ;i<modelArr.count;i++) {
//            //                    UGLHCategoryListModel *obj = [modelArr objectAtIndex:i];
//            //
//            //                    [self->_lHCategoryList addObject:obj];
//            //                    NSLog(@"obj= %@",obj);
//            //                }
//            //            }
//            //数组转模型数组
//
//            [self->_myTable reloadData];
//
//        } failure:^(id msg) {
//            [SVProgressHUD showErrorWithStatus:msg];
//        }];
//    }];
}
- (IBAction)SegmentValueChanged:(id)sender {
    UISegmentedControl *segment = (UISegmentedControl *)sender;
    if (segment.selectedSegmentIndex == 0) {
        //我的粉丝
        [self getFansList];
    } else {
        //帖子粉丝
        [self gettiezFansList];
    }
}


#pragma mark tableview datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_mySegment.selectedSegmentIndex == 0) {
        return _fansListArray.count;
    } else {
        return _tiezfansListArray.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_mySegment.selectedSegmentIndex == 0) {
        //        UGLHFocusUserModel *model = (UGLHFocusUserModel *) [_fansListArray objectAtIndex:indexPath.row];
        
    } else {
        //        UGLHFocusUserModel *model = (UGLHFocusUserModel *) [_tiezfansListArray objectAtIndex:indexPath.row];
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    FastSubViewCode(cell);
    //           subLabel(@"标题Label").text = model.nickname;
    //           [subImageView(@"图片ImageView") sd_setImageWithURL:[NSURL URLWithString:model.headImg] placeholderImage:[UIImage imageNamed:@"touxiang-1"]];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_mySegment.selectedSegmentIndex == 0) {
        
    } else {
        
    }
  
}

@end

