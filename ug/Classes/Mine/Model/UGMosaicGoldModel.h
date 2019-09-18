//
//  UGMosaicGoldModel.h
//  ug
//
//  Created by ug on 2019/9/18.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol UGMosaicGoldParamModel <NSObject>

@end
@interface UGMosaicGoldParamModel : UGModel<UGMosaicGoldParamModel>
@property (nonatomic, strong) NSString *win_apply_image;//图片
@property (nonatomic, strong) NSString *win_apply_content;// 内容
@property (nonatomic, assign) BOOL showWinAmount;//决定数字是否显示
@property (nonatomic, strong) NSString *quickAmount1;//
@property (nonatomic, strong) NSString *quickAmount2;//
@property (nonatomic, strong) NSString *quickAmount3;//
@property (nonatomic, strong) NSString *quickAmount4;//
@property (nonatomic, strong) NSString *quickAmount5;//
@property (nonatomic, strong) NSString *quickAmount6;//
@property (nonatomic, strong) NSString *quickAmount7;//
@property (nonatomic, strong) NSString *quickAmount8;//
@property (nonatomic, strong) NSString *quickAmount9;//
@property (nonatomic, strong) NSString *quickAmount10;//
@property (nonatomic, strong) NSString *quickAmount11;//
@property (nonatomic, strong) NSString *quickAmount12;//
@end


@protocol UGMosaicGoldModel <NSObject>

@end
@interface UGMosaicGoldModel : UGModel<UGMosaicGoldModel>
@property (nonatomic, strong) NSString *mid;//id
@property (nonatomic, strong) NSString *name;//标题
@property (nonatomic, strong) UGMosaicGoldParamModel *param;//
@end

NS_ASSUME_NONNULL_END
