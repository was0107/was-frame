//
//  ContentController_iPad.h
//  WASMain
//
//  Created by iPhoneTeam BCS on 3/27/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContentController.h"

@class WASMainViewController;
@class DetailViewController;

@interface ContentController_iPad : ContentController<UISplitViewControllerDelegate>
{
    UISplitViewController   *splitViewController_;
    UINavigationController  *navigationController_;   // contains our MasterViewController (UITableViewController)
    WASMainViewController   *mainViewController_;
    DetailViewController    *detailViewController;
    UIPopoverController     *popoverController_;
}

@property (nonatomic, retain) UISplitViewController     *splitViewController;
@property (nonatomic, retain) UINavigationController    *navigationController;
@property (nonatomic, retain) WASMainViewController     *mainViewController;
@property (nonatomic, retain) DetailViewController      *detailViewController;
@property (nonatomic, retain) UIPopoverController       *popoverController;

- (UIView *)view;
@end
