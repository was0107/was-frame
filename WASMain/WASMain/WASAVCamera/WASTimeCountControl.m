//
//  WASTimeCountControl.m
//  WASMain
//
//  Created by allen.wang on 8/9/12.
//  Copyright (c) 2012 b5m. All rights reserved.
//

#import "WASTimeCountControl.h"

@interface WASTimeCountControl()
@property (nonatomic, assign) NSUInteger time;
@property (nonatomic, retain) NSString   *timeString;
@property (nonatomic, retain) NSTimer    *calTimer;
@end

@interface WASTimeCountControl(InternalMethods)

/**
 *	@brief	set time count
 *
 *	@param 	time 	
 */
- (void) setTime:(NSUInteger)time;

/**
 *	@brief	refresh UI
 */
- (void) fireTime;

/**
 *	@brief	start a timer
 */
- (void) startTimer;

/**
 *	@brief	calcurate time string 
 */
- (void) calcaTimeString;

/**
 *	@brief	start or pause the timer
 *
 *	@param 	timeCountType 	timeCountType description
 */
- (void) setTimeCountType:(EWASTimeCountState)timeCountType;

@end

@implementation WASTimeCountControl
@synthesize timeCountType= _timeCountType;
@synthesize time         = _time;
@synthesize timeString   = _timeString;
@synthesize calTimer     = _calTimer;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.alpha           = 0.5f;
        self.timeString      = @"00:00";

    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [super drawRect:rect];
    [[UIColor blackColor] set];
    CGRect newRect = rect;
    newRect.origin.y = 8.0f;
    [self.timeString drawInRect:newRect withFont:[UIFont systemFontOfSize:18] lineBreakMode:UILineBreakModeMiddleTruncation alignment:UITextAlignmentCenter];
}


- (void) dealloc
{
    [_calTimer invalidate], _calTimer = nil;
    self.timeString  = nil;
    [super dealloc];
}
@end


@implementation WASTimeCountControl(InternalMethods)

- (void) setTime:(NSUInteger)time   
{
    if (time != _time) {
        _time = time;
        
        [self calcaTimeString];
        [self setNeedsDisplay];
    }
}

- (void) fireTime
{
    [self setTime:self.time+1];
}

- (void) startTimer
{
    if (!_calTimer) {
        _calTimer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(fireTime) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_calTimer forMode:NSDefaultRunLoopMode];
    }
}

- (void) calcaTimeString
{
    if (self.time <10) {
        self.timeString = [NSString stringWithFormat:@"00:0%lu",(unsigned long)self.time];
    }
    else if (self.time < 60) {
        self.timeString = [NSString stringWithFormat:@"00:%lu",(unsigned long)self.time];
    }
    else if (self.time < 3600) {
        self.timeString = [NSString stringWithFormat:@"%u:%d",self.time/60, self.time%60];
    }
}


- (void) setTimeCountType:(EWASTimeCountState)timeCountType
{
    if (_timeCountType != timeCountType) {
        _timeCountType  = timeCountType;
    }
    switch (_timeCountType) {
        case EWASMultipleTimeCountStart:
            [self startTimer];
            break;
        case EWASMultipleTimeCountPause:
            [_calTimer invalidate], _calTimer = nil;
            self.timeString = @"暂停中";
            [self setNeedsDisplay];
            break;
        case EWASMultipleTimeCountStop:
            [_calTimer invalidate], _calTimer = nil;
            self.time = 0;
            break;
            
        default:
            break;
    }
}
@end
