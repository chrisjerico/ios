
//  FishUtility.h
//  FishUtility
//
//  Created by fish on 16/8/3.
//  Copyright © 2016年 fish. All rights reserved.
//

#ifndef FishUtility_h
#define FishUtility_h

#ifdef __OBJC__

    #ifdef DEBUG
        #import "define_log.h"
        #import "UIViewController+Log.h"
    #endif

    // 第三方库
    #import "JRSwizzle.h"               // 方法交换
    #import "Aspects.h"                 // 方法交换
    #import "UIImageView+WebCache.h"    // SDWebImage
    #import "UIButton+WebCache.h"       // SDWebImage
    #import "SDImageCache.h"            // SDWebImage
    #import "SDAnimatedImageView.h"     // SDWebImage
    #import "UIImage+Metadata.h"        // SDWebImage
    #import "MJExtension.h"             // 字典转模型
    #import "DateTools.h"               // 日期
    #import "Masonry.h"                 // 约束
    #import "SVProgressHUD.h"           // 提示
    #import "YYCategories.h"            // 常用类别
    #import "NSObject+XWAdd.h"          // KVO, NotificationCenter
    #import "MJRefresh.h"               // 上下拉刷新
    #import "UIScrollView+Refresh.h"

    // Utils
    #import "UIView+Utils.h"
    #import "UIView+TagString.h"
    #import "NSString+Utils.h"
    #import "NSTimer+Block.h"
    #import "NSUserDefaults+Utils.h"
    #import "NSObject+Utils.h"
    #import "UIImage+Utils.h"
    #import "UIColor+Utils.h"
    #import "UIAlertController+Utils.h"
    #import "UIGestureRecognizer+Utils.h"
    #import "UICollectionViewCell+Utils.h"
    #import "NSMutableAttributedString+Utils.h"
    #import "NSArray+Utils.h"
    #import "UIResponder+EventRouter.h"
    #import "category.h"
    #import "LoadingStateView.h"

    // HUD
    #import "HUDHelper.h"
    #import "AlertHelper.h"
    
    // Define
    #import "AppDefine.h"

    // Network
    #import "CCNetworkRequests1.h"
    #import "CCNetworkRequests1+UGLiuHe.h"
    #import "CCNetworkRequests1+UG.h"

    // LogVC
    #import "LogVC.h"

    // Other
    #import "define_default.h"
    #import "NSNull+Safe.h"
    #import "NSDictionary+NilSafe.h"
    #import "UIView+Frame.h"
    #import "NSDate+Millisecond.h"

#import "NSObject+AspectsHelper.h"

#endif

#endif /* FishUtility_h */
