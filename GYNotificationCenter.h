//
//  GYNotificationCenter.h
//  WeRead
//
//  Created by 王斌 on 16/7/4.
//  Copyright © 2016年 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GYNotificationOberverIdentifer.h"

@interface GYNotificationCenter : NSObject

+ (nullable instancetype)defaultCenter;

#pragma mark -- add observer

- (void)addObserver:(nonnull id)observer
              name:(nonnull NSString *)aName
             block:(nonnull GYNotificatioObserverBlock)block;

- (void)addObserver:(nonnull id)observer
              name:(nonnull NSString *)aName
     dispatchQueue:(nullable dispatch_queue_t)disPatchQueue
             block:(nonnull GYNotificatioObserverBlock)block;

- (void)addObserver:(nonnull id)observer
              name:(nonnull NSString *)aName
            object:(nullable id)anObject
             block:(nonnull GYNotificatioObserverBlock)block;

- (void)addObserver:(nonnull id)observer
              name:(nonnull NSString *)aName
            object:(nullable id)anObject
     dispatchQueue:(nullable dispatch_queue_t)disPatchQueue
             block:(nonnull GYNotificatioObserverBlock)block;

#pragma mark -- remove observer

- (void)removerObserver:(nonnull id)observer
                   name:(nonnull NSString *)anName
                 object:(nullable id)anObject;

- (void)removerObserver:(nonnull id)observer;

#pragma mark - post Notification

- (void)postNotification:(NSNotification *)notification;

- (void)postNotificationName:(NSString *)aName object:(nullable id)anObject;

- (void)postNotificationName:(NSString *)aName object:(nullable id)anObject userInfo:(nullable NSDictionary *)aUserInfo;

@end
