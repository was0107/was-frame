//
//  WASMainViewController.h
//  WASMain
//
//  Created by iPhoneTeam BCS on 3/21/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Binding.h"


@interface WASMainViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *mainTableView_;
	NSTimer *sendTimer;
	NSArray *tagsArray;
	int counter;
	int imagesCounter;
    Binding *bind;
}

@property (nonatomic, retain) UITableView *mainTableView;
@property (nonatomic, retain) IBOutlet    UITextField *filed;
@property (nonatomic, retain) IBOutlet    UITextField *filed1;

- (void) setLoggerHostAndPort;

@end

