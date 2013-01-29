//
//  WASDebugMemoryView.m
//  WASDebug
//
//  Created by allen.wang on 11/21/12.
//  Copyright (c) 2012 b5m. All rights reserved.
//

#import "WASDebugMemoryView.h"
#import "WASDebugMemoryModel.h"

@implementation WASDebugMemoryView
- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if ( self )
	{
		self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
		self.layer.borderColor = [UIColor colorWithWhite:0.5f alpha:1.0f].CGColor;
		self.layer.borderWidth = 1.0f;
        
		CGRect plotFrame;
		plotFrame.size.width = frame.size.width;
		plotFrame.size.height = frame.size.height - 60;
		plotFrame.origin.x = 0.0f;
		plotFrame.origin.y = 20.0f;
		
		_plotView = [[WASDebugPlotsView alloc] initWithFrame:plotFrame];
		_plotView.alpha = 0.75f;
		_plotView.lowerBound = 0.0f;
		_plotView.upperBound = 0.0f;
		_plotView.lineColor = [UIColor yellowColor];
		_plotView.lineWidth = 2.0f;
		_plotView.capacity = MAX_MEMORY_HISTORY;
		[self addSubview:_plotView];
        
		CGRect titleFrame;
		titleFrame.size.width = 60.0f;
		titleFrame.size.height = 20.0f;
		titleFrame.origin.x = 8.0f;
		titleFrame.origin.y = 0.0f;
        
		_titleView = [[UILabel alloc] initWithFrame:titleFrame];
		_titleView.textColor = [UIColor orangeColor];
		_titleView.textAlignment = UITextAlignmentLeft;
		_titleView.font = [UIFont systemFontOfSize:12];
		_titleView.lineBreakMode = UILineBreakModeClip;
		_titleView.numberOfLines = 1;
		_titleView.text = @"Memory";
        _titleView.backgroundColor = [UIColor clearColor];
		[self addSubview:_titleView];
        
		CGRect statusFrame;
		statusFrame.size.width = frame.size.width - 16.0f - 60.0f;
		statusFrame.size.height = 20.0f;
		statusFrame.origin.x = 68.0f;
		statusFrame.origin.y = 0.0f;
        
		_statusView = [[UILabel alloc] initWithFrame:statusFrame];
		_statusView.textColor = [UIColor colorWithWhite:0.85f alpha:1.0f];
		_statusView.textAlignment = UITextAlignmentLeft;
		_statusView.font = [UIFont systemFontOfSize:12];
		_statusView.lineBreakMode = UILineBreakModeClip;
		_statusView.numberOfLines = 1;
        _statusView.backgroundColor = [UIColor clearColor];
		[self addSubview:_statusView];
        
		CGRect allocFrame;
		allocFrame.size.width = 50.0f;
		allocFrame.size.height = 26.0f;
		allocFrame.origin.x = 4.0f;
		allocFrame.origin.y = frame.size.height - 30.0f;
        
		_manualAlloc = [[UIButton alloc] initWithFrame:allocFrame];
		_manualAlloc.backgroundColor = [UIColor darkGrayColor];
		_manualAlloc.layer.borderColor = [UIColor lightGrayColor].CGColor;
		_manualAlloc.layer.borderWidth = 2.0f;
		_manualAlloc.titleLabel.font = [UIFont systemFontOfSize:12];
        [_manualAlloc setTitle:@"+50M" forState:UIControlStateNormal];
        [_manualAlloc setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_manualAlloc addTarget:self action:@selector(handleUISignal:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:_manualAlloc];
		
		allocFrame.origin.x += allocFrame.size.width + 3.0f;
		
		_manualFree = [[UIButton alloc] initWithFrame:allocFrame];
		_manualFree.backgroundColor = [UIColor darkGrayColor];
		_manualFree.layer.borderColor = [UIColor lightGrayColor].CGColor;
		_manualFree.layer.borderWidth = 2.0f;
		_manualFree.titleLabel.font = [UIFont systemFontOfSize:12];
        [_manualFree setTitle:@"-50M" forState:UIControlStateNormal];
        [_manualFree setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_manualFree addTarget:self action:@selector(handleUISignal:) forControlEvents:UIControlEventTouchUpInside];
        
        
		[self addSubview:_manualFree];
		
		allocFrame.origin.x += allocFrame.size.width + 3.0f;
		
		_manualAllocAll = [[UIButton alloc] initWithFrame:allocFrame];
		_manualAllocAll.backgroundColor = [UIColor darkGrayColor];
		_manualAllocAll.layer.borderColor = [UIColor lightGrayColor].CGColor;
		_manualAllocAll.layer.borderWidth = 2.0f;
		_manualAllocAll.titleLabel.font = [UIFont systemFontOfSize:12];
        [_manualAllocAll setTitle:@"+ALL" forState:UIControlStateNormal];
        [_manualAllocAll setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_manualAllocAll addTarget:self action:@selector(handleUISignal:) forControlEvents:UIControlEventTouchUpInside];
        
        
		[self addSubview:_manualAllocAll];
        
		allocFrame.origin.x += allocFrame.size.width + 3.0f;
		
		_manualFreeAll = [[UIButton alloc] initWithFrame:allocFrame];
		_manualFreeAll.backgroundColor = [UIColor darkGrayColor];
		_manualFreeAll.layer.borderColor = [UIColor lightGrayColor].CGColor;
		_manualFreeAll.layer.borderWidth = 2.0f;
		_manualFreeAll.titleLabel.font = [UIFont systemFontOfSize:12];
        [_manualFreeAll setTitle:@"-ALL" forState:UIControlStateNormal];
        [_manualFreeAll setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_manualFreeAll addTarget:self action:@selector(handleUISignal:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:_manualFreeAll];
		
		CGRect warningFrame;
		warningFrame.size.width = 100.0f;
		warningFrame.size.height = 26.0f;
		warningFrame.origin.x = frame.size.width - warningFrame.size.width - 4.0f;
		warningFrame.origin.y = frame.size.height - 30.0f;
		
		_autoWarning = [[UIButton alloc] initWithFrame:warningFrame];
		_autoWarning.backgroundColor = [UIColor darkGrayColor];
		_autoWarning.layer.borderColor = [UIColor lightGrayColor].CGColor;
		_autoWarning.layer.borderWidth = 2.0f;
		_autoWarning.titleLabel.font = [UIFont systemFontOfSize:12];
        [_autoWarning setTitle:@"Warning(Off)" forState:UIControlStateNormal];
        [_autoWarning setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_autoWarning addTarget:self action:@selector(handleUISignal:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:_autoWarning];
	}
	return self;
}

- (void)dealloc
{
	SAFE_RELEASE_SUBVIEW( _titleView );
	SAFE_RELEASE_SUBVIEW( _statusView );
	SAFE_RELEASE_SUBVIEW( _plotView );
	SAFE_RELEASE_SUBVIEW( _manualAllocAll );
	SAFE_RELEASE_SUBVIEW( _manualFreeAll );
	SAFE_RELEASE_SUBVIEW( _manualAlloc );
	SAFE_RELEASE_SUBVIEW( _manualFree );
	SAFE_RELEASE_SUBVIEW( _autoWarning );
    
	[super dealloc];
}

- (IBAction)handleUISignal:(id)sender
{
	UIButton *buttonSender = (UIButton *) sender;
	if ( buttonSender == _manualAllocAll )
	{
		[[WASDebugMemoryModel sharedInstance] allocAll];  
        [self update];
    }
	else if ( buttonSender == _manualFreeAll )
	{
		[[WASDebugMemoryModel sharedInstance] freeAll];  
        [self update];
	}
	else if ( buttonSender == _manualAlloc )
	{
		[[WASDebugMemoryModel sharedInstance] alloc50M];  
        [self update];
    }
	else if ( buttonSender == _manualFree )
	{
		[[WASDebugMemoryModel sharedInstance] free50M];   
        [self update];

    }
	else if ( buttonSender == _autoWarning)
	{
		[[WASDebugMemoryModel sharedInstance] toggleWarning];
		
		if ( [WASDebugMemoryModel sharedInstance].warningMode )
		{
            [_autoWarning setTitle:@"Warning(On)" forState:UIControlStateNormal];
            [_autoWarning setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
		}
		else
		{
            [_autoWarning setTitle:@"Warning(Off)" forState:UIControlStateNormal];
            [_autoWarning setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
		}
        [self update];
    }
}

- (void)update
{
	NSUInteger used = [WASDebugMemoryModel sharedInstance].usedBytes;
	NSUInteger total = [WASDebugMemoryModel sharedInstance].totalBytes;
	
	float percent = (total > 0.0f) ? ((float)used / (float)total * 100.0f) : 0.0f;
	if ( percent >= 50.0f )
	{
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.6f];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationRepeatAutoreverses:YES];
		[UIView setAnimationRepeatCount:CGFLOAT_MAX];
		
		self.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.6f];
		
		[UIView commitAnimations];
	}
	else
	{
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.6f];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationRepeatAutoreverses:NO];
		[UIView setAnimationRepeatCount:1];
		
		self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
		
		[UIView commitAnimations];
	}
    
	[_plotView setPlots:[WASDebugMemoryModel sharedInstance].chartDatas];
	[_plotView setUpperBound:[WASDebugMemoryModel sharedInstance].upperBound * 1.1f];
	[_plotView setNeedsDisplay];
	
	NSMutableString * text = [NSMutableString string];
	[text appendFormat:@"Used:%@  ", [WASDebugUtility number2String:used]];
	[text appendFormat:@"Free:%@ (%.0f%%)  ", [WASDebugUtility number2String:total - used], percent];
	_statusView.text = text;
}



@end
