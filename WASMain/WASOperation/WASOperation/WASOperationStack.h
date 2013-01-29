//
//  WASOperationStack.h
//  WASOperation
//
//  Created by allen.wang on 1/21/13.
//  Copyright (c) 2013 allen.wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSOperationQueue (LIFO)

- (void)addOperationAtFrontOfQueue:(NSOperation *)op;
- (void)addOperationsAtFrontOfQueue:(NSArray *)ops waitUntilFinished:(BOOL)wait;
- (void)addOperationAtFrontOfQueueWithBlock:(void (^)(void))block;

@end

@interface WASOperationStack : NSOperationQueue

@end
