//
//  WASAVCameraViewController.m
//  WASMain
//
//  Created by allen.wang on 8/8/12.
//  Copyright (c) 2012 b5m. All rights reserved.
//

#import "WASAVCameraViewController.h"
#import "WASAVCameraCaptureManager.h"
#import "WASAVCameraRecorder.h"
#import "WASToolBarView.h"
#import "WASMultipleControl.h"
#import "WASFlashDecorder.h"
#import "WASAVCameraDefines.h"
#import "WASToolBarItem.h"
#import "WASTimeCountControl.h"
#import "WASBrowseVideoViewController.h"






static void *WASAVCamFocusModeObserverContext = &WASAVCamFocusModeObserverContext;


@interface WASAVCameraViewController ()
{
    WASToolBarView      *_toolView;
    WASMultipleControl  *_flashControl;
    WASMultipleControl  *_cameraControl;
    WASTimeCountControl *_timeControl;
}
@property (nonatomic, retain) WASTimeCountControl *timeControl;

-(UIButton*) buttonWithTitle:(NSString*) title 
                       image:(UIImage*)  image 
                 highLighted:(UIImage *) highLightedImage 
                      action:(SEL) sel;

@end

@interface WASAVCameraViewController () <UIGestureRecognizerDelegate>
@end

@interface WASAVCameraViewController (InternalMethods)
- (CGPoint)convertToPointOfInterestFromViewCoordinates:(CGPoint)viewCoordinates;
- (void)tapToAutoFocus:(UIGestureRecognizer *)gestureRecognizer;
- (void)tapToContinouslyAutoFocus:(UIGestureRecognizer *)gestureRecognizer;
- (void)updateButtonStates;
- (NSString *)stringForFocusMode:(AVCaptureFocusMode)focusMode;

@end

@interface WASAVCameraViewController (AVCamCaptureManagerDelegate) <WASAVCameraCaptureManagerDelegate>
@end



@implementation WASAVCameraViewController
@synthesize captureManager;
@synthesize videoPreviewView;
@synthesize captureVideoPreviewLayer;
@synthesize focusModeLabel;
@synthesize timeControl = _timeControl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)firstSEL:(id)sender
{
    NSLog(@"1");
    
    WASBrowseVideoViewController *controller = [[[WASBrowseVideoViewController alloc] init] autorelease];
    [self.navigationController pushViewController:controller animated:YES];
    [self setupNavigationBars:NO];
}

- (IBAction) pauseSEL:(id)sender
{
    NSLog(@"pauseSEL");
}


- (IBAction) takeCameraSEL:(id)sender
{
    
    WASToolBarItem *button2 = (WASToolBarItem*)sender;
    
    [button2 setIsSelected:!button2.isSelected];
    
    
    WASToolBarItem *button0 = [_toolView.toolItems objectAtIndex:0];
    WASToolBarItem *button1 = [_toolView.toolItems objectAtIndex:1];
    WASToolBarItem *button3 = [_toolView.toolItems objectAtIndex:3];
    WASToolBarItem *button4 = [_toolView.toolItems objectAtIndex:4];
    
    if (button2.isSelected)
    {
        [[self captureManager] startRecording];
        NSLog(@"startRecording");

        button0.hidden = YES;
        button4.hidden = YES;
        button1.hidden = NO;
        button3.hidden = NO;
        
        self.timeControl.hidden = NO;
        self.timeControl.timeCountType =  EWASMultipleTimeCountStart; 
    }
    else
    {
        [[self captureManager] stopRecording];
        NSLog(@"stopRecording");
        
        self.timeControl.timeCountType =  EWASMultipleTimeCountStop; 
        self.timeControl.hidden = YES;



        button0.hidden = NO;
        button4.hidden = NO;
        button1.hidden = YES;
        button3.hidden = YES;
    }
    
}

- (IBAction) backSEL:(id)sender
{
    NSLog(@"backSEL");
}


- (IBAction) cancelSEL:(id)sender
{
    NSLog(@"cancelSEL");
}


- (void) valueChange:(WASMultipleControl *)sender
{
    NSLog(@"valueChange = %d", sender.currentItem);
    [captureManager changeFlashMode:sender.currentItem];
}



- (void)setupToolView
{
    _toolView = [[WASToolBarView alloc] initWithFrame:CGRectMake(0, 420, 320, 60)];
    
    _toolView.toolItems = [NSArray arrayWithObjects:
                           [self buttonWithTitle:@"local" image:nil highLighted:nil action:@selector(firstSEL:)],
                           [self buttonWithTitle:@"pause" image:nil highLighted:nil action:@selector(pauseSEL:)],
                           [self buttonWithTitle:@"camera" image:nil highLighted:nil action:@selector(takeCameraSEL:)],
                           [self buttonWithTitle:@"cancel" image:nil highLighted:nil action:@selector(cancelSEL:)],
                           [self buttonWithTitle:@"back" image:nil highLighted:nil action:@selector(backSEL:)], nil];
    
    
    
    WASToolBarItem *button1 = [_toolView.toolItems objectAtIndex:1];
    WASToolBarItem *button3 = [_toolView.toolItems objectAtIndex:3];
    
    button1.hidden = YES;
    button3.hidden = YES;
    
    [self.view addSubview:_toolView];
}

- (void)setupControl
{
    _flashControl = [[WASMultipleControl alloc] initWithFrame: CGRectMake(10, 10, 80, 38)];
    [_flashControl addTipImage:[UIImage imageNamed:@"blueArrow"]  contents:[NSArray arrayWithObjects:@"关闭",@"打开",@"自动",nil] selected:0];
    [_flashControl addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];
    [self.view insertSubview:_flashControl atIndex:3];
    
    _cameraControl = [[WASMultipleControl alloc] initWithFrame: CGRectMake(230, 10, 80, 38)];
    [_cameraControl addTipImage:[UIImage imageNamed:@"blueArrow"]  contents:nil selected:0];
    [_cameraControl addTarget:self action:@selector(toggleCamera:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view insertSubview:_cameraControl atIndex:4];
}

- (void)setupCaptureLayer
{
    // Create video preview layer and add it to the UI
    AVCaptureVideoPreviewLayer *newCaptureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:[[self captureManager] session]];
    UIView *view = [self videoPreviewView];
    CALayer *viewLayer = [view layer];
    [viewLayer setMasksToBounds:YES];
    
    CGRect bounds = [view bounds];
    [newCaptureVideoPreviewLayer setFrame:bounds];
    
    if ([newCaptureVideoPreviewLayer isOrientationSupported]) {
        [newCaptureVideoPreviewLayer setOrientation:AVCaptureVideoOrientationPortrait];
    }
    
    [newCaptureVideoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    [viewLayer insertSublayer:newCaptureVideoPreviewLayer below:[[viewLayer sublayers] objectAtIndex:0]];
    
    [self setCaptureVideoPreviewLayer:newCaptureVideoPreviewLayer];
    [newCaptureVideoPreviewLayer release];
    
    // Add a single tap gesture to focus on the point tapped, then lock focus
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToAutoFocus:)];
    [singleTap setDelegate:self];
    [singleTap setNumberOfTapsRequired:1];
    [view addGestureRecognizer:singleTap];
    
    // Add a double tap gesture to reset the focus mode to continuous auto focus
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToContinouslyAutoFocus:)];
    [doubleTap setDelegate:self];
    [doubleTap setNumberOfTapsRequired:2];
    [singleTap requireGestureRecognizerToFail:doubleTap];
    [view addGestureRecognizer:doubleTap];
    
    [doubleTap release];
    [singleTap release];
    
    // Start the session. This is done asychronously since -startRunning doesn't return until the session is running.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[[self captureManager] session] startRunning];
    });
}

- (void)setupNavigationBars:(BOOL)flag
{
    UIApplication *application = [UIApplication sharedApplication];
    [application setStatusBarHidden:flag withAnimation:UIStatusBarAnimationFade];
    //    
    [self.navigationController setNavigationBarHidden:flag animated:YES];
//    [self.navigationController setToolbarHidden:flag animated:YES];
}

- (WASTimeCountControl *) timeControl
{
    if (!_timeControl) {
        _timeControl = [[WASTimeCountControl alloc] initWithFrame:CGRectMake(110, 380, 100, 40)];
        _timeControl.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_timeControl];
        [_timeControl setHidden:YES];
    }
    return _timeControl;
}


-(void)willResignActiveNotification:(NSNotification*)aNotification
{
    [self stopRecording];

    [WASFlashDecorder decorderView:self.view open:YES];
}
-(void)willEnterForegroundNotification:(NSNotification*)aNotification
{
    [WASFlashDecorder decorderView:self.view open:YES endBlock:NULL];
}

- (void)addNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(willResignActiveNotification:) 
                                                 name:UIApplicationWillResignActiveNotification 
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(willResignActiveNotification:) 
                                                 name:UIApplicationDidEnterBackgroundNotification 
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(willEnterForegroundNotification:) 
                                                 name:UIApplicationWillEnterForegroundNotification 
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(willEnterForegroundNotification:) 
                                                 name:UIApplicationDidBecomeActiveNotification 
                                               object:nil];
}

- (void)viewDidLoad
{
    NSLog(@"viewDidLoad");
    [super viewDidLoad];
    
    
    [self addNotifications];

    
    [WASFlashDecorder decorderView:self.view open:YES];
    if (![self captureManager]) 
    {
        [self setupToolView];
        WASAVCameraCaptureManager *manager = [[WASAVCameraCaptureManager alloc] init];
        [self setCaptureManager:manager];
        [manager release];
        
        [[self captureManager] setDelegate:self];
        
        if ([[self captureManager] setupSession])
        {
            [self setupCaptureLayer];
        }
    }
     [self setupControl];
     [self updateButtonStates];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupNavigationBars:YES];

    [WASFlashDecorder decorderView:self.view open:YES endBlock:NULL];
}



-(WASToolBarItem*) buttonWithTitle:(NSString*) title image:(UIImage*)image highLighted:(UIImage *)highLightedImage action:(SEL) sel
{
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.backgroundColor = [UIColor clearColor];
//    [button setTitle:title forState:UIControlStateNormal];
//    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//    [button addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
//    return button;
    
    
    
    
    WASToolBarItem *barItem = [[[WASToolBarItem alloc] init] autorelease];
    
    barItem.backgroundColor = [UIColor redColor];
    barItem.name            = title;
    barItem.image           = image;
    barItem.selectedImage   = highLightedImage;
    barItem.type            = EWAS_TOOLBAR_ITEM_TYPE_BOTTOM;
    [barItem addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    
    return barItem;
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"captureManager.videoInput.device.focusMode"];
    [[NSNotificationCenter defaultCenter]  removeObserver:self];
	[captureManager release], captureManager = nil;
    [videoPreviewView release], videoPreviewView = nil;
	[captureVideoPreviewLayer release], captureVideoPreviewLayer = nil;
	[_toolView release], _toolView = nil;
	[_flashControl release], _flashControl = nil;
	[_cameraControl release], _cameraControl = nil;
    [super dealloc];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == WASAVCamFocusModeObserverContext) {
        // Update the focus UI overlay string when the focus mode changes
//		[focusModeLabel setText:[NSString stringWithFormat:@"focus: %@", [self stringForFocusMode:(AVCaptureFocusMode)[[change objectForKey:NSKeyValueChangeNewKey] integerValue]]]];
	} else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
#pragma mark Toolbar Actions
- (void)stopRecording
{
    WASToolBarItem *button2 = [_toolView.toolItems objectAtIndex:2];
    if (button2.isSelected) {
        [self takeCameraSEL:button2];
    }
}

- (IBAction)toggleCamera:(id)sender
{
    // Toggle between cameras when there is more than one
    _toolView.userInteractionEnabled = NO;
    
    [WASFlashDecorder decorderView:self.view open:NO endBlock:^()
     {
         [self stopRecording];
         
         [[self captureManager] toggleCamera];
         [_flashControl setHidden:![[self captureManager] isBackFaceCamera]];
         // Do an initial focus
         [[self captureManager] continuousFocusAtPoint:CGPointMake(.5f, .5f)];

         [WASFlashDecorder decorderView:self.view open:YES endBlock:^(){
             _toolView.userInteractionEnabled = YES;
         }];

     }];

    
}

- (IBAction)toggleRecording:(id)sender
{
    // Start recording if there isn't a recording running. Stop recording if there is.
//    [[self recordButton] setEnabled:NO];
    if (![[[self captureManager] recorder] isRecording])
        [[self captureManager] startRecording];
    else
        [[self captureManager] stopRecording];
}

- (IBAction)captureStillImage:(id)sender
{
    // Capture a still image
//    [[self stillButton] setEnabled:NO];
    [[self captureManager] captureStillImage];
    
    // Flash the screen white and fade it out to give UI feedback that a still image was taken
    UIView *flashView = [[UIView alloc] initWithFrame:[[self videoPreviewView] frame]];
    [flashView setBackgroundColor:[UIColor whiteColor]];
    [[[self view] window] addSubview:flashView];
    
    [UIView animateWithDuration:.4f
                     animations:^{
                         [flashView setAlpha:0.f];
                     }
                     completion:^(BOOL finished){
                         [flashView removeFromSuperview];
                         [flashView release];
                     }
     ];
}

- (UIView *) videoPreviewView
{
    if (!videoPreviewView) {
        videoPreviewView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
        videoPreviewView.backgroundColor = [UIColor clearColor];
        [self.view insertSubview:videoPreviewView atIndex:2];
    }
    return videoPreviewView;
}

@end

@implementation WASAVCameraViewController (InternalMethods)

// Convert from view coordinates to camera coordinates, where {0,0} represents the top left of the picture area, and {1,1} represents
// the bottom right in landscape mode with the home button on the right.
- (CGPoint)convertToPointOfInterestFromViewCoordinates:(CGPoint)viewCoordinates 
{
    CGPoint pointOfInterest = CGPointMake(.5f, .5f);
    CGSize frameSize = [[self videoPreviewView] frame].size;
    
    if ([captureVideoPreviewLayer isMirrored]) {
        viewCoordinates.x = frameSize.width - viewCoordinates.x;
    }    
    
    if ( [[captureVideoPreviewLayer videoGravity] isEqualToString:AVLayerVideoGravityResize] ) {
		// Scale, switch x and y, and reverse x
        pointOfInterest = CGPointMake(viewCoordinates.y / frameSize.height, 1.f - (viewCoordinates.x / frameSize.width));
    } else {
        CGRect cleanAperture;
        for (AVCaptureInputPort *port in [[[self captureManager] videoInput] ports]) {
            if ([port mediaType] == AVMediaTypeVideo) {
                cleanAperture = CMVideoFormatDescriptionGetCleanAperture([port formatDescription], YES);
                CGSize apertureSize = cleanAperture.size;
                CGPoint point = viewCoordinates;
                
                CGFloat apertureRatio = apertureSize.height / apertureSize.width;
                CGFloat viewRatio = frameSize.width / frameSize.height;
                CGFloat xc = .5f;
                CGFloat yc = .5f;
                
                if ( [[captureVideoPreviewLayer videoGravity] isEqualToString:AVLayerVideoGravityResizeAspect] ) {
                    if (viewRatio > apertureRatio) {
                        CGFloat y2 = frameSize.height;
                        CGFloat x2 = frameSize.height * apertureRatio;
                        CGFloat x1 = frameSize.width;
                        CGFloat blackBar = (x1 - x2) / 2;
						// If point is inside letterboxed area, do coordinate conversion; otherwise, don't change the default value returned (.5,.5)
                        if (point.x >= blackBar && point.x <= blackBar + x2) {
							// Scale (accounting for the letterboxing on the left and right of the video preview), switch x and y, and reverse x
                            xc = point.y / y2;
                            yc = 1.f - ((point.x - blackBar) / x2);
                        }
                    } else {
                        CGFloat y2 = frameSize.width / apertureRatio;
                        CGFloat y1 = frameSize.height;
                        CGFloat x2 = frameSize.width;
                        CGFloat blackBar = (y1 - y2) / 2;
						// If point is inside letterboxed area, do coordinate conversion. Otherwise, don't change the default value returned (.5,.5)
                        if (point.y >= blackBar && point.y <= blackBar + y2) {
							// Scale (accounting for the letterboxing on the top and bottom of the video preview), switch x and y, and reverse x
                            xc = ((point.y - blackBar) / y2);
                            yc = 1.f - (point.x / x2);
                        }
                    }
                } else if ([[captureVideoPreviewLayer videoGravity] isEqualToString:AVLayerVideoGravityResizeAspectFill]) {
					// Scale, switch x and y, and reverse x
                    if (viewRatio > apertureRatio) {
                        CGFloat y2 = apertureSize.width * (frameSize.width / apertureSize.height);
                        xc = (point.y + ((y2 - frameSize.height) / 2.f)) / y2; // Account for cropped height
                        yc = (frameSize.width - point.x) / frameSize.width;
                    } else {
                        CGFloat x2 = apertureSize.height * (frameSize.height / apertureSize.width);
                        yc = 1.f - ((point.x + ((x2 - frameSize.width) / 2)) / x2); // Account for cropped width
                        xc = point.y / frameSize.height;
                    }
                }
                
                pointOfInterest = CGPointMake(xc, yc);
                break;
            }
        }
    }
    
    return pointOfInterest;
}

// Auto focus at a particular point. The focus mode will change to locked once the auto focus happens.
- (void)tapToAutoFocus:(UIGestureRecognizer *)gestureRecognizer
{
    if ([[[captureManager videoInput] device] isFocusPointOfInterestSupported]) {
        CGPoint tapPoint = [gestureRecognizer locationInView:[self videoPreviewView]];
        CGPoint convertedFocusPoint = [self convertToPointOfInterestFromViewCoordinates:tapPoint];
        [captureManager autoFocusAtPoint:convertedFocusPoint];
    }
}

// Change to continuous auto focus. The camera will constantly focus at the point choosen.
- (void)tapToContinouslyAutoFocus:(UIGestureRecognizer *)gestureRecognizer
{
    if ([[[captureManager videoInput] device] isFocusPointOfInterestSupported])
        [captureManager continuousFocusAtPoint:CGPointMake(.5f, .5f)];
}

// Update button states based on the number of available cameras and mics
- (void)updateButtonStates
{
//	NSUInteger cameraCount = [[self captureManager] cameraCount];
//	NSUInteger micCount = [[self captureManager] micCount];
    
    CFRunLoopPerformBlock(CFRunLoopGetMain(), kCFRunLoopCommonModes, ^(void) {
//        if (cameraCount < 2) {
//            [[self cameraToggleButton] setEnabled:NO]; 
//            
//            if (cameraCount < 1) {
//                [[self stillButton] setEnabled:NO];
//                
//                if (micCount < 1)
//                    [[self recordButton] setEnabled:NO];
//                else
//                    [[self recordButton] setEnabled:YES];
//            } else {
//                [[self stillButton] setEnabled:YES];
//                [[self recordButton] setEnabled:YES];
//            }
//        } else {
//            [[self cameraToggleButton] setEnabled:YES];
//            [[self stillButton] setEnabled:YES];
//            [[self recordButton] setEnabled:YES];
//        }
    });
}

- (NSString *)stringForFocusMode:(AVCaptureFocusMode)focusMode
{
	NSString *focusString = @"";
	
	switch (focusMode) {
		case AVCaptureFocusModeLocked:
			focusString = @"locked";
			break;
		case AVCaptureFocusModeAutoFocus:
			focusString = @"auto";
			break;
		case AVCaptureFocusModeContinuousAutoFocus:
			focusString = @"continuous";
			break;
	}
	
	return focusString;
}


@end

@implementation WASAVCameraViewController (WASAVCameraCaptureManagerDelegate)

- (void)captureManager:(WASAVCameraCaptureManager *)captureManager didFailWithError:(NSError *)error
{
    CFRunLoopPerformBlock(CFRunLoopGetMain(), kCFRunLoopCommonModes, ^(void) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[error localizedDescription]
                                                            message:[error localizedFailureReason]
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"OK", @"OK button title")
                                                  otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    });
}

- (void)captureManagerRecordingBegan:(WASAVCameraCaptureManager *)captureManager
{
    CFRunLoopPerformBlock(CFRunLoopGetMain(), kCFRunLoopCommonModes, ^(void) {
//        [[self recordButton] setTitle:NSLocalizedString(@"Stop", @"Toggle recording button stop title")];
//        [[self recordButton] setEnabled:YES];
    });
}

- (void)captureManagerRecordingFinished:(WASAVCameraCaptureManager *)captureManager
{
    CFRunLoopPerformBlock(CFRunLoopGetMain(), kCFRunLoopCommonModes, ^(void) {
//        [[self recordButton] setTitle:NSLocalizedString(@"Record", @"Toggle recording button record title")];
//        [[self recordButton] setEnabled:YES];
    });
}

- (void)captureManagerStillImageCaptured:(WASAVCameraCaptureManager *)captureManager
{
    CFRunLoopPerformBlock(CFRunLoopGetMain(), kCFRunLoopCommonModes, ^(void) {
//        [[self stillButton] setEnabled:YES];
    });
}

- (void)captureManagerDeviceConfigurationChanged:(WASAVCameraCaptureManager *)captureManager
{
	[self updateButtonStates];
}

@end
