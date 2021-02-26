//
//  HomeLHColumnView.m
//  UGBWApp
//
//  Created by fish on 2020/10/16.
//  Copyright © 2020 ug. All rights reserved.
//

#import "HomeLHColumnView.h"
#import "UGPostListVC.h"
#import "UGPostDetailVC.h"
#import "UGDocumentListVC.h"
#import "LHJournalDetailVC.h"
#import "LHGalleryListVC2.h"

#import "UGLHCategoryListModel.h"
#import "UGLHPostModel.h"

#import "UGLHHomeContentCollectionViewCell.h"
#import "LHPostPayView.h"
#import "UGLHOldYearViewController.h"
#import "UGAppVersionManager.h"

@interface HomeLHColumnView ()<UICollectionViewDelegate, UICollectionViewDataSource, WSLWaterFlowLayoutDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *contentCollectionView;           /**<  论坛，专帖XXX显示*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightLayoutConstraint;        /**<  contentCollectionView 的约束高*/

@property (nonatomic, strong) NSMutableArray<UGLHCategoryListModel *> *lHCategoryList;  /**<   栏目列表数据 */

@property (nonatomic, strong) UGPostDetailVC *postvc;                                   /**<   帖子 */
@end


@implementation HomeLHColumnView

- (void)awakeFromNib {
    [super awakeFromNib];
    _lHCategoryList = [NSMutableArray<UGLHCategoryListModel *> new];
    
    //六合内容
    WSLWaterFlowLayout * _flow;
    _flow = [[WSLWaterFlowLayout alloc] init];
    _flow.delegate = self;
    _flow.flowLayoutStyle = WSLWaterFlowVerticalEqualHeight;
    
    //    self.contentCollectionView.backgroundColor = RGBA(221, 221, 221, 1);
    self.contentCollectionView.backgroundColor = [UIColor whiteColor];
    self.contentCollectionView.dataSource = self;
    self.contentCollectionView.delegate = self;
    self.contentCollectionView.tagString= @"六合内容";
    [self.contentCollectionView registerNib:[UINib nibWithNibName:@"UGLHHomeContentCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    [CMCommon setBorderWithView:self.contentCollectionView top:YES left:YES bottom:NO right:YES borderColor:RGBA(221, 221, 221, 1) borderWidth:1];
    [self.contentCollectionView setCollectionViewLayout:_flow];
}

- (void)reloadData:(void (^)(BOOL succ))completion {
    FastSubViewCode(self)
    
    WeakSelf;
    [CMNetwork categoryListWithParams:@{} completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            weakSelf.lHCategoryList = [NSMutableArray<UGLHCategoryListModel *> new];
            NSLog(@"model= %@",model.data);
            NSArray *modelArr = (NSArray *)model.data;         //数组转模型数组
            
            if (modelArr.count==0) {
                weakSelf.heightLayoutConstraint.constant = 0.0;
                return ;
            }
            
            if (modelArr.count) {
                for (int i = 0 ;i<modelArr.count;i++) {
                    UGLHCategoryListModel *obj = [modelArr objectAtIndex:i];
                    
                    [weakSelf.lHCategoryList addObject:obj];
                    NSLog(@"obj= %@",obj);
                }
            }
            //数组转模型数组
            
            
            //            subView(@"开奖结果").hidden = NO;
            //            subView(@"六合论坛").hidden = NO;
            // 需要在主线程执行的代码
            [weakSelf.contentCollectionView reloadData];
            if (weakSelf.lHCategoryList.count%2==0) {
                weakSelf.heightLayoutConstraint.constant = weakSelf.lHCategoryList.count/2*80+1;
            } else {
                weakSelf.heightLayoutConstraint.constant = weakSelf.lHCategoryList.count/2*80+80+1;
            }
            
            if (completion)
                completion(true);
            
        } failure:^(id msg) {
            if (completion)
                completion(false);
        }];
    }];
}


#pragma mark UICollectionView datasource

////组个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
//组内成员个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    int rows = 0;
    if ([collectionView.tagString isEqualToString:@"六合内容"]) {
        rows = (int)_lHCategoryList.count;
    }
    return rows;
}
//每个cell的具体内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    //    if ([collectionView.tagString isEqualToString:@"六合内容"]) {
    UGLHHomeContentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    UGLHCategoryListModel *model = [self.lHCategoryList objectAtIndex:indexPath.row];
    FastSubViewCode(cell);
    [subImageView(@"图片ImgV") sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:[UIImage imageNamed:@"loading"]];
    [subLabel(@"标题Label") setText:model.name];
    [subLabel(@"详细Label") setText:model.desc];

    [model.isHot isEqualToString:@"1"] ? [subButton(@"hotButton") setHidden:NO] : [subButton(@"hotButton") setHidden:YES];
    
    NSLog(@"model.name = %@ model.cid = %@,mode= %@",model.name,model.cid,model);
    
    if ([@"l002" containsString:APP.SiteId]) {
        if ([model.cid isEqualToString:@"662"]||[model.cid isEqualToString:@"714"] ) {
            [subButton(@"hotButton") setTitle:@"官方" forState:(UIControlStateNormal)];
        } else {
            [subButton(@"hotButton") setTitle:@"hot" forState:(UIControlStateNormal)];
        }
    }
    
    
    [cell setBackgroundColor: [UIColor whiteColor]];
    cell.layer.borderWidth = 1;
    cell.layer.borderColor = [RGBA(221, 221, 221, 1) CGColor];
    return cell;
    //    }
    
    
}
////cell size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    float itemW = (UGScreenW)/ 2.0;
    CGSize size = {itemW, 80};
    return size;
}
////item偏移
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
}
//行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

-(int)judgmentLink:(NSString *)link{
//    /mobile/#/lottery/index ===》彩种 1
//    /mobile/#/lottery/mystery ===〉帖子  2
//    /mobile/real/goToGame ===》 游戏第3方  3
//    “”==〉其他
    int judgment;
    if ([ link containsString:@"/mobile/#/lottery/index"]) {
        judgment = 1;
    }
    else if ([link containsString:@"/mobile/#/lottery/mystery"]) {
        judgment =  2;
    }
    else if([link containsString:@"/mobile/real/goToGame"]){
        judgment = 3;
    }
    else{
        judgment =  4;
    }
    return judgment;
}

-(NSString *)judgmentGameType:(NSString *)gameType{

    NSString * judgment;
    if ([gameType containsString:@"cqssc" ]) {
        judgment = @"cqssc";
    }
    else if ([gameType containsString:@"pk10"]) {
        judgment =  @"pk10";
    }
    else if([gameType containsString:@"xyft"]){
        judgment = @"xyft";
    }
    else if([gameType containsString:@"qxc"]){
        judgment = @"qxc";
    }
    else if([gameType containsString:@"lhc"]){
        judgment = @"lhc";
    }
    else if([gameType containsString:@"jsk3"]){
        judgment = @"jsk3";
    }
    else if([gameType containsString:@"pcdd"]){
        judgment = @"pcdd";
    }
    else if([gameType containsString:@"gd11x5"]){
        judgment = @"gd11x5";
    }
    else if([gameType containsString:@"xync"]){
        judgment = @"xync";
    }
    else if([gameType containsString:@"bjkl8" ]){
        judgment = @"bjkl8";
    }
    else if([gameType containsString:@"gdkl10"]){
        judgment = @"gdkl10";
    }
    else if([gameType containsString:@"fc3d"]){
        judgment = @"fc3d";
    }
    else if([gameType containsString:@"pk10nn"]){
        judgment = @"pk10nn";
    }
    else if([gameType containsString:@"dlt"]){
        judgment = @"dlt";
    }
    else if([gameType containsString:@"qxc"]){
        judgment = @"qxc";
    }
    else if([gameType containsString:@"ofclvn_hochiminhvip"]){
        judgment = @"ofclvn_hochiminhvip";
    }
    else if([gameType containsString:@"ofclvn_haboivip" ]){
        judgment = @"ofclvn_haboivip";
    }
    return judgment;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    UGLHCategoryListModel *model = [self.lHCategoryList objectAtIndex:indexPath.row];
    
    // 后台给的栏目ID可能不正确，要根据别名修正
    NSMutableDictionary *typeDict = @{@"sixpic":@"5",}.mutableCopy;
    // 以下别名，链接带alias的则修正
    if (!model.link.urlParams[@"alias"]) {
        [typeDict addEntriesFromDictionary:@{
                    @"humorGuess":@"6",
                    @"rundog":@"7",
                    @"fourUnlike":@"8",
        }];
    }
    model.cid = typeDict[model.categoryType] ? : model.cid;
    BOOL isNum = [CMCommon judgeIsNumberByRegularExpressionWith:model.categoryType];
    
    if ([model.thread_type isEqualToString:@"2"]) {
        UGPostListVC *vc = _LoadVC_from_storyboard_(@"UGPostListVC");
        vc.clm = model;
        [NavController1 pushViewController:vc animated:true];
        return;
    }
    else if (model.contentId.length) {
        // 获取帖子详情
        [SVProgressHUD showWithStatus:nil];
        NSLog(@"model.contentId = %@",model.contentId);
        __weakSelf_(__self);
        [NetworkManager1 lhdoc_contentDetail:model.contentId].completionBlock = ^(CCSessionModel *sm, id resObject, NSError *err) {
            [SVProgressHUD dismiss];
            if (!sm.error) {
                UGLHPostModel *pm = [UGLHPostModel mj_objectWithKeyValues:sm.resObject[@"data"]];
                pm.link = model.link;
                pm.baomaType = model.baomaType;
                pm.read_pri = model.read_pri;
                
                NSLog(@"获取帖子详情 = %@",pm.content);
                void (^push)(void) = ^{
                    
                    __self.postvc = _LoadVC_from_storyboard_(@"UGPostDetailVC");
                    __self.postvc.pm = pm;
                    __self.postvc.title = model.name;
                    [NavController1 pushViewController:__self.postvc animated:true];
                };
                if (!pm.hasPay && pm.price > 0.000001) {
                    LHPostPayView *ppv = _LoadView_from_nib_(@"LHPostPayView");
                    ppv.pm = pm;
                    ppv.didConfirmBtnClick = ^(LHPostPayView * _Nonnull ppv) {
                        if (!UGLoginIsAuthorized()) {
                            [ppv hide:nil];
                            SANotificationEventPost(UGNotificationShowLoginView, nil);
                            return;
                        }
                        [NetworkManager1 lhcdoc_buyContent:pm.cid].completionBlock = ^(CCSessionModel *sm, id resObject, NSError *err) {
                            if (!sm.error) {
                                pm.hasPay = true;
                                [ppv hide:nil];
                                UIAlertController *ac = [AlertHelper showAlertView:@"支付成功" msg:nil btnTitles:@[@"确定"]];
                                [ac setActionAtTitle:@"确定" handler:^(UIAlertAction *aa) {
                                    push();
                                }];
                            }
                        };
                    };
                    [ppv show];
                } else {
                    push();
                }
            }
        };
        return;
    }
    
    int judgment = [self judgmentLink:model.link];
    //    /mobile/#/lottery/index ===》彩种 1
    //    /mobile/#/lottery/mystery ===〉帖子  2
    //    /mobile/real/goToGame ===》 游戏第3方  3
    //    “”==〉其他
    //    /mobile/#/lottery/index ===》彩种 1
    if (judgment == 1) {
        
        NSLog(@"model.categoryType = %@",model.categoryType);
        if ([model.categoryType isEqualToString:@"187"]) {
            UGNextIssueModel *m = [UGNextIssueModel new];
            m.title = model.name;
            m.gameId = model.categoryType;
            m.gameType = @"cqssc";
            [NavController1 pushViewControllerWithNextIssueModel:m isChatRoom:NO];
        }
        else if ([model.categoryType isEqualToString:@"186"]) {
            UGNextIssueModel *m = [UGNextIssueModel new];
            m.title = model.name;
            m.gameId = model.categoryType;
            m.gameType = @"pk10";
            [NavController1 pushViewControllerWithNextIssueModel:m isChatRoom:NO];
        }
        else{
            UGNextIssueModel *m = [UGNextIssueModel new];
            m.title = model.name;
            m.gameId = model.categoryType;
            m.gameType = [self judgmentGameType:model.baomaType];
            [NavController1 pushViewControllerWithNextIssueModel:m isChatRoom:NO];
        }
      
    }
    else  if (judgment == 2) { //    /mobile/#/lottery/mystery ===〉帖子  2
        if ([model.thread_type isEqualToString:@"2"]) {
            UGPostListVC *vc = _LoadVC_from_storyboard_(@"UGPostListVC");
            vc.clm = model;
            [NavController1 pushViewController:vc animated:true];
            return;
        }
        else if (model.contentId.length) {
            // 获取帖子详情
            [SVProgressHUD showWithStatus:nil];
            NSLog(@"model.contentId = %@",model.contentId);
            __weakSelf_(__self);
            [NetworkManager1 lhdoc_contentDetail:model.contentId].completionBlock = ^(CCSessionModel *sm, id resObject, NSError *err) {
                [SVProgressHUD dismiss];
                if (!sm.error) {
                    UGLHPostModel *pm = [UGLHPostModel mj_objectWithKeyValues:sm.resObject[@"data"]];
                    pm.link = model.link;
                    pm.baomaType = model.baomaType;
                    pm.read_pri = model.read_pri;
                    NSLog(@"获取帖子详情 = %@",pm.content);
                    void (^push)(void) = ^{
                        
                        __self.postvc = _LoadVC_from_storyboard_(@"UGPostDetailVC");
                        __self.postvc.pm = pm;
                        __self.postvc.title = model.name;
                        [NavController1 pushViewController:__self.postvc animated:true];
                    };
                    if (!pm.hasPay && pm.price > 0.000001) {
                        LHPostPayView *ppv = _LoadView_from_nib_(@"LHPostPayView");
                        ppv.pm = pm;
                        ppv.didConfirmBtnClick = ^(LHPostPayView * _Nonnull ppv) {
                            if (!UGLoginIsAuthorized()) {
                                [ppv hide:nil];
                                SANotificationEventPost(UGNotificationShowLoginView, nil);
                                return;
                            }
                            [NetworkManager1 lhcdoc_buyContent:pm.cid].completionBlock = ^(CCSessionModel *sm, id resObject, NSError *err) {
                                if (!sm.error) {
                                    pm.hasPay = true;
                                    [ppv hide:nil];
                                    UIAlertController *ac = [AlertHelper showAlertView:@"支付成功" msg:nil btnTitles:@[@"确定"]];
                                    [ac setActionAtTitle:@"确定" handler:^(UIAlertAction *aa) {
                                        push();
                                    }];
                                }
                            };
                        };
                        [ppv show];
                    } else {
                        push();
                    }
                }
            };
            return;
        }
        
        else{
            UGDocumentListVC *vc = _LoadVC_from_storyboard_(@"UGDocumentListVC");
            vc.clm = model;
            [NavController1 pushViewController:vc animated:true];
            NSLog(@"每期资料,公式规律");
        }
    }
    //    /mobile/real/goToGame ===》 游戏第3方  3
    else  if (judgment == 3) {
        NSArray  *array = [model.link componentsSeparatedByString:@"/"];
        NSString *number1 = [array objectAtIndex:array.count-2];
        if (!UGLoginIsAuthorized()) {
            [[NSNotificationCenter defaultCenter] postNotificationName:UGNotificationShowLoginView object:nil];
            return ;
        }
        NSDictionary *params = @{@"token":UserI.sessid,
                                 @"id":number1,
//                                 @"game":gameCode,
        };
        [SVProgressHUD showWithStatus:nil];
      
        [CMNetwork getGotoGameUrlWithParams:params completion:^(CMResult<id> *model, NSError *err) {
            [CMResult processWithResult:model success:^{
                [SVProgressHUD dismiss];
                dispatch_async(dispatch_get_main_queue(), ^{
                    QDWebViewController *qdwebVC = [[QDWebViewController alloc] init];
                    NSLog(@"网络链接：model.data = %@", model.data);
                    qdwebVC.urlString = [CMNetwork encryptionCheckSignForURL:model.data];
                    
                   
//                    qdwebVC.urlString = [qdwebVC.urlString stringByReplacingOccurrencesOfString:@"http://2044953.com" withString:@"https://2044953.com:8888"];
                    NSLog(@"网络链接：model.data = %@", qdwebVC.urlString);
    
                    qdwebVC.enterGame = YES;
                    [NavController1 pushViewController:qdwebVC animated:YES];
                });
            } failure:^(id msg) {
                [SVProgressHUD showErrorWithStatus:msg];
            }];
        }];
        
    }
    //    “”==〉其他
    else  if (judgment == 4) {

        if([@"zxkf" containsString:model.alias]) {
            TGWebViewController *webViewVC = [[TGWebViewController alloc] init];
            webViewVC.url = model.link;
            webViewVC.webTitle = model.name;
            [NavController1 pushViewController:webViewVC animated:YES];
            NSLog(@"在线客服");
            return;
        }
        
        if ([@"forum,gourmet" containsString:model.categoryType]) {
            UGPostListVC *vc = _LoadVC_from_storyboard_(@"UGPostListVC");
            vc.clm = model;
            [NavController1 pushViewController:vc animated:true];
            NSLog(@"高手论坛,极品专贴");
        }
        else if([@"mystery,rule" containsString:model.categoryType]) {
            UGDocumentListVC *vc = _LoadVC_from_storyboard_(@"UGDocumentListVC");
            vc.clm = model;
            [NavController1 pushViewController:vc animated:true];
            NSLog(@"每期资料,公式规律");
        }
        else if([@"humorGuess,rundog,fourUnlike" containsString:model.categoryType]) {
            //fourUnlike
            NSLog(@"model.categoryType = %@",model.categoryType);
            LHJournalDetailVC *vc = _LoadVC_from_storyboard_(@"LHJournalDetailVC");
            vc.clm = model;
            [NavController1 pushViewController:vc animated:true];
            NSLog(@"幽默猜测,跑狗玄机,四不像");
        }
        else if([@"sixpic" containsString:model.categoryType]) {
            LHGalleryListVC2 *vc = _LoadVC_from_storyboard_(@"LHGalleryListVC2");
            vc.clm = model;
            [NavController1 pushViewController:vc animated:true];
            NSLog(@"六合图库");
        }
        else if([@"yellowCale" containsString:model.categoryType]) {
            
            UGLHOldYearViewController *vc = _LoadVC_from_storyboard_(@"UGLHOldYearViewController");
            vc.clm = model;
            [NavController1 pushViewController:vc animated:true];
            NSLog(@"老黃历");
        }
        else if([@"rwzx" containsString:model.categoryType]) {
            [NavController1 pushViewController:_LoadVC_from_storyboard_(@"UGMissionCenterViewController")  animated:YES];
            NSLog(@"任务中心");
        }
        else if([@"appdl" containsString:model.categoryType]) {
            [[UGAppVersionManager shareInstance] updateVersionApi:true completion:nil];
            NSLog(@"APP下载");
        }
        else {
            BOOL ret = [NavController1 pushViewControllerWithLinkCategory:7 linkPosition:model.appLinkCode];
            if (!ret && model.appLink.length) {
                TGWebViewController *webViewVC = [[TGWebViewController alloc] init];
                webViewVC.url = model.appLink;
                webViewVC.webTitle = model.name;
                [NavController1 pushViewController:webViewVC animated:YES];
            }
        }
    }
    
    
}


#pragma mark - WSLWaterFlowLayoutDelegate
//返回每个item大小
- (CGSize)waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    float itemW = (UGScreenW-1)/ 2.0;
    CGSize size = {itemW, 80};
    return size;
    
    
}

/** 列数*/
-(CGFloat)columnCountInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
    return 1;
}
/** 行数*/
//-(CGFloat)rowCountInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
//    return 5;
//}
/** 列间距*/
-(CGFloat)columnMarginInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
    return 0;
}
/** 行间距*/
-(CGFloat)rowMarginInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
    return 0;
}
/** 边缘之间的间距*/
-(UIEdgeInsets)edgeInsetInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
    
    return UIEdgeInsetsMake(0, 0, 0,0);
}

@end
