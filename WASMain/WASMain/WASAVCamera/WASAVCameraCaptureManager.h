//
//  WASAVCameraManager.h
//  WASMain
//
//  Created by allen.wang on 8/8/12.
//  Copyright (c) 2012 b5m. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@class WASAVCameraRecorder;
@protocol WASAVCameraCaptureManagerDelegate;

@interface WASAVCameraCaptureManager : NSObject {
}

@property (nonatomic,retain) AVCaptureSession *session;
@property (nonatomic,assign) AVCaptureVideoOrientation orientation;
@property (nonatomic,retain) AVCaptureDeviceInput *videoInput;
@property (nonatomic,retain) AVCaptureDeviceInput *audioInput;
@property (nonatomic,retain) AVCaptureStillImageOutput *stillImageOutput;
@property (nonatomic,retain) WASAVCameraRecorder *recorder;
@property (nonatomic,assign) id deviceConnectedObserver;
@property (nonatomic,assign) id deviceDisconnectedObserver;
@property (nonatomic,assign) UIBackgroundTaskIdentifier backgroundRecordingID;
@property (nonatomic,assign) id <WASAVCameraCaptureManagerDelegate> delegate;

- (BOOL) setupSession;
- (void) startRecording;
- (void) stopRecording;
- (BOOL) isSupportFlashMode;
- (BOOL) isBackFaceCamera;
- (void) changeFlashMode:(AVCaptureFlashMode) mode;
- (void) captureStillImage;
- (BOOL) toggleCamera;
- (NSUInteger) cameraCount;
- (NSUInteger) micCount;
- (void) autoFocusAtPoint:(CGPoint)point;
- (void) continuousFocusAtPoint:(CGPoint)point;

@end

// These delegate methods can be called on any arbitrary thread. If the delegate does something with the UI when called, make sure to send it to the main thread.
@protocol WASAVCameraCaptureManagerDelegate <NSObject>
@optional
- (void) captureManager:(WASAVCameraCaptureManager *)captureManager didFailWithError:(NSError *)error;
- (void) captureManagerRecordingBegan:(WASAVCameraCaptureManager *)captureManager;
- (void) captureManagerRecordingFinished:(WASAVCameraCaptureManager *)captureManager;
- (void) captureManagerStillImageCaptured:(WASAVCameraCaptureManager *)captureManager;
- (void) captureManagerDeviceConfigurationChanged:(WASAVCameraCaptureManager *)captureManager;
@end