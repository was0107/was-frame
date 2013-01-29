//
//  WASVideoFactory.h
//  comb5mios
//
//  Created by allen.wang on 8/7/12.
//  Copyright (c) 2012 b5m. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WASVideoFactory : NSObject
@property (nonatomic, retain) UIViewController *contentsController; //the contain viewcontroller
@property (nonatomic, copy  ) NSString         *videoURL;           //video URL, after assignment, the movie will show
@property (nonatomic, assign) BOOL              enableRotaion;      //enable rotation

/**
 * @brief pressent view controller
 *
 * @param [out] N/A    
 * @return              void
 * @note
 */
- (void)showPickerController;

@end
