//
//  HelpDocModel.h
//  UGBWApp
//
//  Created by fish on 2020/10/6.
//  Copyright © 2020 ug. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HelpDocModel : NSObject
@property (nonatomic, strong) NSString *btnTitle;   /**<   按钮标题 */
@property (nonatomic, strong) NSString *webName;     /**<   html 文件标题*/

-(instancetype)initWithBtnTitle:(NSString *)title WebName:(NSString *)webName;
@end

NS_ASSUME_NONNULL_END
