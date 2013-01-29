//
//  WASVideoFactory.m
//  comb5mios
//
//  Created by allen.wang on 8/7/12.
//  Copyright (c) 2012 b5m. All rights reserved.
//

#import "WASVideoFactory.h"
#import <MediaPlayer/MediaPlayer.h>

#define kMaximumDuration            30.0f
#define kPublicMovie                @"public.movie"

#define BARBUTTON(TITLE, SELECTOR) 	[[[UIBarButtonItem alloc] initWithTitle:TITLE \
                                    style:UIBarButtonItemStylePlain target:self \
                                    action:SELECTOR] autorelease]

#define DegreesToRadians(degrees)   (degrees * M_PI / 180)


#pragma mark -- WASVideoFactory()

@interface WASVideoFactory()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, retain)  MPMoviePlayerController* playerController;

/**
 * @brief check record video is available
 *     
 * @param [out] N/A    
 * @return              BOOL 
 * @note
 */
- (BOOL)videoRecordingAvailable;

/**
 * @brief play video with URL
 *
 * 
 * @param [in]  N/A     url    
 * @param [out] N/A    
 * @return              void
 * @note
 */
- (void)playVideo:(NSString *)url;

/**
 * @brief movie finished call back
 *
 * 
 * @param [in]  N/A     aNotification  
 * @param [in]  N/A           
 * @param [out] N/A    
 * @return              void
 * @note
 */
- (void)movieFinishedCallback:(NSNotification*)aNotification;

/**
 * @brief saving video
 *
 * 
 * @param [in]  N/A     videoPath  
 * @param [in]  N/A     error   
 * @param [in]  N/A     contextInfo      
 * @param [out] N/A    
 * @return              void
 * @note
 */
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;

@end


#pragma mark -- WASVideoFactory

@implementation WASVideoFactory
@synthesize playerController  = _playerController;
@synthesize contentsController= _contentsController;
@synthesize videoURL          = _videoURL;
@synthesize enableRotaion     = _enableRotaion;

- (void)showPickerController
{
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType =  UIImagePickerControllerSourceTypeCamera;
    ipc.delegate = self;
    ipc.allowsEditing = YES;
    ipc.videoQuality = UIImagePickerControllerQualityTypeMedium;
    ipc.videoMaximumDuration = kMaximumDuration;
    ipc.mediaTypes = [NSArray arrayWithObject:kPublicMovie];    
    [self.contentsController presentModalViewController:ipc animated:YES];
}


- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
	if (error) 
        NSLog(@"store video error = %@",[error localizedDescription]);
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	// recover video URL
	NSURL *url = [info objectForKey:UIImagePickerControllerMediaURL];
    
	// check if video is compatible with album
	BOOL compatible = UIVideoAtPathIsCompatibleWithSavedPhotosAlbum([url path]);
	
	// save
	if (compatible)
		UISaveVideoAtPathToSavedPhotosAlbum([url path], self, @selector(video:didFinishSavingWithError:contextInfo:), NULL);
	
    //dismiss
	[self.contentsController dismissModalViewControllerAnimated:YES];
	[picker release];
}

- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker
{
	[self.contentsController dismissModalViewControllerAnimated:YES];
	[picker release];
}

- (BOOL) videoRecordingAvailable
{
	if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) return NO;
	return [[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera] containsObject:kPublicMovie];
}


-(void)movieFinishedCallback:(NSNotification*)aNotification
{
    UIApplication *application = [UIApplication sharedApplication];
    [application setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    MPMoviePlayerController* theMovie=[aNotification object];
    NSLog(@"[aNotification userInfo] = %@",[aNotification userInfo]);

    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:MPMoviePlayerPlaybackDidFinishNotification 
                                                  object:theMovie];
}

- (void)orientationChanged:(NSNotification *)note
{
    if (UIDeviceOrientationUnknown  == [[note object] orientation] ||
        UIDeviceOrientationFaceUp   == [[note object] orientation] ||
        UIDeviceOrientationFaceDown == [[note object] orientation]) {
        return;
    }

    double rotain = 0.0;
    CGRect rect = [[self.contentsController view] frame];

    switch ([[note object] orientation]) {
        case UIDeviceOrientationPortraitUpsideDown:
        {
            rotain = DegreesToRadians(180);
            rect   = CGRectMake(0, 0, 320, 480);
        }
            break;
        case UIDeviceOrientationLandscapeLeft:
        {
            rotain = DegreesToRadians(90);
            rect   = CGRectMake(0, 0, 320, 480);

        }
            break;
        case UIDeviceOrientationLandscapeRight:
        {
            rotain = -DegreesToRadians(90);
            rect   = CGRectMake(0, 0, 320, 480);

        }
            break;
            
        default:
            break;
    }
    
    [[UIApplication sharedApplication] setStatusBarOrientation:[[note object] orientation] animated:YES];
    CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
    
    //add animation, Allen 
    [UIView animateWithDuration:duration 
                     animations:^
    { 
        [self.playerController.view setTransform:CGAffineTransformMakeRotation(rotain)];
        [[_playerController view] setFrame:rect];            
    } ];   
}

- (void) setVideoURL:(NSString *)videoURL
{
    if (_videoURL != videoURL) {
        [_videoURL release];
        _videoURL = [videoURL copy];
        
        [self playVideo:_videoURL];
    }
}

- (void)playVideo:(NSString *)url 
{
    UIApplication *application = [UIApplication sharedApplication];
    [application setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];

    [self.contentsController.navigationController setNavigationBarHidden:YES animated:NO];
    [self.contentsController.navigationController setToolbarHidden:YES animated:NO];

    if (!_playerController) {
        _playerController =[[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:url]];
        [_playerController setControlStyle:MPMovieControlStyleFullscreen]; 
        [_playerController setFullscreen:YES];
        [_playerController prepareToPlay];
        
        
        CGRect rect = [[self.contentsController view] frame];
        [[_playerController view] setFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
        
        [[self.contentsController view] addSubview:_playerController.view];
        
        [self.contentsController view].backgroundColor = [UIColor blackColor];
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(movieFinishedCallback:) 
                                                     name:MPMoviePlayerPlaybackDidFinishNotification 
                                                   object:_playerController];
        
        if (self.enableRotaion) {
            
            //setup device orientation change notification
            UIDevice *device = [UIDevice currentDevice];
            [device beginGeneratingDeviceOrientationNotifications];
            
            [[NSNotificationCenter defaultCenter] addObserver:self 
                                                     selector:@selector(orientationChanged:) 
                                                         name:UIDeviceOrientationDidChangeNotification 
                                                       object:device];
        }
        
    }

	[self.playerController play];
}

- (void) dealloc 
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_videoURL release]; _videoURL = nil;
    [_playerController release]; _playerController = nil;
    [_contentsController release]; _contentsController = nil;
    [super dealloc];
}


@end
