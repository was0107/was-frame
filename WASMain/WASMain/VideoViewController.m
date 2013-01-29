//
//  VideoViewController.m
//  WASMain
//
//  Created by allen.wang on 8/6/12.
//  Copyright (c) 2012 b5m. All rights reserved.
//

#import "VideoViewController.h"

#import "WASVideoFactory.h"

#import <MediaPlayer/MediaPlayer.h>

#define COOKBOOK_PURPLE_COLOR	[UIColor colorWithRed:0.20392f green:0.19607f blue:0.61176f alpha:1.0f]
#define BARBUTTON(TITLE, SELECTOR) 	[[[UIBarButtonItem alloc] initWithTitle:TITLE style:UIBarButtonItemStylePlain target:self action:SELECTOR] autorelease]

// Offsite resource Betty Boop Cinderella @Archive.org
#define PATHSTRING @"http://ia700502.us.archive.org/2/items/bb_poor_cinderella/bb_poor_cinderella_512kb.mp4"

@interface VideoViewController ()

@end

@implementation VideoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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


-(void)myMovieFinishedCallback:(NSNotification*)aNotification
{
    MPMoviePlayerController* theMovie=[aNotification object];
	CFShow([aNotification userInfo]);
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:theMovie];
    [theMovie release];
	self.navigationItem.rightBarButtonItem = BARBUTTON(@"Play", @selector(play:));
//	self.navigationItem.leftBarButtonItem  = BARBUTTON(@"Record", @selector(record:));
	self.title = nil;
}

- (void) Record: (UIBarButtonItem *) bbi
{
    
    
}

- (void) play: (UIBarButtonItem *) bbi
{
	self.navigationItem.rightBarButtonItem = nil;
	self.title = @"Contacting Server";
	MPMoviePlayerController* theMovie=[[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:PATHSTRING]];
    [theMovie setControlStyle:MPMovieControlStyleFullscreen];        //MPMovieControlStyleFullscreen        //MPMovieControlStyleEmbedded
    //满屏
    [theMovie setFullscreen:YES];
    
    
    // 有助于减少延迟
    [theMovie prepareToPlay];
    
    
    [[self view] setBounds:CGRectMake(0, 0, 480, 320)];
    [[self view] setCenter:CGPointMake(160, 240)];
    //选中当前view
//    [[self view] setTransform:CGAffineTransformMakeRotation(M_PI / 2)];
    
    // Set frame of movieplayer
    [[theMovie view] setFrame:CGRectMake(0, 0, 480, 320)];
   
    
    
    [self.view addSubview:theMovie.view];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myMovieFinishedCallback:) name:MPMoviePlayerPlaybackDidFinishNotification object:theMovie];
	[theMovie play];
}

- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
	if (!error) 
		self.title = @"Saved!";
	else 
		CFShow([error localizedDescription]);
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	// recover video URL
	NSURL *url = [info objectForKey:UIImagePickerControllerMediaURL];
    
    
    NSLog(@"infor = %@", info);
	
	// check if video is compatible with album
	BOOL compatible = UIVideoAtPathIsCompatibleWithSavedPhotosAlbum([url path]);
	
	// save
	if (compatible)
		UISaveVideoAtPathToSavedPhotosAlbum([url path], self, @selector(video:didFinishSavingWithError:contextInfo:), NULL);
	
	[self dismissModalViewControllerAnimated:YES];
	[picker release];
}

- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker
{
	[self dismissModalViewControllerAnimated:YES];
	[picker release];
}

- (void) recordVideo: (id) sender
{
	UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
	ipc.sourceType =  UIImagePickerControllerSourceTypeCamera;
	ipc.delegate = self;
	ipc.allowsEditing = YES;
	ipc.videoQuality = UIImagePickerControllerQualityTypeMedium;
	ipc.videoMaximumDuration = 30.0f;
	ipc.mediaTypes = [NSArray arrayWithObject:@"public.movie"];    
	[self presentModalViewController:ipc animated:YES];	
}

- (BOOL) videoRecordingAvailable
{
	if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) return NO;
	return [[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera] containsObject:@"public.movie"];
}

- (void) viewDidLoad
{
//	self.navigationController.navigationBar.tintColor = COOKBOOK_PURPLE_COLOR;
//    self.navigationItem.rightBarButtonItem = BARBUTTON(@"Play", @selector(play:));
    
    WASVideoFactory *factory = [[WASVideoFactory alloc] init];
    factory.contentsController = self;
//    factory.videoURL = PATHSTRING   ;
    
    [factory showPickerController];
    
//    if ([self videoRecordingAvailable])
//		self.navigationItem.leftBarButtonItem = BARBUTTON(@"Record", @selector(recordVideo:));
//	else 
//		self.title = @"No Video Recording";
}
@end
