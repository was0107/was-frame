//
//  WASDebugDetailView.h
//  WASDebug
//
//  Created by allen.wang on 11/21/12.
//  Copyright (c) 2012 b5m. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WASDebugTextView : UIView
{
	UITextView *	_content;
	UIButton *	_close;
}
- (void)setFilePath:(NSString *)path;
@end

#pragma mark -

@interface WASDebugImageView : UIView
{
	UIImageView *	_imageView;
	UIButton *		_close;
}
- (void)setFilePath:(NSString *)path;
- (void)setURL:(NSString *)url;
@end