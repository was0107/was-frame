//
//  WASDebugPlotsView.h
//  WASDebug
//
//  Created by allen.wang on 11/21/12.
//  Copyright (c) 2012 b5m. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WASDebugPlotsView : UIView
{
	UIColor *	_lineColor;
	CGFloat		_lineWidth;
	CGFloat		_lowerBound;
	CGFloat		_upperBound;
	NSUInteger	_capacity;
	NSArray *	_plots;
}

@property (nonatomic, retain) UIColor *		lineColor;
@property (nonatomic, assign) CGFloat		lineWidth;
@property (nonatomic, assign) CGFloat		lowerBound;
@property (nonatomic, assign) CGFloat		upperBound;
@property (nonatomic, assign) NSUInteger	capacity;
@property (nonatomic, retain) NSArray *		plots;

@end
