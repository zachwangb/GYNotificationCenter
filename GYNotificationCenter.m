//
//  GYNotificationCenter.m
//  WeRead
//
//  Created by 王斌 on 16/7/4.
//  Copyright © 2016年 tencent. All rights reserved.
//

#import "GYNotificationCenter.h"
#import <pthread.h>
#import <objc/runtime.h>

#define GY_NOTIFICATION_CONTAINER_KEY @"gyNotificationContainerKey"

@implementation GYNotificationCenter

+ (instancetype)defaultCenter {
    
    static GYNotificationCenter *defaultCenter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultCenter = [[GYNotificationCenter alloc] init];
    });
    return defaultCenter;
    
}

#pragma mark -- add observer

- (void)addObserver:(nonnull id)observer
               name:(nonnull NSString *)aName
              block:(nonnull GYNotificatioObserverBlock)block {
    
    [self addObserver:observer name:aName object:nil dispatchQueue:nil block:block];
    
}

- (void)addObserver:(nonnull id)observer
               name:(nonnull NSString *)aName
      dispatchQueue:(nullable dispatch_queue_t)disPatchQueue
              block:(nonnull GYNotificatioObserverBlock)block {
    
    [self addObserver:observer name:aName object:nil dispatchQueue:disPatchQueue block:block];
    
}

- (void)addObserver:(nonnull id)observer
               name:(nonnull NSString *)aName
             object:(nullable id)anObject
              block:(nonnull GYNotificatioObserverBlock)block {
    
    [self addObserver:observer name:aName object:anObject dispatchQueue:nil block:block];
    
}

- (void)addObserver:(nonnull id)observer
               name:(nonnull NSString *)aName
             object:(nullable id)anObject
      dispatchQueue:(nullable dispatch_queue_t)disPatchQueue
              block:(nonnull GYNotificatioObserverBlock)block {
    
    [self addWithContainerBlock:^(GYNotificationOberverIdentifersContainer *container) {
        
        GYNotificationOberverIdentifer *identifier = [[GYNotificationOberverIdentifer alloc] init];
        [identifier congifureWithName:aName withObject:anObject withDispatchQueue:disPatchQueue withBlock:block];
        
        [container addNotificationOberverIdentifer:identifier];
        
    } toObserver:observer];
}

- (void)addWithContainerBlock:(void (^)(GYNotificationOberverIdentifersContainer *container)) block
                   toObserver:(id)observer {
    
    NotificationPerformLocked(^{
        
        //get container
        GYNotificationOberverIdentifersContainer *notificationOberverIdentifersContainer = (GYNotificationOberverIdentifersContainer *)objc_getAssociatedObject(observer, GY_NOTIFICATION_CONTAINER_KEY);
        
        //add to container
        if (!notificationOberverIdentifersContainer) {
            notificationOberverIdentifersContainer = [[GYNotificationOberverIdentifersContainer alloc] init];
            objc_setAssociatedObject(observer, GY_NOTIFICATION_CONTAINER_KEY, notificationOberverIdentifersContainer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        
        block(notificationOberverIdentifersContainer);
    });
}


#pragma mark -- remove observer

- (void)removerObserver:(nonnull id)observer
                   name:(nonnull NSString *)anName
                 object:(nullable id)anObject {
    
    NotificationPerformLocked(^{
        
        //get container
        GYNotificationOberverIdentifersContainer *notificationOberverIdentifersContainer = (GYNotificationOberverIdentifersContainer *)objc_getAssociatedObject(observer, GY_NOTIFICATION_CONTAINER_KEY);
        
        //add to container
        if (notificationOberverIdentifersContainer) {
            [notificationOberverIdentifersContainer removeObserverWithName:anName];
        }
    });
}

- (void)removerObserver:(nonnull id)observer {
    
    NotificationPerformLocked(^{
        
        //get container
        GYNotificationOberverIdentifersContainer *notificationOberverIdentifersContainer = (GYNotificationOberverIdentifersContainer *)objc_getAssociatedObject(observer, GY_NOTIFICATION_CONTAINER_KEY);
        
        //add to container
        if (notificationOberverIdentifersContainer) {
            [notificationOberverIdentifersContainer removeObserver];
        }
    });
}

#pragma mark - post Notification

- (void)postNotification:(NSNotification *)notification {
    
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (void)postNotificationName:(NSString *)aName object:(nullable id)anObject {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:aName object:anObject];
    
}

- (void)postNotificationName:(NSString *)aName object:(nullable id)anObject userInfo:(nullable NSDictionary *)aUserInfo {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:aName object:anObject userInfo:aUserInfo];
    
}

#pragma mark -- helper

static void NotificationPerformLocked(dispatch_block_t block) {
    static pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
    pthread_mutex_lock(&mutex);
    block();
    pthread_mutex_unlock(&mutex);
}
@end
