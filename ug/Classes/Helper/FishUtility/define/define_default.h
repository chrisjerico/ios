//
//  define_default.h
//  FishUtility
//
//  Created by fish on 16/8/1.
//  Copyright © 2016年 fish. All rights reserved.
//

#ifndef define_default_h
#define define_default_h


//设备高宽
//#define kScreenWidth        ([UIScreen mainScreen].bounds.size.width)
//#define kScreenHeight       ([UIScreen mainScreen].bounds.size.height)


//以iPhone6屏幕（4.7寸）作为参照，输入在iPhone6的宽高，计算出在当前屏幕的宽高
#define _CalHeight(H_in_iphone6H) ((H_in_iphone6H)/667.0 * [UIScreen mainScreen].bounds.size.height)
#define _CalWidth(W_in_iphone6W) ((W_in_iphone6W)/375.0 * [UIScreen mainScreen].bounds.size.width)


//————————————————————————————
// 加载 Nib
//#define _LoadVC_from_storyboard_(vcId) ([[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:(vcId)])
//#define _LoadView_from_nib_(nibName) ([[NSBundle mainBundle] loadNibNamed:(nibName) owner:nil options:nil][0])


//————————————————————————————
// About __block
#define __weakSelf_(__self) __weak typeof(self) __self = self
#define __blockSelf_(__self) __block typeof(self) __self = self
#define __weak_Obj_(obj, name) __weak typeof(obj) name = obj
#define __block_Obj_(obj, name) __block typeof(obj) name = obj
#define __block_ElementaryDataType(variable, name) __block typeof(variable) *name = &variable



#endif /* define_default_h */
