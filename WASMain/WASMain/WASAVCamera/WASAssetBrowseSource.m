//
//  WASAssetBrowseSource.m
//  WASMain
//
//  Created by allen.wang on 8/13/12.
//  Copyright (c) 2012 b5m. All rights reserved.
//

#import "WASAssetBrowseSource.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <MobileCoreServices/UTType.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AssetsLibrary/AssetsLibrary.h>


@interface WASAssetBrowseSource ()

@property (nonatomic, copy) NSArray *items; // NSArray of AssetBrowserItems

@end

@implementation WASAssetBrowseSource

@synthesize name = sourceName, items = assetBrowserItems, delegate, type = sourceType;

- (NSString*)nameForSourceType
{
	NSString *name = nil;
	
	switch (sourceType) {
		case WASAssetBrowserSourceTypeFileSharing:
			name = NSLocalizedString(@"File Sharing", nil);
			break;
		case WASAssetBrowserSourceTypeCameraRoll:
			name = NSLocalizedString(@"Camera Roll", nil);
			break;
		case WASAssetBrowserSourceTypeIPodLibrary:
			name = NSLocalizedString(@"iPod Library", nil);
			break;
		default:
			name = nil;
			break;
	}
	
	return name;
}

+ (WASAssetBrowseSource*)assetBrowserSourceOfType:(WASAssetBrowserSourceType)sourceType
{
	return [[[self alloc] initWithSourceType:sourceType] autorelease];
}

- (id)initWithSourceType:(WASAssetBrowserSourceType)type
{
	if ((self = [super init])) {
		sourceType = type;
		sourceName = [[self nameForSourceType] retain];
		assetBrowserItems = [[NSArray array] retain];
		
		enumerationQueue = dispatch_queue_create("Browser Enumeration Queue", DISPATCH_QUEUE_SERIAL);
		dispatch_set_target_queue(enumerationQueue, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0));
	}
	return self;
}

- (void)updateBrowserItemsAndSignalDelegate:(NSArray*)newItems
{	
	self.items = newItems;
    
	/* Ideally we would reuse the AssetBrowserItems which remain unchanged between updates.
	 This could be done by maintaining a dictionary of assetURLs -> AssetBrowserItems.
	 This would also allow us to more easily tell our delegate which indices were added/removed
	 so that it could animate the table view updates. */
	
	if (self.delegate && [self.delegate respondsToSelector:@selector(assetBrowserSourceItemsDidChange:)]) {
		[self.delegate assetBrowserSourceItemsDidChange:self];
	}
}

- (void)dealloc 
{	
	[sourceName release];
	[assetBrowserItems release];
	
	if (receivingIPodLibraryNotifications) {
		MPMediaLibrary *iPodLibrary = [MPMediaLibrary defaultMediaLibrary];
		[iPodLibrary endGeneratingLibraryChangeNotifications];
		[[NSNotificationCenter defaultCenter] removeObserver:self name:MPMediaLibraryDidChangeNotification object:nil];
	}
	dispatch_release(enumerationQueue);
	
	if (assetsLibrary) {
		[[NSNotificationCenter defaultCenter] removeObserver:self name:ALAssetsLibraryChangedNotification object:nil];	
		[assetsLibrary release];
	}
	
    /*
	[directoryWatcher invalidate];
	directoryWatcher.delegate = nil;
	[directoryWatcher release];
     */
	
	[super dealloc];
}

#pragma mark -
#pragma mark iPod Library

- (void)updateIPodLibrary
{
	dispatch_async(enumerationQueue, ^(void) {
		// Grab videos from the iPod Library
		MPMediaQuery *videoQuery = [[MPMediaQuery alloc] init];
		
		NSMutableArray *items = [NSMutableArray arrayWithCapacity:0];
		NSArray *mediaItems = [videoQuery items];
		for (MPMediaItem *mediaItem in mediaItems) {
			NSURL *URL = (NSURL*)[mediaItem valueForProperty:MPMediaItemPropertyAssetURL];
			
			if (URL) {
				NSString *title = (NSString*)[mediaItem valueForProperty:MPMediaItemPropertyTitle];
				WASAssetBrowseItem *item = [[WASAssetBrowseItem alloc] initWithURL:URL title:title];
				[items addObject:item];
				[item release];
			}
		}
		[videoQuery release];
		
		dispatch_async(dispatch_get_main_queue(), ^(void) {
			[self updateBrowserItemsAndSignalDelegate:items];
		});
	});
}

- (void)iPodLibraryDidChange:(NSNotification*)changeNotification
{
	[self updateIPodLibrary];
}

- (void)buildIPodLibrary
{
	MPMediaLibrary *iPodLibrary = [MPMediaLibrary defaultMediaLibrary];
	receivingIPodLibraryNotifications = YES;
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(iPodLibraryDidChange:) 
												 name:MPMediaLibraryDidChangeNotification object:nil];
	[iPodLibrary beginGeneratingLibraryChangeNotifications];
	
	[self updateIPodLibrary];	
}

#pragma mark -
#pragma mark Assets Library

- (void)updateAssetsLibrary
{
	NSMutableArray *assetItems = [NSMutableArray arrayWithCapacity:0];
	ALAssetsLibrary *assetLibrary = assetsLibrary;
	
	[assetLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            [group setAssetsFilter:[ALAssetsFilter allVideos]];
            [group enumerateAssetsUsingBlock:
             ^(ALAsset *asset, NSUInteger index, BOOL *stop)
             {
                 if (asset) {
                     ALAssetRepresentation *defaultRepresentation = [asset defaultRepresentation];
                     NSString *uti = [defaultRepresentation UTI];
                     NSURL *URL = [[asset valueForProperty:ALAssetPropertyURLs] valueForKey:uti];
//                     NSLog(@"URL.TITLE = %@", [URL absoluteString]);
                     NSString *title = [NSString stringWithFormat:@"%@ %i", NSLocalizedString(@"Video", nil), [assetItems count]+1];
                     WASAssetBrowseItem *item = [[[WASAssetBrowseItem alloc] initWithURL:URL title:title] autorelease];
                     
                     [assetItems addObject:item];
                 }
             }];
        }
		// group == nil signals we are done iterating.
		else {
			dispatch_async(dispatch_get_main_queue(), ^{
				[self updateBrowserItemsAndSignalDelegate:assetItems];
			});
		}
	}
                              failureBlock:^(NSError *error) {
                                  NSLog(@"error enumerating AssetLibrary groups %@\n", error);
                              }];
}

- (void)assetsLibraryDidChange:(NSNotification*)changeNotification
{
	[self updateAssetsLibrary];
}

- (void)buildAssetsLibrary
{
	assetsLibrary = [[ALAssetsLibrary alloc] init];
	ALAssetsLibrary *notificationSender = nil;
	
	NSString *minimumSystemVersion = @"4.1";
	NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
	if ([systemVersion compare:minimumSystemVersion options:NSNumericSearch] != NSOrderedAscending)
		notificationSender = assetsLibrary;
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(assetsLibraryDidChange:) 
												 name:ALAssetsLibraryChangedNotification object:notificationSender];
	[self updateAssetsLibrary];
}

#pragma mark -
#pragma mark iTunes File Sharing

- (NSArray*)browserItemsInDirectory:(NSString*)directoryPath
{
	NSMutableArray *paths = [NSMutableArray arrayWithCapacity:0];
	NSArray *subPaths = [[[[NSFileManager alloc] init] autorelease] contentsOfDirectoryAtPath:directoryPath error:nil];
	if (subPaths) {
		for (NSString *subPath in subPaths) {
			NSString *pathExtension = [subPath pathExtension];
			CFStringRef preferredUTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (CFStringRef)pathExtension, NULL);
			BOOL fileConformsToUTI = UTTypeConformsTo(preferredUTI, kUTTypeAudiovisualContent);
			CFRelease(preferredUTI);
			NSString *path = [directoryPath stringByAppendingPathComponent:subPath];
			
			if (fileConformsToUTI) {
				[paths addObject:path];
			}
		}
	}
	
	NSMutableArray *browserItems = [NSMutableArray arrayWithCapacity:0];
	for (NSString *path in paths) {
		WASAssetBrowseItem *item = [[[WASAssetBrowseItem alloc] initWithURL:[NSURL fileURLWithPath:path]] autorelease];
		[browserItems addObject:item];
	}
	return browserItems;
}

/*
- (void)directoryDidChange:(DirectoryWatcher *)folderWatcher
{
	NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	dispatch_async(enumerationQueue, ^(void) {
		NSArray *browserItems = [self browserItemsInDirectory:documentsDirectory];
		dispatch_async(dispatch_get_main_queue(), ^(void) {
			[self updateBrowserItemsAndSignalDelegate:browserItems];
		});
	});
}
*/
- (void)buildFileSharingLibrary
{
	NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSArray *browserItems = [self browserItemsInDirectory:documentsDirectory];
	[self updateBrowserItemsAndSignalDelegate:browserItems];
//	directoryWatcher = [[DirectoryWatcher watchFolderWithPath:documentsDirectory delegate:self] retain];
}

- (void)buildSourceLibrary
{
	if (haveBuiltSourceLibrary)
		return;
	
	switch (sourceType) {
		case WASAssetBrowserSourceTypeFileSharing:
			[self buildFileSharingLibrary];
			break;
		case WASAssetBrowserSourceTypeCameraRoll:
			[self buildAssetsLibrary];
			break;
		case WASAssetBrowserSourceTypeIPodLibrary:
			[self buildIPodLibrary];
			break;
		default:
			break;
	}
	
	haveBuiltSourceLibrary = YES;
}
@end
