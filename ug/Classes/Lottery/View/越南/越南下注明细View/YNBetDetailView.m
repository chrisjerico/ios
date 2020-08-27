//
//  YNBetDetailView.m
//  UGBWApp
//
//  Created by ug on 2020/8/24.
//  Copyright © 2020 ug. All rights reserved.
//

#import "YNBetDetailView.h"
#import "CountDown.h"
#import "Global.h"

@interface YNBetDetailView (){
    
    NSInteger count;  /**<   总注数*/
    UIScrollView* maskView;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) CountDown *countDown;
@property (nonatomic, strong) NSMutableArray <UGBetModel *> *betArray;

@property (weak, nonatomic) IBOutlet UILabel *BatchNumberLabel;   /**<   批号*/
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;        /**<  组合数*/
@property (weak, nonatomic) IBOutlet UITextField *multipleTF;     /**<  倍数*/
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel; /**<   总金额Label */



@end



@implementation YNBetDetailView



@end
