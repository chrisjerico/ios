//
//  UGinviteLisModel.h
//  ug
//
//  Created by ug on 2019/9/8.
//  Copyright © 2019 ug. All rights reserved.
// "uid": "4923",
//"level": 2,
//"username": "ceshi3",
//"name": "噶啥的",
//"coin": "0.00",
//"enable": "正常",
//"accessTime": "2019-09-05",
//"regtime": "2019-08-22",
//"sunyi": 999.32,
//"is_setting": "1"

#import "UGModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGinviteLisModel : UGModel
@property (nonatomic, strong) NSString *uid;//
@property (nonatomic, strong) NSString *level;//
@property (nonatomic, strong) NSString *username;//
@property (nonatomic, strong) NSString *name;//
@property (nonatomic, strong) NSString *coin;//
@property (nonatomic, strong) NSString *enable;//
@property (nonatomic, strong) NSString *accessTime;//登陆时间
@property (nonatomic, strong) NSString *regtime;//
@property (nonatomic, strong) NSString *sunyi;//
@property (nonatomic, strong) NSString *is_setting;//技术-后端-parker:1是开启0是关闭充值功能
@end

NS_ASSUME_NONNULL_END
