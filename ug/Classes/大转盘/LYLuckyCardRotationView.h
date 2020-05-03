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
@property (nonatomic, strong) NSString *DZPid;   /**id*/

- (void)beignRotaion;

@end
