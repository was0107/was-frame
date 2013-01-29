//
//  WASDebugMemoryModel.h
//  WASDebug
//
//  Created by allen.wang on 11/21/12.
//  Copyright (c) 2012 b5m. All rights reserved.
//

#import <Foundation/Foundation.h>



#undef	MAX_MEMORY_HISTORY
#define MAX_MEMORY_HISTORY	(50)

#pragma mark -

@interface WASDebugMemoryModel : NSObject
{
	int64_t				_usedBytes;
	int64_t				_totalBytes;
	int64_t				_manualBytes;
	NSMutableArray *	_manualBlocks;
	NSMutableArray *	_chartDatas;
	NSUInteger			_upperBound;
	BOOL				_warningMode;
}

@property (nonatomic, readonly) int64_t				usedBytes;
@property (nonatomic, readonly) int64_t				totalBytes;
@property (nonatomic, readonly) int64_t				manualBytes;
@property (nonatomic, readonly) NSMutableArray *	manualBlocks;
@property (nonatomic, readonly) NSMutableArray *	chartDatas;
@property (nonatomic, readonly) NSUInteger			upperBound;
@property (nonatomic, readonly) BOOL				warningMode;

AS_SINGLETON( WASDebugMemoryModel )

- (void)allocAll;
- (void)freeAll;

- (void)alloc50M;
- (void)free50M;

- (void)toggleWarning;

@end
