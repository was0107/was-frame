//
//  WASBindingsSet.h
//  WASBinding
//
//  Created by allen.wang on 10/29/12.
//  Copyright (c) 2012 b5m. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WASBinding.h"

/*!
 *	@brief	绑定的集合类
 */
@interface WASBindingsSet : NSObject
/*!
 *	@brief	从配置文件中返回一个绑定集合，文件是束中进行读取。
 *  @param name 资源文件的名称. 不需要指定文件的扩展名.
 *  @param owner 指定源和绑定目标的所有者.
 */
+ bindingsSetNamed:(NSString*) name owner:(id) owner;

/**
 *	@brief	 通过绑定标识返回一个绑定对象
 */
- (WASBinding*) bindingForKey:(NSString*) identifier;

/**
 *	@brief	 停止所有绑定操作，此函数会调用WASBinding的取消绑定操作
 */
- (void) unbind;

/*!
 *	@brief	简单工厂创建方法。
            从资源文件中读取配置信息
 *
 *	@param 	name        资源文件名称
 *	@param 	bundle      束名称
 *	@param 	source      原对象
 *	@param 	target      目标控件
 *	@return	self
 */
+ (id) bindingsSetNamed:(NSString*) name bundle:(NSBundle*) bundle sourceObject:(id) source targetObject:(id) target;

/*!
 *	@brief	从资源文件中读取配置信息
 *
 *	@param 	resource    资源文件名称
 *	@param 	extension   资源文件的扩展名
 *	@param 	bundle      束名称
 *	@param 	source      原对象
 *	@param 	target      目标控件
 *	@param 	error       返回读取错误，或者不符合绑定规则时，返回对应的错误信息
 *	@return	self
 */
- (id) initWithResourceNamed:(NSString*) resource withExtension:(NSString*) extension owner:(id) owner error:(NSError**) error;
- (id) initWithResourceNamed:(NSString*) resource withExtension:(NSString*) extension bundle:(NSBundle*) bundle sourceObject:(id) source targetObject:(id) target error:(NSError**) error;

@end
