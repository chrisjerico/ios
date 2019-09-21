//
//  UGTestViewController.m
//  ug
//
//  Created by ug on 2019/9/21.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGTestViewController.h"

@interface UGTestViewController ()
@property(nonatomic, readwrite, copy) NSString* startPage;
@end

@implementation UGTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [storage cookies]){
        
        [storage deleteCookie:cookie];
        
    }
    [self setCookie];
    [self ba_web_loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.startPage]]];
    
//    if ([self.title isEqualToString:@"聊天室"]) {
        self.navigationController.navigationBarHidden = YES;
//    }
    
    
}

- (void)ba_web_loadURLString:(NSString *)urlString {
    
//    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//    for (NSHTTPCookie *cookie in [storage cookies]){
//
//        [storage deleteCookie:cookie];
//
//    }
//    [self setCookie];
    [super ba_web_loadURLString:urlString];
    
//    if ([self.title isEqualToString:@"聊天室"]) {
        self.navigationController.navigationBarHidden = YES;
//    }

}

- (void)setCookie{
    
    if (!UGLoginIsAuthorized()) {
        return;
    }
    UGUserModel *user = [UGUserModel currentUser];
    NSMutableDictionary *properties = [NSMutableDictionary dictionary];
    [properties setValue:user.sessid forKey:NSHTTPCookieValue];
    [properties setValue:@"loginsessid" forKey:NSHTTPCookieName];
    [properties setValue:[[NSURL URLWithString:baseServerUrl] host] forKey:NSHTTPCookieDomain];
    [properties setValue:[[NSURL URLWithString:baseServerUrl] path] forKey:NSHTTPCookiePath];
    [properties setValue:[NSDate dateWithTimeIntervalSinceNow:60*60*24] forKey:NSHTTPCookieExpires];
    NSHTTPCookie *cookieuser = [[NSHTTPCookie alloc] initWithProperties:properties];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookieuser];
    
    NSMutableDictionary *properties1 = [NSMutableDictionary dictionary];
    [properties1 setValue:user.token forKey:NSHTTPCookieValue];
    [properties1 setValue:@"logintoken" forKey:NSHTTPCookieName];
    [properties1 setValue:[[NSURL URLWithString:baseServerUrl] host] forKey:NSHTTPCookieDomain];
    [properties1 setValue:[[NSURL URLWithString:baseServerUrl] path] forKey:NSHTTPCookiePath];
    [properties1 setValue:[NSDate dateWithTimeIntervalSinceNow:60*60*24] forKey:NSHTTPCookieExpires];
    
    NSHTTPCookie *cookieuser1 = [[NSHTTPCookie alloc] initWithProperties:properties1];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookieuser1];
    
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
