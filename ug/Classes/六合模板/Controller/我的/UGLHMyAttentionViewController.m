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
@property (weak, nonatomic) IBOutlet UITableView *myTable;
@property (weak, nonatomic) IBOutlet UISegmentedControl *mySegment;

@property(strong,nonatomic)NSMutableArray *followListArray;/**<   关注用户列表数组" */
@property(strong,nonatomic)NSMutableArray *favContentListArray;/**<   关注帖子列表数组" */
@end

@implementation UGLHMyAttentionViewController

- (BOOL)允许游客访问 { return true; }

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的关注";
    _followListArray = [NSMutableArray new];
    _favContentListArray = [NSMutableArray new];
    [self.mySegment setSelectedSegmentIndex:0];
    [self getFollowList];
}

//------------六合------------------------------------------------------
// 关注用户列表
- (void)getFollowList {
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid};
    [CMNetwork followListWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [SVProgressHUD showWithStatus:nil];
        [CMResult processWithResult:model success:^{
            [SVProgressHUD showWithStatus:nil];
            NSLog(@"model= %@",model.data);
            //            NSArray *modelArr = (NSArray *)model.data;         //数组转模型数组
            
            
            //            if (modelArr.count) {
            //                for (int i = 0 ;i<modelArr.count;i++) {
            //                    UGLHCategoryListModel *obj = [modelArr objectAtIndex:i];
            //
            //                    [self->_lHCategoryList addObject:obj];
            //                    NSLog(@"obj= %@",obj);
            //                }
            //            }
            //数组转模型数组
            
            [self->_myTable reloadData];
            
        } failure:^(id msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }];
}
// 关注帖子列表
- (void)getfavContentList {
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid};
    [CMNetwork favContentListWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [SVProgressHUD showWithStatus:nil];
        [CMResult processWithResult:model success:^{
            [SVProgressHUD showWithStatus:nil];
            NSLog(@"model= %@",model.data);
            //            NSArray *modelArr = (NSArray *)model.data;         //数组转模型数组
            
            
            //            if (modelArr.count) {
            //                for (int i = 0 ;i<modelArr.count;i++) {
            //                    UGLHCategoryListModel *obj = [modelArr objectAtIndex:i];
            //
            //                    [self->_lHCategoryList addObject:obj];
            //                    NSLog(@"obj= %@",obj);
            //                }
            //            }
            //数组转模型数组
            
            [self->_myTable reloadData];
            
        } failure:^(id msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)SegmentValueChanged:(id)sender {
    UISegmentedControl *segment = (UISegmentedControl *)sender;
    if (segment.selectedSegmentIndex == 0) {
        //专家
        [self getFollowList];
    } else {
        //帖子
        [self getfavContentList];
    }
}


#pragma mark tableview datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_mySegment.selectedSegmentIndex == 0) {
        return _followListArray.count;
    } else {
        return _favContentListArray.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_mySegment.selectedSegmentIndex == 0) {
        UGLHFocusUserModel *model = (UGLHFocusUserModel *) [_followListArray objectAtIndex:indexPath.row];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
        FastSubViewCode(cell);
        subLabel(@"标题Label").text = model.nickname;
        [subImageView(@"图片ImageView") sd_setImageWithURL:[NSURL URLWithString:model.headImg] placeholderImage:[UIImage imageNamed:@"touxiang-1"]];
        [subButton(@"取消专家Btn") addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
            NSLog(@"取消专家Btn ,id = %@",model.posterUid);
        }];
        return cell;
    } else {
        UGLHPostInfoModel *model = (UGLHPostInfoModel *) [_favContentListArray objectAtIndex:indexPath.row];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
        FastSubViewCode(cell);
        subLabel(@"标题Label").text = model.title;
        [subButton(@"取消帖子Btn") addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
            NSLog(@"取消帖子Btn ,id = %@",model.cid);
        }];
        return cell;
    }
    
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
