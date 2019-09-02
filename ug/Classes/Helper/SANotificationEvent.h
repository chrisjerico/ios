//
//  SANotificationEvent.h


#import <Foundation/Foundation.h>


/// 发送通知
void SANotificationEventPost(id name, id obj);
/// 取消监听
void SANotificationEventUnsubscribe(id name, id self);
/// 监听通知
void SANotificationEventSubscribe(id name, id self, void (^handler)(typeof(self) self, id obj));
