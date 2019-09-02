//
//  UGPromoteDetailController.m
//  ug
//
//  Created by ug on 2019/6/23.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGPromoteDetailController.h"
#import "UGPromoteModel.h"

@interface UGPromoteDetailController ()
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UITextView *contentTextView;
@property (nonatomic, strong) UIActivityIndicatorView *activity;

@end

@implementation UGPromoteDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"活动详情";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.contentTextView];
    [self.view addSubview:self.activity];

}

- (void)setItem:(UGPromoteModel *)item {
    _item = item;
    self.titleLabel.text = self.item.title;
    [self.activity startAnimating];
    NSString *str = [NSString stringWithFormat:@"<head><style>img{width:%f !important;height:auto}</style></head>%@",UGScreenW - 10,self.item.content];
    NSAttributedString *__block attStr = [[NSAttributedString alloc] init];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        attStr = [[NSAttributedString alloc] initWithData:[str dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.activity stopAnimating];
            self.contentTextView.attributedText = attStr;
    
        });
    });
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    CGFloat labelX = 5;
    CGFloat labelY = 15;
    CGFloat labelW = CGRectGetWidth(self.view.frame) - 2*labelX;
    self.titleLabel.frame = CGRectMake(labelX, labelY, labelW, 0);
    [self.titleLabel sizeToFit];
    
    self.contentTextView.frame = CGRectMake(labelX, CGRectGetMaxY(self.titleLabel.frame) + 8, labelW, UGScerrnH - CGRectGetMaxY(self.titleLabel.frame) - 60 );
    self.activity.center = CGPointMake(UGScreenW / 2, UGScerrnH / 2 - 50);
    
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:17];
        _titleLabel.numberOfLines = 0;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UITextView *)contentTextView
{
    if (!_contentTextView) {
        _contentTextView = [[UITextView alloc]init];
        _contentTextView.font = [UIFont systemFontOfSize:17];
    }
    return _contentTextView;
}

- (UIActivityIndicatorView *)activity {
    if (!_activity) {
        _activity = [[UIActivityIndicatorView alloc] init];
        _activity.hidesWhenStopped = YES;
        _activity.color = [UIColor lightGrayColor];
        
    }
    return _activity;
}
@end
