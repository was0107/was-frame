//
//  WASVideoButton.m
//  WASMain
//
//  Created by allen.wang on 8/13/12.
//  Copyright (c) 2012 b5m. All rights reserved.
//

#import "WASVideoButton.h"
#import "WASAssetBrowseItem.h"

#define KVideoFontSize          14.0f
static NSUInteger maxVideoConcurrentOperationCount = 24;


@interface WASVideoButton()
@property (readwrite, nonatomic, retain) NSBlockOperation *was_videoThumbImageOperation;


@end

@implementation WASVideoButton
@synthesize item   = _item;
@synthesize was_videoThumbImageOperation;

+ (NSOperationQueue *)was_sharedVideThumbOperationQueue {
    static NSOperationQueue *_was_sharedVideThumbOperationQueue = nil;
    
    if (!_was_sharedVideThumbOperationQueue) {
        _was_sharedVideThumbOperationQueue = [[NSOperationQueue alloc] init];
        [_was_sharedVideThumbOperationQueue setMaxConcurrentOperationCount:maxVideoConcurrentOperationCount];
    }
    
    return _was_sharedVideThumbOperationQueue;
}



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) setItem:(WASAssetBrowseItem *)item 
{
    if (item != _item) {
        [_item release];
        _item = [item retain];
        
        if (!_item.thumbnailImage) {
            
            void (^block)() = ^
            {
                [_item generateThumbnailAsynchronouslyWithSize:CGSizeMake(75, 75) fillMode:WASAssetBrowserItemFillModeCrop completionHandler:^(UIImage *thumbnail)
                 {
                     [self performSelectorOnMainThread:@selector(setNeedsDisplay) withObject:nil waitUntilDone:NO];
                 }];
            };
            
            NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:block];
            [[[self class] was_sharedVideThumbOperationQueue] addOperation:operation];
        }
        else {
            [self setNeedsDisplay];
            
        }
    }
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    CGRect newRect = rect;
    newRect.origin.y  = rect.size.height - KVideoFontSize;
    newRect.size.height = KVideoFontSize;
    
    [_item.thumbnailImage drawInRect:rect];
    
    [[[UIColor grayColor] colorWithAlphaComponent:0.5f] set];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawPath(context, kCGPathFillStroke);
    CGContextBeginPath(context);
    [[UIColor blackColor] setStroke];
    CGContextFillRect(context, newRect);
    CGContextStrokePath(context);
    
    [[UIColor whiteColor] set];
    
    [_item.duration drawInRect:newRect
            withFont:[UIFont systemFontOfSize:KVideoFontSize]
       lineBreakMode:UILineBreakModeMiddleTruncation
           alignment:UITextAlignmentLeft];
}


@end
