//
//  WASBindingsSet.m
//  WASBinding
//
//  Created by allen.wang on 10/29/12.
//  Copyright (c) 2012 b5m. All rights reserved.
//

#import "WASBindingsSet.h"
#import "WASBindingDefinition.h"
#import "WASBindingDefinition+WASBindingsLoadingMany.h"

@interface WASBindingsSet ()
@property(copy, nonatomic) NSSet* allBindings;
@property(copy, nonatomic) NSDictionary* allBindingsByKey;
@end


@implementation WASBindingsSet
@synthesize allBindings, allBindingsByKey;

+ (id)bindingsSetNamed:(NSString*) name owner:(id) owner; 
{
    return [self bindingsSetNamed:name bundle:[NSBundle bundleForClass:[owner class]] sourceObject:owner targetObject:owner];
}

+ (id)bindingsSetNamed:(NSString*) name bundle:(NSBundle*) bundle sourceObject:(id) source targetObject:(id) target;
{
    return [[[self alloc] initWithResourceNamed:name withExtension:kWASBindingDefinitionFileExtension bundle:bundle sourceObject:source targetObject:target error:NULL] autorelease];
}

- (id) initWithResourceNamed:(NSString*) resource withExtension:(NSString*) extension owner:(id) owner error:(NSError**) error;
{
    return [self initWithResourceNamed:resource withExtension:extension bundle:[NSBundle bundleForClass:[owner class]] sourceObject:owner targetObject:owner error:error];
}

- (id) initWithResourceNamed:(NSString*) resource withExtension:(NSString*) extension bundle:(NSBundle*) bundle sourceObject:(id) source targetObject:(id) target error:(NSError**) error;
{
    self = [super init];
    if (self) {
        
        NSArray* allDefinitions = [WASBindingDefinition definitionsInResourceNamed:resource withExtension:extension bundle:bundle definitionsByKey:NULL error:error];
        
        NSMutableSet* bindings = [NSMutableSet setWithCapacity:allDefinitions.count];
        NSMutableDictionary* bindingsByKey = [NSMutableDictionary dictionaryWithCapacity:allDefinitions.count];
        
        for (WASBindingDefinition* def in allDefinitions) {
            
            WASBinding* binding = [def bindingWithSourceObject:source targetObject:target options:[WASBindingOptions optionsWithDefaultValues]];
            [bindings addObject:binding];
            
            if (def.key)
                [bindingsByKey setObject:binding forKey:def.key];
        }
        
        self.allBindings = bindings;
        self.allBindingsByKey = bindingsByKey;
    }
    
    return self;
}

- (void)dealloc;
{
    [self unbind];
    [super dealloc];
}

- (void)unbind;
{
    [self.allBindings makeObjectsPerformSelector:@selector(unbind)];
    
    self.allBindings = nil;
    self.allBindingsByKey = nil;
}

- (WASBinding*) bindingForKey:(NSString*) identifier;
{
    return [self.allBindingsByKey objectForKey:identifier];
}

@end
