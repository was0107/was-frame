//
//  WASFlashDecorder.m
//  WASMain
//
//  Created by allen.wang on 8/9/12.
//  Copyright (c) 2012 b5m. All rights reserved.
//

#import "WASFlashDecorder.h"

#define rectMakex(x)        CGRectMake(x, 0, 160, 480)


@implementation WASFlashDecorder

+ (void) decorderView:(UIView *)view open:(BOOL) flag 
{
    UIImageView *leftImageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blueArrow"]] autorelease];
    UIImageView *righImageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blueArrowDown"]] autorelease];
    leftImageView.backgroundColor = [UIColor redColor];
    righImageView.backgroundColor = [UIColor blackColor];
    
    leftImageView.tag = 1000;
    righImageView.tag = 1001;
    
    
    leftImageView.frame = rectMakex(flag?0:-160);
    righImageView.frame = rectMakex(flag?160:320);
    
    [view addSubview:leftImageView];
    [view addSubview:righImageView];
}

+ (void) decorderView:(UIView *)view open:(BOOL) flag endBlock:(VoidBlock) block
{
    [[view viewWithTag:1000] removeFromSuperview];
    [[view viewWithTag:1001] removeFromSuperview];
    
    UIImageView *leftImageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blueArrow"]] autorelease];
    UIImageView *righImageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blueArrowDown"]] autorelease];
    leftImageView.backgroundColor = [UIColor redColor];
    righImageView.backgroundColor = [UIColor blackColor];

    
    leftImageView.frame = rectMakex(flag?0:-160);
    righImageView.frame = rectMakex(flag?160:320);
    
    [view addSubview:leftImageView];
    [view addSubview:righImageView];
    
    [UIView animateWithDuration:0.4f animations:^{
        
        leftImageView.frame = rectMakex(!flag?0:-160);
        righImageView.frame = rectMakex(!flag?160:320);
        
    }
     completion:^(BOOL finished) {
         if (block) {
             block();
         }
         [leftImageView removeFromSuperview];
         [righImageView removeFromSuperview];
     }];
    
}


@end
