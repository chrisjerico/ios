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
        NSString *ids = @"c085,c175,c194,c153";
#else
        NSString *ids = @(argv[1]);
#endif
        
        [SiteModel checkSiteInfo:ids :ProjectDir];
        
        [ShellHelper packing:[SiteModel sites:ids] completion:^{
            [ShellHelper upload:^{
                exit(0);
            }];
        }];
        
        while (1) {}
    }
    return 0;
}


