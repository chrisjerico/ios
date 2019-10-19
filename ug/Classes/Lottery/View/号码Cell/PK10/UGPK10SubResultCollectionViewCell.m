//
//  UGPK10SubResultCollectionViewCell.m
//  ug
//
//  Created by ug on 2019/6/17.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGPK10SubResultCollectionViewCell.h"
@interface UGPK10SubResultCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *imgArray;
@property (nonatomic, strong) NSArray *resultArray;
@end
@implementation UGPK10SubResultCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.layer.cornerRadius = 3;
    self.layer.masksToBounds = YES;
    self.layer.borderColor = [[UGSkinManagers shareInstance] setNavbgColor].CGColor;
    self.layer.borderWidth = 0.8;
    self.titleArray = @[@"庄家",@"闲一",@"闲二",@"闲三",@"闲四",@"闲五"];
    self.imgArray = @[@"wn",@"n1",@"n2",@"n3",@"n4",@"n5",@"n6",@"n7",@"n8",@"n9",@"nn"];
    self.resultArray = @[@"没牛",@"牛1",@"牛2",@"牛3",@"牛4",@"牛5",@"牛6",@"牛7",@"牛8",@"牛9",@"牛牛"];
}

- (CALayer *)layer {
    return _bgView.layer;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    _bgView.backgroundColor = backgroundColor;
}

- (void)setResult:(NSString *)result {
    _result = result;
    self.titleLabel.text = self.titleArray[self.tag];
    NSInteger index = [self.resultArray indexOfObject:result];
    self.imgView.image = [UIImage imageNamed:self.imgArray[index]];
}

- (void)setWin:(BOOL)win {
    _win = win;
    if (win) {
        self.backgroundColor = [UIColor yellowColor];
    }else {
        self.backgroundColor = [UIColor whiteColor];
    }
}
@end
