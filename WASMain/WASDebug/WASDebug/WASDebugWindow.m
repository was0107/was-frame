//
//  WASDebugWindow.m
//  WASDebug
//
//  Created by allen.wang on 11/21/12.
//  Copyright (c) 2012 b5m. All rights reserved.
//

#import "WASDebugWindow.h"
#import <QuartzCore/QuartzCore.h>
#import "WASDebugSandBoxViewController.h"
#import "WASDebugDashBoard.h"

#pragma mark -
#pragma mark WASDebugBoard


@interface WASDebugBoard : UIViewController
{
    UIView *_bottomView;
    UINavigationController *_sandBoxcontroller;
}
AS_SINGLETON(WASDebugBoard)

@end

@implementation WASDebugBoard
DEF_SINGLETON( WASDebugBoard )

- (id)init
{
    self = [super init];
    if ( self )
    {
        CGRect rect = [[UIScreen mainScreen] bounds];
        self.view.frame = rect;
        self.view.backgroundColor = [UIColor blackColor];
        UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, 20)];
        tipLabel.text = @"boguang@b5m.com";
        tipLabel.textColor = [UIColor whiteColor];
        tipLabel.backgroundColor = [UIColor blackColor];
        tipLabel.textAlignment = NSTextAlignmentRight;
        tipLabel.font = [UIFont systemFontOfSize:12];
        [self.view addSubview:tipLabel];
        
        CGRect bottomFrame;
        bottomFrame.size.width = self.view.frame.size.width;
        bottomFrame.size.height = self.view.frame.size.height -64;
       _sandBoxcontroller = [[UINavigationController alloc] initWithRootViewController:[WASDebugSandBoxViewController sharedInstance]];
        _sandBoxcontroller.view.backgroundColor = [UIColor blackColor];

        [_sandBoxcontroller setNavigationBarHidden:YES];
        [self.view addSubview:_sandBoxcontroller.view];
        [self.view addSubview:[WASDebugDashBoard sharedInstance]];
        
        bottomFrame.origin.y = 20.0f;
        _sandBoxcontroller.view.frame = bottomFrame;
        [WASDebugDashBoard sharedInstance].frame = bottomFrame;
        
        bottomFrame.size.height = 44.0f;
        bottomFrame.origin.x = 0.0f;
        bottomFrame.origin.y = self.view.frame.size.height - bottomFrame.size.height;
        
        _bottomView = [[UIView alloc] initWithFrame:bottomFrame];
        _bottomView.backgroundColor = [UIColor clearColor];
//        _bottomView.layer.borderWidth = 1.0f;
//        _bottomView.layer.borderColor = [UIColor grayColor].CGColor;
        [self.view addSubview:_bottomView];
        
        CGRect segFrame;
        segFrame.size.width = self.view.frame.size.width - 44.0f - 10.0f;
        segFrame.size.height = 30.0f;
        segFrame.origin.x = 10.0f;
        segFrame.origin.y = (bottomFrame.size.height - segFrame.size.height) / 2.0f;
        
        UISegmentedControl * segmentControl = [[[UISegmentedControl alloc] initWithFrame:segFrame] autorelease];
        segmentControl.segmentedControlStyle = UISegmentedControlStyleBar;
        
        static NSString *title[] = {@"监视",@"沙盒"};
        for ( NSUInteger i = 0 , total = 2; i < total; i++)
        {
            [segmentControl insertSegmentWithTitle:title[i] atIndex:i animated:NO];
        }
        [segmentControl setSelectedSegmentIndex:0];
        [segmentControl addTarget:self action:@selector(segmentValueChanged:) forControlEvents:UIControlEventValueChanged];
        [_bottomView addSubview:segmentControl];
        
        CGRect closeFrame;
        closeFrame.size.width = 44.0f;
        closeFrame.size.height = 44.0f;
        closeFrame.origin.x = self.view.frame.size.width - closeFrame.size.width;
        closeFrame.origin.y = (bottomFrame.size.height - closeFrame.size.height) / 2.0f;
        
        UIButton * closeView = [[[UIButton alloc] initWithFrame:closeFrame] autorelease];
        [closeView setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [closeView addTarget:self action:@selector(closeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:closeView];

    }
    return self;
}

- (void) segmentValueChanged:(id)sender
{
    UISegmentedControl *myUISegmentedControl=(UISegmentedControl *)sender;
    switch (myUISegmentedControl.selectedSegmentIndex) {
        case 0:
            [self.view bringSubviewToFront:[WASDebugDashBoard sharedInstance]];
            break;
        case 1:
            [self.view bringSubviewToFront:_sandBoxcontroller.view];
            break;
        default:
            break;
    }
}

- (IBAction)closeButtonAction:(id)sender
{
    [WASDebugWindow sharedInstance].hidden = YES;
    [WASShortCutDebugWindow sharedInstance].hidden = NO;
}

@end


#pragma mark -
#pragma mark WASShortCutDebugWindow

@implementation WASShortCutDebugWindow

DEF_SINGLETON( WASShortCutDebugWindow )

- (id)init
{
    CGRect screenBound = [UIScreen mainScreen].bounds;
    CGRect shortcutFrame;
    shortcutFrame.size.width = 40.0f;
    shortcutFrame.size.height = 40.0f;
    shortcutFrame.origin.x = CGRectGetMaxX(screenBound) - shortcutFrame.size.width;
    shortcutFrame.origin.y = CGRectGetMaxY(screenBound) - shortcutFrame.size.height - 44.0f;

    self = [super initWithFrame:shortcutFrame];
    if ( self )
    {
        self.backgroundColor = [UIColor clearColor];
        self.hidden = YES;
        self.windowLevel = UIWindowLevelStatusBar + 100.0f;
        
        CGRect buttonFrame = shortcutFrame;
        buttonFrame.origin = CGPointZero;
        
        UIButton * button = [[[UIButton alloc] initWithFrame:buttonFrame] autorelease];
        button.backgroundColor = [UIColor clearColor];
        button.adjustsImageWhenHighlighted = YES;
        [button setImage:[UIImage imageNamed:@"bug"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(bugTouched:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    return self;
}

- (IBAction)bugTouched:(id)sender
{
    [[WASShortCutDebugWindow sharedInstance] setHidden:YES];
    [[WASDebugWindow sharedInstance] setHidden:NO];
}

@end

#pragma mark -
#pragma mark WASDebugWindow

@implementation WASDebugWindow
DEF_SINGLETON( WASDebugWindow )

- (id)init
{
    CGRect screenBound = [UIScreen mainScreen].bounds;
    self = [super initWithFrame:screenBound];
    if (self)
    {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
        self.hidden = YES;
        self.windowLevel = UIWindowLevelStatusBar + 200;

        if ( [self respondsToSelector:@selector(setRootViewController:)] )
        {
            self.rootViewController = [WASDebugBoard sharedInstance];
        }
        else
        {
            [self addSubview:[WASDebugBoard sharedInstance].view];
        }
    }
    return self;
}

- (void)setHidden:(BOOL)hidden
{
	[super setHidden:hidden];
}

- (void)dealloc
{
	[super dealloc];
}

@end
