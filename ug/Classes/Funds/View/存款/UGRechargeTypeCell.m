//
//  UGRechargeTypeCell.m
//  ug
//
//  Created by ug on 2019/5/3.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGRechargeTypeCell.h"
#import "UGdepositModel.h"

@interface UGRechargeTypeCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;            /**<   标题Label */
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;             /**<   备注Label */
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;  /**<   已签到（灰）补签（红）签到（蓝） */
@end


@implementation UGRechargeTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    if (APP.isBgColorForMoneyVC) {
        self.backgroundColor  = Skin1.bgColor;
        self.nameLabel.textColor = [UIColor whiteColor];
    } else if (Skin1.isBlack) {
        self.backgroundColor = Skin1.homeContentColor;
        self.nameLabel.textColor = Skin1.textColor1;
    }
    if ([APP.SiteId isEqualToString:@"c245"]) {
        self.backgroundColor = [UIColor clearColor];
    }
    
    self.mBtn.layer.cornerRadius = 5;
    self.mBtn.layer.borderWidth = 1;
    self.mBtn.layer.borderColor = [RGBA(28, 136, 255, 1) CGColor];
}

- (void)setNameStr:(NSString *)nameStr {
    _nameStr = nameStr;
    self.nameLabel.text = nameStr;
    
     if (nameStr.isHtmlStr) {
         self.nameLabel.attributedText = ({
             NSMutableAttributedString *mas = [[NSAttributedString alloc] initWithData:[nameStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil].mutableCopy;
             // 替换文字颜色
             NSAttributedString *as = [mas copy];
             for (int i=0; i<as.length; i++) {
                 NSRange r = NSMakeRange(0, as.length);
                 NSMutableDictionary *dict = [as attributesAtIndex:i effectiveRange:&r].mutableCopy;
                 UIColor *c = dict[NSForegroundColorAttributeName];
                 if (fabs(c.red - c.green) < 0.05 && fabs(c.green - c.blue) < 0.05) {
                     if (APP.isBgColorForMoneyVC) {
                         dict[NSForegroundColorAttributeName] = [UIColor whiteColor];
                     } else {
                         dict[NSForegroundColorAttributeName] = Skin1.textColor2;
                     }
                     [mas addAttributes:dict range:NSMakeRange(i, 1)];
                 }
             }
             
             NSLog(@"string = %@",mas.string);
             
             mas;
         });
         [self.nameLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
     }
     else{
        [self.nameLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
     }
    if ([@"c134" containsString: APP.SiteId]) {
        [self.nameLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
    }
}

- (void)setTipStr:(NSString *)tipStr {
    
    _tipStr = tipStr;
    self.tipLabel.text = tipStr;
    if (tipStr.isHtmlStr) {
            self.tipLabel.attributedText = ({
            NSMutableAttributedString *mas = [[NSAttributedString alloc] initWithData:[tipStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil].mutableCopy;
            // 替换文字颜色
            NSAttributedString *as = [mas copy];
            for (int i=0; i<as.length; i++) {
                NSRange r = NSMakeRange(0, as.length);
                NSMutableDictionary *dict = [as attributesAtIndex:i effectiveRange:&r].mutableCopy;
                UIColor *c = dict[NSForegroundColorAttributeName];
                if (fabs(c.red - c.green) < 0.05 && fabs(c.green - c.blue) < 0.05) {
                    if (APP.isBgColorForMoneyVC) {
                        dict[NSForegroundColorAttributeName] = [UIColor whiteColor];
                    } else {
                        dict[NSForegroundColorAttributeName] = Skin1.textColor2;
                    }
                    [mas addAttributes:dict range:NSMakeRange(i, 1)];
                }
            }
            mas;
        });
        
    } else {
        [self.tipLabel setTextColor:RGBA(47, 156, 243, 1)];
    }

}

- (void)setItem:(UGpaymentModel *)item {
    _item = item;
    [self setNameStr:item.name];
    [self setTipStr:item.tip];
    

    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:item.bank_sort_icon] placeholderImage:[UIImage imageNamed:@"loading"]  completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
    }] ;
}
   
@end
