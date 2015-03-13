//
//  WASMainAppDelegate.m
//  WASMain
//
//  Created by iPhoneTeam BCS on 3/21/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "WASMainAppDelegate.h"

#import "WASMainViewController.h"
#import "ContentController.h"
#import "ContentController_iPhone.h"
#import "ContentController_iPad.h"
#import "WASDebug.h"

@implementation WASMainAppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize contentController   = contentController_;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
	{
		// load the content controller object for Phone-based devices
        ContentController *iPad = [[ContentController_iPad alloc]init];
        self.contentController = iPad;
        [iPad release];
	}
	else
	{
		// load the content controller object for Pad-based devices
        contentController_ = [[ContentController_iPhone alloc]init];       
	}
    
//    LogMessage(@"Device", 5, @"%@ log", [contentController_ description] );
    
    // use subview to show
//    [self.window addSubview:self.contentController.view];
    
    //use controller to show
    CGRect rect = [[UIScreen mainScreen] bounds];
    rect.origin.y = 20;
    self.window = [[[UIWindow alloc] initWithFrame:rect] autorelease];
    Class main = NSClassFromString(@"TestCardViewController");
    UIViewController *mainViewController_   = [[[main alloc] init] autorelease];
    self.window.rootViewController = mainViewController_;
    [self.window makeKeyAndVisible];
    
//    [WASDebug show];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}

@end
