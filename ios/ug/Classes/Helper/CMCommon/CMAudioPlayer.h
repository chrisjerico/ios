//
//  CMAudioPlayer.h
//  ug
//
//  Created by ug on 2019/11/30.
//  Copyright © 2019 ug. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UGLHlotteryNumberModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface CMAudioPlayer : NSObject
//开始播放语音==>六合
-(void)playLH:(UGLHlotteryNumberModel *)obj;
//开始播放语音
-(void)play:(NSString *)text;
// 暂停播放语音
-(void)pause;
// 解封 暂停 播放语音
-(void)continue;
// 停止
-(void)stop;
@end

NS_ASSUME_NONNULL_END
