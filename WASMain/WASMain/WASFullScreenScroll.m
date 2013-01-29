//
//  WASFullScreenScroll.m
//  WASMain
//
//  Created by allen.wang on 7/13/12.
//  Copyright (c) 2012 b5m. All rights reserved.
//

#import "WASFullScreenScroll.h"

@implementation WASFullScreenScroll
@synthesize contentView = _contentView;
@synthesize enabled = _enabled;
@synthesize shouldShowUIBarsOnScrollUp = _shouldShowUIBarsOnScrollUp;
@synthesize delegate= _delegate;


- (id)initWithView:(UIView*)theContentView
{
    self = [super init];
    if (self) {
        self.enabled = YES;
        self.shouldShowUIBarsOnScrollUp = YES;
        _contentView = theContentView;
    }
    return self;

}

- (void)_layoutWithScrollView:(UIScrollView*)scrollView deltaY:(CGFloat)deltaY
{
    if (!self.enabled) 
        return;
    if (_delegate && [_delegate respondsToSelector:@selector(scrollView:deltaY:)]) {
        [_delegate scrollView:scrollView deltaY:deltaY];
    }
    
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _prevContentOffsetY = scrollView.contentOffset.y;
    NSLog(@"111scrollViewWillBeginDragging = %f", _prevContentOffsetY);

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.decelerating) {
        return;
    }
    if (scrollView.dragging || _isScrollingTop) 
    {
        CGFloat deltaY = scrollView.contentOffset.y-_prevContentOffsetY;
        _prevContentOffsetY = MAX(scrollView.contentOffset.y, -scrollView.contentInset.top);
//        NSLog(@"222scrollViewDidScroll = %f", _prevContentOffsetY);

//        NSLog(@"scrollViewDidScroll deltaY = %f MAX(scrollView.contentOffset.y = %f, -scrollView.contentInset.top = %f)",deltaY,scrollView.contentOffset.y, -scrollView.contentInset.top);
        if (!self.shouldShowUIBarsOnScrollUp && deltaY < 0 && scrollView.contentOffset.y > 0 && !_isScrollingTop) {
            deltaY = abs(deltaY);
        }
        
        [self _layoutWithScrollView:scrollView deltaY:deltaY];
    }
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    _prevContentOffsetY = scrollView.contentOffset.y;
    NSLog(@"333scrollViewShouldScrollToTop = %f", _prevContentOffsetY);
    _isScrollingTop = YES;
    return YES;
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    _isScrollingTop = NO;
}

@end
