//
//  UIImageView+helper.m
//  WASUtility
//
//  Created by allen.wang on 9/14/12.
//  Copyright (c) 2012 b5m. All rights reserved.
//

#import "UIImageView+helper.h"
#import "NSObject+block.h"
#import "UIImageHelper.h"
#import "ARCHelper.h"

@implementation UIImageView (helper)


- (void)whiteFadeInWithDuration:(NSTimeInterval)duration
                          delay:(NSTimeInterval)delay
                          block:(void (^)(void))block
{
    if (!self.image) {
        return;
    }
    
    UIImageView *effectImageView = [[[UIImageView alloc] initWithFrame:self.bounds] autorelease];
    
    effectImageView.backgroundColor = [UIColor clearColor];
    effectImageView.image = [self.image imageFilledWhite];
    effectImageView.contentMode = self.contentMode;
    UIViewAnimationOptions options = UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction;
    [self performBlock:^(void) {
        self.hidden = NO;
        self.alpha = 1.0;
        [self addSubview:effectImageView];
        [UIView animateWithDuration:duration 
                              delay:0.0
                            options:options
                         animations:^(void) {
                             effectImageView.alpha = 0.0;
                         }
                         completion:^(BOOL finished) {
                             [effectImageView removeFromSuperview];
                             self.backgroundColor = [UIColor clearColor];
                             
                             if (block) {
                                 block();
                             }
                         }];
    }
            afterDelay:delay];
}

@end
