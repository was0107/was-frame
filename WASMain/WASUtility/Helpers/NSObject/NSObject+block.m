//
//  NSObject+block.m
//  WASUtility
//
//  Created by allen.wang on 9/14/12.
//  Copyright (c) 2012 b5m. All rights reserved.
//

#import "NSObject+block.h"
#import "ARCHelper.h"

@implementation NSObject (block)

- (void)executeBlock__:(void (^)(void))block
{
    block();
    [block release];
}

- (void)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay
{
    [self performSelector:@selector(executeBlock__:)
               withObject:[[block copy] autorelease]
               afterDelay:delay];
}

@end
