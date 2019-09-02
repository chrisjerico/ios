//
//  SAROPSessionStorage.m
#import "SAROPSessionStorage.h"

#import <sys/sysctl.h>
#import <objc/runtime.h>

#define SAROPSessionStorageSave(key) [self.defaults setObject:[self valueForKey:key] forKey:key]
#define SAROPSessionStorageLoad(key) [self setValue:[self.defaults objectForKey:key] forKey:key]
#define SAROPSessionStorageSynchronize() [self.defaults synchronize]

@interface SAROPSessionStorage () {
    NSArray* _properties;
    NSUserDefaults* _defaults;
    NSMutableDictionary* _userInfo;
}

//@property (nonatomic, strong) NSString* identifier;

@property (nonatomic, assign) NSTimeInterval lastServerTime;
@property (nonatomic, assign) NSTimeInterval lastSystemTime;

@end

@implementation SAROPSessionStorage

time_t SAROPSessionBootTime();

///
/// 使用标识符创建/加载(如果有的话)
///
+ (nonnull instancetype)sessionStorageWithIdentifier:(nonnull NSString*)identifier {
    SAROPSessionStorage* storage = [[self alloc] init];
    [storage reload];
    [storage addObservers];
    storage.identifier = identifier;
    return storage;
}

- (void)dealloc {
    [self removeObservers];
}

#pragma mark -

- (void)addObservers {
    [self.properties enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop) {
        [self addObserver:self forKeyPath:obj options:NSKeyValueObservingOptionNew context:nil];
    }];
}

- (void)removeObservers {
    [self.properties enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop) {
        [self removeObserver:self forKeyPath:obj context:nil];
    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    [self resave];
}

#pragma mark - Storage

/// 保存信息.
- (void)resave {
    @synchronized (self) {
        static CFRunLoopObserverRef _observer = nil;
        if (_observer != nil) {
            return;
        }
        CFRunLoopRef runLoop = CFRunLoopGetMain();
        CFStringRef runLoopMode = kCFRunLoopCommonModes;
        // 添加到空等待.
        _observer = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, kCFRunLoopBeforeWaiting, false, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
            @synchronized (self) {
                CFRunLoopRemoveObserver(runLoop, observer, runLoopMode);
                [self update];
                _observer = nil;
            }
        });
        CFRunLoopAddObserver(runLoop, _observer, runLoopMode);
    }
}

/// 加载信息
- (void)reload {
    @synchronized (self) {
        [self.properties enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop) {
            id value = [self.defaults objectForKey:obj];
            [self setValue:value forKey:obj];
            //NSLog(@"reload key = %@ , value= %@",obj,value);
        }];
        // 加载userInfo
        self->_userInfo = [[self.defaults objectForKey:@"self->_userInfo"] mutableCopy];
    }
    NSLog(@"%s", __func__);
}

/// 更新数据
- (void)update {
    @synchronized (self) {
        [self.properties enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop) {
            id value = [self valueForKey:obj];
            [self.defaults setObject:value forKey:obj];
            //NSLog(@"update key = %@ , value= %@",obj,value);
        }];
        // 保存userInfo
        [self.defaults setObject:self->_userInfo forKey:@"self->_userInfo"];
        [self.defaults synchronize];
    }
    NSLog(@"%s", __func__);
}

#pragma mark - Setter

- (void)setSessionTimestamp:(NSString *)sessionTimestamp {
    // 更新时间
    self.lastSystemTime = SAROPSessionBootTime();
    self.lastServerTime = sessionTimestamp.doubleValue;
}

- (void)setNilValueForKey:(NSString *)key {
    [self setValue:@0 forKey:key];
    //    if ([key isEqualToString:@"_lastServerTime"]) {
    //        self->_lastServerTime = 0;
    //        return;
    //    }
    //    if ([key isEqualToString:@"_lastSystemTime"]) {
    //        self->_lastSystemTime = 0;
    //        return;
    //    }
    //    [super setNilValueForKey:key];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if (_userInfo == nil) {
        _userInfo = [NSMutableDictionary dictionary];
    }
    if (value == nil) {
        [_userInfo removeObjectForKey:key];
    } else {
        [_userInfo setObject:value forKey:key];
    }
    [self resave];
}

- (id)valueForUndefinedKey:(NSString *)key {
    return _userInfo[key];
}

#pragma mark - Getter

- (NSUserDefaults*)defaults {
    if (_defaults == nil) {
        NSString* name = [NSString stringWithFormat:@"%@.rop.sa", self.identifier];
        _defaults = [[NSUserDefaults alloc] initWithSuiteName:name];
    }
    return _defaults;
}

- (NSString*)sessionTimestamp {
    // 如果需要读取..
    NSTimeInterval ost = _lastServerTime;
    NSTimeInterval obt = _lastSystemTime;
    NSTimeInterval nbt = SAROPSessionBootTime();
    NSTimeInterval nst = ost + (nbt - obt) * 1000;
    
    if (ost == 0 || obt == 0) {
        nst = NSDate.date.timeIntervalSince1970;
    }
    
    //NSLog(@"%s ost: %.0lf, nst: %.0lf, obt: %.0lf, nbt: %.0lf", __func__, ost, nst, obt, nbt);
    
    return [NSString stringWithFormat:@"%.0lf", nst];
}

#pragma mark -

- (NSArray*)properties {
    if (_properties == nil) {
        _properties = self.class.__properties;
    }
    return _properties;
}

+ (NSArray*)__properties {
    unsigned int count = 0;
    objc_property_t* ps = class_copyPropertyList(self, &count);
    NSMutableArray* properties = [NSMutableArray arrayWithCapacity:count];
    if (self.superclass != nil && self.superclass != NSObject.class) {
        [properties addObjectsFromArray:self.superclass.__properties];
    }
    for (NSInteger i = 0; i < count; ++i) {
        objc_property_t p = *(ps + i);
        const char* name = property_getName(p);
        if (name == nil) {
            continue;
        }
        [properties addObject:@(name)];
    }
    free(ps);
    return properties;
}

@end

///
/// 获取启动时间
///
time_t SAROPSessionBootTime() {
    int mib[2] = { CTL_KERN, KERN_BOOTTIME };
    struct timeval boottime = {};
    size_t size = sizeof(boottime);
    if (sysctl(mib, 2, &boottime, &size, NULL, 0) != -1 && boottime.tv_sec != 0) {
        return time(nil) - boottime.tv_sec;
    }
    return -1;
}
