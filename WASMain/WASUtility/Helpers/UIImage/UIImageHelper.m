//
//  UIImageHelper.m
//  Enormego Cocoa Helpers
//
//  Created by Devin Doty on 1/13/2010.
//  Copyright (c) 2008-2009 enormego
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#if TARGET_OS_IPHONE
#import "UIImageHelper.h"
#import <CoreGraphics/CoreGraphics.h>

CGFloat degreesToRadiens(CGFloat degrees)
{
	return degrees * M_PI / 180.0f;
}

@implementation UIImage (Helper)


+ (UIImage*)imageWithContentsOfURL:(NSURL*)url {
	NSError* error;
	NSData* data = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:url] returningResponse:NULL error:NULL];
	if(error || !data) {
		return nil;
	} else {
		return [UIImage imageWithData:data];
	}
}

+ (UIImage*)imageWithResourcesPathCompontent:(NSString*)pathCompontent {
	return [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:pathCompontent]];
}

- (UIImage*)scaleToSize:(CGSize)size {
	
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
	if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
		UIGraphicsBeginImageContextWithOptions(size, NO, [[UIScreen mainScreen] scale]);
	} else {
		UIGraphicsBeginImageContext(size);
	}
#else
	UIGraphicsBeginImageContext(size);
#endif
	
	[self drawInRect:CGRectMake(0.0f, 0.0f, size.width, size.height)];
	UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return scaledImage;
}

- (UIImage*)aspectScaleToMaxSize:(CGFloat)size withBorderSize:(CGFloat)borderSize borderColor:(UIColor*)aColor cornerRadius:(CGFloat)aRadius shadowOffset:(CGSize)aOffset shadowBlurRadius:(CGFloat)aBlurRadius shadowColor:(UIColor*)aShadowColor{
	
	CGSize imageSize = CGSizeMake(self.size.width, self.size.height);
	
	CGFloat hScaleFactor = imageSize.width / size;
	CGFloat vScaleFactor = imageSize.height / size;
	
	CGFloat scaleFactor = MAX(hScaleFactor, vScaleFactor);
	
	CGFloat newWidth = imageSize.width   / scaleFactor;
	CGFloat newHeight = imageSize.height / scaleFactor;
	
	CGRect imageRect = CGRectMake(borderSize, borderSize, newWidth, newHeight);
	
	
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
	if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
		UIGraphicsBeginImageContextWithOptions(CGSizeMake(newWidth + (borderSize*2), newHeight + (borderSize*2)), NO, [[UIScreen mainScreen] scale]);
	} else {
		UIGraphicsBeginImageContext(CGSizeMake(newWidth + (borderSize*2), newHeight + (borderSize*2)));
	}
#else
	UIGraphicsBeginImageContext(CGSizeMake(newWidth + (borderSize*2), newHeight + (borderSize*2)));
#endif
	
	
	CGContextRef imageContext = UIGraphicsGetCurrentContext();
	CGContextSaveGState(imageContext);
	CGPathRef path = NULL;
	
	if (aRadius > 0.0f) {
		
		CGFloat radius;	
		radius = MIN(aRadius, floorf(imageRect.size.width/2));
		float x0 = CGRectGetMinX(imageRect), y0 = CGRectGetMinY(imageRect), x1 = CGRectGetMaxX(imageRect), y1 = CGRectGetMaxY(imageRect);
		
		CGContextBeginPath(imageContext);
		CGContextMoveToPoint(imageContext, x0+radius, y0);
		CGContextAddArcToPoint(imageContext, x1, y0, x1, y1, radius);
		CGContextAddArcToPoint(imageContext, x1, y1, x0, y1, radius);
		CGContextAddArcToPoint(imageContext, x0, y1, x0, y0, radius);
		CGContextAddArcToPoint(imageContext, x0, y0, x1, y0, radius);
		CGContextClosePath(imageContext);
		path = CGContextCopyPath(imageContext);
		CGContextClip(imageContext);
		
	} 
	
	[self drawInRect:imageRect];	
	CGContextRestoreGState(imageContext);
	
	if (borderSize > 0.0f) {
		
		CGContextSetLineWidth(imageContext, borderSize);
		[aColor != nil ? aColor : [UIColor blackColor] setStroke];
		
		if(path == NULL){
			
			CGContextStrokeRect(imageContext, imageRect);
			
		} else {
			
			CGContextAddPath(imageContext, path);
			CGContextStrokePath(imageContext);
			
		}
	}
	
	if(path != NULL){
		CGPathRelease(path);
	}
	
	UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	if (aBlurRadius > 0.0f) {
		
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
		if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
			UIGraphicsBeginImageContextWithOptions(CGSizeMake(scaledImage.size.width + (aBlurRadius*2), scaledImage.size.height + (aBlurRadius*2)), NO, [[UIScreen mainScreen] scale]);
		} else {
			UIGraphicsBeginImageContext(CGSizeMake(scaledImage.size.width + (aBlurRadius*2), scaledImage.size.height + (aBlurRadius*2)));
		}
#else
		UIGraphicsBeginImageContext(CGSizeMake(scaledImage.size.width + (aBlurRadius*2), scaledImage.size.height + (aBlurRadius*2)));
#endif
		
		CGContextRef imageShadowContext = UIGraphicsGetCurrentContext();
		
		if (aShadowColor!=nil) {
			CGContextSetShadowWithColor(imageShadowContext, aOffset, aBlurRadius, aShadowColor.CGColor);
		} else {
			CGContextSetShadow(imageShadowContext, aOffset, aBlurRadius);
		}
		
		[scaledImage drawInRect:CGRectMake(aBlurRadius, aBlurRadius, scaledImage.size.width, scaledImage.size.height)];
		scaledImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		
	}
	
	return scaledImage;	
}

- (UIImage*)aspectScaleToMaxSize:(CGFloat)size withShadowOffset:(CGSize)aOffset blurRadius:(CGFloat)aRadius color:(UIColor*)aColor{
	return [self aspectScaleToMaxSize:size	withBorderSize:0 borderColor:nil cornerRadius:0 shadowOffset:aOffset shadowBlurRadius:aRadius shadowColor:aColor];
}

- (UIImage*)aspectScaleToMaxSize:(CGFloat)size withCornerRadius:(CGFloat)aRadius{
	
	return [self aspectScaleToMaxSize:size withBorderSize:0 borderColor:nil cornerRadius:aRadius shadowOffset:CGSizeZero shadowBlurRadius:0.0f shadowColor:nil];
}

- (UIImage*)aspectScaleToMaxSize:(CGFloat)size{
	
	return [self aspectScaleToMaxSize:size withBorderSize:0 borderColor:nil cornerRadius:0 shadowOffset:CGSizeZero shadowBlurRadius:0.0f shadowColor:nil];
}

- (UIImage*)aspectScaleToSize:(CGSize)size{
	
	CGSize imageSize = CGSizeMake(self.size.width, self.size.height);
	
	CGFloat hScaleFactor = imageSize.width / size.width;
	CGFloat vScaleFactor = imageSize.height / size.height;
	
	CGFloat scaleFactor = MAX(hScaleFactor, vScaleFactor);
	
	CGFloat newWidth = imageSize.width   / scaleFactor;
	CGFloat newHeight = imageSize.height / scaleFactor;
	
	// center vertically or horizontally in size passed
	CGFloat leftOffset = (size.width - newWidth) / 2;
	CGFloat topOffset = (size.height - newHeight) / 2;
	
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
	if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
		UIGraphicsBeginImageContextWithOptions(CGSizeMake(size.width, size.height), NO, [[UIScreen mainScreen] scale]);
	} else {
		UIGraphicsBeginImageContext(CGSizeMake(size.width, size.height));
	}
#else
	UIGraphicsBeginImageContext(CGSizeMake(size.width, size.height));
#endif
	
	[self drawInRect:CGRectMake(leftOffset, topOffset, newWidth, newHeight)];
	UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return scaledImage;	
}

- (CGSize)aspectScaleSize:(CGFloat)size{
	
	CGSize imageSize = CGSizeMake(self.size.width, self.size.height);
	
	CGFloat hScaleFactor = imageSize.width / size;
	CGFloat vScaleFactor = imageSize.height / size;
	
	CGFloat scaleFactor = MAX(hScaleFactor, vScaleFactor);
	
	CGFloat newWidth = imageSize.width   / scaleFactor;
	CGFloat newHeight = imageSize.height / scaleFactor;
	
	return CGSizeMake(newWidth, newHeight);
	
}

- (void)drawInRect:(CGRect)rect withAlphaMaskColor:(UIColor*)aColor{
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSaveGState(context);
	
	CGContextTranslateCTM(context, 0.0, rect.size.height);
	CGContextScaleCTM(context, 1.0, -1.0);
	
	rect.origin.y = rect.origin.y * -1;
	const CGFloat *color = CGColorGetComponents(aColor.CGColor);
	CGContextClipToMask(context, rect, self.CGImage);
	CGContextSetRGBFillColor(context, color[0], color[1], color[2], color[3]);
	CGContextFillRect(context, rect);
	
	CGContextRestoreGState(context);
}

- (void)drawInRect:(CGRect)rect withAlphaMaskGradient:(NSArray*)colors{
	
	NSAssert([colors count]==2, @"an array containing two UIColor variables must be passed to drawInRect:withAlphaMaskGradient:");
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSaveGState(context);
	
	CGContextTranslateCTM(context, 0.0, rect.size.height);
	CGContextScaleCTM(context, 1.0, -1.0);
	
	rect.origin.y = rect.origin.y * -1;
	
	CGContextClipToMask(context, rect, self.CGImage);
	
	const CGFloat *top = CGColorGetComponents(((UIColor*)[colors objectAtIndex:0]).CGColor);
	const CGFloat *bottom = CGColorGetComponents(((UIColor*)[colors objectAtIndex:1]).CGColor);
	
	CGColorSpaceRef _rgb = CGColorSpaceCreateDeviceRGB();
	size_t _numLocations = 2;
	CGFloat _locations[2] = { 0.0, 1.0 };
	CGFloat _colors[8] = { top[0], top[1], top[2], top[3], bottom[0], bottom[1], bottom[2], bottom[3] };
	CGGradientRef gradient = CGGradientCreateWithColorComponents(_rgb, _colors, _locations, _numLocations);
	CGColorSpaceRelease(_rgb);
	
	CGPoint start = CGPointMake(CGRectGetMidX(rect), rect.origin.y);
	CGPoint end = CGPointMake(CGRectGetMidX(rect), rect.size.height);
	
	CGContextClipToRect(context, rect);
	CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
	
	CGGradientRelease(gradient);
	
	CGContextRestoreGState(context);
}

- (UIImage *)imageFilledWithColor:(UIColor *)color {
    
	const size_t width = self.size.width;
	const size_t height = self.size.height;
	const size_t bytesPerRow = width * 4;
    
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
	CGContextRef bmContext = CGBitmapContextCreate(NULL, width, height, 8, bytesPerRow, space, kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
    CGColorSpaceRelease(space);
	if (!bmContext)
		return nil;
    
	CGContextDrawImage(bmContext, (CGRect){.origin.x = 0.0f, .origin.y = 0.0f, .size.width = width, .size.height = height}, self.CGImage);
    
	UInt8 *data = (UInt8*)CGBitmapContextGetData(bmContext);
	if (!data)
	{
		CGContextRelease(bmContext);
		return nil;
	}
    
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    const int numComponents = CGColorGetNumberOfComponents(color.CGColor);
    CGFloat r, g, b;
    if (numComponents == 4) {
        r = components[0];
        g = components[1];
        b = components[2];
    } else {
        r = g = b = components[0];
    }
    
    unsigned char R = (unsigned char)(r * 255.);
    unsigned char G = (unsigned char)(g * 255.);
    unsigned char B = (unsigned char)(b * 255.);
    
    const size_t bitmapByteCount = bytesPerRow * height;
    for (int i=0; i < bitmapByteCount; i+=4) {
        
        if (data[i+0] == 0 ||
            (data[i+1] == 0 &&
             data[i+2] == 0 &&
             data[i+3] == 0))
        {
            continue;
        }
        
        data[i+1] = R;
        data[i+2] = G;
        data[i+3] = B;
    }
    
	CGImageRef dstImageRef = CGBitmapContextCreateImage(bmContext);
	UIImage *dstImage = [UIImage imageWithCGImage:dstImageRef];
    
	CGImageRelease(dstImageRef);
	CGContextRelease(bmContext);
    
    return dstImage;
}

- (UIImage *)imageFilledBlack {
    return [self imageFilledWithColor:[UIColor blackColor]];
}

- (UIImage *)imageFilledWhite {
    return [self imageFilledWithColor:[UIColor whiteColor]];
}

@end
#endif