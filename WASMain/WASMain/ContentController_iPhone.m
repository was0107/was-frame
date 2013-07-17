//
//  ContentController_iPhone.m
//  WASMain
//
//  Created by iPhoneTeam BCS on 3/27/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ContentController_iPhone.h"
//#import "WASMainViewController.h"
#import "DetailViewController_iPhone.h"


@implementation ContentController_iPhone

@synthesize navigationController    =   navigationController_;
@synthesize mainViewController      =   mainViewController_;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here. 
//        Class main = NSClassFromString(@"TestLayoutViewController");
        Class main = NSClassFromString(@"TestCardViewController");
        mainViewController_   = [[main alloc] init];
//        navigationController_ = [[UINavigationController alloc] initWithRootViewController:mainViewController_];
//        navigationController_.hidesBottomBarWhenPushed = NO;
//        [navigationController_ setNavigationBarHidden:NO animated:YES];
    }
    
    return self;
}


- (void)dealloc
{
    [mainViewController_   release];
    [navigationController_ release];
    [super dealloc];
}

- (UIView *)view
{
    return self.mainViewController.view;
}

@end
