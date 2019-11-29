//
//  Global.m
//  ug
//
//  Created by ug on 2019/11/29.
//  Copyright © 2019 ug. All rights reserved.
//

#import "Global.h"

@implementation Global
@synthesize lotterydataArray;

static Global *mglobal;

+(Global *)getInstanse
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mglobal=[[Global alloc]init];
    });
    
    return mglobal;
}


@end
