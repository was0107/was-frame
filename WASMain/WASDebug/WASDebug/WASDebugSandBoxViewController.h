//
//  WASDebugSandBoxViewController.h
//  WASDebug
//
//  Created by allen.wang on 11/21/12.
//  Copyright (c) 2012 b5m. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WASDebugBaseController.h"


@interface WasDebugSandboxCell : UITableViewCell
{
	UIImageView *	_iconView;
    UILabel *       _nameLabel;
    UILabel *       _sizeLabel;
    UIView  *       _lineLabel;
}
- (void)bindData:(NSObject *)data;
@end

@interface WASDebugSandBoxViewController : WASDebugBaseController
@property (nonatomic, retain) NSString *	filePath;
AS_SINGLETON(WASDebugSandBoxViewController)


@end
