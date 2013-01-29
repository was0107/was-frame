//
//  WASMainAppDelegate.h
//  WASMain
//
//  Created by iPhoneTeam BCS on 3/21/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WASMainViewController;
@class ContentController;

@interface WASMainAppDelegate : NSObject <UIApplicationDelegate>
{
    
    ContentController       *contentController_;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet WASMainViewController *viewController;

@property (nonatomic, retain) ContentController *contentController;

@end
