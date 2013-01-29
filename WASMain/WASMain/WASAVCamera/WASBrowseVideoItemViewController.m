//
//  WASBrowseVideoItemViewController.m
//  WASMain
//
//  Created by allen.wang on 8/13/12.
//  Copyright (c) 2012 b5m. All rights reserved.
//

#import "WASBrowseVideoItemViewController.h"
#import "WASVideoButton.h"


@interface WASBrowseVideoItemViewController ()
@property (nonatomic, retain) UIScrollView *contentView;
@property (nonatomic, assign) NSUInteger    totalCount;

@end

@implementation WASBrowseVideoItemViewController
@synthesize totalCount = _totalCount;
@synthesize videoArray = _videoArray;
@synthesize contentView=_contentView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self contentView];
    [self reloadItems];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void) setVideoArray:(NSMutableArray *)videoArray
{
    if (videoArray != _videoArray) {
        [_videoArray release];
        _videoArray = videoArray;
        
//        self.totalCount = 
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (UIScrollView *) contentView
{
    if(!_contentView)
    {
        CGRect rect = CGRectMake(0, 0, 320, 420);
        CGSize size = CGSizeMake(320, 80 * ([self.videoArray count] / 4 + (0 == ([self.videoArray count] % 4) ? 0 : 1)));

        _contentView = [[UIScrollView alloc] initWithFrame:rect ];
        _contentView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_contentView ];
        
        _contentView.contentSize = size;
        
    }
    return _contentView;
}

- (void) reloadItems
{
    for (int i = 0 ; i < [self.videoArray count]; i++) {
        int row = (i)/ 4;
        int col = (i) % 4;
        WASVideoButton *button = [[[WASVideoButton alloc] initWithFrame:CGRectMake((4 + 75 )* col + 4, (4 + 75 )* row + 4, 75, 75 )] autorelease];
        WASAssetBrowseItem *item = [_videoArray objectAtIndex:i];

        button.tag             = i;
        button.item            = item;
        [_contentView addSubview:button];
    }
}

@end
