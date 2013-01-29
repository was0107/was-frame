//
//  WASToolBarItem.m
//  WASMain
//
//  Created by allen.wang on 8/10/12.
//  Copyright (c) 2012 b5m. All rights reserved.
//

#import "WASToolBarItem.h"

#define kColorLineHeight            5.0f
#define kNameFrameHeight            20.0f
#define kNameFontSize               16.0f
#define kImageFrameHeight           30.0f

@interface WASToolBarItem() 
{
    BOOL _isSelected;
    BOOL _isClicked;

}

@end

@interface WASToolBarItem(InternalMethods) 

/**
 *	@brief	check the touches , if the touch in current view , then set it selected
 *
 *	@param 	touches 	
 *
 *	@return	YES , It's in the current view.
 */
- (BOOL) isInPosition:(NSSet *)touches ;

@end

@implementation WASToolBarItem
@synthesize lineColor = _lineColor;
@synthesize name      = _name;
@synthesize image     = _image;
@synthesize selectedImage = _selectedImage;
@synthesize type      = _type;
@synthesize isSelected=_isSelected;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) dealloc
{
    [_lineColor release], _lineColor = nil;
    [_name release], _name = nil;
    [_image release], _image = nil;
    [_selectedImage release], _selectedImage = nil;
    [super dealloc];
}


- (void) setIsSelected:(BOOL)isSelected 
{
    if (_isSelected != isSelected) {
        _isSelected   = isSelected;
        
        [self setNeedsDisplay];
        
        
        NSLog(@"isSelected = %d", _isSelected);
    }
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    [[UIColor grayColor] set];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawPath(context, kCGPathFillStroke);
    CGContextBeginPath(context);
    [_lineColor setStroke];
    CGContextFillRect(context, CGRectMake(0.0f , 
                                          (_type == EWAS_TOOLBAR_ITEM_TYPE_TOP)?kColorLineHeight:(rect.size.height - kColorLineHeight) ,
                                          rect.size.width, 
                                          kColorLineHeight));
    CGContextStrokePath(context);
    
    CGFloat _nameStartY = (_type == EWAS_TOOLBAR_ITEM_TYPE_TOP)?(rect.size.height - kColorLineHeight):
                                                                (rect.size.height - kColorLineHeight - kNameFrameHeight);
    [_name drawInRect:CGRectMake(0, _nameStartY, rect.size.width, kNameFrameHeight) 
             withFont:[UIFont systemFontOfSize:kNameFontSize]
        lineBreakMode:UILineBreakModeMiddleTruncation 
            alignment:UITextAlignmentCenter];
    
    
    if (_isSelected) {
        [_selectedImage drawInRect:CGRectMake(0, _nameStartY - kImageFrameHeight, rect.size.width, kImageFrameHeight)];
    }
    else {
        [_image drawInRect:CGRectMake(0, _nameStartY - kImageFrameHeight, rect.size.width, kImageFrameHeight)];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    _isClicked = YES;
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    _isClicked = NO;
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    _isClicked = NO;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self isInPosition:touches]) {
        
        if (_isClicked) {
            [self sendActionsForControlEvents:UIControlEventTouchUpInside];
            _isClicked =    NO;
        }
    }
    
    [super touchesEnded:touches withEvent:event];
}

@end

@implementation WASToolBarItem(InternalMethods) 

- (BOOL) isInPosition:(NSSet *)touches 
{
    if(touches.count==1)
    {
        for (UITouch *touch in touches)
        {
            CGPoint pos = [touch locationInView:self];
            if(pos.x>=0 && 
               pos.y>=0 &&
               pos.x<self.bounds.size.width && 
               pos.y<self.bounds.size.height)
                
                return YES;
        }
    }
    
    return NO;
}


@end
