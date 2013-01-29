//
//  WASFlashDecorder.h
//  WASMain
//
//  Created by allen.wang on 8/9/12.
//  Copyright (c) 2012 b5m. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef VoidBlock
typedef void (^VoidBlock)();
#endif

@interface WASFlashDecorder : NSObject
+ (void) decorderView:(UIView *)view open:(BOOL) flag ;
+ (void) decorderView:(UIView *)view open:(BOOL) flag endBlock:(VoidBlock) block;
@end
