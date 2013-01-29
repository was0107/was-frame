//
//  WASBinding.m
//  WASBinding
//
//  Created by allen.wang on 10/17/12.
//  Copyright (c) 2012 b5m. All rights reserved.
//

#import "WASBinding.h"

static NSString* const kWASBindingIsDispatchingChangeOnCurrentThreadKey = @"WASBindingIsDispatchingChangeOnCurrentThread";


@interface WASBinding()
@property (nonatomic, assign) id sourceObject;
@property (nonatomic, assign) id targetObject;
@property (nonatomic, copy)   NSString *sourceKeyPath;
@property (nonatomic, copy)   NSString *targetKeyPath;
@property (nonatomic, copy)   WASBindingOptions *options;
@property (nonatomic, retain) NSMutableSet *cleanupBlocks;
@property (nonatomic, getter = isSynchronizing) BOOL synchronizing;


- (void) synchronizeFromTargetToSource;

- (void) addCleanupBlock:(void(^)(WASBinding *mySelf))block;

@end

@implementation WASBinding
@synthesize sourceObject = _sourceObject;
@synthesize targetObject = _targetObject;
@synthesize sourceKeyPath= _sourceKeyPath;
@synthesize targetKeyPath= _targetKeyPath;
@synthesize options      = _options;
@synthesize synchronizing= _synchronizing;
@synthesize cleanupBlocks= _cleanupBlocks;
@synthesize logging      = _logging;

+ bindingWithKeyPath:(NSString*) key ofSourceObject:(id) object boundToKeyPath:(NSString*) otherKey ofTargetObject:(id) otherObject options:(WASBindingOptions*) options
{
    return [[[self alloc] initWithKeyPath:key ofSourceObject:object boundToKeyPath:otherKey ofTargetObject:otherObject options:options] autorelease];
}

- initWithKeyPath:(NSString*) sourcePath ofSourceObject:(id) source boundToKeyPath:(NSString*) targetPath ofTargetObject:(id) target options:(WASBindingOptions *)o
{
    self = [super init];
    if (self) {        
        self.options = o ? o: [WASBindingOptions optionsWithDefaultValues];
        
        self.sourceObject   = source;
        self.sourceKeyPath  = sourcePath;
        self.targetObject   = target;
        self.targetKeyPath  = targetPath;
        
        [self.targetObject addObserver:self forKeyPath:self.targetKeyPath options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
        [self.sourceObject addObserver:self forKeyPath:self.sourceKeyPath options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld|NSKeyValueObservingOptionInitial context:NULL];
    }
    
    return self;
}

- (void) dealloc
{
    [self unbind];
    [super dealloc];
}

- (void) unbind
{
    for (void (^block)(WASBinding*) in self.cleanupBlocks)
        block(self);
    
    self.cleanupBlocks = nil;
    
    //你可以发送一条指定观察方对象和键路径的removeObserver:forKeyPath:消息至被观察的对象，来移除一个键-值观察者。
    //如果在观察者被注册时，内容被指定为一个对象，那么在观察者被移除后它可以被安全地释放。当接收到removeObserver:forKeyPath:消息后，观察方对象不会再收到关于指定的关键值路径和对象的任何 observeValueForKeyPath:ofObject:change:context:消息。
    [self.sourceObject removeObserver:self forKeyPath:self.sourceKeyPath];
    [self.targetObject removeObserver:self forKeyPath:self.targetKeyPath];
    
    self.sourceObject = nil;
    self.targetObject = nil;
    
    self.sourceKeyPath = nil;
    self.targetKeyPath = nil;
}

- (void) addCleanupBlock:(void (^)(WASBinding*))block
{
    if (!self.cleanupBlocks)
        self.cleanupBlocks = [NSMutableSet set];
    
    [self.cleanupBlocks addObject:[[block copy] autorelease]];
}


- (NSArray*) arrayByTransformingArray:(NSArray*) objects usingValueTransformerSelector:(SEL) sel
{
    WASBindingOptions* opts = self.options;
    if (!opts.valueTransformer)
        return objects;
    
    NSMutableArray* transformedObjects = [NSMutableArray arrayWithCapacity:objects.count];
    for (id object in objects) {
        [transformedObjects addObject:[opts.valueTransformer performSelector:sel withObject:object]];
    }
    
    return transformedObjects;
}

- (NSSet*) setByTransformingSet:(NSSet*) objects usingValueTransformerSelector:(SEL) sel
{
    WASBindingOptions* opts = self.options;
    if (!opts.valueTransformer)
        return objects;
    
    NSMutableSet* transformedObjects = [NSMutableSet setWithCapacity:objects.count];
    for (id object in objects) {
        [transformedObjects addObject:[opts.valueTransformer performSelector:sel withObject:object]];
    }
    
    return transformedObjects;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    WASBindingOptions* opts = self.options;
    
    if (opts.concurrencyModel == kWASBindingConcurrencyAllowedThread && opts.allowedThread != [NSThread currentThread]) {
        
        [NSException raise:@"WASBindingDisallowedThreadException" format:@"This thread (%@) is not the allowed thread for this binding (%@). (This binding was set up with the allowed thread concurrency model.)", [NSThread currentThread], opts.allowedThread];
        
    }
    
    void (^performSync)() = ^{
        
        if (self.synchronizing)
            return;
        
        if (object == self.targetObject && [keyPath isEqualToString:self.targetKeyPath] && opts.direction == kWASBindingDirectionSourceToTargetOnly)
            return;
        
        self.synchronizing = YES;
        
        id otherObject = (object == self.sourceObject && [keyPath isEqualToString:self.sourceKeyPath]? self.targetObject : self.sourceObject);
        NSString* otherKey = (object == self.sourceObject && [keyPath isEqualToString:self.sourceKeyPath]? self.targetKeyPath : self.sourceKeyPath);
        
        SEL valueTransformerSelector = (object == self.sourceObject? @selector(transformedValue:) : @selector(reverseTransformedValue:));
        
        //变更字典项NSKeyValueChangeKindKey供发生变更的类型信息。
        NSKeyValueChange kind = [[change objectForKey:NSKeyValueChangeKindKey] unsignedIntegerValue];
        
        if (kind == NSKeyValueChangeSetting) {
            //如果被观察对象的值改变了，NSKeyValueChangeKindKey项将返回一个NSKeyValueChangeSetting。
            //依赖观察者注册时指定的选项，字典中的NSKeyValueChangeOldKey和NSKeyValueChangeNewKey项分别包含了被观察属性变更前后的值。
            
            id value = [change objectForKey:NSKeyValueChangeNewKey];
            
            if (self.logging) {
                NSLog(@"%@ - Will change value for %@ -> %@ (from %@ -> %@) to\n\t%@", self, otherObject, otherKey, object, keyPath, value);
            }
            
            if (opts.valueTransformer) {
                value = [opts.valueTransformer performSelector:valueTransformerSelector withObject:value];
                
                if (self.logging)
                    NSLog(@"Value transformed to: %@", value);
            }
            
            [otherObject setValue:value forKeyPath:otherKey];
            
        } 
        else {
            //如果被观察的属性是一个对多的关系，NSKeyValueChangeKindKey项同样可以通过返回三个不同的项NSKeyValueChangeInsertion，NSKeyValueChangeRemoval或NSKeyValueChangeReplacement来分别指明关系中的对象被执行的插入、删除和替换操作。
            //变更字典项NSKeyValueChangeIndexesKey是一个指定关系表变更索引的NSIndexSet对象。
            //注册观察者时，如果NSKeyValueObservingOptionNew或NSKeyValueObservingOptionOld被指定为选项，变更字典中NSKeyValueChangeOldKey和NSKeyValueChangeNewKey两个项将以数组形式包含相关对象在变更前后的值。
            BOOL isRelationshipOrdered = [[change objectForKey:NSKeyValueChangeNewKey] isKindOfClass:[NSArray class]] || [[change objectForKey:NSKeyValueChangeOldKey] isKindOfClass:[NSArray class]];
            
            if (isRelationshipOrdered) {
                
                switch (kind) {
                    case NSKeyValueChangeInsertion: {
                        
                        NSIndexSet* indexes = [change objectForKey:NSKeyValueChangeIndexesKey];
                        NSArray* objects = [change objectForKey:NSKeyValueChangeNewKey];
                        
                        if (self.logging) {
                            NSLog(@"%@ - Will change value for %@ -> %@ (from %@ -> %@)\n\tby inserting objects: %@\n\tat indexes: %@", self, otherObject, otherKey, object, keyPath, objects, indexes);
                        }
                        
                        objects = [self arrayByTransformingArray:objects usingValueTransformerSelector:valueTransformerSelector];
                        
                        [[otherObject mutableArrayValueForKey:otherKey] insertObjects:objects atIndexes:indexes];
                        
                        break;
                    }
                        
                    case NSKeyValueChangeRemoval: {
                        
                        NSIndexSet* indexes = [change objectForKey:NSKeyValueChangeIndexesKey];
                        
                        if (self.logging) {
                            NSLog(@"%@ - Will change value for %@ -> %@ (from %@ -> %@)\n\tby removing objects: %@\n\tfrom indexes: %@", self, otherObject, otherKey, object, keyPath, [change objectForKey:NSKeyValueChangeOldKey], indexes);
                        }
                        
                        [[otherObject mutableArrayValueForKey:otherKey] removeObjectsAtIndexes:indexes];
                        
                        break;
                    }
                        
                    case NSKeyValueChangeReplacement: {
                        
                        NSIndexSet* indexes = [change objectForKey:NSKeyValueChangeIndexesKey];
                        NSArray* objects = [change objectForKey:NSKeyValueChangeNewKey];
                        
                        objects = [self arrayByTransformingArray:objects usingValueTransformerSelector:valueTransformerSelector];
                        
                        if (self.logging) {
                            NSLog(@"%@ - Will change value for %@ -> %@ (from %@ -> %@)\n\tby replacing objects: %@\n\tat indexes: %@\n\twith objects: %@", self, otherObject, otherKey, object, keyPath, [change objectForKey:NSKeyValueChangeOldKey], indexes, objects);
                        }
                        
                        [[otherObject mutableArrayValueForKey:otherKey] replaceObjectsAtIndexes:indexes withObjects:objects];
                        
                        break;
                    }
                        
                    default:
                        break;
                }
                
            } else /* relationship is unordered */ {
                
                switch (kind) {
                    case NSKeyValueChangeInsertion: {
                        
                        NSSet* objects = [change objectForKey:NSKeyValueChangeNewKey];
                        
                        objects = [self setByTransformingSet:objects usingValueTransformerSelector:valueTransformerSelector];
                        
                        if (self.logging) {
                            NSLog(@"%@ - Will change value for %@ -> %@ (from %@ -> %@)\n\tby set union with objects: %@", self, otherObject, otherKey, object, keyPath, objects);
                        }
                        
                        [[otherObject mutableSetValueForKey:otherKey] unionSet:objects];
                        
                        break;
                    }
                        
                    case NSKeyValueChangeRemoval: {
                        
                        NSSet* objects = [change objectForKey:NSKeyValueChangeOldKey];
                        
                        objects = [self setByTransformingSet:objects usingValueTransformerSelector:valueTransformerSelector];
                        
                        if (self.logging) {
                            NSLog(@"%@ - Will change value for %@ -> %@ (from %@ -> %@)\n\tby set difference with objects: %@", self, otherObject, otherKey, object, keyPath, objects);
                        }
                        
                        [[otherObject mutableSetValueForKey:otherKey] minusSet:objects];
                        
                        break;
                    }
                        
                    case NSKeyValueChangeReplacement: {
                        
                        NSSet* addedObjects = [change objectForKey:NSKeyValueChangeNewKey];
                        NSSet* removedObjects = [change objectForKey:NSKeyValueChangeOldKey];
                        
                        addedObjects = [self setByTransformingSet:addedObjects usingValueTransformerSelector:valueTransformerSelector];
                        removedObjects = [self setByTransformingSet:removedObjects usingValueTransformerSelector:valueTransformerSelector];
                        
                        if (self.logging) {
                            NSLog(@"%@ - Will change value for %@ -> %@ (from %@ -> %@)\n\tby replacing set of objects: %@\n\twith objects: %@", self, otherObject, otherKey, object, keyPath, addedObjects, removedObjects);
                        }
                        
                        NSMutableSet* mutableSet = [otherObject mutableSetValueForKey:otherKey];
                        [mutableSet minusSet:removedObjects];
                        [mutableSet unionSet:addedObjects];
                        
                        break;
                    }
                        
                    default:
                        break;
                }
                
            }
            
        }
        
        self.synchronizing = NO;
        
    };
    
    if (opts.concurrencyModel == kWASBindingConcurrencyDispatchOnQueue)
        dispatch_async(opts.dispatchQueue, performSync);
    else
        performSync();
}

- (void) synchronizeFromTargetToSource
{
    WASBindingOptions* opts = self.options;
    
    if (opts.concurrencyModel == kWASBindingConcurrencyAllowedThread && opts.allowedThread != [NSThread currentThread]) {
        
        [NSException raise:@"WASBindingDisallowedThreadException" format:@"This thread (%@) is not the allowed thread for this binding (%@). (This binding was set up with the allowed thread concurrency model.)", [NSThread currentThread], opts.allowedThread];
        
    }    
    
    self.synchronizing = YES;
    
    [self.sourceObject setValue:[self.targetObject valueForKeyPath:self.targetKeyPath] forKeyPath:self.sourceKeyPath];
    
    self.synchronizing = NO;
}

- (WASBinding *)setLogging
{
    self.logging = YES;
    return self;
}

@end


#if TARGET_OS_IPHONE

@implementation WASBinding (WASUIControlBindingAdditions)

- (id)initWithKeyPath:(NSString *)key ofSourceObject:(id)object boundToKeyPath:(NSString *)otherKey ofTargetUIControl:(UIControl*)otherObject options:(WASBindingOptions *)opts
{
    NSAssert((opts.concurrencyModel == kWASBindingConcurrencyAllowedThread && opts.allowedThread == [NSThread mainThread]) ||
             (opts.concurrencyModel == kWASBindingConcurrencyDispatchOnQueue && opts.dispatchQueue == dispatch_get_main_queue()) , @"Binding to UIControl requires dispatch to occur on the main thread.");
    
    if (opts.direction == kWASBindingDirectionSourceToTargetOnly) {
        return [self initWithKeyPath:key ofSourceObject:object boundToKeyPath:otherKey ofTargetObject:otherObject options:opts];
    }
    
    WASBindingOptions* actualOptions = [[opts copy] autorelease];
    actualOptions.direction = kWASBindingDirectionSourceToTargetOnly;
    
    self = [self initWithKeyPath:key ofSourceObject:object boundToKeyPath:otherKey ofTargetObject:otherObject options:actualOptions];
    
    if (self) {
        [otherObject addTarget:self action:@selector(synchronizeFromTargetToSource) forControlEvents:UIControlEventValueChanged];
        
        [self addCleanupBlock:^(WASBinding* me) {
            [(UIControl*)me.targetObject removeTarget:self action:@selector(synchronizeFromTargetToSource) forControlEvents:UIControlEventValueChanged];
        }];
    }
    
    return self;
}

+ (id)bindingWithKeyPath:(NSString *)key ofSourceObject:(id)object boundToKeyPath:(NSString *)otherKey ofTargetUIControl:(UIControl*)otherObject options:(WASBindingOptions *)options;
{
    return [[[self alloc] initWithKeyPath:key ofSourceObject:object boundToKeyPath:otherKey ofTargetUIControl:otherObject options:options] autorelease];
}

@end

#endif
