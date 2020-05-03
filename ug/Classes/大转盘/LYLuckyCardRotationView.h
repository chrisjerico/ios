//
//  LYLuckyCardRotationView.h
//  LYLuckyCardDemo
//
//  Created by leo on 17/2/9.
//  Copyright © 2017年 leo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DZPModel.h"
@interface LYLuckyCardRotationView : UIView
@property (nonatomic, strong) NSArray<DZPprizeModel*> *dataArray;

@property (weak, nonatomic) IBOutlet UIView *canRotationView;//可旋转的图
@property (nonatomic, strong) CABasicAnimation *animationPart1;
- (void)beignRotaion;

@end
