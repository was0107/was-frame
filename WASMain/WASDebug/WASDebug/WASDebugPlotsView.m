//
//  WASDebugPlotsView.m
//  WASDebug
//
//  Created by allen.wang on 11/21/12.
//  Copyright (c) 2012 b5m. All rights reserved.
//

#import "WASDebugPlotsView.h"

@implementation WASDebugPlotsView

@synthesize lineColor = _lineColor;
@synthesize lineWidth = _lineWidth;
@synthesize lowerBound = _lowerBound;
@synthesize upperBound = _upperBound;
@synthesize capacity = _capacity;
@synthesize plots = _plots;

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self)
	{
		self.backgroundColor = [UIColor clearColor];
		
		self.lineColor = [UIColor whiteColor];
		self.lineWidth = 1.0f;
		self.lowerBound = 0.0f;
		self.upperBound = 1.0f;
		self.capacity = 50;
	}
	return self;
}

- (void)dealloc
{
	[_lineColor release];
	[_plots release];
	
	[super dealloc];
}

- (void)drawRect:(CGRect)rect
{
	[super drawRect:rect];
    
	CGContextRef context = UIGraphicsGetCurrentContext();
	if ( context )
	{
		CGContextClearRect( context, self.bounds );
		
		CGRect bound = CGRectInset( self.bounds, 4.0f, 4.0f );		
		CGPoint baseLine;
		baseLine.x = bound.origin.x;
		baseLine.y = bound.origin.y + bound.size.height;
		
		CGContextMoveToPoint( context, baseLine.x, baseLine.y );
		
		NSUInteger step = 0;
		
		for ( NSNumber * value in _plots )
		{
			CGFloat f = fminf( fmaxf( [value floatValue], _lowerBound ), _upperBound ) / (_upperBound - _lowerBound);
			CGPoint p = CGPointMake( baseLine.x, baseLine.y - bound.size.height * f );
			
			CGContextAddLineToPoint( context, p.x, p.y );
			
			CGContextSetStrokeColorWithColor( context, self.lineColor.CGColor );
			CGContextSetLineWidth( context, self.lineWidth );
			CGContextSetLineCap( context, kCGLineCapRound );
			CGContextSetLineJoin( context, kCGLineJoinRound );
			
			float lengths[] = { 4, 4 };  
			CGContextSetLineDash( context, 0, lengths, 2 ); 
            
			CGContextStrokePath( context );			
			CGContextMoveToPoint( context, p.x, p.y );
			
			baseLine.x += bound.size.width / _capacity;
			
			step += 1;
			if ( step >= _capacity )
				break;
		}		
	}
}

@end
