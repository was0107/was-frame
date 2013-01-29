//
//  WASMultipleControl.m
//  WASMain
//
//  Created by allen.wang on 8/9/12.
//  Copyright (c) 2012 b5m. All rights reserved.
//

#import "WASMultipleControl.h"


#define kLeftWidth          16.0f
#define kRightWidth         kLeftWidth
#define kMiddleWidth        50.0f


@interface WASMultipleControl()
@property (nonatomic, assign) BOOL isTapped;
@property (nonatomic, assign) BOOL isClicked;
@end

@interface WASMultipleControl(InternalMethods)

/**
 *	@brief	set the contents
 *
 *	@param 	contents 	
 */
- (void) setContents:(NSArray *)contents ;

/**
 *	@brief	set current items , 
 *
 *	@param 	currentItem 	
 */
- (void) setCurrentItem:(NSUInteger)currentItem;

/**
 *	@brief	set is tapped or not
 *
 *	@param 	isTapped 	
 */
- (void) setIsTapped:(BOOL)isTapped ;

@end    

@implementation WASMultipleControl
@synthesize tipImage = _tipImage;
@synthesize contents = _contents;
@synthesize currentItem= _currentItem;
@synthesize isTapped   = _isTapped;
@synthesize isClicked  = _isClicked;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void) addTipImage:(UIImage *)image contents:(NSArray *)array selected:(NSUInteger )item
{
    self.tipImage = image;
    self.contents = array;
    [self setCurrentItem:item];
    
    [self setIsTapped:NO];
    self.backgroundColor = [UIColor clearColor];
    self.alpha           = 0.5f;
    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect newRect = rect;
    
    if (self.contents) {
        newRect  = CGRectMake(8, 8,15,rect.size.height-12);
    }
    else {
        newRect  = CGRectMake(kLeftWidth, 8,kMiddleWidth,rect.size.height-12);
    }
    
    if (self.tipImage) {        
        [self.tipImage drawInRect:newRect];
    }
    
    [[UIColor blackColor] setFill];
    CGFloat fontSize = 18.0f;
    
    if (self.contents) 
    {
        if (self.isTapped) {
            for (int i = 0; i< [self.contents count]; i++) {
                NSString *string = [self.contents objectAtIndex:i];
                newRect = CGRectMake(kLeftWidth + kMiddleWidth *i + 10, (rect.size.height - fontSize)/2-2, kMiddleWidth, rect.size.height);
                [string drawInRect:newRect withFont:[UIFont systemFontOfSize:fontSize]];
                
                if (i> 0 && i < [self.contents count]) {
                    
                    CGContextDrawPath(context, kCGPathFillStroke);
                    CGContextBeginPath(context);
                    [[UIColor blackColor] setStroke];
                    CGContextSetLineWidth(context,1.0f);
                    CGContextMoveToPoint(context, kLeftWidth + kMiddleWidth *i + 5, 2);
                    CGContextAddLineToPoint(context, kLeftWidth + kMiddleWidth *i + 5, rect.size.height-1);
                    CGContextStrokePath(context);
                }
            }
        }
        else {
            NSString *string = [self.contents objectAtIndex:_currentItem];
            newRect = CGRectMake(kLeftWidth + 10 , (rect.size.height - fontSize)/2 -2, kMiddleWidth, rect.size.height);
            [string drawInRect:newRect withFont:[UIFont systemFontOfSize:fontSize]];
        }
        
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
    if(touches.count==1)
    {
        for (UITouch *touch in touches)
        {
            CGPoint pos = [touch locationInView:self];
            if(pos.x>=0 && 
               pos.y>=0 &&
               pos.x<self.bounds.size.width && 
               pos.y<self.bounds.size.height)
                
                self.isTapped = !self.isTapped;
            if (_isClicked) {
                [self sendActionsForControlEvents:UIControlEventTouchUpInside];
                _isClicked =    NO;
            }
            
            if (!self.isTapped) {
                [self setCurrentItem:(pos.x - kLeftWidth - kRightWidth)/kMiddleWidth];
            }
        }
    }
    
    [super touchesEnded:touches withEvent:event];
    
}

- (void) dealloc
{
    self.tipImage = nil;
    self.contents = nil;
    [super dealloc];
}

@end



@implementation WASMultipleControl(InternalMethods)
- (void) setContents:(NSArray *)contents    
{
    if (contents != _contents) {
        [_contents release];
        _contents = [contents retain];
        
    }
}

- (void) setCurrentItem:(NSUInteger)currentItem
{
    if (currentItem != _currentItem) {
        if (self.contents) {
            if (currentItem > [self.contents count]) {
                _currentItem = 0;
                return;
            }
            _currentItem = currentItem;
            [self sendActionsForControlEvents:UIControlEventValueChanged];
            
        }
        else {
            _currentItem = 0;
        }
    }
}

- (void) setIsTapped:(BOOL)isTapped 
{
    if (_isTapped != isTapped) {
        _isTapped  = isTapped;
        
        if (!self.contents) {
            return;
        }
        NSUInteger count = 1;
        if (_isTapped) {
            count = [self.contents count];
        }
        
        [UIView animateWithDuration:0.2f animations:^{
            
            CGRect rect = self.frame;
            rect.size.width   = kLeftWidth + kRightWidth + kMiddleWidth * count;
            self.frame = rect;
            
            [self setNeedsDisplay];
        } completion:^(BOOL finished) {
        }];
        
    }
}

@end 
