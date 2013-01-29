//
//  WASToolBarView.h
//  WASMain
//
//  Created by allen.wang on 8/9/12.
//  Copyright (c) 2012 b5m. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WASToolBarView : UIView

/**
 *	@brief	tool items 
 */
@property (nonatomic, retain) NSArray *toolItems;


/**
 *	@brief	add center button , just like camera take
 *
 *	@param 	buttonImage 	normalImage
 *	@param 	highlightImage 	highlightImgage
 *	@param 	sel             @selector
 */
-(void) addCenterButtonWithImage:(UIImage*)buttonImage highlightImage:(UIImage*)highlightImage  action:(SEL) sel;
    
@end
