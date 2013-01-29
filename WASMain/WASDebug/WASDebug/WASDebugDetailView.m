//
//  WASDebugDetailView.m
//  WASDebug
//
//  Created by allen.wang on 11/21/12.
//  Copyright (c) 2012 b5m. All rights reserved.
//

#import "WASDebugDetailView.h"
#import "WASDebugBaseController.h"

@implementation WASDebugTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self )
    {		
        self.backgroundColor = [UIColor clearColor];
        
        CGRect contentFrame = frame;
        contentFrame.origin = CGPointZero;
        contentFrame = CGRectInset(contentFrame, 10.0f, 10.0f);
        
        _content = [[UITextView alloc] initWithFrame:contentFrame];
        _content.font = [UIFont systemFontOfSize:13];
        _content.textColor = [UIColor blackColor];
        _content.textAlignment = UITextAlignmentLeft;
        _content.editable = NO;
        _content.dataDetectorTypes = UIDataDetectorTypeLink;
        _content.scrollEnabled = YES;
        _content.backgroundColor = [UIColor whiteColor];
        _content.layer.borderColor = [UIColor grayColor].CGColor;
        _content.layer.borderWidth = 2.0f;
        [self addSubview:_content];
        
        CGRect closeFrame;
        closeFrame.size.width = 40.0f;
        closeFrame.size.height = 40.0f;
        closeFrame.origin.x = frame.size.width - closeFrame.size.width + 5.0f;
        closeFrame.origin.y = -5.0f;
        
        _close = [[UIButton alloc] initWithFrame:closeFrame];
        [_close setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [_close addTarget:self action:@selector(closeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_close];
    }
    return self;
}

- (void)setFilePath:(NSString *)path
{
	if ( [path hasSuffix:@".plist"] || [path hasSuffix:@".strings"] )
	{
		_content.text = [[NSDictionary dictionaryWithContentsOfFile:path] description];
	}
	else
	{
		NSData * data = [NSData dataWithContentsOfFile:path];
        if (data && [data bytes]) {
            _content.text = [NSString stringWithUTF8String:[data bytes]];
        }
	}
}

- (IBAction)closeButtonAction:(id)sender
{
    [self.baseController dismissModalViewAnimated:YES];
}

- (void)dealloc
{
    [_content release], _content = nil;
    [_close release], _close = nil;

	[super dealloc];
}

@end



@implementation WASDebugImageView


- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if ( self )
	{
		self.backgroundColor = [UIColor whiteColor];
        
        self.layer.borderColor = [UIColor grayColor].CGColor;
        self.layer.borderWidth = 2.0f;
		
		CGRect bounds = frame;
		bounds.origin = CGPointZero;
		bounds = CGRectInset( bounds, 10.0f, 10.0f );
		
		_imageView = [[UIImageView alloc] initWithFrame:bounds];
		_imageView.contentMode = UIViewContentModeCenter;
        [self addSubview:_imageView];

		CGRect closeFrame;
		closeFrame.size.width = 40.0f;
		closeFrame.size.height = 40.0f;
		closeFrame.origin.x = frame.size.width - closeFrame.size.width + 5.0f;
		closeFrame.origin.y = -5.0f;
		_close = [[UIButton alloc] initWithFrame:closeFrame];
        [_close setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [_close addTarget:self action:@selector(closeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:_close];
	}
	return self;
}

- (void)setFilePath:(NSString *)path
{
	_imageView.image = [UIImage imageWithContentsOfFile:path];
}

- (void)setURL:(NSString *)url
{
    dispatch_queue_t queue = dispatch_queue_create( "com.was.debug", nil );
    dispatch_async(queue,^(void){
        UIImage *image = [UIImage imageWithData:[NSURL URLWithString:url]];
        dispatch_async(dispatch_get_main_queue(), ^{
            _imageView.image = image;
        });
    });
}


- (IBAction)closeButtonAction:(id)sender
{
    [self.baseController dismissModalViewAnimated:YES];
}


- (void)dealloc
{
    [_imageView release], _imageView = nil;
    [_close release], _close = nil;
	
	[super dealloc];
}

@end

















