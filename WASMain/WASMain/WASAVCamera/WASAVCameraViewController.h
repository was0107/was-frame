//
//  WASAVCameraViewController.h
//  WASMain
//
//  Created by allen.wang on 8/8/12.
//  Copyright (c) 2012 b5m. All rights reserved.
//

#import <UIKit/UIKit.h>


@class WASAVCameraCaptureManager, AVCamPreviewView, AVCaptureVideoPreviewLayer;

@interface WASAVCameraViewController : UIViewController

@property (nonatomic,retain) WASAVCameraCaptureManager *captureManager;
@property (nonatomic,retain) IBOutlet UIView *videoPreviewView;
@property (nonatomic,retain) IBOutlet UILabel*focusModeLabel;
@property (nonatomic,retain) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;

@end
