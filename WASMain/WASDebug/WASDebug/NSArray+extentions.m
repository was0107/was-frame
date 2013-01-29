//
//  NSArray+extentions.m
//  WASDebug
//
//  Created by allen.wang on 11/21/12.
//  Copyright (c) 2012 b5m. All rights reserved.
//

#import "NSArray+extentions.h"

@implementation NSArray(extentions)

- (NSArray *)head:(NSUInteger)count
{
	if ( [self count] < count )
	{
		return self;
	}
	else
	{
		NSMutableArray * tempFeeds = [NSMutableArray array];
		for ( NSObject * elem in self )
		{
			[tempFeeds addObject:elem];
			if ( [tempFeeds count] >= count )
				break;
		}
		return tempFeeds;
	}
}

- (NSArray *)tail:(NSUInteger)count
{
	return self;
}

@end

#pragma mark -

@implementation NSMutableArray(extentions)

- (NSMutableArray *)pushHead:(NSObject *)obj
{
	if ( obj )
	{
		[self insertObject:obj atIndex:0];
	}
	
	return self;
}

- (NSMutableArray *)pushHeadN:(NSArray *)all
{
	if ( [all count] )
	{	
		for ( NSUInteger i = [all count]; i > 0; --i )
		{
			[self insertObject:[all objectAtIndex:i - 1] atIndex:0];
		}
	}
	
	return self;
}

- (NSMutableArray *)popTail
{
	if ( [self count] > 0 )
	{
		[self removeObjectAtIndex:[self count] - 1];
	}
	
	return self;
}

- (NSMutableArray *)popTailN:(NSUInteger)n
{
	if ( [self count] > 0 )
	{
		if ( n >= [self count] )
		{
			[self removeAllObjects];
		}
		else
		{
			NSRange range;
			range.location = n;
			range.length = [self count] - n;
			
			[self removeObjectsInRange:range];
		}
	}
	
	return self;
}

- (NSMutableArray *)pushTail:(NSObject *)obj
{
	if ( obj )
	{
		[self addObject:obj];		
	}
	
	return self;
}

- (NSMutableArray *)pushTailN:(NSArray *)all
{
	if ( [all count] )
	{
		[self addObjectsFromArray:all];		
	}
	
	return self;
}

- (NSMutableArray *)popHead
{
	if ( [self count] )
	{
		[self removeLastObject];
	}
	
	return self;
}

- (NSMutableArray *)popHeadN:(NSUInteger)n
{
	if ( [self count] > 0 )
	{
		if ( n >= [self count] )
		{
			[self removeAllObjects];
		}
		else
		{
			NSRange range;
			range.location = 0;
			range.length = n;
			
			[self removeObjectsInRange:range];
		}
	}
	
	return self;
}

- (NSMutableArray *)keepHead:(NSUInteger)n
{
	if ( [self count] > n )
	{
		NSRange range;
		range.location = n;
		range.length = [self count] - n;
		
		[self removeObjectsInRange:range];		
	}
	
	return self;
}

- (NSMutableArray *)keepTail:(NSUInteger)n
{
	if ( [self count] > n )
	{
		NSRange range;
		range.location = 0;
		range.length = [self count] - n;
		
		[self removeObjectsInRange:range];		
	}
	
	return self;
}

- (void)addObjectNoRetain:(NSObject *)object
{
	[self addObject:object];
	[object release];
}

- (void)removeObjectNoRelease:(NSObject *)object
{
	[object retain];
	[self removeObject:object];
}

- (void)removeAllObjectsNoRelease
{
	for ( NSObject * object in self )
	{
		[object retain];
	}	
	
	[self removeAllObjects];
}

@end
