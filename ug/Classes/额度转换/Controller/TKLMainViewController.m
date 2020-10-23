//
//  TKLMainViewController.m
//  UGBWApp
//
//  Created by fish on 2020/10/23.
//  Copyright © 2020 ug. All rights reserved.
//

#import "TKLMainViewController.h"

@interface TKLMainViewController ()

@end

@implementation TKLMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self viewStyle];
    
    
}

-(void)viewStyle{
    FastSubViewCode(self.view);
    //设置圆角边框设置边框及边框颜色
//    subView(@"左边View").layer.cornerRadius = 5;
//    subView(@"左边View").layer.masksToBounds = YES;
//    subView(@"左边View").layer.borderWidth = 1;
//    subView(@"左边View").layer.borderColor =[ [UIColor blueColor] CGColor];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
