//
//  DamageValueLabel.h
//  WASUtility
//
//  Created by allen.wang on 9/14/12.
//  Copyright (c) 2012 b5m. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
	DamageAnimationTypeAllJump,
	DamageAnimationTypeAlpha,
	DamageAnimationTypeSonJump,     //defaul animation
} DamageAnimationType;


@interface DamageValueLabel : UILabel
- (void)startAnimation;
- (void)startAnimationWithAnimationType:(DamageAnimationType)type;
@end
