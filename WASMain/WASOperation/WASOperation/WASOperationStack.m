//
//  WASOperationStack.m
//  WASOperation
//
//  Created by allen.wang on 1/21/13.
//  Copyright (c) 2013 allen.wang. All rights reserved.
//

#import "WASOperationStack.h"


@implementation NSOperationQueue (LIFO)

- (void)setLIFODependendenciesForOperation:(NSOperation *)op
{
    @synchronized(self)
    {
        //suspend queue
        BOOL wasSuspended = [self isSuspended];
        [self setSuspended:YES];
        
        //make op a dependency of all queued ops
        NSInteger maxOperations = ([self maxConcurrentOperationCount] > 0) ? [self maxConcurrentOperationCount]: INT_MAX;
        NSArray *operations = [self operations];
        NSInteger index = [operations count] - maxOperations;
        if (index >= 0)
        {
            NSOperation *operation = operations[index];
            if (![operation isExecuting])
            {
                [operation addDependency:op];
            }
        }
        
        //resume queue
        [self setSuspended:wasSuspended];
    }
}

- (void)addOperationAtFrontOfQueue:(NSOperation *)op
{
    [self setLIFODependendenciesForOperation:op];
    [self addOperation:op];
}

- (void)addOperationsAtFrontOfQueue:(NSArray *)ops waitUntilFinished:(BOOL)wait
{
    for (NSOperation *op in ops)
    {
        [self setLIFODependendenciesForOperation:op];
    }
    [self addOperations:ops waitUntilFinished:wait];
}

- (void)addOperationAtFrontOfQueueWithBlock:(void (^)(void))block
{
    [self addOperationAtFrontOfQueue:[NSBlockOperation blockOperationWithBlock:block]];
}

@end


@implementation WASOperationStack

- (void)addOperation:(NSOperation *)op
{
    [self setLIFODependendenciesForOperation:op];
    [super addOperation:op];
}

- (void)addOperations:(NSArray *)ops waitUntilFinished:(BOOL)wait
{
    for (NSOperation *op in ops)
    {
        [self setLIFODependendenciesForOperation:op];
    }
    [super addOperations:ops waitUntilFinished:wait];
}

- (void)addOperationWithBlock:(void (^)(void))block
{
    [self addOperation:[NSBlockOperation blockOperationWithBlock:block]];
}

@end
