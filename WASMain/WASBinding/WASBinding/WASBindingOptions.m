//
//  WASBindingOptions.m
//  WASBinding
//
//  Created by allen.wang on 10/17/12.
//  Copyright (c) 2012 b5m. All rights reserved.
//

#import "WASBindingOptions.h"

@implementation WASBindingOptions

@synthesize concurrencyModel= _concurrencyModel;
@synthesize allowedThread   = _allowedThread;
@synthesize dispatchQueue   = _dispatchQueue;
@synthesize direction       = _direction;
@synthesize valueTransformer= _valueTransformer;

- init 
{ 
    return [super init];
}

+ optionsWithDefaultValues;
{
    return [[self new] autorelease];
}

- (void)dealloc;
{
    if (_dispatchQueue)
        dispatch_release(_dispatchQueue);
    
    [_allowedThread release];   _allowedThread = nil;
    [_valueTransformer release];_valueTransformer = nil;
    [super dealloc];
}

- (void)setConcurrencyModel:(WASBindingConcurrencyModel) m;
{
    if (_concurrencyModel != m) 
    {
        _concurrencyModel = m;
        
        switch (_concurrencyModel) 
        {
            case kWASBindingConcurrencyAllowedThread:
                self.dispatchQueue = NULL;
                break;
                
            case kWASBindingConcurrencyDispatchOnQueue:
                self.allowedThread = nil;
                break;
                
        }
    }
}

- (NSThread *)allowedThread;
{
    if (!_allowedThread && self.concurrencyModel == kWASBindingConcurrencyAllowedThread)
        return [NSThread mainThread];
    
    return _allowedThread;
}

- (void)setAllowedThread:(NSThread *) a;
{
    if (a != _allowedThread) {
        [_allowedThread release];
        _allowedThread = [a retain];
        
        if (_allowedThread)
            self.concurrencyModel = kWASBindingConcurrencyAllowedThread;
    }
}

- (dispatch_queue_t)dispatchQueue;
{
    if (!_dispatchQueue && self.concurrencyModel == kWASBindingConcurrencyDispatchOnQueue)
        return dispatch_get_main_queue();
    
    return _dispatchQueue;
}

- (void)setDispatchQueue:(dispatch_queue_t) dq;
{
    if (_dispatchQueue != dq) 
    {
        dispatch_release(_dispatchQueue);
        if (dq)
            dispatch_retain(dq);
        
        _dispatchQueue = dq;
        
        if (dq)
            self.concurrencyModel = kWASBindingConcurrencyDispatchOnQueue;
    }
}

- (void)setDirection:(WASBindingDirection) d;
{
    if (_direction != d) 
    {
        _direction = d;
        
        if (_direction != kWASBindingDirectionSourceToTargetOnly && self.valueTransformer && ![[self.valueTransformer class] allowsReverseTransformation])
            self.valueTransformer = nil;
    }
}

- (void)setValueTransformer:(NSValueTransformer *) v;
{
    if (v != _valueTransformer) 
    {
        [_valueTransformer release];
        _valueTransformer = [v retain];
        
        if (_valueTransformer && ![[_valueTransformer class] allowsReverseTransformation])
            self.direction = kWASBindingDirectionSourceToTargetOnly;
    }
}

- (id)copyWithZone:(NSZone *)zone;
{
    WASBindingOptions* newOptions = [[WASBindingOptions allocWithZone:zone] init];
    
    newOptions->_concurrencyModel = _concurrencyModel;
    
    [newOptions->_allowedThread autorelease];
    newOptions->_allowedThread = [_allowedThread retain];
    
    newOptions->_direction = _direction;
    
    [newOptions->_valueTransformer autorelease];
    newOptions->_valueTransformer = [_valueTransformer retain];
    
    if (newOptions->_dispatchQueue && newOptions->_dispatchQueue != _dispatchQueue)
        dispatch_release(newOptions->_dispatchQueue);
    if (_dispatchQueue)
        dispatch_retain(_dispatchQueue);
    
    newOptions->_dispatchQueue = _dispatchQueue;
    
    return newOptions;
}

- (id)mutableCopyWithZone:(NSZone *)zone;
{
    return [self copyWithZone:zone];
}

@end
