//
//  Define_Log.h
//  
//
//  Created by fish on 15/10/16.
//  Copyright © 2015年 fish. All rights reserved.
//

#ifndef Define_Log_h
#define Define_Log_h


//——————————————————————————————————————————
#pragma mark - 打印 Log
//——————————————————————————————————————————

//打印View的Frame
#define _NSLog_Frame_(obj) NSLog(@"%@.frame :x=%.2f, y=%.2f, w=%.2f, h=%.2f", [(obj) class], obj.frame.origin.x, obj.frame.origin.y, obj.frame.size.width, obj.frame.size.height);

//打印View的Bounds
#define _NSLog_Bounds_(obj) NSLog(@"%@.frame :x=%.2f, y=%.2f, w=%.2f, h=%.2f", [(obj) class], obj.bounds.origin.x, obj.bounds.origin.y, obj.bounds.size.width, obj.bounds.size.height);

//打印Rect
#define _NSLog_Rect_(rect) NSLog(@"Rect :x=%.2f, y=%.2f, w=%.2f, h=%.2f", (rect).origin.x, (rect).origin.y, (rect).size.width, (rect).size.height);

//打印Point
#define _NSLog_Point(point) NSLog(@"Point :x=%.2f, y=%.2f", point.x, point.y);

//打印Size
#define _NSLog_Size(size) NSLog(@"Size :w=%.2f, h=%.2f", size.width, size.height);

//打印Subviews
#define _NSLog_Subviews_(obj) NSLog(@"%@.subviews :%@", [(obj) class], (obj).subviews);

//打印transform
#define _NSLog_CGAffineTransform_(obj) NSLog(@"%@.transform :a=%.2f, b=%.2f, c=%.2f, d=%.2f, tx=%.2f, ty=%.2f", [(obj) class], (obj).transform.a, (obj).transform.b, (obj).transform.c, (obj).transform.d, (obj).transform.tx, (obj).transform.ty);


#define _NSLog_Font_(font) NSLog(@"Font : name=%@ (\n\t\
pointSize %.2f, \n\t\
ascender %.2f,  \n\t\
descender %.2f, \n\t\
capHeight %.2f, \n\t\
xHeight %.2f,   \n\t\
lineHeight %.2f,\n\t\
leading %.2f    \n\
)", font.fontName, font.pointSize, font.ascender, font.descender, font.capHeight, font.xHeight, font.lineHeight, font.leading);

//打印Dealloc
#define _NSLog_Dealloc_ NSLog(@"%@   calls dealloc\n", [self class]);



//————————————————————————————
/// Dlog
//#ifdef DEBUG
//#   define DLog(fmt, ...) {NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);}
//#   define ELog(err) {if(err) DLog(@"%@", err)}
//#else
//#   define DLog(...)
//#   define ELog(err)
//#endif


//#ifdef DEBUG
//#define NSLog(s, ...) {NSLog( @"%@",  [NSString stringWithFormat:(s), ##__VA_ARGS__]);}
//#else
//#define NSLog(s, ...) {}
//#endif

//#ifdef DEBUG
//# define NSLog(fmt, ...) NSLog((@" 方法:%s 行号:%d 内容:" fmt),  __FUNCTION__, __LINE__, ##__VA_ARGS__);
//#else
//# define NSLog(...);
//#endif

#endif /* Define_Log_h */
