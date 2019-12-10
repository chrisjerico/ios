//
//  main.m
//  AutoPackingProject
//
//  Created by fish on 2019/11/25.
//  Copyright © 2019 fish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShellHelper.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
#ifdef DEBUG
        NSString *ids = @"c084";
#else
        NSString *ids = @(argv[1]);
#endif
        
        
        [ShellHelper pullCode:^{
            if (![[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/PullSuccess.txt", ProjectDir]]) {
                @throw [NSException exceptionWithName:@"git 拉取代码失败，请手动更新代码" reason:@"" userInfo:nil];
            }
            
            [SiteModel checkSiteInfo:ids :ProjectDir];
            
            [ShellHelper packing:[SiteModel sites:ids] completion:^{
                
                
                
                [ShellHelper upload:^{
                    exit(0);
                }];
            }];
        }];
        while (1) {}
    }
    return 0;
}


