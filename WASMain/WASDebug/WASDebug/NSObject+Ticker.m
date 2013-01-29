//
//  NSObject+Ticker.m
//  WASDebug
//
//  Created by allen.wang on 11/21/12.
//  Copyright (c) 2012 b5m. All rights reserved.
//

#import "NSObject+Ticker.h"
#import "NSArray+extentions.h"

#pragma mark -

@interface BeeTicker : NSObject
{
    NSTimer *			_timer;
    NSTimeInterval		_lastTick;
    NSMutableArray *	_receives;
}

@property (nonatomic, readonly)	NSTimer *			timer;
@property (nonatomic, readonly)	NSTimeInterval		lastTick;

AS_SINGLETON( BeeTicker )

- (void)addReceive:(NSObject *)obj;
- (void)removeReceive:(NSObject *)obj;
- (void)performTick;

@end

#pragma mark -

@implementation BeeTicker
@synthesize timer = _timer;
@synthesize lastTick = _lastTick;

DEF_SINGLETON( BeeTicker )

- (id)init
{
    self = [super init];
    if ( self )
    {
        _receives = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addReceive:(NSObject *)obj
{
	if ( NO == [_receives containsObject:obj] )
	{
		[_receives addObjectNoRetain:obj];
		
		if ( nil == _timer )
		{
			_timer = [NSTimer scheduledTimerWithTimeInterval:0.5f
													  target:self 
													selector:@selector(performTick) 
													userInfo:nil
													 repeats:YES];
			
			_lastTick = [NSDate timeIntervalSinceReferenceDate];
		}
	}
}

- (void)removeReceive:(NSObject *)obj
{
	[_receives removeObjectNoRelease:obj];
	
	if ( 0 == _receives.count )
	{
		[_timer invalidate];
		_timer = nil;
	}
}

- (void)performTick
{
	NSTimeInterval tick = [NSDate timeIntervalSinceReferenceDate];
	NSTimeInterval elapsed = tick - _lastTick;
	
	for ( NSObject * obj in _receives )
	{
		if ( [obj respondsToSelector:@selector(handleTick:)] )
		{
			[obj handleTick:elapsed];
		}
	}
    
	_lastTick = tick;
}

- (void)dealloc
{
	[_timer invalidate];
	_timer = nil;
	
	[_receives removeAllObjectsNoRelease];
	[_receives release];
    
	[super dealloc];
}

@end

#pragma mark -

@implementation NSObject(Ticker)

- (void)observeTick
{
	[[BeeTicker sharedInstance] addReceive:self];
}

- (void)unobserveTick
{
	[[BeeTicker sharedInstance] removeReceive:self];
}

- (void)handleTick:(NSTimeInterval)elapsed
{
}

@end
