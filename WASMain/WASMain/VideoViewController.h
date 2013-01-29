//
//  VideoViewController.h
//  WASMain
//
//  Created by allen.wang on 8/6/12.
//  Copyright (c) 2012 b5m. All rights reserved.
//

#import <UIKit/UIKit.h>

#define BARBUTTON(TITLE, SELECTOR) 	[[[UIBarButtonItem alloc] initWithTitle:TITLE style:UIBarButtonItemStylePlain target:self action:SELECTOR] autorelease]


@interface VideoViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@end
