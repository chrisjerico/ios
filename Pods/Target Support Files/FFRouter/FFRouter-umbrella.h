#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "FFRouter.h"
#import "FFRouterLogger.h"
#import "FFRouterNavigation.h"
#import "FFRouterRewrite.h"

FOUNDATION_EXPORT double FFRouterVersionNumber;
FOUNDATION_EXPORT const unsigned char FFRouterVersionString[];

