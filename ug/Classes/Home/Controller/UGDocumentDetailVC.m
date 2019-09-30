//
//  UGDocumentDetailVC.m
//  ug
//
//  Created by xionghx on 2019/9/27.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGDocumentDetailVC.h"
#import <objc/runtime.h>
@interface UGDocumentDetailVC ()

@property(nonatomic, strong)UILabel * titleLabel;
@property(nonatomic, strong)UITextView * headerLabel;
@property(nonatomic, strong)UITextView * contentLabel;
@property(nonatomic, strong)UITextView * footerLabel;



@end

@implementation UGDocumentDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
	
	UIView * titleBGView = [UIView new];
	
	titleBGView.backgroundColor = UGNavColor;
	
	[self.view addSubview:titleBGView];
	[titleBGView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.left.right.equalTo(self.view);
		make.height.equalTo(@64);
	}];
	
	

	
	self.view.backgroundColor = UIColor.whiteColor;
	
	[self.view addSubview:self.titleLabel];
	[self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {

		make.centerX.equalTo(titleBGView);
		make.bottom.equalTo(titleBGView).offset(-8);
		make.left.right.equalTo(titleBGView).inset(100);
	}];
	
	UIButton * closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[closeButton setTitle:@"关闭" forState:UIControlStateNormal];
	[closeButton addTarget:self action:@selector(closeButtonTaped:)];
	
	[self.view addSubview:closeButton];
	[closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.equalTo(titleBGView).offset(-20);
		make.bottom.equalTo(titleBGView).offset(-5);

	}];
	
	[self.view addSubview:self.headerLabel];
	[self.headerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.right.equalTo(self.view).inset(10);
		make.top.equalTo(titleBGView.mas_bottom);
		make.height.equalTo(@80);

	}];
	
	[self.view addSubview:self.contentLabel];
	[self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.right.equalTo(self.view).inset(10);
		make.top.equalTo(self.headerLabel.mas_bottom).offset(20);
	}];
	[self.view addSubview:self.footerLabel];
	[self.footerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.contentLabel.mas_bottom).offset(10);
		make.left.right.equalTo(self.view).inset(10);
		make.height.equalTo(@40);
		make.bottom.equalTo(self.view).offset(-20);
	}];
	
}
- (void)setModel:(UGDocumentDetailData *)model {
	_model = model;
	
	self.titleLabel.htmlString = model.title;

	self.headerLabel.htmlString = model.header;
	self.contentLabel.htmlString = model.content;
	self.footerLabel.htmlString = model.footer;
	
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
	[paragraphStyle setAlignment:NSTextAlignmentCenter];
	
	NSDictionary * attributeds = @{NSFontAttributeName				: [UIFont boldSystemFontOfSize:18],
								   NSParagraphStyleAttributeName	: paragraphStyle,
								   NSForegroundColorAttributeName	: UIColor.whiteColor};
	self.titleLabel.attributedText = [[NSMutableAttributedString alloc] initWithString:self.titleLabel.htmlString attributes:attributeds];
	
}

- (UILabel *)titleLabel {
	
	if (!_titleLabel) {
		
		_titleLabel = [UILabel new];
		_titleLabel.numberOfLines = 1;
		_titleLabel.textColor = UIColor.whiteColor;
	
	}
	return _titleLabel;
}

-(UITextView *)headerLabel {
	
	if (!_headerLabel) {
		
		_headerLabel = [UITextView new];
		_headerLabel.editable = false;
		_headerLabel.showsVerticalScrollIndicator = false;
	}
	return _headerLabel;
}

-(UITextView *)contentLabel {
	if (!_contentLabel) {
		_contentLabel = [UITextView new];
		_contentLabel.editable = false;
		_contentLabel.showsVerticalScrollIndicator = false;
	}
	return _contentLabel;
}
-(UITextView *)footerLabel {
	if (!_footerLabel) {
		_footerLabel = [UITextView new];
		_footerLabel.editable = false;
		_footerLabel.showsVerticalScrollIndicator = false;
	}
	return _footerLabel;
}

-(void)closeButtonTaped: (UIButton *)sender {
	
	[self dismissViewControllerAnimated:true completion:nil];
}
@end



@implementation UGDocumentDetailData



@end



@implementation UILabel (HTML)
static NSString * htmlStringKey = @"htmlStringKey";
static NSString * textViewHtmlStringKey = @"textViewHtmlStringKey";

- (void)setHtmlString:(NSString *)htmlString {
    objc_setAssociatedObject(self, &htmlStringKey, htmlString, OBJC_ASSOCIATION_COPY_NONATOMIC);
	NSAttributedString * attributedString = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes: nil error:nil];

	self.attributedText = attributedString;
	
}
- (NSString *)htmlString {
    return  objc_getAssociatedObject(self, &htmlStringKey);

}

@end


@implementation UITextView (HTML)

- (void)setHtmlString:(NSString *)htmlString {
    objc_setAssociatedObject(self, &textViewHtmlStringKey, htmlString, OBJC_ASSOCIATION_COPY_NONATOMIC);
	NSAttributedString * attributedString = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes: nil error:nil];

	self.attributedText = attributedString;
	
}
- (NSString *)htmlString {
    return  objc_getAssociatedObject(self, &textViewHtmlStringKey);

}

@end
