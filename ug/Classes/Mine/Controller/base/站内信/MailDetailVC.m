//
//  MailDetailVC.m
//  UGBWApp
//
//  Created by xionghx on 2020/12/26.
//  Copyright © 2020 ug. All rights reserved.
//

#import "MailDetailVC.h"

@interface MailDetailVC ()
@property (strong, nonatomic) IBOutlet UITextView *textView;

@end

@implementation MailDetailVC

-(void)setContent:(NSString *)content{
    _content = content;
    NSString *str = _NSString(@"<head><style>body{margin:20;color: red}img{width:auto !important;max-width:100%%;height:auto !important}</style></head><body><text>%@</text></body>", _content);
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[str dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    self.textView.attributedText = attributedString;
}

- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:false completion:nil];
}

@end
