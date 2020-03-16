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

#import "BAKit_ConfigurationDefine.h"
#import "BAKit_WebView.h"
#import "BAKit_WebView_Version.h"
#import "WeakScriptMessageDelegate.h"
#import "WKWebView+BAJavaScriptAlert.h"
#import "WKWebView+BAKit.h"
#import "WKWebView+Post.h"

FOUNDATION_EXPORT double BAWKWebViewVersionNumber;
FOUNDATION_EXPORT const unsigned char BAWKWebViewVersionString[];

