//
//  GYNotificationOberverIdentifer.m
//  WeRead
//
//  Created by 王斌 on 16/7/4.
//  Copyright © 2016年 tencent. All rights reserved.
//

#import "GYNotificationOberverIdentifer.h"
#import <pthread.h>

@interface GYNotificationOberverIdentifer()

@property(nonatomic,strong) NSNotificationCenter *notificationCenterCenter;
@property(nonatomic,strong) dispatch_queue_t dispatchQueue;
@property(nonatomic,copy) GYNotificatioObserverBlock block;
@property(nonatomic,weak) id object;

@end

@implementation GYNotificationOberverIdentifer

- (instancetype)init {
    
    if (self = [super init]) {
    }
    return self;
    
}

- (void)congifureWithName:(NSString *)anName
               withObject:(id)object
        withDispatchQueue:(dispatch_queue_t)dispatchQueue
                withBlock:(GYNotificatioObserverBlock)block {
    
    NSAssert(anName,@"name is nil");
    NSAssert(block,@"block is nil");
    
    [self clearAll];
    _name = anName;
    _dispatchQueue = dispatchQueue;
    _block = block;
    _object = object;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:anName object:object];
    
}

- (void)dealloc {
    
    [self stopObserver];
    
}

- (void)handleNotification:(NSNotification *)notification {
    
    if (self.dispatchQueue) {
        if ([NSThread isMainThread] && self.dispatchQueue == dispatch_get_main_queue()) {
            
           self.block(notification);
            
        } else {
            dispatch_async(self.dispatchQueue, ^{
                if (self.block) {
                    self.block(notification);
                }
            });
        }
    } else {
        self.block(notification);
    }
    
}

- (void)stopObserver {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:_name object:_object];
    [self clearAll];
    
}

- (void)clearAll {
    
    _block = nil;
    _object = nil;
    _dispatchQueue = nil;
    
}
@end

@interface GYNotificationOberverIdentifersContainer()

@property(nonatomic,strong) NSMutableDictionary *notificationOberverIdentifersDic;

@end

@implementation GYNotificationOberverIdentifersContainer

- (void)addNotificationOberverIdentifer:(GYNotificationOberverIdentifer *)identifier {
    
    NSAssert(identifier,@"identifier is nil");
    if (identifier) {
        NotificationPerformLocked(^{
            [self modifyContainer:^(NSMutableDictionary *notificationOberverIdentifersDic) {
                //不重复add observer
                if (![notificationOberverIdentifersDic objectForKey:identifier.name]) {
                    [notificationOberverIdentifersDic setObject:identifier forKey:identifier.name];
                }
            }];
        });
    }
    
}

- (void)removeObserverWithName:(NSString *)name {
    
    if (name) {
        NotificationPerformLocked(^{
            [self modifyContainer:^(NSMutableDictionary *notificationOberverIdentifersDic) {
                
                if ([notificationOberverIdentifersDic objectForKey:name]) {
                    GYNotificationOberverIdentifer *identifier = (GYNotificationOberverIdentifer *)[notificationOberverIdentifersDic objectForKey:name];
                    [identifier stopObserver];
                    [notificationOberverIdentifersDic removeObjectForKey:name];
                }
            }];

        });
    }
}

- (void)removeObserver {
    
    NotificationPerformLocked(^{
        [self modifyContainer:^(NSMutableDictionary *notificationOberverIdentifersDic) {
            
            for (NSString *key in notificationOberverIdentifersDic ) {
                GYNotificationOberverIdentifer *identifier = (GYNotificationOberverIdentifer *)[notificationOberverIdentifersDic objectForKey:key];
                [identifier stopObserver];
            }
            
            [notificationOberverIdentifersDic removeAllObjects];
        }];
    });
}

- (void)modifyContainer:(void (^)(NSMutableDictionary *notificationOberverIdentifersDic)) block {
    
    if (!self.notificationOberverIdentifersDic) {
        self.notificationOberverIdentifersDic = [[NSMutableDictionary alloc] init];
    }
    block(self.notificationOberverIdentifersDic);
}

#pragma mark -- helper

static void NotificationPerformLocked(dispatch_block_t block) {
    
    static pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
    pthread_mutex_lock(&mutex);
    block();
    pthread_mutex_unlock(&mutex);
}

@end
