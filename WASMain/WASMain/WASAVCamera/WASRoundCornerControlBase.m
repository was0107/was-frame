//
//  WASRoundCornerControl.m
//  WASMain
//
//  Created by allen.wang on 8/9/12.
//  Copyright (c) 2012 b5m. All rights reserved.
//

#import "WASRoundCornerControlBase.h"

@implementation WASRoundCornerControlBase

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [[UIColor blackColor] set];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, self.bounds);
    
    CGFloat cornerRadius = rect.size.height/2.0;
    [[UIColor whiteColor] setFill];
    CGPathRef shade = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(rect.origin.x+2, rect.origin.y+2, rect.size.width-4, 
                                                                         cornerRadius+rect.size.height/2.0-4) 
                                                 cornerRadius:cornerRadius].CGPath;
    CGContextAddPath(context, shade);
    CGContextDrawPath(context, kCGPathFillStroke);

}


@end
