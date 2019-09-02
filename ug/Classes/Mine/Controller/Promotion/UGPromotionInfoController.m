//
//  UGPromotionInfoController.m
//  ug
//
//  Created by ug on 2019/5/10.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGPromotionInfoController.h"

@interface UGPromotionInfoController ()
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *promotionIdlabel;
@property (weak, nonatomic) IBOutlet UILabel *promotionUrlLabel;
@property (weak, nonatomic) IBOutlet UIImageView *promotionQrcodeImageView;
@property (weak, nonatomic) IBOutlet UILabel *registerUrlLabel;
@property (weak, nonatomic) IBOutlet UIImageView *registerQrcodeImageView;
@property (weak, nonatomic) IBOutlet UILabel *incomeLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthMembers;
@property (weak, nonatomic) IBOutlet UILabel *totalMembers;
@property (weak, nonatomic) IBOutlet UIButton *urlCopyButton1;
@property (weak, nonatomic) IBOutlet UISwitch *qrcodeSwitch1;
@property (weak, nonatomic) IBOutlet UIButton *urlCopyButton2;
@property (weak, nonatomic) IBOutlet UISwitch *qrcodeSwitch2;

@property (nonatomic, assign) BOOL showHomeUrl;
@property (nonatomic, assign) BOOL showRegisterUrl;

@end

@implementation UGPromotionInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UGBackgroundColor;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 90, 0);
    self.urlCopyButton1.layer.cornerRadius = 3;
    self.urlCopyButton1.layer.masksToBounds = YES;
    self.urlCopyButton2.layer.cornerRadius = 3;
    self.urlCopyButton2.layer.masksToBounds = YES;
    
}
- (IBAction)homeUrlCopy:(id)sender {
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.promotionUrlLabel.text;
    [SVProgressHUD showInfoWithStatus:@"复制成功"];
    
}
- (IBAction)homeSwitchClick:(id)sender {
    
    self.showHomeUrl = !self.showHomeUrl;
    [self.tableView reloadData];
}
- (IBAction)registerUrlCopy:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.registerUrlLabel.text;
    [SVProgressHUD showInfoWithStatus:@"复制成功"];
}
- (IBAction)registerSwitchClick:(id)sender {
    
    self.showRegisterUrl = !self.showRegisterUrl;
    [self.tableView reloadData];
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
//    return 0;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return self.showHomeUrl ? 285 : 100;
    }else if (indexPath.section == 2) {
        
        return self.showRegisterUrl ? 285 : 100;
    }else {
        
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    
}
@end
