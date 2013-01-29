//
//  WASDebugMemoryView.h
//  WASDebug
//
//  Created by allen.wang on 11/21/12.
//  Copyright (c) 2012 b5m. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WASDebugPlotsView.h"

@interface WASDebugMemoryView : UIView
{
	UILabel *			_titleView;
	UILabel *			_statusView;
	WASDebugPlotsView * _plotView;
	UIButton *			_manualAlloc;
	UIButton *			_manualFree;
	UIButton *			_manualAllocAll;
	UIButton *			_manualFreeAll;
	UIButton *			_autoWarning;
}

- (void)update;
@end
