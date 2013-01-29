//
//  WASBingDefinition.h
//  WASBinding
//
//  Created by allen.wang on 10/29/12.
//  Copyright (c) 2012 b5m. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WASBinding.h"
#import "WASBindingOptions.h"


typedef enum {
    kWASBindingLoadingAllowIncompletePropertyList  = 1 <<0,
}WASBindingLoadingOptions;


@interface WASBindingDefinition : NSObject<NSCopying, NSMutableCopying>

/*!
 *	@brief	从配置文件中创建绑定定义类，创建成功，则返回本类的实例对象，否则返回nil，并且返回错误信息
 *
 *	@return	本类的实例对象
 */
- (id) initWithPropertyListRepresentation:(id) plist options:(WASBindingLoadingOptions) options error:(NSError**) error;

/*!
 *	@brief	从绑定的定义中创建绑定对象
 *
 *	@return	绑定的对象
 */
- (WASBinding*) bindingWithOwner:(id) owner options:(WASBindingOptions*) opts;

/*!
 *	@brief	从绑定的定义中创建绑定对象
 *
 *	@return	绑定的对象
 */
- (WASBinding*) bindingWithSourceObject:(id) source targetObject:(id) target options:(WASBindingOptions*) opts;

/*!
 *	@brief	绑定的属性列表的描述。
 */
@property(readonly, nonatomic) id propertyListRepresentation;

/*!
 *	@brief	绑定对象所对应的键
 */
@property(readonly, copy, nonatomic) NSString* key;

@end


/*!
 *	@brief	定义绑定对象时，发生的错误所在的域
 */
#define kWASBindingDefinitionErrorDomain @"net.infinite-labs.WASBinding.Definition"

/*!
 *	@brief	在kWASBindingDefinitionErrorDomain中的错误代码。
 */
enum WASBindingDefinitionErrors {
    kWASBindingDefinitionErrorInvalidPropertyList = 1, /**< 属性列表无效，或者不是WASBingDefinition期待的值 */
    kWASBindingDefinitionErrorMissingEntry, /**< 缺失一个实体，对应的键是kWASBindingDefinitionErrorSourceKey */
    kWASBindingDefinitionErrorInvalidEntry, /**< 无效的实体，对应的键是kWASBindingDefinitionErrorSourceKey，对应的值是kWASBindingDefinitionErrorSourceValue */
    kWASBindingDefinitionErrorDuplicateKey /**< 重复的实体。 */

};

/*!
 *	@brief	错误的用户信息中，对应kWASBindingDefinitionErrorDomain中的键
 */
#define kWASBindingDefinitionErrorSourceKey @"WASBindingDefinitionErrorSourceKey"
/*!
 *	@brief	错误的用户信息中，对应kWASBindingDefinitionErrorDomain中的值
 */
#define kWASBindingDefinitionErrorSourceValue @"WASBindingDefinitionErrorSourceValue"

/*!
 *	@brief	可编辑的绑定定义，继承于不可编辑的定义
 */
@interface WASMutableBindingDefinition : WASBindingDefinition

/*!
 *	@brief	静态方法，返回所有被观察的键
 *
 *	@return	集合
 */
+ (NSSet*) allObservableKeys;

/*!
 *	@brief	创建实例
 *
 *	@return	self
 */
- (id) init;

@property(copy, nonatomic) NSString* key;
@property(copy, nonatomic) NSString* pathToSource, * pathToTarget;
@property(copy, nonatomic) NSString* sourceKeyPath, * targetKeyPath;
@property(nonatomic) WASBindingDirection direction;
@property(copy, nonatomic) NSString* valueTransformerName;

@end
