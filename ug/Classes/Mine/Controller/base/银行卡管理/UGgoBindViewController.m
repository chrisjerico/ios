//
//  UGgoBindViewController.m
//  ug
//
//  Created by ug on 2019/10/10.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGgoBindViewController.h"
#import "UIView+TagString.h"
#import "IBButton.h"
#import "UGSetupPayPwdController.h"

@interface UGgoBindViewController ()
//@property (weak, nonatomic) IBOutlet IBButton *myButton;

@end

@implementation UGgoBindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    FastSubViewCode(self.view);
    [subButton(@"立即绑定") setBackgroundColor: [[UGSkinManagers shareInstance] setNavbgColor]];
//    subButton(@"asdfas") sd_setImageWithURL:<#(nullable NSURL *)#> forState:<#(UIControlState)#>
//       IBButton  *button = [self viewWithTagString:@"WebView"];
//    [_myButton setBackgroundColor: [[UGSkinManagers shareInstance] setNavbgColor]];
}


- (IBAction)goBindVC:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGBindCardViewController" bundle:nil];
    UGSetupPayPwdController *fundVC = [storyboard instantiateViewControllerWithIdentifier:@"UGSetupPayPwdController"];
    [self.navigationController pushViewController:fundVC animated:YES];
}

@end
