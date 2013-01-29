//
//  WASAVCameraRecorder.h
//  WASMain
//
//  Created by allen.wang on 8/8/12.
//  Copyright (c) 2012 b5m. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@protocol WASAVCameraRecorderDelegate;

@interface WASAVCameraRecorder : NSObject {
}

@property (nonatomic,retain) AVCaptureSession *session;
@property (nonatomic,retain) AVCaptureMovieFileOutput *movieFileOutput;
@property (nonatomic,copy) NSURL *outputFileURL;
@property (nonatomic,readonly) BOOL recordsVideo;
@property (nonatomic,readonly) BOOL recordsAudio;
@property (nonatomic,readonly,getter=isRecording) BOOL recording;
@property (nonatomic,assign) id <NSObject,WASAVCameraRecorderDelegate> delegate;

/**
 *	@brief	init recorder
 *
 *	@param 	session 	
 *	@param 	outputFileURL 	file path
 *
 *	@return	id
 */
-(id)initWithSession:(AVCaptureSession *)session outputFileURL:(NSURL *)outputFileURL;

/**
 *	@brief	start recording with orientation
 *
 *	@param 	videoOrientation 	orientation
 */
-(void)startRecordingWithOrientation:(AVCaptureVideoOrientation)videoOrientation;

/**
 *	@brief	stop recording
 */
-(void)stopRecording;

@end

/**
 *	@brief	WASAVCameraRecorderDelegate
 */
@protocol WASAVCameraRecorderDelegate
@required
/**
 *	@brief	recording did begin
 *
 *	@param 	recorder 	reorder object
 */
-(void)recorderRecordingDidBegin:(WASAVCameraRecorder *)recorder;

/**
 *	@brief	recording did finish to output file, you can send the movie to the server with the from the output file URL
 *
 *	@param 	recorder 	
 *	@param 	outputFileURL 	
 *	@param 	error       
 */
-(void)recorder:(WASAVCameraRecorder *)recorder recordingDidFinishToOutputFileURL:(NSURL *)outputFileURL error:(NSError *)error;
@end