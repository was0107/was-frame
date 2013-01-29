//
//  WASDebugDashBoard.h
//  WASDebug
//
//  Created by allen.wang on 11/21/12.
//  Copyright (c) 2012 b5m. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WASDebugMemoryView.h"

@interface WASDebugDashBoard : UIView
{
	WASDebugMemoryView *	_memoryView;
}

AS_SINGLETON( WASDebugDashBoard )
@end
