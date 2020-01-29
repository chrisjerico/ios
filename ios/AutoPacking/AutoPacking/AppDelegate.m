//
//  AppDelegate.m
//  AutoPacking
//
//  Created by fish on 2019/12/3.
//  Copyright © 2019 fish. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    ^int(int count){
        return 1;
    };
    ^(int count){
        return 2;
    };
    ^{
        NSLog(@"000");
    };
    int(^aaa)(int) = ^(int count){
        return 1;
    };
    
    
}

-(void)func:(int (^)(int))blk{
    
}

typedef int (^blk)(int);

-(void)func2:(blk)blk1{
    
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end
