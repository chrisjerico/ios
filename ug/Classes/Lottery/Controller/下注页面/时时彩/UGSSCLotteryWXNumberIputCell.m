//
//  UGSSCLotteryWXNumberIputCell.m
//  UGBWApp
//
//  Created by xionghx on 2020/9/23.
//  Copyright © 2020 ug. All rights reserved.
//

#import "UGSSCLotteryWXNumberIputCell.h"

@implementation UGSSCLotteryWXNumberIputCell

- (void)awakeFromNib {
    [super awakeFromNib];
	
	self.inputView.delegate = self;
	
    // Initialization code
}

- (void)prepareForReuse {
	[super prepareForReuse];
	self.inputView.text = nil;
}
- (void)textViewDidChange:(UITextView *)textView {
	
	if (self.delegate && [self.delegate respondsToSelector:@selector(newNumberGenerated:)]) {
		NSString *inputText = [NSString stringWithFormat:@" %@ ", textView.text];
		NSString *pattern = @"(?<=[\\D])[\\d]{5}(?=[\\D])";
		NSRegularExpression *regular = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];

		NSArray *results = [regular matchesInString:inputText options:0 range:NSMakeRange(0, inputText.length)];
		NSMutableArray * numberArray = [NSMutableArray array];
		for (NSTextCheckingResult * result in results) {
			
			[numberArray appendObject:[inputText substringWithRange:result.range]];
		}
		[self.delegate newNumberGenerated:numberArray];

	}
}
@end
