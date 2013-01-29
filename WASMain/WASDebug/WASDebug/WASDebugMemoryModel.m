//
//  WASDebugMemoryModel.m
//  WASDebug
//
//  Created by allen.wang on 11/21/12.
//  Copyright (c) 2012 b5m. All rights reserved.
//

#import "WASDebugMemoryModel.h"
#import "WASDebugUtility.h"
#include <mach/mach.h>
#include <malloc/malloc.h>
#import "NSArray+extentions.h"


@implementation WASDebugMemoryModel

@synthesize usedBytes = _usedBytes; 
@synthesize totalBytes = _totalBytes;
@synthesize manualBytes = _manualBytes;
@synthesize manualBlocks = _manualBlocks;
@synthesize chartDatas = _chartDatas;
@synthesize upperBound = _upperBound;
@synthesize warningMode = _warningMode;

DEF_SINGLETON( WASDebugMemoryModel )

- (id) init
{
    self = [super init];
    if (self)
    {
        _chartDatas = [[NSMutableArray alloc] init];
        _manualBlocks = [[NSMutableArray alloc] init];
        _upperBound = 0.0f;  
        [self observeTick];
    }
    return self;
}

- (void)dealloc
{
	[self unobserveTick];
	
	[_chartDatas removeAllObjects];
	[_chartDatas release];
	
	for ( NSNumber * block in _manualBlocks )
	{
		void * ptr = (void *)[block unsignedLongLongValue];
		NSZoneFree( NSDefaultMallocZone(), ptr );
		
		[_manualBlocks removeLastObject];
	}
	
	[super dealloc];
}

- (void)allocAll
{
	NSUInteger total = NSRealMemoryAvailable();
	
	for ( ;; )
	{
		if ( _manualBytes + 50 * M >= total )
			break;
        
		void * block = NSZoneCalloc( NSDefaultMallocZone(), 50, M );
		if ( nil == block )
		{
			block = NSZoneMalloc( NSDefaultMallocZone(), 50 * M );
		}
		
		if ( block )
		{			
			_manualBytes += 50 * M;			
			[_manualBlocks addObject:[NSNumber numberWithUnsignedLongLong:(unsigned long long)block]];
		}
		else
		{
			break;
		}
	}
	
	[self handleTick:0.0f];
}

- (void)freeAll
{
	for ( NSNumber * block in _manualBlocks )
	{
		void * ptr = (void *)[block unsignedLongLongValue];
        _manualBytes -= [block unsignedLongLongValue];	
		NSZoneFree( NSDefaultMallocZone(), ptr );
	}
	
	[_manualBlocks removeAllObjects];
	
	[self handleTick:0.0f];
}

- (void)alloc50M
{
	void * block = NSZoneCalloc( NSDefaultMallocZone(), 50, M );
	if ( nil == block )
	{
		block = NSZoneMalloc( NSDefaultMallocZone(), 50 * M );
	}
	
	if ( block )
	{
		_manualBytes += 50 * M;
		[_manualBlocks addObject:[NSNumber numberWithUnsignedLongLong:(unsigned long long)block]];
	}
	
	[self handleTick:0.0f];
}

- (void)free50M
{
	NSNumber * block = [_manualBlocks lastObject];
	if ( block )
	{
		void * ptr = (void *)[block unsignedLongLongValue];
		NSZoneFree( NSDefaultMallocZone(), ptr );
		
		[_manualBlocks removeLastObject];
	}
	
	[self handleTick:0.0f];
}

- (void)toggleWarning
{
	_warningMode = _warningMode ? NO : YES;
	
	[self handleTick:0.0f];	
}

- (void)handleTick:(NSTimeInterval)elapsed
{
	struct mstats stat = mstats();
	
	_usedBytes = stat.bytes_used;
	_totalBytes = NSRealMemoryAvailable();
	
	[_chartDatas addObject:[NSNumber numberWithUnsignedLongLong:_usedBytes]];
	[_chartDatas keepTail:MAX_MEMORY_HISTORY];
    
	_upperBound = 0.0f;
    
	for ( NSNumber * n in _chartDatas )
	{
		if ( [n intValue] > _upperBound )
		{
			_upperBound = [n intValue];
		}
	}
	
	if ( _warningMode )
	{
		[[UIApplication sharedApplication] performSelector:@selector(_performMemoryWarning)];		
	}
}

@end
