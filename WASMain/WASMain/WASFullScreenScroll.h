//
//  WASFullScreenScroll.h
//  WASMain
//
//  Created by allen.wang on 7/13/12.
//  Copyright (c) 2012 b5m. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WASFullScreenScrollDelegate <NSObject>

- (void)scrollView:(UIScrollView*)scrollView deltaY:(CGFloat)deltaY;

@end

@interface WASFullScreenScroll : NSObject<UIScrollViewDelegate>
{
    CGFloat _prevContentOffsetY;
    
    BOOL    _isScrollingTop;
}
@property (nonatomic,  retain) UIView *contentView;
@property (nonatomic) BOOL enabled;
@property (nonatomic) BOOL shouldShowUIBarsOnScrollUp;
@property (nonatomic, assign) id<WASFullScreenScrollDelegate> delegate;

- (id)initWithView:(UIView*)theContentView;

@end
