//
//  WASBinding.h
//  WASBinding
//
//  Created by allen.wang on 10/17/12.
//  Copyright (c) 2012 b5m. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WASBindingOptions.h"

/**
 *	@brief	  实现在两个对象之间的关键路径上同步操作，模型值改变的时，同时改变控制器或者视图上的值（反之亦然）。
 *            此同步典型地具有在任一关键路径上被反射其他的变化，但也有其它实现方式来达到同样的上的。欲了解更多信息，请参阅WASBindingOptions类。
 *            一旦创建了绑定,值将会同步，直到解除绑定。就像KVO的观察者方法和相应的技术在Mac OS X，绑定不持有任一对象，你必须在对象无效的时候，调用解除绑定。一旦解除绑定，同步将不再有效。
 *            虽然这个类允许你创建一个绑定的编程方式，你通常会通过这个库包含在绑定编辑器创建绑定，并在运行时加载的WASBindingsSet类。有关更多信息，请参见该类的文档。
 */
@interface WASBinding : NSObject

/** 
 设置绑定的对象间，值发生改变时是否记录日志，这有助于调试
 请参阅 - (WASBinding*) setLogging;
 */
@property(nonatomic, getter = isLogging) BOOL logging;

/**
 
 *	@brief	 在给定的同步关键路径上创建一个新的绑定。
 *           一个为“源”对象，另一个为“目标”对象。一旦你创建了一个绑定对象，目标对象的关键路径是源对象的关键路径的当前值覆盖。
 *           通常情况下，将模型对象作为“源”对象，控制器或视图对象作为“目标”对象。
 *           欲了解更多信息，请参阅WASBindingOptions类。
 *  @warn    有两个不同的绑定绑定到相同的关键路径和相同的对象上，会产生不确定的行为。确保不这样做。
 *
 *	@param 	key             观察的路径
 *	@param 	object          源对象
 *	@param 	otherKey        被观察的路径
 *	@param 	otherObject 	目标控件
 *	@param 	options         绑定的规则， 详情请参阅WASBindingOptions
 */
- (id) initWithKeyPath:(NSString*) key 
        ofSourceObject:(id) object 
        boundToKeyPath:(NSString*) otherKey 
        ofTargetObject:(id) otherObject 
               options:(WASBindingOptions*) options;

/**
 *	@brief	 结束此绑定对象的影响。
 *           绑定调用此方法后，将不执行任何进一步的操作，并不会持有任何源和目标对象，它们可以被安全地释放。
 *	     	 此方法可以被多次调用，但和第一次调用一样，不会有任何效果。
 */
- (void) unbind;

/*!
 *	@brief	简单工厂创建方法
 *
 *	@param 	key             观察的路径
 *	@param 	object          源对象
 *	@param 	otherKey        被观察的路径
 *	@param 	otherObject 	目标控件
 *	@param 	options         绑定的规则， 详情请参阅WASBindingOptions
 *
 *	@return	WASBinding 实例
 */+ (id) bindingWithKeyPath:(NSString*) key 
              ofSourceObject:(id) object 
              boundToKeyPath:(NSString*) otherKey
              ofTargetObject:(id) otherObject 
                     options:(WASBindingOptions*) options;


/** 
 
 *	@brief	记录所有观察到的变化。调用此方法是等效的日志记录属性设置为YES。
 *  @return Returns 接受者.
 *	@see logging
 */
- (WASBinding*) setLogging;


@end


/**
 *	@brief	此类别为不支持KVO的UIControl的对象，增加了同步支持。
 *          使用这种方法有局限性：目标对象必须是UIControl的对象;
 *          只对控件对象本身提供了关键路径的控件有效
 */
@interface WASBinding (WASUIControlBindingAdditions)

/*!
 *	@brief	此方法创建一个绑定，当控件的值发生改变时进行同步（即，每一次的控件发送一个UIControlEventValueChanged的的事件）。
            参数的值传递给此方法的更多信息，请参阅initWithKeyPath：ofSourceObject：boundToKeyPath：ofTargetObject：选项。
 *
 *	@param 	key             观察的路径
 *	@param 	object          源对象
 *	@param 	otherKey        被观察的路径
 *	@param 	otherObject 	目标控件
 *	@param 	options         绑定的规则， 详情请参阅WASBindingOptions
 *
 *	@return	WASBinding 实例
 */
- (id)initWithKeyPath:(NSString *)key 
       ofSourceObject:(id)object 
       boundToKeyPath:(NSString *)otherKey 
    ofTargetUIControl:(UIControl*)otherObject 
              options:(WASBindingOptions *)options;

/*!
 *	@brief	简单工厂创建方法
 *          此方法创建一个绑定，当控件的值发生改变时进行同步（即，每一次的控件发送一个UIControlEventValueChanged的的事件）。
 *          参数的值传递给此方法的更多信息，请参阅initWithKeyPath：ofSourceObject：boundToKeyPath：ofTargetObject：选项。
 *
 *	@param 	key             观察的路径
 *	@param 	object          源对象
 *	@param 	otherKey        被观察的路径
 *	@param 	otherObject 	目标控件
 *	@param 	options         绑定的规则， 详情请参阅WASBindingOptions
 *
 *	@return	WASBinding 实例
 */
+ (id)bindingWithKeyPath:(NSString *)key
          ofSourceObject:(id)object
          boundToKeyPath:(NSString *)otherKey
       ofTargetUIControl:(UIControl*)otherObject
                 options:(WASBindingOptions *)options;


@end
