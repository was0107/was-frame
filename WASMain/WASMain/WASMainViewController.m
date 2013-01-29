//
//  WASMainViewController.m
//  WASMain
//
//  Created by iPhoneTeam BCS on 3/21/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "WASMainViewController.h"
#import "DetailViewController_iPhone.h"
#import "Validator.h"


#define kHostIP     @"158.236.224.58"
#define kHostPort   50000

@implementation WASMainViewController
@synthesize mainTableView       = mainTableView_;
@synthesize filed               = _filed;
@synthesize filed1               = _filed1;
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    
	tagsArray = [[NSArray arrayWithObjects:@"main",@"audio",@"video",@"network",@"database",nil] retain];
    
//    sendTimer = [[NSTimer scheduledTimerWithTimeInterval:0.20f
//                                                  target:self
//                                                selector:@selector(sendTimerFired:)
//                                                userInfo:nil
//                                                 repeats:YES] retain];
/*        
    mainTableView_  = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 
                                                                   CGRectGetWidth(self.view.frame), 
                                                                   CGRectGetHeight(self.view.frame)) 
                                                  style:UITableViewStylePlain];
    mainTableView_.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    mainTableView_.delegate = self;
    mainTableView_.dataSource = self;
    LogMessage(@"MainTable", kLoggerLevel4, @"%s:%d:%@",__FUNCTION__,__LINE__,[mainTableView_ description]);
    [self.view addSubview:mainTableView_];
    self.view.autoresizesSubviews  = YES;
        
 
    Validator *valide = [[Validator alloc] init];    
    [valide textLengthValiDate:self.filed maxLength:4 onFail:^(id obj) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"FDF" message:@"FD" delegate:nil cancelButtonTitle:@"fdfd" otherButtonTitles:nil, nil];
        [alert show];
    }];
    */
     bind = [[Binding alloc] init];
   
    
    [bind bind:self.filed1 keyPath:@"text" target:self.filed targetKeypath:@"text"];
    
    
    
    [super viewDidLoad];
}

- (void)dealloc
{
	[sendTimer invalidate];
	[sendTimer release];
	[tagsArray release];
    [mainTableView_ release];
    [super dealloc];
}

- (void)viewDidUnload
{    
    
    [mainTableView_ release];

    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated    // Called when the view is about to made visible. Default does nothing
{
    LogMessage(@"MainTable", kLoggerLevel4, @"%s:%d:%@",__FUNCTION__,__LINE__,[mainTableView_ description]);
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    LogMessage(@"MainTable", kLoggerLevel4, @"%s:%d:%@",__FUNCTION__,__LINE__,[mainTableView_ description]);

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    
}

- (void) setLoggerHostAndPort
{
//    LoggerSetViewerHost(NULL, (CFStringRef)kHostIP, (UInt32)kHostPort);
//    LoggerSetOptions(NULL,						// configure the default logger
//                     kLoggerOption_BufferLogsUntilConnection |
//                     kLoggerOption_UseSSL |
//                     (YES ? kLoggerOption_BrowseBonjour : 0) |
//                     (YES ? kLoggerOption_BrowseOnlyLocalDomain : 0));
}

- (void)sendTimerFired:(NSTimer *)timer
{
	static int image = 1;
	int phase = arc4random() % 10;
	if (phase != 1 && phase != 5)
	{
		NSMutableString *s = [NSMutableString stringWithFormat:@"test log message %d - Random characters follow: ", counter++];
		int nadd = 1 + arc4random() % 150;
		for (int i = 0; i < nadd; i++)
			[s appendFormat:@"%c", 32 + (arc4random() % 27)];
		LogMessage([tagsArray objectAtIndex:(arc4random() % [tagsArray count])], arc4random() % 3, s);
	}
	else if (phase == 1)
	{
		unsigned char *buf = (unsigned char *)malloc(1024);
		int n = 1 + arc4random() % 1024;
		for (int i = 0; i < n; i++)
			buf[i] = (unsigned char)arc4random();
		NSData *d = [[NSData alloc] initWithBytesNoCopy:buf length:n];
		LogData(@"main", 1, d);
		[d release];
	}
	else if (phase == 5)
	{
		imagesCounter++;
		UIGraphicsBeginImageContext(CGSizeMake(100, 100));
		CGContextRef ctx = UIGraphicsGetCurrentContext();
		CGFloat r = (CGFloat)(arc4random() % 256) / 255.0f;
		CGFloat g = (CGFloat)(arc4random() % 256) / 255.0f;
		CGFloat b = (CGFloat)(arc4random() % 256) / 255.0f;
		UIColor *fillColor = [UIColor colorWithRed:r green:g blue:b alpha:1.0f];
		CGContextSetFillColorWithColor(ctx, fillColor.CGColor);
		CGContextFillRect(ctx, CGRectMake(0, 0, 100, 100));
		CGContextSetTextMatrix(ctx, CGAffineTransformConcat(CGAffineTransformMakeTranslation(0, 100), CGAffineTransformMakeScale(1.0f, -1.0f)));
		CGContextSelectFont(ctx, "Helvetica", 14.0, kCGEncodingMacRoman);
		CGContextSetShadowWithColor(ctx, CGSizeMake(1, 1), 1.0f, [UIColor whiteColor].CGColor);
		CGContextSetTextDrawingMode(ctx, kCGTextFill);
		CGContextSetFillColorWithColor(ctx, [UIColor blackColor].CGColor);
		char buf[64];
		sprintf(buf, "Log Image %d", image++);
		CGContextShowTextAtPoint(ctx, 0, 50, buf, strlen(buf));
		UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
		CGSize sz = img.size;
		LogImageData(@"image", 0, sz.width, sz.height, UIImagePNGRepresentation(img));
		UIGraphicsEndImageContext();
	}
	if (phase == 0)
	{
		[NSThread detachNewThreadSelector:@selector(sendLogFromAnotherThread:)
								 toTarget:self
							   withObject:[NSNumber numberWithInteger:counter++]];
	}
}

- (void)sendLogFromAnotherThread:(NSNumber *)counterNum
{
	LogMessage(@"transfers", 0, @"message %d from standalone thread", [counterNum integerValue]);
}




#pragma --
#pragma UITableViewDataSource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Header";
}

//- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
//{
//    return @"Footer";
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *mainTableViewIdentifier = @"mainTableViewIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mainTableViewIdentifier];
    if (!cell) 
    {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle 
                                      reuseIdentifier:mainTableViewIdentifier] autorelease];
    }
    cell.textLabel.text         = @"This is main text label";
    cell.detailTextLabel.text   = @"This is detail text label";
    LogMessage(@"UITableViewCell", kLoggerLevel4, @"%s:%d:%@",__FUNCTION__,__LINE__,[cell description]);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController_iPhone *detail = [[DetailViewController_iPhone alloc]init];
    
    [self.navigationController pushViewController:detail animated:YES];
    [detail release];
}


@end



