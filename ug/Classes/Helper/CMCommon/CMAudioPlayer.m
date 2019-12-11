//
//  CMAudioPlayer.m
//  ug
//
//  Created by ug on 2019/11/30.
//  Copyright © 2019 ug. All rights reserved.
//

#import "CMAudioPlayer.h"

@interface CMAudioPlayer ()<AVSpeechSynthesizerDelegate>
{
    AVSpeechSynthesizer*av;
}

@end
@implementation CMAudioPlayer

-(instancetype)init{
    self = [super init];
    if (self) {
        av =  [[AVSpeechSynthesizer alloc]init];
    }
    return self;
}

-(void)playLH:(UGLHlotteryNumberModel *)obj{
    if (av) {
        NSString *text; /**<   提示*/
        NSString *sx; /**<   生肖*/
        NSString *color; /**<   颜色 */
        NSString *number; /**<   开奖号码" */
        NSLog(@"obj.numSxArrary= %@",obj.numSxArrary);
        NSLog(@"obj.numbersArrary= %@",obj.numbersArrary);
        if (obj.numSxArrary.count&&(obj.numSxArrary.count-1 >0) ){
            sx = [obj.numSxArrary objectAtIndex:(obj.numSxArrary.count-1)];
//             sx = [obj.numSxArrary objectAtIndex:(obj.count)];
        }
        if (obj.numColorArrary.count) {
            NSString* colorEN = [obj.numColorArrary objectAtIndex:(obj.numColorArrary.count-1)];
//            NSString* colorEN = [obj.numColorArrary objectAtIndex:(obj.count)];
            if ([colorEN isEqualToString:@"green"]) {
                color = @"绿色";
            }
            else if([colorEN isEqualToString:@"red"]) {
                color = @"红色";
            }
            if([colorEN isEqualToString:@"blue"]) {
                color = @"蓝色";
            }
        }
        if (obj.numbersArrary.count&&(obj.numbersArrary.count-1 >0)) {
            number = [obj.numbersArrary objectAtIndex:(obj.numbersArrary.count-1)];
//            number = [obj.numbersArrary objectAtIndex:(obj.count)];
        }
        if (obj.numSxArrary.count==7) {
//         if (obj.count==6) {
            if (!obj.isOpen) {
                text = [NSString stringWithFormat:@"特码,%@号。%@波,生肖:%@",number,color,sx];
            } else {
                text = @"特码已开出,请前去刮一刮";
            }
        }
        else{
            text = [NSString stringWithFormat:@"第%lu球,%@号。%@波,生肖:%@",(unsigned long)obj.numSxArrary.count,number,color,sx];
//              text = [NSString stringWithFormat:@"第%lu球,%@号。%@波,生肖:%@",(unsigned long)obj.count+1,number,color,sx];
        }
        
        AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:text];
        utterance.pitchMultiplier= 0.8;//设置语调
//        utterance.volume = 1.0f;//设置音量（0.0--1.0）
//        utterance.rate = 0.6f;//设置语速
        //中式发音
        AVSpeechSynthesisVoice *voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];
        utterance.voice = voice;
        [av speakUtterance:utterance];
    }
    
}
//开始播放语音
-(void)play:(NSString *)text{
    if (av) {
        AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:text];
        utterance.pitchMultiplier= 0.8;//设置语调
        utterance.volume = 1.0f;//设置音量（0.0--1.0）
        utterance.rate = 0.5f;//设置语速
        //中式发音
        AVSpeechSynthesisVoice *voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];
        utterance.voice = voice;
        [av speakUtterance:utterance];
    }
    
}
// 暂停播放语音
-(void)pause{
    if (av.speaking) {
        [self->av pauseSpeakingAtBoundary:AVSpeechBoundaryWord];
    }
}

// 解封 暂停 播放语音
-(void)continue{
    if (av.paused) {
        [self->av continueSpeaking];
    }
}

// 停止
-(void)stop{
    if (av.speaking) {
        [self->av stopSpeakingAtBoundary:AVSpeechBoundaryWord];
    }
}

//开始朗读的代理方法
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didStartSpeechUtterance:(AVSpeechUtterance *)utterance{
    
}
//结束朗读的代理方法
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance{
    
}
//暂停朗读的代理方法
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didPauseSpeechUtterance:(AVSpeechUtterance *)utterance{
    
}
//继续朗读的代理方法
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didContinueSpeechUtterance:(AVSpeechUtterance *)utterance{
    
}
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didCancelSpeechUtterance:(AVSpeechUtterance *)utterance{
    
}
////将要播放的语音文字代理方法
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer willSpeakRangeOfSpeechString:(NSRange)characterRange utterance:(AVSpeechUtterance *)utterance{
    
}
@end
