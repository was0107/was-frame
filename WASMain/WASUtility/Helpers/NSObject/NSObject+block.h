//
//  NSObject+block.h
//  WASUtility
//
//  Created by allen.wang on 9/14/12.
//  Copyright (c) 2012 b5m. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (block)
- (void)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay;
@end
