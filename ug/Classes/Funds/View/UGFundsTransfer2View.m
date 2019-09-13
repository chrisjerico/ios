//
//  UGFundsTransfer2View.m
//  ug
//
//  Created by ug on 2019/9/13.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGFundsTransfer2View.h"

@interface UGFundsTransfer2View ()


//============================================================

@property (weak, nonatomic) IBOutlet UILabel *myLabel;

@property (weak, nonatomic) IBOutlet UILabel *my2Label;

@property (weak, nonatomic) IBOutlet UILabel *my3Label;


@end
@implementation UGFundsTransfer2View

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"UGFundsTransfer2View" owner:self options:0].firstObject;
        self.frame = frame;
        self.backgroundColor = [UIColor whiteColor];
        

        
        // 方式一
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChangeAction:) name:@"UITextFieldTextDidChangeNotification" object:_myTextField];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChangeAction:) name:@"UITextFieldTextDidChangeNotification" object:_my2TextField];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChangeAction:) name:@"UITextFieldTextDidChangeNotification" object:_my3TextField];
        
        
    }
    return self;
    
}

#pragma mark - Notification
- (void)textDidChangeAction:(NSNotification *)sender {
    UITextField *textObject;
    if ([[sender class] isSubclassOfClass:[NSNotification class]]) {
        textObject = sender.object;
    } else {
        textObject = (id)sender;
    }
    
    
    NSInteger limitNum = 0;
    
    NSString *toBeString = textObject.text;
    
    if (textObject  == _myTextField) {
        limitNum = 8;
        if (toBeString.length>8) {
            self.myLabel.text = @"8/8";
        } else {
            self.myLabel.text = [NSString stringWithFormat:@"%lu/8",(unsigned long)toBeString.length];
        }
        
    }
    else if (textObject  == _my2TextField) {
        limitNum = 20;
        if (toBeString.length>20) {
            self.my2Label.text = @"20/20";
        } else {
            self.my2Label.text = [NSString stringWithFormat:@"%lu/20",(unsigned long)toBeString.length];
        }
    }
    else if (textObject  == _my3TextField) {
        limitNum = 20;
        if (toBeString.length>20) {
            self.my3Label.text = @"20";
        } else {
            self.my3Label.text = [NSString stringWithFormat:@"%lu/20",(unsigned long)toBeString.length];
        }
    }
    
    
    
    // 获取高亮部分
    UITextRange *selectedRange = [textObject markedTextRange];
    UITextPosition *position = [textObject positionFromPosition:selectedRange.start offset:0];
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    
    if (!position) {
        if (toBeString.length > limitNum) {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:limitNum];
            if (rangeIndex.length == 1) {
                textObject.text = [toBeString substringToIndex:limitNum];
                
                
            } else {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, limitNum)];
                textObject.text = [toBeString substringWithRange:rangeRange];
                
                
                
            }
            
        }
    }
}

@end
