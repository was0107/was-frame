//
//  WASDebugDashBoard.m
//  WASDebug
//
//  Created by allen.wang on 11/21/12.
//  Copyright (c) 2012 b5m. All rights reserved.
//

#import "WASDebugDashBoard.h"

@implementation WASDebugDashBoard

DEF_SINGLETON( WASDebugDashBoard )

- (id) init
{
    self = [super init];
    if (self) {
        self.backgroundColor =  [UIColor blackColor];
        self.layer.borderColor = [[UIColor whiteColor] CGColor];
        CGRect rect = [[UIScreen mainScreen] bounds];
        rect.size.height -= 64.0f;
        self.frame = rect;
        _memoryView = [[WASDebugMemoryView alloc] initWithFrame:self.frame];
        [self addSubview:_memoryView];
        [self observeTick];
        [self handleTick:0.0f];
    }
    return self;
}

- (void) dealloc
{
    [self unobserveTick];
    SAFE_RELEASE_SUBVIEW( _memoryView );
    [super dealloc];
}

- (void)handleTick:(NSTimeInterval)elapsed
{
	[_memoryView update];
}



@end
