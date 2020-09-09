//
//  NSMutableAttributedString+Utils.h
//  MediaViewer
//
//  Created by fish on 2018/1/23.
//  Copyright © 2018年 fish. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSAttributedString (Utils)
- (NSAttributedString *)substringWithFrameSize:(CGSize)size;
@end



@interface NSMutableAttributedString (Utils)

@property (nonatomic) UIFont *font;         /**<    字体 */
@property (nonatomic) UIColor *color;       /**<    颜色 */

@property (nonatomic) CGFloat kern;         /**<    字间距 */
@property (nonatomic) CGFloat lineSpacing;  /**<    行间距 */

- (void)replaceOccurrencesOfString:(NSString *)target withString:(NSString *)replacement;
- (void)replaceOccurrencesOfString:(NSString *)target withAttributedString:(NSAttributedString *)replacement;
- (void)setString:(NSString *)aString;

- (void)addAttributes:(NSDictionary<NSAttributedStringKey, id> *)attrs withString:(NSString *)string;
- (void)setAttributes:(NSDictionary<NSAttributedStringKey, id> *)attrs withString:(NSString *)string;

@end


// —————— 拓展

@interface UILabel (NSMutableAttributedStringUtils)
- (void)updateAttributedText:(void (^)(NSMutableAttributedString *attributedText))block;
@end
