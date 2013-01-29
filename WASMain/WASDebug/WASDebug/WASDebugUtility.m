//
//  WASDebugUtility.m
//  WASDebug
//
//  Created by allen.wang on 11/21/12.
//  Copyright (c) 2012 b5m. All rights reserved.
//

#import "WASDebugUtility.h"

@implementation WASDebugUtility

+ (NSString *)number2String:(int64_t)n
{
	if ( n < K )
	{
		return [NSString stringWithFormat:@"%lldB", n];
	}
	else if ( n < M )
	{
		return [NSString stringWithFormat:@"%.2fK", (float)n / (float)K];
	}
	else if ( n < G )
	{
		return [NSString stringWithFormat:@"%.2fM", (float)n / (float)M];
	}
	else
	{
		return [NSString stringWithFormat:@"%.2fG", (float)n / (float)G];
	}
}

@end
