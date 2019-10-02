//
//  UGGoogleAuthenticationFirstViewController.m
//  ug
//
//  Created by ug on 2019/9/25.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGGoogleAuthenticationFirstViewController.h"
#import "UGGoogleAuthenticationSecondViewController.h"

@interface UGGoogleAuthenticationFirstViewController ()
@property (weak, nonatomic) IBOutlet UIButton *myButton;

@end

@implementation UGGoogleAuthenticationFirstViewController
-(void)skin{
    [self.view setBackgroundColor: [[UGSkinManagers shareInstance] setbgColor]];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.extendedLayoutIncludesOpaqueBars = YES;
    SANotificationEventSubscribe(UGNotificationWithSkinSuccess, self, ^(typeof (self) self, id obj) {
        
        [self skin];
    });
}
-(void)viewDidLayoutSubviews{
    self.myButton.layer.masksToBounds = YES;
    //如果想要有点弧度的不是地球那么圆的可以设置
    self.myButton.layer.cornerRadius = 3;//这个值越大弧度越大
    
    [self.myButton setBackgroundColor:UGNavColor];
  
}
- (IBAction)myButtonClicked:(id)sender {
    
    UGGoogleAuthenticationSecondViewController *vc = [UGGoogleAuthenticationSecondViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)downLoadAction:(id)sender {
}


@end
