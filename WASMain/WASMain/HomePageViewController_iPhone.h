//
//  HomePageViewController_iPhone.h
//  WASMain
//
//  Created by allen.wang on 7/9/12.
//  Copyright (c) 2012 b5m. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WASEXTableView.h"
#import "WASFullScreenScroll.h"


@interface HomePageViewController_iPhone : UIViewController<
WASFullScreenScrollDelegate,
WASEXTableViewDelegate,
UITableViewDataSource,
UITableViewDelegate>
{
    UIView *contentView;
    WASEXTableView *_tableView;
}

@end
