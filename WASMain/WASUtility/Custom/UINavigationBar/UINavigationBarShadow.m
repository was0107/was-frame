//
//  UINavigationBarShadow.m
//  WASUtility
//
//  Created by allen.wang on 9/17/12.
//  Copyright (c) 2012 b5m. All rights reserved.
//

#import "UINavigationBarShadow.h"
#import <QuartzCore/QuartzCore.h>


@interface UINavigationBarShadow()
@property (nonatomic, retain) UIImage *image;

@end

@implementation UINavigationBarShadow
@synthesize image = _image;
@synthesize imageName = _imageName;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _image = [UIImage imageNamed:self.imageName];
    if (!_image) {
        return;
    }
    self.tintColor = [UIColor colorWithRed:46.0 / 255.0 green:149.0 / 255.0 blue:206.0 / 255.0 alpha:1.0];
    
    // draw shadow
    self.layer.masksToBounds = NO;
    self.layer.shadowOffset = CGSizeMake(0, 3);
    self.layer.shadowOpacity = 0.6;
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
}

- (void)drawRect:(CGRect)rect
{
    if (!_image) {
        return;
    }
    [_image drawInRect:rect];
}


@end
