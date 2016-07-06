#GYNotificationCenter

GYNotificationCenter is a warpper for NSNotificationCenter, it provides a easier way to use NSNotificationCenter. 

##What's wrong with NSNotificationCenter

Normally , how to use NSNotificationCenter ?

first register it

```
- (void)addObserver:(id)notificationObserver
           selector:(SEL)notificationSelector
               name:(NSString *)notificationName
             object:(id)notificationSender
```

Remove it explicitly when it is unused.

```
- (void)removeObserver:(id)notificationObserver
```
##Problems

 1. you should explicitly remove the observer when unused
 2. it only supply a selector , not a block
 3. the thread which the notification delivered is not sure

Apple gives a alternate way to solve 2 - 3.

```
- (id<NSObject>)addObserverForName:(NSString *)name
                            object:(id)obj
                             queue:(NSOperationQueue *)queue
                        usingBlock:(void (^)(NSNotification *note))block
```
In order to remove it , you have to keep a property .

## GYNotificationCenter

###Usage
Similar to the Apple API
```
- (void)addObserver:(nonnull id)observer
              name:(nonnull NSString *)aName
     dispatchQueue:(nullable dispatch_queue_t)disPatchQueue
             block:(nonnull GYNotificatioObserverBlock)block;
```
But you never have to explicitly remove it when you want to remove it in the dealloc , it will be automatically removed when the observer is dealloc .

Besides , you can also explicitly remove it in case you want unregister except for dealloc.

```
- (void)removerObserver:(nullable id)observer
                   name:(nullable NSString *)anName
                 object:(nullable id)anObject;

- (void)removerObserver:(nullable id)observer;
```
You can remove a observer with a selector name , or even remove all registers in a observer.

