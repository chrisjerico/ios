//
//  UGLHMYDynamicViewController.m
//  ug
//
//  Created by ug on 2019/11/25.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGLHMYDynamicViewController.h"
#import "UGLHPostModel.h"
@interface UGLHMYDynamicViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(strong,nonatomic)NSMutableArray *postListArray;/**<   帖子列表数组" */

@end

@implementation UGLHMYDynamicViewController

- (BOOL)允许游客访问 { return true; }

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的动态";
    _postListArray = [NSMutableArray new];

    
    
    {
        [_tableView setupHeaderRefreshRequest:^CCSessionModel *(UITableView *tv) {
            return [NetworkManager1 lhdoc_historyContent:@"1" page:1];
        } completion:^NSArray *(UITableView *tv, CCSessionModel *sm) {
            NSArray *array = sm.responseObject[@"list"];
            for (NSDictionary *dict in array)
                [tv.dataArray addObject:[UGLHPostModel mj_objectWithKeyValues:dict]];
            return array;

//    [self getPostList];
//}
//
////------------六合------------------------------------------------------
// 我的历史帖子
//- (void)getPostList {
//    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid,
//                             @"cateId":@"1",
//
//    };
//    [CMNetwork historyContentWithParams:params completion:^(CMResult<id> *model, NSError *err) {
//        [SVProgressHUD showWithStatus:nil];
//        [CMResult processWithResult:model success:^{
//           [SVProgressHUD dismiss];
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

        }];
        [_tableView setupFooterRefreshRequest:^CCSessionModel *(UITableView *tv) {
            return [NetworkManager1 lhdoc_historyContent:@"1" page:tv.pageIndex];
        } completion:^NSArray *(UITableView *tv, CCSessionModel *sm) {
            NSArray *array = sm.responseObject[@"list"];
            for (NSDictionary *dict in array)
                [tv.dataArray addObject:[UGLHPostModel mj_objectWithKeyValues:dict]];
            return array;
        }];
        [_tableView.mj_header beginRefreshing];
    }
}


#pragma mark tableview datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

        return _postListArray.count;
   
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UGLHPostModel *model = (UGLHPostModel *) [_postListArray objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    FastSubViewCode(cell);
    [subImageView(@"headImg") sd_setImageWithURL:[NSURL URLWithString:model.headImg] placeholderImage:[UIImage imageNamed:@"touxiang-1"]];
    subLabel(@"nickname").text = model.nickname;
    subLabel(@"createTime").text = model.createTime;
    subLabel(@"点赞数Label").text = @(model.likeNum).stringValue;
    subLabel(@"标题Label").text = model.title;
    subLabel(@"内容Label").text = model.content;
    [subButton(@"点赞Btn") setTitle:@(model.likeNum).stringValue forState:(UIControlStateNormal)];
    [subButton(@"阅读Btn") setTitle:@(model.viewNum).stringValue forState:(UIControlStateNormal)];
    [subButton(@"点赞Btn") addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
        NSLog(@"点赞Btn ,id = %@",model.cid);
    }];
    [subButton(@"阅读Btn") addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
        NSLog(@"阅读Btn ,id = %@",model.cid);
    }];
    [subButton(@"消息Btn") addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
        NSLog(@"消息Btn ,id = %@",model.cid);
    }];
    if (model.isHot) {
        [subImageView(@"热门ImgV") setHidden:NO];
    } else {
        [subImageView(@"热门ImgV") setHidden:YES];
    }
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

  
}

@end
