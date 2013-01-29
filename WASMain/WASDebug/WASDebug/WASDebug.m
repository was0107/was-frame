//
//  WASDebug.m
//  WASDebug
//
//  Created by allen.wang on 11/21/12.
//  Copyright (c) 2012 b5m. All rights reserved.
//

#import "WASDebug.h"
#import "WASDebugWindow.h"

@implementation WASDebug
+(void) show
{
    [[WASShortCutDebugWindow sharedInstance] setHidden:NO];
}

@end
