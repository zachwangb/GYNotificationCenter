//
//  GYNotificationOberverIdentifer.h
//  WeRead
//
//  Created by 王斌 on 16/7/4.
//  Copyright © 2016年 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^GYNotificatioObserverBlock)(NSNotification *notification);

@interface GYNotificationOberverIdentifer : NSObject

@property(nonatomic,strong) NSString *name;

- (void)congifureWithName:(NSString *)anName
               withObject:(id)object
        withDispatchQueue:(dispatch_queue_t)dispatchQueue
                withBlock:(GYNotificatioObserverBlock)block;

- (void)stopObserver;

@end


@interface GYNotificationOberverIdentifersContainer : NSObject

- (void)addNotificationOberverIdentifer:(GYNotificationOberverIdentifer *)identifier;

- (void)removeObserverWithName:(NSString *)name;

- (void)removeObserver;
@end