//
//  WASBingDefinition+WASBindingsLoadingMany.m
//  WASBinding
//
//  Created by allen.wang on 10/29/12.
//  Copyright (c) 2012 b5m. All rights reserved.
//

#import "WASBindingDefinition+WASBindingsLoadingMany.h"

#define kWASBindingDefinitionContainerKey @"WASBindings"

@implementation WASBindingDefinition (WASBindingsLoadingMany)

+ (NSArray*) definitionsInResourceNamed:(NSString*) resource withExtension:(NSString*) extension bundle:(NSBundle*) bundle definitionsByKey:(NSDictionary**) byKey error:(NSError**) error;
{
    if (!bundle)
        bundle = [NSBundle mainBundle];
    
    NSURL* url = [bundle URLForResource:resource withExtension:extension];
    if (!url) {
        if (error) *error = [NSError errorWithDomain:kWASBindingDefinitionErrorDomain code:kWASBindingDefinitionErrorInvalidPropertyList userInfo:nil];
        return nil;
    }
    
    return [self definitionsWithContentsOfURL:url options:0 definitionsByKey:byKey error:error];
}

+ (NSData*) propertyListDataWithDefinitions:(NSArray*) definitions error:(NSError**) error;
{
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    NSMutableArray* definitionPlists = [NSMutableArray arrayWithCapacity:definitions.count];
    
    for (WASBindingDefinition* definition in definitions)
        [definitionPlists addObject:definition.propertyListRepresentation];
    
    [dictionary setObject:definitionPlists forKey:kWASBindingDefinitionContainerKey];
    
    return [NSPropertyListSerialization dataWithPropertyList:dictionary format:NSPropertyListBinaryFormat_v1_0 options:0 error:error];
}

+ (BOOL) writeDefinitions:(NSArray*) definitions toFileAtURL:(NSURL*) url error:(NSError**) error;
{
    NSData* data = [self propertyListDataWithDefinitions:definitions error:error];
    if (!data)
        return NO;
    
    return [data writeToURL:url options:NSDataWritingAtomic error:error];
}

+ (NSArray*) definitionsWithContentsOfURL:(NSURL*) url options:(WASBindingLoadingManyOptions) opts  definitionsByKey:(NSDictionary**) byKey error:(NSError**) error;
{
    return [self definitionsWithPropertyListData:[NSData dataWithContentsOfURL:url] options:opts definitionsByKey:byKey error:error];
}

+ (NSArray*) definitionsWithPropertyListData:(NSData*) data options:(WASBindingLoadingManyOptions) opts definitionsByKey:(NSDictionary**) byKey error:(NSError**) error;
{
    id plist = [NSPropertyListSerialization propertyListWithData:data options:0 format:NULL error:error];
    if (!plist)
        return nil;
    
    if (![plist isKindOfClass:[NSDictionary class]]) {
        if (error) *error = [NSError errorWithDomain:kWASBindingDefinitionErrorDomain code:kWASBindingDefinitionErrorInvalidPropertyList userInfo:nil];
        return nil;
    }
    
    id allDefinitionPlists = [plist objectForKey:kWASBindingDefinitionContainerKey];
    if (!allDefinitionPlists || ![allDefinitionPlists isKindOfClass:[NSArray class]]){
        if (error) *error = [NSError errorWithDomain:kWASBindingDefinitionErrorDomain code:kWASBindingDefinitionErrorInvalidPropertyList userInfo:nil];
        return nil;
    }
    
    NSMutableArray* result = [NSMutableArray array];
    NSMutableDictionary* resultsByKey = nil;
    if (byKey)
        resultsByKey = [NSMutableDictionary dictionary];
    
    for (id plist in allDefinitionPlists) {
        WASBindingLoadingOptions singleOptions = 0;
        if (opts & kWASBindingLoadingAllowIncompleteOrDuplicateDefinitions)
            singleOptions |= kWASBindingLoadingAllowIncompletePropertyList;
        
        WASBindingDefinition* definition = [[[WASBindingDefinition alloc] initWithPropertyListRepresentation:plist options:singleOptions error:error] autorelease];
        
        if (!definition)
            return nil;
        
        [result addObject:definition];
        
        if (definition.key && ![definition.key isEqualToString:@""]) {
            if ((opts & kWASBindingLoadingAllowIncompleteOrDuplicateDefinitions) == 0 && [resultsByKey objectForKey:definition.key]) {
                if (error) {
                    NSDictionary* info = [NSDictionary dictionaryWithObject:definition.key forKey:kWASBindingDefinitionErrorSourceKey];
                    *error = [NSError errorWithDomain:kWASBindingDefinitionErrorDomain code:kWASBindingDefinitionErrorDuplicateKey userInfo:info];                  
                    return nil;
                }
            }
            
            [resultsByKey setObject:definition forKey:definition.key];
        }
    }
    
    if (byKey)
        *byKey = resultsByKey;
    return result;
}

@end
