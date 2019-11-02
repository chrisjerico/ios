//
//  UGDocumentView.m
//  ug
//
//  Created by xionghx on 2019/10/1.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGDocumentView.h"

@interface UGDocumentView()
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UITextView *textView;
@property (nonatomic) UIButton *confirmButton;
@end

@implementation UGDocumentView



static UGDocumentView *_singleInstance = nil;

+ (instancetype)shareInstance {
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		if (_singleInstance == nil)
			_singleInstance = [[self alloc] initWithFrame:CGRectZero];
	});
	return _singleInstance;
}

+ (void)showWith:(UGDocumentDetailData *)model {
	UIWindow * window = UIApplication.sharedApplication.keyWindow;
	UGDocumentView * documentView = [UGDocumentView shareInstance];
	documentView.model = model;
	
	[window addSubview: documentView];
	[documentView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(window);
	}];
}

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		
		self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
		
		UIView *contentView = [UIView new];
		contentView.layer.cornerRadius = 10;
		contentView.layer.masksToBounds = true;
		[self addSubview:contentView];
		[contentView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.right.equalTo(self).inset(20);
			make.top.bottom.equalTo(self).inset(80);
		}];
		
		// TitleLabel
		UILabel *titleLabel = [UILabel new];
		titleLabel.text = @"温馨提示";
		titleLabel.textAlignment = NSTextAlignmentCenter;
		titleLabel.font = [UIFont boldSystemFontOfSize:20];
		titleLabel.backgroundColor = [UIColor whiteColor];
		[contentView addSubview:_titleLabel = titleLabel];
		[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(contentView);
			make.left.right.equalTo(contentView);
			make.height.equalTo(@64);
		}];
		
        // 标题下划线
		UIView * line = [UIView new];
		line.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
		[contentView addSubview:line];
		[line mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.right.equalTo(contentView);
			make.top.equalTo(titleLabel.mas_bottom);
			make.height.equalTo(@1);
		}];
        
        // TextView
        _textView = [[UITextView alloc] init];
        _textView.editable = false;
		[contentView addSubview:_textView];
		[_textView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.right.equalTo(contentView);
			make.top.equalTo(line.mas_bottom);
		}];
		[contentView addSubview: self.confirmButton];
        
        // 确定Button
		[self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(self.textView.mas_bottom);
			make.bottom.equalTo(contentView);
			make.left.right.equalTo(contentView);
			make.height.equalTo(@45);
		}];
		
        
        
	}
	return self;
}

- (UIButton *)confirmButton {
	if (!_confirmButton) {
		_confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
		[_confirmButton addTarget:self action:@selector(dismissSelf:) forControlEvents:UIControlEventTouchUpInside];
		_confirmButton.backgroundColor = Skin1.navBarBgColor;
	}
	return _confirmButton;
}

- (void)dismissSelf:(UIButton *)sender {
	[self removeFromSuperview];
}

- (void)setModel:(UGDocumentDetailData *)model {
	_model = model;
    _titleLabel.text = model.title;
    
    __weakSelf_(__self);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *str = _NSString(@"<head><style>img{width:%f !important;height:auto}</style></head>%@%@%@", APP.Width-50, model.header, model.content, model.footer);
         NSAttributedString *attStr = [[NSAttributedString alloc] initWithData:[str dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
         dispatch_async(dispatch_get_main_queue(), ^{
            __self.textView.attributedText = attStr;
        });
    });
}
@end
