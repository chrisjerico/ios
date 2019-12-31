//
//  AVAsset+Degress.m
//  jwlive
//
//  Created by fish on 2017/8/8.
//  Copyright © 2017年 pican zhang. All rights reserved.
//

#import "AVAsset+Degress.h"

@implementation AVAsset (Degress)

- (NSUInteger)getDegress {
    NSUInteger degress = 0;
    
    NSArray *tracks = [self tracksWithMediaType:AVMediaTypeVideo];
    if([tracks count] > 0) {
        AVAssetTrack *videoTrack = [tracks objectAtIndex:0];
        CGAffineTransform t = videoTrack.preferredTransform;
        
        if(t.a == 0 && t.b == 1.0 && t.c == -1.0 && t.d == 0){
            //LandscapeLeft
            degress = 180;
        }else if(t.a == 0 && t.b == -1.0 && t.c == 1.0 && t.d == 0){
            //LandscapeRight
            degress = 0;
        }else if(t.a == 1.0 && t.b == 0 && t.c == 0 && t.d == 1.0){
            //Portrait
            degress = 90;
        }else if(t.a == -1.0 && t.b == 0 && t.c == 0 && t.d == -1.0){
            //PortraitUpsideDown
            degress = 270;
        }
    }
    
    return degress;
}

@end
