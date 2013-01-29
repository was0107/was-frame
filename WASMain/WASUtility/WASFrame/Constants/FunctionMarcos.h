//
//  FunctionMarcos.h
//  WASUtility
//
//  Created by allen.wang on 9/17/12.
//  Copyright (c) 2012 b5m. All rights reserved.
//

#import "BaseMacros.h"
#import "CGMacros.h"



CG_INLINE void
setUIViewWidth(UIView* view, int value) {
    CGRect frame = view.frame;
    frame.size.width = value;
    view.frame = frame;
}

CG_INLINE void
setUIViewHeight(UIView* view, int value) {
    CGRect frame = view.frame;
    frame.size.height = value;
    view.frame = frame;
}

CG_INLINE void
setUIViewOrigin(UIView* view, CGPoint value) {
    CGRect frame = view.frame;
    frame.origin = value;
    view.frame = frame;
}

CG_INLINE void
setUIViewSize(UIView* view, CGSize value) {
    CGRect frame = view.frame;
    frame.size = value;
    view.frame = frame;
}

CG_INLINE void
setUIViewWidthHeight(UIView* view, int width, int height) {
    CGRect frame = view.frame;
    frame.size.width = width;
    frame.size.height = height;
    view.frame = frame;
}

#ifndef RANDOM_INT
#define RANDOM_INT() (arc4random())
#endif


CG_INLINE UIColor*
UIColorRGB(unsigned int argb) {
	int red = (argb >> 16) & 0xff;
	int green = (argb >> 8) & 0xff;
	int blue = (argb >> 0) & 0xff;
	return [UIColor colorWithRed:red/255.0f
                           green:green/255.0f
                            blue:blue/255.0f
                           alpha:1.0f];
}

CG_INLINE UIColor*
UIColorRGBA(unsigned int argb) {
	int alpha = (argb >> 24) & 0xff;
	int red = (argb >> 16) & 0xff;
	int green = (argb >> 8) & 0xff;
	int blue = (argb >> 0) & 0xff;
	return [UIColor colorWithRed:red/255.0f
                           green:green/255.0f
                            blue:blue/255.0f
                           alpha:alpha/255.0f];
}

CG_INLINE UIColor*
UIColorRGBWithAlpha(unsigned int argb, CGFloat alpha) {
	int red = (argb >> 16) & 0xff;
	int green = (argb >> 8) & 0xff;
	int blue = (argb >> 0) & 0xff;
	return [UIColor colorWithRed:red/255.0f
                           green:green/255.0f
                            blue:blue/255.0f
                           alpha:alpha];
}

