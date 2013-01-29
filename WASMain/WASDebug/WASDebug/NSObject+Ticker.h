//
//  NSObject+Ticker.h
//  WASDebug
//
//  Created by allen.wang on 11/21/12.
//  Copyright (c) 2012 b5m. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Ticker)
- (void)observeTick;
- (void)unobserveTick;
- (void)handleTick:(NSTimeInterval)elapsed;
@end