//
//  ContentController_iPad.m
//  WASMain
//
//  Created by iPhoneTeam BCS on 3/27/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ContentController_iPad.h"
#import "DetailViewController.h"
#import "WASMainViewController.h"


static NSString *buttonTitle = @"Top Paid Apps";

@implementation ContentController_iPad
@synthesize splitViewController = splitViewController_;
@synthesize navigationController= navigationController_;
@synthesize mainViewController  = mainViewController_;
@synthesize detailViewController= detailViewController_;
@synthesize popoverController   = popoverController_;

- (id)init
{
    self = [super init];
    if (self) 
    {
        // Initialization code here.
        mainViewController_   = [[WASMainViewController alloc] init];
        navigationController_ = [[UINavigationController alloc] initWithRootViewController:mainViewController_];
        detailViewController_ = [[DetailViewController alloc]init];
        splitViewController_  = [[UISplitViewController alloc]init];
        NSArray *viewControllers = [NSArray arrayWithObjects:navigationController_, detailViewController_,nil];
        splitViewController_.viewControllers = viewControllers;
    }
    
    return self;
}

- (void)dealloc
{
    [navigationController_   release];
    [splitViewController_    release];
    [mainViewController_     release];
    [detailViewController_   release];
    [popoverController_      release];
    
    [super dealloc];
}

- (UIView *)view
{
    return splitViewController_.view;
}

#pragma --
#pragma UISplitViewControllerDelegate

// Called when a button should be added to a toolbar for a hidden view controller
- (void)splitViewController: (UISplitViewController*)svc 
     willHideViewController: (UIViewController *)aViewController 
          withBarButtonItem: (UIBarButtonItem*)barButtonItem 
       forPopoverController: (UIPopoverController*)pc
{
    
    barButtonItem.title = buttonTitle;
    [self.detailViewController.navBar.topItem setLeftBarButtonItem:barButtonItem animated:NO];
    self.popoverController = pc;
}

// Called when the view is shown again in the split view, invalidating the button and popover controller
- (void)splitViewController: (UISplitViewController*)svc
     willShowViewController: (UIViewController *)aViewController 
  invalidatingBarButtonItem: (UIBarButtonItem *)barButtonItem
{
    
    [self.detailViewController.navBar.topItem setLeftBarButtonItem:nil animated:NO];
    self.popoverController = nil;
}

// Called when the view controller is shown in a popover so the delegate can take action like hiding other popovers.
- (void)splitViewController: (UISplitViewController*)svc 
          popoverController: (UIPopoverController*)pc 
  willPresentViewController: (UIViewController *)aViewController
{
    
}

@end
