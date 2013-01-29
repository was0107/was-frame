//
//  NSArray+extentions.h
//  WASDebug
//
//  Created by allen.wang on 11/21/12.
//  Copyright (c) 2012 b5m. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray(extentions)

- (NSArray *)head:(NSUInteger)count;
- (NSArray *)tail:(NSUInteger)count;

@end

#pragma mark -

@interface NSMutableArray(extentions)

- (NSMutableArray *)pushHead:(NSObject *)obj;
- (NSMutableArray *)pushHeadN:(NSArray *)all;
- (NSMutableArray *)popTail;
- (NSMutableArray *)popTailN:(NSUInteger)n;

- (NSMutableArray *)pushTail:(NSObject *)obj;
- (NSMutableArray *)pushTailN:(NSArray *)all;
- (NSMutableArray *)popHead;
- (NSMutableArray *)popHeadN:(NSUInteger)n;

- (NSMutableArray *)keepHead:(NSUInteger)n;
- (NSMutableArray *)keepTail:(NSUInteger)n;

- (void)addObjectNoRetain:(NSObject *)obj;
- (void)removeObjectNoRelease:(NSObject *)obj;
- (void)removeAllObjectsNoRelease;

@end
