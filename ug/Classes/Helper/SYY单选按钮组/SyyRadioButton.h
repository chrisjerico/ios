//
//  SyyRadioButton.h
//  QRadioButtonDemo
//
//  Created by 火炬信息 on 16/9/1.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SyyRadioButtonDelegate;

@interface SyyRadioButton : UIButton{
    NSString                        *_groupId;
    BOOL                            _checked;
  
}

@property(nonatomic, assign)id<SyyRadioButtonDelegate>   delegate;
@property(nonatomic, copy, readonly)NSString            *groupId;
@property(nonatomic, assign)BOOL checked;

- (void)initWithDelegate:(id)delegate groupId:(NSString*)groupId;
- (void)removeFromGroupGroupId :(NSString *)groupId;
-(void)remove;
@end

@protocol SyyRadioButtonDelegate <NSObject>

@optional

- (void)didSelectedRadioButton:(SyyRadioButton *)radio groupId:(NSString *)groupId;

@end