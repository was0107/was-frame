//
//  WASDebugSandBoxViewController.m
//  WASDebug
//
//  Created by allen.wang on 11/21/12.
//  Copyright (c) 2012 b5m. All rights reserved.
//

#import "WASDebugSandBoxViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "WASDebugDetailView.h"

#define STRING_BACK_TO_TOP_FOLDER   @".."


@implementation WasDebugSandboxCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
        _iconView = [[UIImageView alloc] init];
        [self addSubview:_iconView];
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.textColor = [UIColor grayColor];
        _nameLabel.textAlignment = UITextAlignmentLeft;
        _nameLabel.font = [UIFont systemFontOfSize:13];
        _nameLabel.lineBreakMode = UILineBreakModeHeadTruncation;
        _nameLabel.numberOfLines = 2;
        [self addSubview:_nameLabel];
        
        _sizeLabel = [[UILabel alloc] init];
        _sizeLabel.textColor = [UIColor grayColor];
        _sizeLabel.backgroundColor = [UIColor clearColor];
        _sizeLabel.textAlignment = UITextAlignmentRight;
        _sizeLabel.font = [UIFont systemFontOfSize:13];
        _sizeLabel.lineBreakMode = UILineBreakModeClip;
        _sizeLabel.numberOfLines = 1;
        [self addSubview:_sizeLabel];
        
        _lineLabel = [[UIView alloc] init];
        _lineLabel.backgroundColor = [UIColor lightGrayColor];
        _lineLabel.alpha = 0.5f;
        [self addSubview:_lineLabel];
    }
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    CGSize bound = self.frame.size;
    
    CGRect iconFrame;
	iconFrame.size.width = bound.height;
	iconFrame.size.height = bound.height;
	iconFrame.origin.x = 0.0f;
	iconFrame.origin.y = 0.0f;
	_iconView.frame = iconFrame;
    
	CGRect nameFrame;
	nameFrame.size.width = bound.width - iconFrame.size.width - 4.0f - 60.0f;
	nameFrame.size.height = bound.height;
	nameFrame.origin.x = iconFrame.size.width + 2.0f;
	nameFrame.origin.y = 0.0f;
	_nameLabel.frame = nameFrame;
	
	CGRect sizeFrame;
	sizeFrame.size.width = 50.0f;
	sizeFrame.size.height = bound.height;
	sizeFrame.origin.x = bound.width - sizeFrame.size.width - 5.0f;
	sizeFrame.origin.y = 0.0f;
	_sizeLabel.frame = sizeFrame;
    
    
    CGRect lineFrame = self.frame;
    lineFrame.origin.y = lineFrame.size.height - .5f;
    lineFrame.size.height = 1;
    _lineLabel.frame = lineFrame;
}

- (void)bindData:(NSObject *)data
{
	NSString * filePath = (NSString *)data;
	if ( [filePath isEqualToString:STRING_BACK_TO_TOP_FOLDER] )
	{
		_nameLabel.text = STRING_BACK_TO_TOP_FOLDER;
		_iconView.image = __IMAGE( @"folder.png" );
		_sizeLabel.text = @"";
	}
	else
	{
		BOOL isDirectory = NO;	
		NSDictionary * attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:NULL];
		if ( attributes )
		{
			if ( [[attributes fileType] isEqualToString:NSFileTypeDirectory] )
			{
				isDirectory = YES;
			}
		}
		
		_nameLabel.text = [(NSString *)data lastPathComponent];
		_iconView.image = __IMAGE( isDirectory ? @"folder.png" : @"file.png" );
		_sizeLabel.text = @"";
		
		if ( NO == isDirectory )
		{
			NSDictionary * attribs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:NULL];
			if ( attribs )
			{
				NSNumber * size = [attribs objectForKey:NSFileSize];
				_sizeLabel.text = [WASDebugUtility number2String:[size integerValue]];
			}
		}
	}
}

- (void)dealloc
{
    [_iconView release], _iconView = nil;
    [_nameLabel release], _nameLabel = nil;
    [_sizeLabel release], _sizeLabel = nil;
    [_lineLabel release], _lineLabel = nil;
	[super dealloc];
}

@end


@implementation WASDebugSandBoxViewController
@synthesize filePath = _filePath;
DEF_SINGLETON(WASDebugSandBoxViewController)

- (id) init
{
    self = [super init];
    if (self) {
            self.filePath = NSHomeDirectory();
    }
    return self;
}

- (void) setFilePath:(NSString *)filePath
{
    if (_filePath != filePath) {
        [_filePath  release];
        _filePath = [filePath copy];
    }
    
    self.contents = [NSMutableArray arrayWithCapacity:10];
    [self.contents addObject:STRING_BACK_TO_TOP_FOLDER];
    [self.contents addObjectsFromArray:[[NSFileManager defaultManager] contentsOfDirectoryAtPath:_filePath error:NULL]];
    
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
	// Do any additional setup after loading the view.
//    [self setBaseInsets:UIEdgeInsetsMake(0.0f, 0, 44.0f, 0)];

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

#pragma mark -
#pragma mark UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.contents count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* WasDebugSandboxCellIdentifier = @"WasDebugSandboxCellIdentifier";
    WasDebugSandboxCell* cell = [tableView dequeueReusableCellWithIdentifier:WasDebugSandboxCellIdentifier];
    
    if (!cell) {
        cell = [[[WasDebugSandboxCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:WasDebugSandboxCellIdentifier] autorelease];
        cell.backgroundColor = [UIColor colorWithRed:236.0f/255.0f green:236.0f/255.0f blue:236.0f/255.0f alpha:1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    NSString * file = [self.contents objectAtIndex:indexPath.row];
    if ( [file isEqualToString:STRING_BACK_TO_TOP_FOLDER] )
    {
        [cell bindData:file];
    }
    else
    {
        NSString * path = [NSString stringWithFormat:@"%@/%@", self.filePath, file];
        [cell bindData:path];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString * file = [self.contents objectAtIndex:indexPath.row];
	if ( [file isEqualToString:STRING_BACK_TO_TOP_FOLDER] )
	{
        [self.navigationController popViewControllerAnimated:YES];
		return;
	}
	
	BOOL isDirectory = NO;
	NSString * path = [NSString stringWithFormat:@"%@/%@", self.filePath, file];
	NSDictionary * attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:NULL];
	if ( attributes )
	{
		if ( [[attributes fileType] isEqualToString:NSFileTypeDirectory] )
		{
			isDirectory = YES;
		}
	}
    
	if ( isDirectory )
	{
		WASDebugSandBoxViewController * viewController = [[WASDebugSandBoxViewController alloc] init];
		viewController.filePath = path;        
        [self.navigationController pushViewController:viewController animated:YES];
		[viewController release];
	}
    else
	{
        
        CGRect detailFrame = self.view.bounds;
        detailFrame.origin.y += 20;
        detailFrame.size.height -= 44.0f;
        
		if ( [path hasSuffix:@".png"] || [path hasSuffix:@".jpg"] || [path hasSuffix:@".jpeg"] || [path hasSuffix:@".gif"] )
		{
			WASDebugImageView * detailView = [[WASDebugImageView alloc] initWithFrame:detailFrame];
			[detailView setFilePath:path];
			[self presentModalView:detailView animated:YES];
			[detailView release];
		}
		else if ( [path hasSuffix:@".strings"] || [path hasSuffix:@".plist"] || [path hasSuffix:@".txt"] )
		{
			WASDebugTextView * detailView = [[WASDebugTextView alloc] initWithFrame:detailFrame];
			[detailView setFilePath:path];
			[self presentModalView:detailView animated:YES];
			[detailView release];
		}
		else
		{
			WASDebugTextView * detailView = [[WASDebugTextView alloc] initWithFrame:detailFrame];
			[detailView setFilePath:path];
			[self presentModalView:detailView animated:YES];
			[detailView release];
		}
	}

}

@end
