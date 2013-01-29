//
//  WASBindingOptions.h
//  WASBinding
//
//  Created by allen.wang on 10/17/12.
//  Copyright (c) 2012 b5m. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
    此枚举允许你为绑定选择一种并发模式，并发模式决定了在多线程时的绑定行为。
 */
typedef enum {
    /**
     如果设置这种并发模式，在允许的线程将被传播变化将不会有任何限制（调度或锁定），但在允许的线程以外的其他线程上的变化会导致一个异常被抛出。
     这是默认的并发模型。
     - [WASBindingOptions allowedThread]属性可以设置允许的线程，如果没有设置，主线程是默认的。
     */
    kWASBindingConcurrencyAllowedThread = 0,
    
    /** 
     如果这种并发模式设置，绑定将更改传播只能通过所提供的调度队列调度块。同时发生的变化被派遣在此队列，并且没有顺序保证。
     块是异步调度。
     默认调度队列是主队列。需要注意的是和主队列调度是相似，但不完全相同，使用与主线程的线程策略。使用队列时，变化将异步传播，即使仍然在主线程中。     
     */
    kWASBindingConcurrencyDispatchOnQueue,
} WASBindingConcurrencyModel;

/**
 此枚举决定了目标和源之间的传递方向
 */
typedef enum {
    /** 
     对于绑定在源上的key值变化，会引起目标上的key值变化，反之亦然。
     这是缺省的值。
     */
    kWASBindingDirectionBoth = 0,
    
    /** 
     对于绑定在源上的key值变化，会引起目标上的key值变化，反之不成立。
     */
    kWASBindingDirectionSourceToTargetOnly,
} WASBindingDirection;


/**
    这个类的实例代表具有约束力的（一个WASBinding的实例）的选项。您可以创建一个的init（）方法（或+ optionsWithDefaultValues​​方便的方法），然后进行自定义。
    注意，这个类的属性，无论你的设置，它会尝试其成员保持一致。例如，设置允许的线程则自动设置并发模型为kWASBindingConcurrencyAllowedThread，反之亦然，设置其它的并发模式，则指allowedThread属性被设置为NULL。
    实例是可复制的。所有副本，不论是复制或mutableCopy，是可变的。
 */
@interface WASBindingOptions : NSObject<NSCopying, NSMutableCopying>

/** 简单工厂方法 for -init. */
+ optionsWithDefaultValues;

/** 
    使用缺省值来创建绑定选项
 */
- (id)init;

/** 
 为绑定设置并发模型。它指定的绑定行为，在被观察的路径面对并发访问时。
 欲了解更多信息，请参阅文档的WASBindingConcurrencyModel类型。
 
 */
@property(nonatomic) WASBindingConcurrencyModel concurrencyModel;

/** 
 如果并发模式设置为kWASBindingConcurrencyAllowedThread，那么这个属性表明了观察的键的源和目标对象奖在这个线程一执行。
 默认线程是主线程。
 如果有任何其他的并发模式设置，此属性将被设置为NULL。
 */
@property(nonatomic, retain) NSThread* allowedThread;

/**
 如果并发模式设置为kWASBindingConcurrencyDispatchOnQueue，那么这个属性表明了观察的键的源和目标对象奖在这个队列上异步的执行。
 默认线程是主队列。
 如果有任何其他的并发模式设置，此属性将被设置为NULL。
 设置此属性会正确地保留和释放的队列。
 */
@property(nonatomic) dispatch_queue_t dispatchQueue;

/** 
 设置绑定方向。这个方向指定数据的传递方向，当有变化发生的时候。
 欲了解更多信息，请参阅文档的WASBindingDirection类型。*/
@property(nonatomic) WASBindingDirection direction;

/** 
 绑定的值传递器。
 该值传递器将来自源对象产生的变化，转换到目标对象的上，如果支持反向转换，则也会反向转换。
 如果传递器不支持反向转换，将自动设置的方向kWASBindingDirectionSourceToTargetOnly。
 
 */
@property(nonatomic, retain) NSValueTransformer* valueTransformer;
@end
