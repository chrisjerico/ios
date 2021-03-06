//
//  MessageUnderMenuView.m
//  UGBWApp
//
//  Created by ug on 2020/6/19.
//  Copyright © 2020 ug. All rights reserved.
//

#import "MessageUnderMenuView.h"


@interface MessageUnderMenuView ()


@end

@implementation MessageUnderMenuView


- (instancetype)MessageUnderMenuView {
    NSBundle *bundle=[NSBundle mainBundle];
    NSArray *objs=[bundle loadNibNamed:@"MessageUnderMenuView" owner:nil options:nil];
    return [objs firstObject];
}


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (!self.subviews.count) {
        MessageUnderMenuView *v = [[MessageUnderMenuView alloc] initView];
        [self addSubview:v];
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

- (instancetype)initView {
   if (self = [super init]) {
        self = [self MessageUnderMenuView];

        FastSubViewCode(self);
       
       subView(@"全部已读面板").layer.cornerRadius = 5;
       subView(@"全部已读面板").layer.masksToBounds = YES;
       
       subView(@"全部删除面板").layer.cornerRadius = 5;
       subView(@"全部删除面板").layer.masksToBounds = YES;
       
       [subView(@"底部面板") setBackgroundColor:RGBA(60, 136, 247, 1)];
     
        WeakSelf;
        [subButton(@"已读btn") addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
            if ([CMCommon stringIsNull:[UGUserModel currentUser].sessid]) {
                return;
            }
            NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid,
                                     };
            [SVProgressHUD showWithStatus:nil];
            [CMNetwork readMsgAllUrlWithParams:params completion:^(CMResult<id> *model, NSError *err) {
                [CMResult processWithResult:model success:^{
                    [SVProgressHUD showSuccessWithStatus:model.msg];
                    //==>通知个人中心刷新站内信
                    SANotificationEventPost(UGNotificationGetUserInfoComplete, nil);
                    if (weakSelf.readedclickBllock) {
                        weakSelf.readedclickBllock();
                    }

                } failure:^(id msg) {
                    [SVProgressHUD showErrorWithStatus:msg];

                }];
            }];

         }];


        [subButton(@"删除btn") addBlockForControlEvents:UIControlEventTouchUpInside block:^(__kindof UIControl *sender) {
            if ([CMCommon stringIsNull:[UGUserModel currentUser].sessid]) {
                return;
            }
            NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid,
                                     };
            [SVProgressHUD showWithStatus:nil];
            [CMNetwork deleteMsgAllWithParams:params completion:^(CMResult<id> *model, NSError *err) {
                [CMResult processWithResult:model success:^{
                    [SVProgressHUD showSuccessWithStatus:model.msg];

                    if (weakSelf.delclickBllock) {
                        weakSelf.delclickBllock();
                    }

                } failure:^(id msg) {
                    [SVProgressHUD showErrorWithStatus:msg];

                }];
            }];

         }];
        
    }
    return self;
}



//- (IBAction)readerAction:(id)sender {
//    if ([CMCommon stringIsNull:[UGUserModel currentUser].sessid]) {
//        return;
//    }
//    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid,
//    };
//    [SVProgressHUD showWithStatus:nil];
//    [CMNetwork readMsgAllUrlWithParams:params completion:^(CMResult<id> *model, NSError *err) {
//        [CMResult processWithResult:model success:^{
//            [SVProgressHUD showSuccessWithStatus:model.msg];
//            
//            if (self.readedclickBllock) {
//                self.readedclickBllock();
//            }
//            
//        } failure:^(id msg) {
//            [SVProgressHUD showErrorWithStatus:msg];
//            
//        }];
//    }];
//                
//}

@end
