//
//  SANotificationEvent.m

#import "SANotificationEvent.h"

///
/// 通知事件
///
@interface SANotificationEvent : NSObject

@property (nonatomic, copy)   id name;
@property (nonatomic, strong) id object;

@property (nonatomic, weak)   id observer;
@property (nonatomic, strong) void(^handler)(id, id);

@property (nonatomic, strong) NSNotification* origin;

/// 构造方法
+ (instancetype)notificationWithName:(NSString*)name observer:(id)ob handler:(void(^)(id,id))hander;

@end

@implementation SANotificationEvent

+ (instancetype) notificationWithName:(NSString*)name observer:(id)ob handler:(void(^)(id,id))hander {
    SANotificationEvent* ntf = SANotificationEvent.new;
    ntf.name = name;
    ntf.observer = ob;
    ntf.handler = hander;
    return ntf;
}

+ (void)addObserver:(SANotificationEvent*)obj {
    @synchronized (self.observers) {
        NSMutableArray* arr = self.observers[obj.name] ?: ^{
            id arr = [NSMutableArray arrayWithObject: obj];
            [NSNotificationCenter.defaultCenter addObserver:self
                                                   selector:@selector(notification:)
                                                       name:obj.name
                                                     object:nil];
            [self.observers setObject: arr forKey: obj.name];
            return arr;
        }();
        for (SANotificationEvent* ntf in arr) {
            if (ntf.observer == obj.observer
                && ntf.handler == obj.handler) {
                return;
            }
        }
        [arr addObject: obj];
    }
}
+ (void)removeObserver:(SANotificationEvent*)obj {
    @synchronized (self.observers) {
        NSMutableArray* arr = self.observers[obj.name];
        [arr removeObject: obj];
    }
}
+ (void)removeObserverWithName:(NSString*)name observer:(id)obj {
    @synchronized (self.observers) {
        NSMutableArray* arr = self.observers[name];
        if (obj == nil) {
            [arr removeAllObjects];
            return;
        }
        // clear..
        [arr filterUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(SANotificationEvent* ntf, id _) {
            if (ntf.object == nil) {
                return false;
            }
            if (ntf.object == obj) {
                return false;
            }
            return true;
        }]];
    }
}

+ (void)notification:(NSNotification*)sender {
    @synchronized (self.observers) {
        NSMutableArray* arr = self.observers[sender.name];
        // notification & auto clear
        [arr filterUsingPredicate: [NSPredicate predicateWithBlock:^BOOL(SANotificationEvent* ntf, id _) {
            if (ntf.observer != nil) {
                ntf.origin = sender;
                ntf.handler(ntf.observer, sender.object ?: sender.userInfo);
                return true;
            }
            return false;
        }]];
    }
    
}

+ (NSMutableDictionary*)observers {
    static NSMutableDictionary* _observers = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _observers = NSMutableDictionary.new;
    });
    return _observers;
}

@end

/// 添加监听
void SANotificationEventSubscribe(id name, id self, void (^handler)(typeof(self) self, id obj)) {
    SANotificationEvent* ntf = [SANotificationEvent notificationWithName:name
                                                      observer:self
                                                       handler:handler];
    [SANotificationEvent addObserver: ntf];
 
}

/// 取消监听
void SANotificationEventUnsubscribe(id name, id self) {
    [SANotificationEvent removeObserverWithName:name observer:self];
}

/// 触发通知
void SANotificationEventPost(id name, id obj) {
    [NSNotificationCenter.defaultCenter postNotificationName:name object:obj];
}
