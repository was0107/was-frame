//
//  ContentController_iPhone.h
//  WASMain
//
//  Created by iPhoneTeam BCS on 3/27/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContentController.h"

@class WASMainViewController;

@interface ContentController_iPhone : ContentController
{
    UINavigationController *navigationController_;
    UIViewController  *mainViewController_;

}
@property (nonatomic, retain) UINavigationController *navigationController;

@property (nonatomic, retain) UIViewController  *mainViewController;

- (UIView *)view;

@end
