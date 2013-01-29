//
//  WASMultipleControl.h
//  WASMain
//
//  Created by allen.wang on 8/9/12.
//  Copyright (c) 2012 b5m. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WASRoundCornerControlBase.h"

@interface WASMultipleControl : WASRoundCornerControlBase
@property (nonatomic, retain) UIImage *tipImage;
@property (nonatomic, retain) NSArray *contents;
@property (nonatomic, assign) NSUInteger currentItem;

/**
 *	@brief	add defalut tim image ,contents(they should be NSString objects) and current seleteItem
 *
 *	@param 	image 	image description
 *	@param 	array 	array description
 *	@param 	item 	item description
 */
- (void) addTipImage:(UIImage *)image contents:(NSArray *)array selected:(NSUInteger )item;

@end
