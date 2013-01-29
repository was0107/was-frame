//
//  WASAssetBrowseItem.h
//  WASMain
//
//  Created by allen.wang on 8/13/12.
//  Copyright (c) 2012 b5m. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMedia/CMTime.h>
@class AVAsset;


enum {
	WASAssetBrowserItemFillModeCrop,
	WASAssetBrowserItemFillModeAspectFit
};
typedef NSInteger WASAssetBrowserItemFillMode;

CGRect makeRectWithAspectRatioOutsideRect(CGSize aspectRatio, CGRect containerRect);


@interface WASAssetBrowseItem : NSObject
{
@private	
	NSURL       *assetURL;
	UIImage     *thumbnailImage;
	NSString    *assetTitle;
	BOOL        haveRichestTitle;
	BOOL        audioOnly;
	BOOL        canGenerateThumbnails;
    
    AVAsset     *asset;
	dispatch_queue_t assetQueue;
}

- (id)initWithURL:(NSURL*)URL;
- (id)initWithURL:(NSURL*)URL title:(NSString*)title; // title can be nil.

/* With AssetBrowserItemFillModeAspectFit size acts as a maximum size. Pass CGRectZero for a full size thumbnail;
 With AssetBrowserItemFillModeCrop the image is cropped to fit size. If the asset does not have enough resolution 
 than the returned image have be the aspect ratio specified by size, but lower resolution.
 Retrieve the generated thumbnail with the thumbnailImage property. */
- (void)generateThumbnailAsynchronouslyWithSize:(CGSize)size fillMode:(WASAssetBrowserItemFillMode)mode completionHandler:(void (^)(UIImage *thumbnail))handler;
- (UIImage*)placeHolderImage;

- (void)generateTitleFromMetadataAsynchronouslyWithCompletionHandler:(void (^)(NSString *title))handler;

@property (nonatomic, readonly) NSURL *URL;
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic,   copy)         NSString *duration;
@property (nonatomic, readonly) BOOL haveRichestTitle;
@property (nonatomic, readonly, retain) UIImage *thumbnailImage;
@property (nonatomic, readonly) AVAsset *asset;

- (void)clearThumbnailCache;
- (void)clearAssetCache;

@end

