//
//  WASTimeCountControl.h
//  WASMain
//
//  Created by allen.wang on 8/9/12.
//  Copyright (c) 2012 b5m. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WASRoundCornerControlBase.h"


enum  {
    EWASMultipleTimeCountStart = 0, /**< EWASMultipleTimeCountStart start and continue*/
    EWASMultipleTimeCountPause = 1, /**< EWASMultipleTimeCountPause pause */
    EWASMultipleTimeCountStop  = 2, /**< EWASMultipleTimeCountStop pause */
};

typedef NSUInteger EWASTimeCountState;

@interface WASTimeCountControl : WASRoundCornerControlBase
@property (nonatomic, assign) EWASTimeCountState    timeCountType;


@end
