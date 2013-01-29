//
//  CGMarcos.h
//  WASUtility
//
//  Created by allen.wang on 9/17/12.
//  Copyright (c) 2012 b5m. All rights reserved.
//

#import "BaseMacros.h"


#ifndef FormatCGSize
#define FormatCGSize(__value) NSStringFromCGSize(__value)
#endif
#ifndef FormatCGPoint
#define FormatCGPoint(__value) NSStringFromCGPoint(__value)
#endif
#ifndef FormatCGRect
#define FormatCGRect(__value) NSStringFromCGRect(__value)
#endif
#ifndef FormatSize
#define FormatSize(__value) FormatCGSize(__value)
#endif
#ifndef FormatPoint
#define FormatPoint(__value) FormatCGPoint(__value)
#endif
#ifndef FormatRect
#define FormatRect(__value) FormatCGRect(__value)
#endif

#ifndef DebugSize
#define DebugSize(__name, __value) NSLog(@"%@: %@", __name, NSStringFromCGSize(__value))
#endif
#ifndef DebugPoint
#define DebugPoint(__name, __value) NSLog(@"%@: %@", __name, NSStringFromCGPoint(__value))
#endif
#ifndef DebugRect
#define DebugRect(__name, __value) NSLog(@"%@: %@", __name, NSStringFromCGRect(__value))
#endif


#pragma mark
#pragma mark CGPoint


CG_INLINE CGPoint
CGPointAdd(const CGPoint p1, const CGPoint p2) {
	return CGPointMake(p1.x + p2.x, p1.y + p2.y);
}

CG_INLINE CGPoint
CGPointAdd3(const CGPoint p1, const CGPoint p2, const CGPoint p3) {
	return CGPointMake(p1.x + p2.x + p3.x, p1.y + p2.y + p3.y);
}

CG_INLINE CGPoint
CGPointSubtract(const CGPoint p0, const CGPoint p1) {
    return CGPointMake(p0.x - p1.x,
                       p0.y - p1.y);
}

CG_INLINE CGPoint
CGPointMax(const CGPoint p1, const CGPoint p2) {
	return CGPointMake(max(p1.x, p2.x),
                       max(p1.y, p2.y));
}

CG_INLINE CGPoint
CGPointRound(const CGPoint p1) {
	return CGPointMake(roundf(p1.x),
                       roundf(p1.y));
}

CG_INLINE CGFloat
CGPointDistance(CGPoint p0, CGPoint p1) {
    CGFloat result = sqrtf(sqr(p0.x - p1.x) + sqr(p0.y - p1.y));
    return result;
}

CG_INLINE CGFloat
CGPointLength(CGPoint p1) {
    return sqrtf(sqr(p1.x) + sqr(p1.y));
    
}

CG_INLINE CGPoint
CGPointScale(const CGPoint p0, const CGFloat factor) {
    return CGPointMake(p0.x * factor,
                       p0.y * factor);
}

CG_INLINE CGPoint
CGPointInvert(const CGPoint p0) {
    return CGPointMake(-p0.x,
                       -p0.y);
}

CG_INLINE CGFloat
CGPointDotProduct(const CGPoint p1, const CGPoint p2) {
	return (p1.x * p2.x) + (p1.y * p2.y);
}

CG_INLINE CGPoint
CGPointNormalize(const CGPoint p0) {
    return CGPointScale(p0, 1.0f / CGPointLength(p0));
}

CG_INLINE CGPoint
CGPointBlendFast(const CGPoint p1, const CGPoint p2, const CGFloat factor, const CGFloat nfactor) {
	CGPoint p = {
		p1.x * nfactor + p2.x * factor,
		p1.y * nfactor + p2.y * factor,
	};
	return p;
}

CG_INLINE CGPoint
CGPointBlend(const CGPoint p1, const CGPoint p2, const CGFloat value) {
	CGFloat factor = clamp01(value);
	CGFloat nfactor = 1.0f - factor;
	return CGPointBlendFast(p1, p2, factor, nfactor);
}


#pragma mark
#pragma mark CGSize


CG_INLINE CGSize
CGSizeAdd(const CGSize p1, const CGSize p2) {
	return CGSizeMake(p1.width + p2.width,
                      p1.height + p2.height);
}

CG_INLINE CGSize
CGSizeSubtract(const CGSize p1, const CGSize p2) {
	return CGSizeMake(p1.width - p2.width,
                      p1.height - p2.height);
}

CG_INLINE CGSize
CGSizeMax(const CGSize p1, const CGSize p2) {
	return CGSizeMake(max(p1.width, p2.width),
                      max(p1.height, p2.height));
}

CG_INLINE CGSize
CGSizeMin(const CGSize p1, const CGSize p2) {
	return CGSizeMake(min(p1.width, p2.width),
                      min(p1.height, p2.height));
}

CG_INLINE CGSize
CGSizeFitInSize(CGSize r0, CGSize r1) {
    if (r0.width <= r1.width && r0.height <= r1.height) {
        return r0;
    }
    CGFloat widthFactor = r1.width / r0.width;
    CGFloat heightFactor = r1.height / r0.height;
    CGFloat factor = min(widthFactor, heightFactor);
    CGSize result;
    result.width = roundf(r0.width * factor);
    result.height = roundf(r0.height * factor);
    return result;
}


#pragma mark
#pragma mark CGRect


CG_INLINE CGRect
CGSizeCenterOnRect(CGSize r0, CGRect r1) {
    CGRect result;
    result.origin.x = roundf(r1.origin.x + (r1.size.width - r0.width) * 0.5f);
    result.origin.y = roundf(r1.origin.y + (r1.size.height - r0.height) * 0.5f);
    result.size = r0;
    return result;
}


CG_INLINE CGRect
CGRectCenterOnRect(CGRect r0, CGRect r1) {
    return CGSizeCenterOnRect(r0.size, r1);
}


CG_INLINE CGPoint
CGRectCenter(const CGRect r) {
	return CGPointMake(r.origin.x + r.size.width * 0.5f,
					   r.origin.y + r.size.height * 0.5f);
}
