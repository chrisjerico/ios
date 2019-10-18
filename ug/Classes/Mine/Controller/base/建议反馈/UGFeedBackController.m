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
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - Table view data delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        
        TGWebViewController *webViewVC = [[TGWebViewController alloc] init];
       
        UGSystemConfigModel *config = [UGSystemConfigModel currentConfig];
        if (config.zxkfUrl.length > 0) {
            webViewVC.url = SysConf.zxkfUrl;
            webViewVC.webTitle = @"在线客服";
            [self.navigationController pushViewController:webViewVC animated:YES];

		}
    
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
