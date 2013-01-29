//
//  WASBingDefinition+WASBindingsLoadingMany.h
//  WASBinding
//
//  Created by allen.wang on 10/29/12.
//  Copyright (c) 2012 b5m. All rights reserved.
//

#import "WASBindingDefinition.h"

typedef enum {
    kWASBindingLoadingAllowIncompleteOrDuplicateDefinitions = 1 << 0,
} WASBindingLoadingManyOptions;


#define kWASBindingDefinitionFileExtension @"ilabs-bindings"


@interface WASBindingDefinition (WASBindingsLoadingMany)

+ (NSArray*) definitionsInResourceNamed:(NSString*) resource withExtension:(NSString*) extension bundle:(NSBundle*) bundle definitionsByKey:(NSDictionary**) byKey error:(NSError**) error;
+ (NSArray*) definitionsWithContentsOfURL:(NSURL*) url options:(WASBindingLoadingManyOptions) opts  definitionsByKey:(NSDictionary**) byKey error:(NSError**) error;
+ (NSArray*) definitionsWithPropertyListData:(NSData*) data options:(WASBindingLoadingManyOptions) opts definitionsByKey:(NSDictionary**) byKey error:(NSError**) error;

+ (BOOL) writeDefinitions:(NSArray*) definitions toFileAtURL:(NSURL*) url error:(NSError**) error;
+ (NSData*) propertyListDataWithDefinitions:(NSArray*) definitions error:(NSError**) error;
@end
