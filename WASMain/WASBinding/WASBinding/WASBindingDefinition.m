//
//  WASBingDefinition.m
//  WASBinding
//
//  Created by allen.wang on 10/29/12.
//  Copyright (c) 2012 b5m. All rights reserved.
//

#import "WASBindingDefinition.h"
// This key uniquely identifies the binding within a set of bindings. Optional.
#define kWASBindingDefinitionKey @"Key"


//要绑定的来源和目标的所有者，默认是self
#define kWASBindingDefinitionPathToSourceKey @"PathToSource"
#define kWASBindingDefinitionPathToTargetKey @"PathToTarget"

// 要绑定对象的来源和目标，对应的路径
#define kWASBindingDefinitionSourceKeyPathKey @"SourceKeyPath"
#define kWASBindingDefinitionTargetKeyPathKey @"TargetKeyPath"

// -----
#define kWASBindingDefinitionDirectionKey @"Direction"
#define kWASBindingDefinitionDirectionBoth [NSNumber numberWithUnsignedInteger:kWASBindingDirectionBoth]
#define kWASBindingDefinitionDirectionSourceToTarget [NSNumber numberWithUnsignedInteger:kWASBindingDirectionSourceToTargetOnly]

#define kWASBindingDefinitionDirectionAllowableValues [NSSet setWithObjects:kWASBindingDefinitionDirectionBoth, kWASBindingDefinitionDirectionSourceToTarget, nil]
// -----
#define kWASBindingDefinitionValueTransformerNameKey @"ValueTransformerName"




@interface WASBindingDefinition ()
@property(copy, nonatomic) NSString* key;

@property(copy, nonatomic) NSString* pathToSource, * pathToTarget;
@property(copy, nonatomic) NSString* sourceKeyPath, * targetKeyPath;
@property(nonatomic) WASBindingDirection direction;
@property(copy, nonatomic) NSString* valueTransformerName;

- (id) objectForKey:(NSString*) key inDictionary:(NSDictionary*) dict assumingOfClass:(Class) cls allowableValues:(NSSet*) allowable error:(NSError**) error;

- (id) copyWithClass:(Class) cls;

@end


@implementation WASBindingDefinition

@synthesize key;
@synthesize pathToSource, pathToTarget;
@synthesize sourceKeyPath, targetKeyPath;
@synthesize direction;
@synthesize valueTransformerName;

- (id) initWithPropertyListRepresentation:(id) plist options:(WASBindingLoadingOptions) options error:(NSError**) error;
{
    self = [super init];
    if (self) {
        if (![plist isKindOfClass:[NSDictionary class]]) {
            if (error) *error = [NSError errorWithDomain:kWASBindingDefinitionErrorDomain code:kWASBindingDefinitionErrorInvalidPropertyList userInfo:nil];
            
            [self release];
            return nil;
        }
        
        BOOL validates = (options & kWASBindingLoadingAllowIncompletePropertyList) == 0;
        
#define WASBindingDefinitionSetOrReturnError(what, key, valueClass, allowable) \
what = [self objectForKey:key inDictionary:plist assumingOfClass:valueClass allowableValues:allowable error:error]; \
if (validates && !what) { [self release]; return nil; }
        
        // --------------------
        // Required stuff
        
        WASBindingDefinitionSetOrReturnError(self.sourceKeyPath, kWASBindingDefinitionSourceKeyPathKey, [NSString class], nil);
        WASBindingDefinitionSetOrReturnError(self.targetKeyPath, kWASBindingDefinitionTargetKeyPathKey, [NSString class], nil);
        
        NSNumber* directionNumber;
        WASBindingDefinitionSetOrReturnError(directionNumber, kWASBindingDefinitionDirectionKey, [NSNumber class], kWASBindingDefinitionDirectionAllowableValues);
        self.direction = [directionNumber unsignedIntegerValue];
        
        // --------------------
        // Optional stuff
        
        // Value transformer name
        
        NSError* optionalError;
        
#define WASBindingDefinitionSetOptionallyOrReturnError(what, key, valueClass, allowable) \
what = [self objectForKey:key inDictionary:plist assumingOfClass:valueClass allowableValues:allowable error:&optionalError]; \
if (!what && !([[optionalError domain] isEqualToString:kWASBindingDefinitionErrorDomain] && [optionalError code] == kWASBindingDefinitionErrorMissingEntry)) { \
if (error) *error = optionalError; \
[self release]; return nil; \
}
        
        // Value transformer name
        
        WASBindingDefinitionSetOptionallyOrReturnError(self.valueTransformerName, kWASBindingDefinitionValueTransformerNameKey, [NSString class], nil);
        
        if ([self.valueTransformerName isEqualToString:@""])
            self.valueTransformerName = nil;
        
        // Identifier
        
        WASBindingDefinitionSetOptionallyOrReturnError(self.key, kWASBindingDefinitionKey, [NSString class], nil);
        
        if ([self.key isEqualToString:@""])
            self.key = nil;
        
        // Paths to source and target
        
       WASBindingDefinitionSetOptionallyOrReturnError(self.pathToSource, kWASBindingDefinitionPathToSourceKey, [NSString class], nil);
        
        if ([self.pathToSource isEqualToString:@""])
            self.key = nil;
        
        WASBindingDefinitionSetOptionallyOrReturnError(self.pathToTarget, kWASBindingDefinitionPathToTargetKey, [NSString class], nil);
        
        if ([self.pathToTarget isEqualToString:@""])
            self.pathToTarget = nil;
        
        
#undef WASBindingDefinitionSetOptionallyOrReturnError
#undef WASBindingDefinitionSetOrReturnError
        
    }
    
    return self;
}

- (id) initWithPathToSource:(NSString*) pts boundSourceKeyPath:(NSString*) sp pathToTarget:(NSString*) ptt boundTargetKeyPath:(NSString*) tp options:(WASBindingOptions*) opts key:(NSString*) optionalKey;
{
    self = [super init];
    if (self) {
        self.key = optionalKey;
        
        self.pathToSource = pts;
        self.pathToTarget = ptt;
        
        self.sourceKeyPath = sp;
        self.targetKeyPath = tp;
        
        self.direction = opts.direction;
        
        if (opts.valueTransformer) {
            for (NSString* name in [NSValueTransformer valueTransformerNames]) {
                if ([NSValueTransformer valueTransformerForName:name] == opts.valueTransformer) {
                    self.valueTransformerName = name;
                }
            }
            
            if (!self.valueTransformerName)
                self.valueTransformerName = NSStringFromClass([opts.valueTransformer class]);
        }
    }
    
    return self;
}

- (void) dealloc;
{
    [key release];
    [pathToSource release];
    [pathToTarget release];
    [sourceKeyPath release];
    [targetKeyPath release];
    [valueTransformerName release];
    
    [super dealloc];
}

- (id) objectForKey:(NSString*) aKey inDictionary:(NSDictionary*) dict assumingOfClass:(Class) cls allowableValues:(NSSet*) allowable error:(NSError**) error;
{
    id value = [dict objectForKey:aKey];
    
    if (!value) {
        if (error) {
            NSDictionary* dict = [NSDictionary dictionaryWithObject:aKey forKey:kWASBindingDefinitionErrorSourceKey];
            
            *error = [NSError errorWithDomain:kWASBindingDefinitionErrorDomain code:kWASBindingDefinitionErrorMissingEntry userInfo:dict];
        }
        
        return nil;
    }
    else if (![value isKindOfClass:cls] || (allowable && ![allowable containsObject:value])) {
        if (error) {
            NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
                                  aKey, kWASBindingDefinitionErrorSourceKey,
                                  value, kWASBindingDefinitionErrorSourceValue,
                                  nil];
            
            *error = [NSError errorWithDomain:kWASBindingDefinitionErrorDomain code:kWASBindingDefinitionErrorInvalidEntry userInfo:dict];
        }
        
        return nil;
    }
    
    return value;
}

- (id)propertyListRepresentation;
{
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    
    if (self.pathToSource)
        [dictionary setObject:self.pathToSource forKey:kWASBindingDefinitionPathToSourceKey];
    
    if (self.pathToTarget)
        [dictionary setObject:self.pathToTarget forKey:kWASBindingDefinitionPathToTargetKey];
    
    if (self.sourceKeyPath)
        [dictionary setObject:self.sourceKeyPath forKey:kWASBindingDefinitionSourceKeyPathKey];
    
    if (self.targetKeyPath)
        [dictionary setObject:self.targetKeyPath forKey:kWASBindingDefinitionTargetKeyPathKey];
    
    [dictionary setObject:[NSNumber numberWithUnsignedInteger:self.direction] forKey:kWASBindingDefinitionDirectionKey];
    
    if (self.valueTransformerName)
        [dictionary setObject:self.valueTransformerName forKey:kWASBindingDefinitionValueTransformerNameKey];
    
    if (self.key)
        [dictionary setObject:self.key forKey:kWASBindingDefinitionKey];
    
    return dictionary;
}

- (WASBinding*) bindingWithOwner:(id) owner options:(WASBindingOptions*) opts;
{
    return [self bindingWithSourceObject:owner targetObject:owner options:opts];
}

- (WASBinding*) bindingWithSourceObject:(id) source targetObject:(id) target options:(WASBindingOptions*) opts;
{
    if (opts)
        opts = [[opts copy] autorelease];
    else
        opts = [WASBindingOptions optionsWithDefaultValues];
    
    opts.direction = self.direction;
    if (self.valueTransformerName) {
        opts.valueTransformer = [NSValueTransformer valueTransformerForName:self.valueTransformerName];
    }
    
    if (self.pathToSource)
        source = [source valueForKeyPath:self.pathToSource];
    
    if (self.pathToTarget)
        target = [target valueForKeyPath:self.pathToTarget];
    
#if TARGET_OS_IPHONE
    if ([target isKindOfClass:[UIControl class]]) {
        return [WASBinding bindingWithKeyPath:self.sourceKeyPath ofSourceObject:source boundToKeyPath:self.targetKeyPath ofTargetUIControl:target options:opts];
    }
#endif
    
    return [WASBinding bindingWithKeyPath:self.sourceKeyPath ofSourceObject:source boundToKeyPath:self.targetKeyPath ofTargetObject:target options:opts];
}

- (id) copyWithClass:(Class) cls;
{
    WASBindingDefinition* def = [cls new];
    
    for (NSString* KVOKey in [WASMutableBindingDefinition allObservableKeys]) // TODO a better way to store those
        [def setValue:[self valueForKey:KVOKey] forKey:KVOKey];
    
    return def;
}

- (id)copyWithZone:(NSZone *)zone;
{
    return [self copyWithClass:[WASBindingDefinition class]];
}

- (id)mutableCopyWithZone:(NSZone *)zone;
{
    return [self copyWithClass:[WASMutableBindingDefinition class]];    
}

@end


@implementation WASMutableBindingDefinition

- (id) init { return [super init]; }

#define WASBindingDefinitionCallSuperForProperty(getter, setter, type) \
- (type) getter { return [super getter]; } \
- (void) setter (type) newValue { [super setter newValue]; }

WASBindingDefinitionCallSuperForProperty(key, setKey:, NSString*)
WASBindingDefinitionCallSuperForProperty(pathToSource, setPathToSource:, NSString*)
WASBindingDefinitionCallSuperForProperty(pathToTarget, setPathToTarget:, NSString*)
WASBindingDefinitionCallSuperForProperty(sourceKeyPath, setSourceKeyPath:, NSString*)
WASBindingDefinitionCallSuperForProperty(targetKeyPath, setTargetKeyPath:, NSString*)
WASBindingDefinitionCallSuperForProperty(direction, setDirection:, WASBindingDirection)
WASBindingDefinitionCallSuperForProperty(valueTransformerName, setValueTransformerName:, NSString*)

+ (NSSet*) allObservableKeys;
{
    return [NSSet setWithObjects:
            @"key",
            @"pathToSource",
            @"pathToTarget",
            @"sourceKeyPath",
            @"targetKeyPath",
            @"direction",
            @"valueTransformerName",
            nil];
}

@end
