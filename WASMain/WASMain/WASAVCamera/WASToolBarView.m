//
//  WASToolBarView.m
//  WASMain
//
//  Created by allen.wang on 8/9/12.
//  Copyright (c) 2012 b5m. All rights reserved.
//

#import "WASToolBarView.h"
#import "WASToolBarItem.h"


@interface WASToolBarView()

- (void) initlize;

@end

@implementation WASToolBarView
@synthesize toolItems = _toolItems;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void) setToolItems:(NSArray *)toolItems
{
    if (toolItems != _toolItems) {
        [_toolItems release];
        _toolItems = [toolItems retain];
        
        [self initlize];
    }
}

- (void) initlize
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    int count = [self.toolItems count];
    CGFloat width = 320.0f / count;
    CGRect  rect  = self.frame;
    rect.origin.y = 0;
    rect.size.width = width;
    rect.size.height= 60;

    for (int i = 0 ; i < count; i++) {
        rect.origin.x = i * width;
        WASToolBarItem *button = [self.toolItems objectAtIndex:i];
        button.frame     = rect;
        [self addSubview:button];
    }
    
}

-(void) addCenterButtonWithImage:(UIImage*)buttonImage highlightImage:(UIImage*)highlightImage  action:(SEL) sel
{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | 
                              UIViewAutoresizingFlexibleLeftMargin  |
                              UIViewAutoresizingFlexibleBottomMargin|
                              UIViewAutoresizingFlexibleTopMargin;
    
    
    button.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:highlightImage forState:UIControlStateSelected];
    
    CGFloat heightDifference = buttonImage.size.height - self.frame.size.height;
    if (heightDifference < 0)
        button.center = self.center;
    else
    {
        CGPoint center = self.center;
        center.y = center.y - heightDifference/2.0;
        button.center = center;
    }
    
    [button addTarget:self.superview action:sel forControlEvents:UIControlEventTouchUpInside];

    [self addSubview:button];
}



- (void) dealloc
{
    [_toolItems release], _toolItems = nil;
    [super dealloc];
}
@end
