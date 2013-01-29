//
//  WASDebugBaseController.h
//  WASDebug
//
//  Created by allen.wang on 11/21/12.
//  Copyright (c) 2012 b5m. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WASDebugBaseController;

@interface UIView(WASDebugBaseController)

- (WASDebugBaseController *) baseController;
- (UIViewController *) firstViewController;
- (id) traverseResponderChainForUIViewController;


@end

@interface WASDebugBaseController : UIViewController
@property (nonatomic, retain) NSMutableArray *contents;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UIButton * modalMaskView;
@property (nonatomic, retain) UIView *	 modalContentView;

- (void)setBaseInsets:(UIEdgeInsets)insets;

- (void)presentModalView:(UIView *)view animated:(BOOL)animated;

- (void)dismissModalViewAnimated:(BOOL)animated;


@end
