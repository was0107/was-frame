//
//  WASDebugUtility.h
//  WASDebug
//
//  Created by allen.wang on 11/21/12.
//  Copyright (c) 2012 b5m. All rights reserved.
//

#import <UIKit/UIKit.h>


#define K	(1024)
#define M	(K * 1024)
#define G	(M * 1024)

@interface WASDebugUtility : NSObject
+ (NSString *)number2String:(int64_t)n;
@end
