//
//  UGDocumentView.m
//  ug
//
//  Created by xionghx on 2019/10/1.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGDocumentView.h"

@interface UGDocumentView()
@property (nonatomic, strong) UIButton * confirmButton;
@property (nonatomic, strong) UITextView * contentView;

@end

@implementation UGDocumentView



static UGDocumentView *_singleInstance = nil;

+ (instancetype)shareInstance
{
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		if (_singleInstance == nil) {
			_singleInstance = [[self alloc] initWithFrame:CGRectZero];
		}
	});
	return _singleInstance;
}

+ (void)show {
	
	
	
}

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		
		self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
		
		UIView * contentView = [UIView new];
		contentView.layer.cornerRadius = 10;
		contentView.layer.masksToBounds = true;
		[self addSubview:contentView];
		[contentView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.right.equalTo(self).inset(20);
			make.top.bottom.equalTo(self).inset(80);
		}];
		
		
		UILabel * label = [UILabel new];
		label.text = @"温馨提示";
		label.textAlignment = NSTextAlignmentCenter;
		label.font = [UIFont boldSystemFontOfSize:20];
		label.backgroundColor = UIColor.whiteColor;
		UIView * line = [UIView new];
		line.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
		[contentView addSubview:label];
		[label mas_makeConstraints:^(MASConstraintMaker *make) {
//			make.centerX.equalTo(contentView);
			make.top.equalTo(contentView).offset(5);
			make.left.right.equalTo(contentView);
			make.height.equalTo(@60);
			
		}];
		
		[contentView addSubview:line];
		[line mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.right.equalTo(contentView);
			make.top.equalTo(label.mas_bottom).offset(5);
			make.height.equalTo(@1);
		}];
		[contentView addSubview:self.contentView];
		[self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.right.equalTo(contentView);
			make.top.equalTo(line);
		}];
		[contentView addSubview: self.confirmButton];
		[self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(self.contentView.mas_bottom);
			make.bottom.equalTo(contentView);
			make.left.right.equalTo(contentView);
			make.height.equalTo(@40);
		}];
		
	}
	return self;
}

- (UIButton *)confirmButton {
	
	if (!_confirmButton) {
		_confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
		[_confirmButton addTarget:self action:@selector(dismissSelf:) forControlEvents:UIControlEventTouchUpInside];
		_confirmButton.backgroundColor = [UIColor blueColor];
	}
	return _confirmButton;
}

-(void) dismissSelf: (UIButton *)sender {
	[self removeFromSuperview];
}

- (UITextView *)contentView {
	
	if (!_contentView) {
		_contentView = [[UITextView alloc] init];
	}
	return _contentView;
}

- (void)setModel:(UGDocumentDetailData *)model {
	_model = model;
	
	
	NSAttributedString * attributedString = [[NSAttributedString alloc] initWithData:[[NSString stringWithFormat:@"%@%@%@", model.title, model.content, model.footer] dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes: nil error:nil];
	self.contentView.attributedText = attributedString;
	
}
@end
