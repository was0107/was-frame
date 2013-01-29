//
//  UIImageView+helper.h
//  WASUtility
//
//  Created by allen.wang on 9/14/12.
//  Copyright (c) 2012 b5m. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (helper)

- (void)whiteFadeInWithDuration:(NSTimeInterval)duration
                          delay:(NSTimeInterval)delay
                          block:(void (^)(void))block;
@end
