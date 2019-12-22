//
//  UGFeedBackController.m
//  ug
//
//  Created by ug on 2019/6/8.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGFeedBackController.h"
#import "SLWebViewController.h"
#import "UGFeedBackRecordController.h"
#import "QDWebViewController.h"
#import "UGWriteMessageViewController.h"
#import "UGSystemConfigModel.h"
@interface UGFeedBackController ()

@property (strong, nonatomic) IBOutlet UITableView *myTableView;

@property (weak, nonatomic) IBOutlet UIView *cellBgView;      /**<   在线客服 */
@property (weak, nonatomic) IBOutlet UILabel *onlineServiceLabel;
@property (weak, nonatomic) IBOutlet UILabel *onLineServiceInfoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *onlineImgV;

@property (weak, nonatomic) IBOutlet UIView *cell2BgView;   /**<   建议 */
@property (weak, nonatomic) IBOutlet UILabel *adviceLabel;
@property (weak, nonatomic) IBOutlet UILabel *adviceInfoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *adviceImgV;

@property (weak, nonatomic) IBOutlet UIView *cell3BgView;   /**<  投诉 */
@property (weak, nonatomic) IBOutlet UILabel *complaintsLabel;
@property (weak, nonatomic) IBOutlet UILabel *complaintsInfoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *complaintsImgV;

@property (weak, nonatomic) IBOutlet UIView *cell4BgView;    /**<   反馈*/
@property (weak, nonatomic) IBOutlet UILabel *feedbackLabel;
@property (weak, nonatomic) IBOutlet UILabel *feedbackInfoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *feedbackImgV;
@end

@implementation UGFeedBackController
-(void)skin{
   
    
}- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"建议反馈";
    [self.view setBackgroundColor: [UIColor whiteColor]];
    SANotificationEventSubscribe(UGNotificationWithSkinSuccess, self, ^(typeof (self) self, id obj) {
        
        [self skin];
    });
    
    [_myTableView setBackgroundColor:Skin1.textColor4];

    [_cellBgView setBackgroundColor:Skin1.textColor4];
    [_onlineServiceLabel setTextColor:Skin1.textColor1];
    [_onLineServiceInfoLabel setTextColor:Skin1.textColor1];
    if (Skin1.isBlack) {
        [_onlineImgV setImage:[UIImage imageNamed:@"BMrate-up"]];
    } else {
        [_onlineImgV setImage:[UIImage imageNamed:@"jiantou2"]];
    }
    
    [_cell2BgView setBackgroundColor:Skin1.textColor4];
    [_adviceLabel setTextColor:Skin1.textColor1];
    [_adviceInfoLabel setTextColor:Skin1.textColor1];
    if (Skin1.isBlack) {
        [_adviceImgV setImage:[UIImage imageNamed:@"BMrate-up"]];
    } else {
        [_adviceImgV setImage:[UIImage imageNamed:@"jiantou2"]];
    }
    
    [_cell3BgView setBackgroundColor:Skin1.textColor4];
    [_complaintsLabel setTextColor:Skin1.textColor1];
    [_complaintsInfoLabel setTextColor:Skin1.textColor1];
    if (Skin1.isBlack) {
        [_complaintsImgV setImage:[UIImage imageNamed:@"BMrate-up"]];
    } else {
        [_complaintsImgV setImage:[UIImage imageNamed:@"jiantou2"]];
    }
    
    [_cell4BgView setBackgroundColor:Skin1.textColor4];
    [_feedbackLabel setTextColor:Skin1.textColor1];
    [_feedbackInfoLabel setTextColor:Skin1.textColor1];
    if (Skin1.isBlack) {
        [_feedbackImgV setImage:[UIImage imageNamed:@"BMrate-up"]];
    } else {
        [_feedbackImgV setImage:[UIImage imageNamed:@"jiantou2"]];
    }
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - Table view data delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        [NavController1 pushVCWithUserCenterItemType:UCI_在线客服];
    }else if (indexPath.row == 1) {
  
        UGWriteMessageViewController *writeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UGWriteMessageViewController"];
        writeVC.navigationItem.title = @"建议反馈";
        writeVC.feedType = 0;
        [self.navigationController pushViewController:writeVC animated:YES];
    }else if (indexPath.row == 2) {
        UGWriteMessageViewController *writeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UGWriteMessageViewController"];
        writeVC.navigationItem.title = @"投诉建议";
        writeVC.feedType = 1;
        [self.navigationController pushViewController:writeVC animated:YES];
        
    }else {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGFeedBackController" bundle:nil];
        UGFeedBackRecordController *recordVC = [storyboard instantiateViewControllerWithIdentifier:@"UGFeedBackRecordController"];
        [self.navigationController pushViewController:recordVC animated:YES];
        
    }
    
}

@end
