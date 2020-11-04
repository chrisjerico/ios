//
//  PromotionCodeCell.m
//  UGBWApp
//
//  Created by xionghx on 2020/11/2.
//  Copyright © 2020 ug. All rights reserved.
//

#import "PromotionCodeCell.h"
@interface PromotionCodeCell()<UITextViewDelegate>
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *contenLabels;
@property (weak, nonatomic) IBOutlet UITextView *urlView;
@property (nonatomic, strong)UIImage *qrcodeImage;
@end
@implementation PromotionCodeCell

- (void)awakeFromNib {
    [super awakeFromNib];
	self.selectionStyle = UITableViewCellSelectionStyleNone;
	self.urlView.delegate = self;
	
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}


- (void)bind: (InviteCodeModel *)item {
	((UILabel *)(self.contenLabels[0])).text = item.invite_code;
	((UILabel *)(self.contenLabels[1])).text = item.user_type_txt;
	((UILabel *)(self.contenLabels[2])).text = item.url;
	NSRange range = [item.created_time rangeOfString:@" "];
	((UILabel *)(self.contenLabels[3])).text = [NSString stringWithFormat:@"%@\n%@", [item.created_time substringToIndex:range.location], [item.created_time substringFromIndex:range.location]];
	((UILabel *)(self.contenLabels[4])).text = item.used_num.stringValue;
	self.urlView.text = item.url;
	self.qrcodeImage = [self createNonInterpolatedUIImageFormCIImage:[self creatQRcodeWithUrlstring:item.url] withSize:150];
	NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n", item.url]];
	NSMutableAttributedString * buttonString = [[NSMutableAttributedString alloc] initWithString:@"显示二维码"];
	[buttonString addAttributes:@{NSLinkAttributeName: @"ug://Mine/InviteCode/PromotionCodeCell/show_qrcode", NSBackgroundColorAttributeName: UIColor.greenColor} range:NSMakeRange(0, buttonString.length)];
	[attributedString appendAttributedString: buttonString];
	self.urlView.attributedText = attributedString;
}

- (CIImage *)creatQRcodeWithUrlstring:(NSString *)urlString{
	
	// 1.实例化二维码滤镜
	CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
	// 2.恢复滤镜的默认属性 (因为滤镜有可能保存上一次的属性)
	[filter setDefaults];
	// 3.将字符串转换成NSdata
	NSData *data  = [urlString dataUsingEncoding:NSUTF8StringEncoding];
	// 4.通过KVO设置滤镜, 传入data, 将来滤镜就知道要通过传入的数据生成二维码
	[filter setValue:data forKey:@"inputMessage"];
	// 5.生成二维码
	CIImage *outputImage = [filter outputImage];
	return outputImage;
}
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
	CGRect extent = CGRectIntegral(image.extent);
	CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
	
	// 1.创建bitmap;
	size_t width = CGRectGetWidth(extent) * scale;
	size_t height = CGRectGetHeight(extent) * scale;
	CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
	CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
	CIContext *context = [CIContext contextWithOptions:nil];
	CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
	CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
	CGContextScaleCTM(bitmapRef, scale, scale);
	CGContextDrawImage(bitmapRef, extent, bitmapImage);
	
	// 2.保存bitmap到图片
	CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
	CGContextRelease(bitmapRef);
	CGImageRelease(bitmapImage);
	return [UIImage imageWithCGImage:scaledImage];
}
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
	
	if ([URL.lastPathComponent isEqualToString:@"show_qrcode"]) {
		NSMutableAttributedString * buttonString = [[NSMutableAttributedString alloc] initWithString:@"关闭二维码/n/n/n/n++++++++++++++++++++++++++++++++++"];
		[buttonString addAttributes:@{NSLinkAttributeName: @"ug://Mine/InviteCode/PromotionCodeCell/hide_qrcode", NSBackgroundColorAttributeName: UIColor.redColor} range:NSMakeRange(0, buttonString.length)];
		NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.urlView.attributedText];
		[attributedString replaceCharactersInRange:characterRange withAttributedString:buttonString];
		
		NSTextAttachment *attchImage = [[NSTextAttachment alloc] init];
		attchImage.image = self.qrcodeImage;
		attchImage.bounds = CGRectMake(0, 0, 150, 150);
		[attributedString insertAttributedString:[NSAttributedString attributedStringWithAttachment:attchImage] atIndex:attributedString.length];
		self.urlView.attributedText = attributedString;
		[self layoutSubviews];
		return false;
	} else if ([URL.lastPathComponent isEqualToString:@"hide_qrcode"]) {
		NSMutableAttributedString * buttonString = [[NSMutableAttributedString alloc] initWithString:@"显示二维码"];
		[buttonString addAttributes:@{NSLinkAttributeName: @"ug://Mine/InviteCode/PromotionCodeCell/show_qrcode", NSBackgroundColorAttributeName: UIColor.greenColor} range:NSMakeRange(0, buttonString.length)];
		NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.urlView.attributedText];
		[attributedString replaceCharactersInRange:NSMakeRange(characterRange.location, attributedString.length - characterRange.location) withAttributedString:buttonString];
		self.urlView.attributedText = attributedString;
		return false;
	} else {
		return true;
	}
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
	
	
	return TRUE;
}
@end
