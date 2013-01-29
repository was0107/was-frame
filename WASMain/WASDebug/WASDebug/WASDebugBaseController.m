//
//  WASDebugBaseController.m
//  WASDebug
//
//  Created by allen.wang on 11/21/12.
//  Copyright (c) 2012 b5m. All rights reserved.
//

#import "WASDebugBaseController.h"

@implementation UIView(WASDebugBaseController)

- (WASDebugBaseController *) baseController
{
    return (WASDebugBaseController *) [self firstViewController];
}

- (UIViewController *) firstViewController {
    return (UIViewController *)[self traverseResponderChainForUIViewController];
}

- (id) traverseResponderChainForUIViewController {
    id nextResponder = [self nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        return nextResponder;
    } else if ([nextResponder isKindOfClass:[UIView class]]) {
        return [nextResponder traverseResponderChainForUIViewController];
    } else {
        return nil;
    }
}

@end



#pragma mark -
#pragma mark WASDebugBaseController

@interface WASDebugBaseController ()<UITableViewDelegate, UITableViewDataSource>
{
    UIEdgeInsets					_baseInsets;
}

@end

@implementation WASDebugBaseController
@synthesize tableView = _tableView;
@synthesize contents = _contents;
@synthesize modalContentView = _modalContentView;
@synthesize modalMaskView = _modalMaskView;

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
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 34.0f;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.backgroundView = nil;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.separatorColor = [UIColor clearColor];
    
    
    CGRect bottomFrame;
    bottomFrame.size.width = self.view.frame.size.width;
    bottomFrame.size.height = self.view.frame.size.height - 44;
    bottomFrame.origin.x = 0.0f;
    bottomFrame.origin.y = 0.0f;
    tableView.frame = bottomFrame;
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
    
    _modalMaskView = [[UIButton alloc] initWithFrame:self.view.bounds];
    _modalMaskView.hidden = YES;
    _modalMaskView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.1f];
    [_modalMaskView addTarget:self action:@selector(didModalMaskTouched:) forControlEvents:UIControlEventTouchUpInside];
    [_modalMaskView addTarget:self action:@selector(didModalMaskTouched:) forControlEvents:UIControlEventTouchUpOutside];
    [self.view addSubview:_modalMaskView];
    
	// Do any additional setup after loading the view.
}

- (IBAction)didModalMaskTouched:(id)sender
{
    [self dismissModalViewAnimated:NO];
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

- (void)setBaseInsets:(UIEdgeInsets)insets
{
	if ( _tableView.tableHeaderView && NO == _tableView.tableHeaderView.hidden )
	{
		insets.top -= 20.0f;		
	}
    
	if ( _tableView.tableFooterView && NO == _tableView.tableFooterView.hidden )
	{
		insets.bottom -= 20.0f;		
	}
	
	_baseInsets = insets;
	_tableView.contentInset = insets;
}

- (void)presentModalView:(UIView *)view animated:(BOOL)animated
{
	if ( self.modalContentView || view.superview == self.view )
		return;
		
	self.modalMaskView.hidden = NO;
	self.modalMaskView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.0f];
	
	self.modalContentView = view;
	self.modalContentView.hidden = NO;
	
	[self.view addSubview:self.modalContentView];
	[self.view bringSubviewToFront:self.modalMaskView];
	[self.view bringSubviewToFront:self.modalContentView];
	
	
	if ( animated )
	{	
        [UIView animateWithDuration:0.2f animations: ^(void) {
             self.modalContentView.transform = CGAffineTransformScale( CGAffineTransformIdentity, 1.05, 1.05 );
             self.modalMaskView.alpha = 1.0f;
             self.modalContentView.alpha = 1.0f;
         } completion:^(BOOL finished) {
             [UIView animateWithDuration:0.2f animations: ^(void) {
                 self.modalContentView.transform = CGAffineTransformScale( CGAffineTransformIdentity, 0.95, 0.95 );
             }];
         }];
	}
	else
	{
		self.modalMaskView.alpha = 1.0f;
		self.modalContentView.alpha = 1.0f;
	}	
}

- (void)dismissModalViewAnimated:(BOOL)animated
{
	if (!self.modalContentView )
		return;
    
	if ( animated )
	{
        [UIView animateWithDuration:0.2f animations: ^(void) {
			self.modalMaskView.alpha = 0.0f;
			self.modalContentView.alpha = 0.0f;
			self.modalContentView.transform = CGAffineTransformScale( CGAffineTransformIdentity, 0.001, 0.001 );
        } completion:^(BOOL finished) {
            self.modalMaskView.hidden = YES;	
            [_modalContentView removeFromSuperview];
            [_modalContentView release], _modalContentView = nil;
        }];
	}
	else
	{
        self.modalMaskView.hidden = YES;	
        [_modalContentView removeFromSuperview];
        [_modalContentView release], _modalContentView = nil;
	}
}


#pragma mark - stub table view methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}


@end
