//
//  WASToolBarItem.h
//  WASMain
//
//  Created by allen.wang on 8/10/12.
//  Copyright (c) 2012 b5m. All rights reserved.
//

#import <UIKit/UIKit.h>

enum  {
    EWAS_TOOLBAR_ITEM_TYPE_TOP = 0 ,/**< color line is draw on top description */
    EWAS_TOOLBAR_ITEM_TYPE_BOTTOM = 1 /**< color line is draw on bottom */
};

typedef NSUInteger EWAS_TOOLBAR_ITEM_TYPE;

@interface WASToolBarItem : UIControl
@property (nonatomic, retain) UIColor *lineColor;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) UIImage *selectedImage;
@property (nonatomic, copy  ) NSString*name;
@property (nonatomic, assign) EWAS_TOOLBAR_ITEM_TYPE type;
@property (nonatomic, readonly) BOOL isSelected;

- (void) setIsSelected:(BOOL)selected;

@end
