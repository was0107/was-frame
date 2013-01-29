//
//  WASAssetBrosweSource.h
//  WASMain
//
//  Created by allen.wang on 8/13/12.
//  Copyright (c) 2012 b5m. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WASAssetBrowseItem.h"

@class ALAssetsLibrary;

enum {
	WASAssetBrowserSourceTypeFileSharing			= 1 << 0, /**< FILE SHARING */
	WASAssetBrowserSourceTypeCameraRoll             = 1 << 1, /**< CAMERA ROLL */
	WASAssetBrowserSourceTypeIPodLibrary			= 1 << 2, /**< IPOD LIBRARY */
	WASAssetBrowserSourceTypeAll					= 0xFFFFFFFF /**< ALL */
};
typedef NSUInteger WASAssetBrowserSourceType;

@protocol WASAssetBrowserSourceDelegate;

@class ALAssetsLibrary;

@interface WASAssetBrowseSource : NSObject
{
@private	
	WASAssetBrowserSourceType   sourceType;
	NSString                    *sourceName;
	NSArray                     *assetBrowserItems;
	BOOL                        haveBuiltSourceLibrary;
	BOOL                        receivingIPodLibraryNotifications;
    ALAssetsLibrary             *assetsLibrary;
	dispatch_queue_t            enumerationQueue;
    id <WASAssetBrowserSourceDelegate> delegate;

}

+ (WASAssetBrowseSource*)assetBrowserSourceOfType:(WASAssetBrowserSourceType)sourceType;

- (id)initWithSourceType:(WASAssetBrowserSourceType)sourceType;

- (void)buildSourceLibrary;

@property (nonatomic, readonly)         NSString *name;
@property (nonatomic, readonly, copy)   NSArray *items; // NSArray of AssetBrowserItems
@property (nonatomic, readonly)         WASAssetBrowserSourceType type;
@property (nonatomic, assign) id <WASAssetBrowserSourceDelegate> delegate;

@end

@protocol WASAssetBrowserSourceDelegate <NSObject>;
@optional
- (void)assetBrowserSourceItemsDidChange:(WASAssetBrowseSource*)source;
@end
