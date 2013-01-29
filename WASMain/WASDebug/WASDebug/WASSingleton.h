//
//  WASSingleton.h
//  WASDebug
//
//  Created by allen.wang on 11/21/12.
//  Copyright (c) 2012 b5m. All rights reserved.
//

#import <Foundation/Foundation.h>

#undef	AS_SINGLETON
#define AS_SINGLETON( __class ) \
+ (__class *)sharedInstance;

#undef	DEF_SINGLETON
#define DEF_SINGLETON( __class ) \
+ (__class *)sharedInstance \
{ \
    static dispatch_once_t once; \
    static __class * __singleton__; \
    dispatch_once( &once, ^{ __singleton__ = [[__class alloc] init]; } ); \
    return __singleton__; \
}

#undef __IMAGE
#define __IMAGE(x)   [UIImage imageNamed:x]


#define SAFE_RELEASE_SUBVIEW(x) [x removeFromSuperview];[ x release]; x = nil;