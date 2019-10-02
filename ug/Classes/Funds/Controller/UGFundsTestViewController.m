//
//  UGFundsTestViewController.m
//  ug
//
//  Created by ug on 2019/9/12.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGFundsTestViewController.h"
// 限制输入字符数
#define YH_LIMITWORD 8
#define YH_LIMITTEXTWORD 8

@interface UGFundsTestViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *myTextField;

@property (weak, nonatomic) IBOutlet UITextField *my2TextField;

@property (weak, nonatomic) IBOutlet UITextField *my3TextField;

@property (weak, nonatomic) IBOutlet UITextField *my4TextField;

@property (strong, nonatomic) NSString *defaultText;
@property (weak, nonatomic) IBOutlet UILabel *myLabel;

@property (weak, nonatomic) IBOutlet UILabel *my2Label;

@property (weak, nonatomic) IBOutlet UILabel *my3Label;

@property (weak, nonatomic) IBOutlet UILabel *my4Label;

@end

@implementation UGFundsTestViewController
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _defaultText = @"限制输入8个字符";
    [self.view setBackgroundColor: [[UGSkinManagers shareInstance] setbgColor]];
    // 方式一
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChangeAction:) name:@"UITextFieldTextDidChangeNotification" object:_myTextField];
    
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChangeAction:) name:@"UITextFieldTextDidChangeNotification" object:_my2TextField];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChangeAction:) name:@"UITextFieldTextDidChangeNotification" object:_my3TextField];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChangeAction:) name:@"UITextFieldTextDidChangeNotification" object:_my4TextField];
    
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
        limitNum = 6;
        if (toBeString.length>6) {
             self.myLabel.text = @"6";
        } else {
             self.myLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)toBeString.length];
        }
       
    }
    else if (textObject  == _my2TextField) {
        limitNum = 8;
        if (toBeString.length>8) {
            self.my2Label.text = @"8";
        } else {
            self.my2Label.text = [NSString stringWithFormat:@"%lu",(unsigned long)toBeString.length];
        }
    }
    else if (textObject  == _my3TextField) {
        limitNum = 20;
        if (toBeString.length>20) {
            self.my3Label.text = @"20";
        } else {
            self.my3Label.text = [NSString stringWithFormat:@"%lu",(unsigned long)toBeString.length];
        }
    }
    else if (textObject  == _my4TextField) {
        limitNum = 9;
        if (toBeString.length>9) {
            self.my4Label.text = @"9";
        } else {
            self.my4Label.text = [NSString stringWithFormat:@"%lu",(unsigned long)toBeString.length];
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

#pragma mark - UITextViewDelegate
#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    NSString *text = textView.text;
    if ([text containsString:_defaultText]) {
        text = [text stringByReplacingOccurrencesOfString:_defaultText withString:@""];
    }
    textView.text = text;
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@""]) {
        textView.text = _defaultText;
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    //[self textDidChangeAction:(id)textView];
}



@end
