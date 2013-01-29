//
//  WASBrowseVideoViewController.m
//  WASMain
//
//  Created by allen.wang on 8/10/12.
//  Copyright (c) 2012 b5m. All rights reserved.
//

#import "WASBrowseVideoViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <CoreLocation/CoreLocation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "WASBrowseVideoItemViewController.h"
#import "WASAssetBrowseSource.h"




@interface WASBrowseVideoViewController ()<CLLocationManagerDelegate,WASAssetBrowserSourceDelegate>
{
    CLLocationManager       *location;
    __block NSUInteger      totalCount;
    BOOL                    haveBuiltSourceLibraries;
    WASAssetBrowseSource    *_source;
}

@property (nonatomic, retain) NSArray        *videoArray;
@property (nonatomic, assign) NSUInteger     totalVideo;

@end

@implementation WASBrowseVideoViewController
@synthesize videoArray = _videoArray;
@synthesize totalVideo = _totalVideo;

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
    
    self.title = @"相机胶卷";
    
    self.tableView.rowHeight = 65.0; // 1 point is for the divider, we want our thumbnails to have an even height.

    
    if (!_source) {
        _source = [[WASAssetBrowseSource assetBrowserSourceOfType:WASAssetBrowserSourceTypeCameraRoll] retain];
        _source.delegate = self;
        [_source buildSourceLibrary];
    }
    
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"please open location function!");
    }
    
    if (!location) {
        location = [[CLLocationManager alloc] init] ;
        location.delegate = self;
    }
    
    [location startUpdatingLocation];
    
    [self videoArray];
    
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    if (haveBuiltSourceLibraries)
		return;
	
	haveBuiltSourceLibraries = YES;
}

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    [location stopUpdatingLocation];

}


- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    [location stopUpdatingLocation];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil){
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier] autorelease];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"相机胶卷（%d）",totalCount];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WASBrowseVideoItemViewController *controller = [[[WASBrowseVideoItemViewController alloc] init] autorelease];
    controller.videoArray = self.videoArray;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)assetBrowserSourceItemsDidChange:(WASAssetBrowseSource*)source
{
    totalCount = [source.items count];
    self.videoArray = _source.items;
    NSLog(@"totalCount = %d", totalCount);
    [self.tableView reloadData];
}


@end
