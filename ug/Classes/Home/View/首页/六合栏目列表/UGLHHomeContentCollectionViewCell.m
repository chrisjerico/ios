//
//  UGLHHomeContentCollectionViewCell.m
//  ug
//
//  Created by ug on 2019/10/27.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGLHHomeContentCollectionViewCell.h"
#import "FLAnimatedImageView.h"
@interface UGLHHomeContentCollectionViewCell ()

@property (weak, nonatomic) IBOutlet FLAnimatedImageView *imgView;      /**<   图片ImageView */
@property (nonatomic, strong) UIImageView *hasSubSign;          /**<   二级目录ImageView */
@end

@implementation UGLHHomeContentCollectionViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    // 一闪一闪的动画效果
    FastSubViewCode(self);
    __weakSelf_(__self);
    __block NSInteger __i = 0;
    __block NSTimer *__timer = [NSTimer scheduledTimerWithInterval:0.27 repeats:true block:^(NSTimer *timer) {
        __i++;
        subButton(@"hotButton").y += __i%2 ? 2 : -2;
        if (__i > 1000000) {
            __i = 0;
        }
        if (!__self) {
            [__timer invalidate];
            __timer = nil;
        }
    }];
    
    [self addSubview:self.hasSubSign];
    
    [self.hasSubSign mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self.mas_right).with.offset(-15);
    }];
}



- (void)setItem:(GameModel *)item {
    _item = item;

    FastSubViewCode(self);
    NSLog(@"item.name = %@",[CMCommon stringIsNull:item.name] ? item.title : item.name);
    NSLog(@"item.category = %@",item.category);
    NSLog(@"item.subType = %lu",(unsigned long)item.subType.count);
    if ([CMCommon stringIsNull:item.category]   ) {//六合类型
        [subImageView(@"图片ImgV") sd_setImageWithURL:[NSURL URLWithString:item.icon] placeholderImage:[UIImage imageNamed:@"loading"]];
        [subLabel(@"标题Label") setText:item.name];
        [subLabel(@"详细Label") setText:item.desc];

        [item.isHot isEqualToString:@"1"] ? [subButton(@"hotButton") setHidden:NO] : [subButton(@"hotButton") setHidden:YES];
        [self.hasSubSign setHidden: (item.subType.count > 0 ? false : true)];
        NSLog(@"model.name = %@ model.cid = %@,mode= %@",item.name,item.cid,item);
        
        if ([@"l002" containsString:APP.SiteId]) {
            if ([item.cid isEqualToString:@"662"]||[item.cid isEqualToString:@"714"] ) {
                [subButton(@"hotButton") setTitle:@"官方" forState:(UIControlStateNormal)];
            } else {
                [subButton(@"hotButton") setTitle:@"hot" forState:(UIControlStateNormal)];
            }
        }
        
        [subImageView(@"中大奖imgV") setHidden:YES];
        [subImageView(@"热门imgV") setHidden:YES];
        
    } else {//其他类型
        [self.hasSubSign setHidden: (item.subType.count > 0 ? false : true)];
        [subImageView(@"图片ImgV") sd_setImageWithURL:[NSURL URLWithString:item.icon] placeholderImage:[UIImage imageNamed:@"loading"]];
        subLabel(@"标题Label").text =  [CMCommon stringIsNull:item.name] ? item.title : item.name;
        subLabel(@"详细Label").text =  [CMCommon stringIsNull:item.subtitle] ? @"" : item.subtitle;
        [subButton(@"hotButton") setHidden:YES];

        
        [subImageView(@"热门imgV") sd_setImageWithURL:[NSURL URLWithString:item.hotIcon] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (error) {
                subImageView(@"热门imgV").image = [UIImage imageNamed:@"hot"];
            }
        }];
        [subImageView(@"中大奖imgV") sd_setImageWithURL:[NSURL URLWithString:item.hotIcon] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (error) {
                [subImageView(@"中大奖imgV") sd_setImageWithURL:[[NSBundle mainBundle] URLForResource:@"effects" withExtension:@"gif"]];
            }
        }];
        [subImageView(@"中大奖imgV") setHidden:!(item.tipFlag==4)];
        BOOL isGPK = Skin1.isGPK;
        if (item.tipFlag==1 || item.tipFlag==2 ||item.tipFlag==3) {
            if (isGPK) {
                subImageView(@"热门imgV") .hidden = YES;
            } else {
                subImageView(@"热门imgV") .hidden = NO;
            }
        }
        else{
            subImageView(@"热门imgV") .hidden = YES;
        }

    }
   
    
}

- (UIImageView *)hasSubSign {
    if (!_hasSubSign) {
        _hasSubSign = [UIImageView new];
        _hasSubSign.image = [UIImage imageNamed:@"game_has_sub"];
        _hasSubSign.backgroundColor = [UIColor clearColor];
        [_hasSubSign setHidden:YES];
    }
    return _hasSubSign;
}
@end
