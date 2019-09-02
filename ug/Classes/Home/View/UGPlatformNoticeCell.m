//
//  UGPlatformNoticeCell.m
//  ug
//
//  Created by ug on 2019/5/31.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGPlatformNoticeCell.h"
#import "UGNoticeModel.h"
@interface UGPlatformNoticeCell ()
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end
@implementation UGPlatformNoticeCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setItem:(UGNoticeModel *)item {
    _item = item;
    
    NSString *str = [NSString stringWithFormat:@"<head><style>img{width:%f !important;height:auto}</style></head>%@",self.width,item.content];
    NSAttributedString *__block attStr = [[NSAttributedString alloc] init];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
       attStr =  [[NSAttributedString alloc] initWithData:[str dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.contentLabel.attributedText = attStr;
        });
    });
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

@end
