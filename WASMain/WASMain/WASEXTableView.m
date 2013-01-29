//
//  WASEXTableView.m
//  WASMain
//
//  Created by allen.wang on 7/12/12.
//  Copyright (c) 2012 b5m. All rights reserved.
//

#import "WASEXTableView.h"

#define kRefreshOffsetY                 60.f
#define kReloadOffsetY                  60.f
#define kRefreshAnimationDuration       .18f

#define CONTENT_TEXT_COLOR              [UIColor colorWithRed:87.0/255.0    green:108.0/255.0   blue:137.0/255.0 alpha:1.0]
#define CONTENT_BORDER_COLOR            [UIColor colorWithRed:87.0/255.0    green:108.0/255.0   blue:137.0/255.0 alpha:1.0]

#pragma mark -- RefreshTableHeader private

@interface RefreshTableHeader()

@property (nonatomic, retain) UILabel *lastUpdatedLabel;
@property (nonatomic, retain) UILabel *statusLabel;
@property (nonatomic, retain) CALayer *arrowImage;
@property (nonatomic, retain) UIActivityIndicatorView *activityView;
@property (nonatomic, assign) eViewType viewType;

- (void) layoutItems;

@end

#pragma mark -- RefreshTableHeader 

@implementation  RefreshTableHeader
@synthesize lastUpdatedLabel    = _lastUpdatedLabel;
@synthesize statusLabel         = _statusLabel;
@synthesize arrowImage          = _arrowImage;
@synthesize activityView        = _activityView;
@synthesize state               = _state;
@synthesize viewType            = _viewType;

- (id)initWithFrame:(CGRect)frame
{    
    [NSException raise:@"Incomplete initializer"
                format:@"RefreshTableHeader must be initialized with a eViewType.\
     Use the initWithFrame:type: method."];
    return nil;
}

- (id)initWithFrame:(CGRect) frame type:(eViewType) theType
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
        [self lastUpdatedLabel];
        [self statusLabel];
        [self arrowImage];
        [self activityView];
        _viewType = theType;
        [self layoutItems];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


- (UILabel *)lastUpdatedLabel
{
    if (!_lastUpdatedLabel) 
    {
        _lastUpdatedLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_lastUpdatedLabel.autoresizingMask  = UIViewAutoresizingFlexibleWidth;
		_lastUpdatedLabel.font              = [UIFont systemFontOfSize:12.0f];
		_lastUpdatedLabel.textColor         = CONTENT_TEXT_COLOR;
		_lastUpdatedLabel.shadowColor       = [UIColor colorWithWhite:0.9f alpha:1.0f];
		_lastUpdatedLabel.shadowOffset      = CGSizeMake(0.0f, 1.0f);
		_lastUpdatedLabel.backgroundColor   = [UIColor clearColor];
		_lastUpdatedLabel.textAlignment     = UITextAlignmentCenter;
		[self addSubview:_lastUpdatedLabel];
    }
    return _lastUpdatedLabel;
}

- (UILabel *) statusLabel
{
    if (!_statusLabel) 
    {
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_statusLabel.autoresizingMask   = UIViewAutoresizingFlexibleWidth;
		_statusLabel.font               = [UIFont boldSystemFontOfSize:13.0f];
		_statusLabel.textColor          = CONTENT_TEXT_COLOR;
		_statusLabel.shadowColor        = [UIColor colorWithWhite:0.9f alpha:1.0f];
		_statusLabel.shadowOffset       = CGSizeMake(0.0f, 1.0f);
		_statusLabel.backgroundColor    = [UIColor clearColor];
		_statusLabel.textAlignment      = UITextAlignmentCenter;
		[self setState:eHeaderRefreshNormal];
		[self addSubview:_statusLabel];   
    }
    
    return _statusLabel;
}

- (CALayer *)arrowImage
{
    if (!_arrowImage) 
    {
        _arrowImage = [[CALayer alloc] init];
		_arrowImage.contentsGravity = kCAGravityResizeAspect;
		[[self layer] addSublayer:_arrowImage];   
    }
    
    return _arrowImage;
}

- (UIActivityIndicatorView *)activityView
{
    if (!_activityView) 
    {
        _activityView   = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		_activityView.hidesWhenStopped  = YES;
		[self addSubview:_activityView];
    }
    
    return _activityView;
}

- (void)layoutItems
{
    CGRect rect     = self.frame;
    
    if (eTypeHeader == _viewType) 
    {
        _activityView.frame         = CGRectMake(25.0f,rect.size.height - 38.0f, 20.0f, 20.0f);
        _arrowImage.frame           = CGRectMake(5.0f, rect.size.height - 52.f,  60.0f, 46.0f);
        _statusLabel.frame          = CGRectMake(0.0f, rect.size.height - 48.0f, rect.size.width, 20.0f);
        _lastUpdatedLabel.frame     = CGRectMake(0.0f, rect.size.height - 30.0f, rect.size.width, 20.0f);
        _arrowImage.contents        = (id)[UIImage imageNamed:@"blueArrow.png"].CGImage;
    }
    else
    {
        _activityView.frame         = CGRectMake(20.0f, 0.0f, 20.0f, 20.0f);
        _arrowImage.frame           = CGRectMake(20.0f, 0,  60.0f, 46.0f);
        _statusLabel.frame          = CGRectMake(0.0f, 0.0f, 320, 20.0f);
        _lastUpdatedLabel.frame     = CGRectMake(0.0f, 20.0f, 320, 20.0f);
        _arrowImage.contents        = (id)[UIImage imageNamed:@"blueArrowDown.png"].CGImage;
    }
}


- (void)setCurrentDate
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
	[formatter setAMSymbol:@"AM"];
	[formatter setPMSymbol:@"PM"];
	[formatter setDateFormat:@"yyyy/MM/dd hh:mm:ss at"];
	NSString *strTime = NSLocalizedString(@"最后更新:",@"");
	strTime = [strTime stringByAppendingString:[formatter stringFromDate:[NSDate date]]];
	_lastUpdatedLabel.text = [NSString stringWithString:strTime];
	[[NSUserDefaults standardUserDefaults] setObject:_lastUpdatedLabel.text forKey:@"EGORefreshTableView_LastRefresh"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	[formatter release];
}

- (void)setState:(eRefreshAndReloadState)aState
{
    switch (aState) 
    {
        case eHeaderRefreshPulling:
        {
            _statusLabel.text = NSLocalizedString(@"松开即可刷新...",@"");
            _arrowImage.hidden = NO;
            _activityView.hidden = YES;
            [CATransaction begin];
            [CATransaction setAnimationDuration:.18];
            _arrowImage.transform = CATransform3DMakeRotation(M_PI, 0.0f, 0.0f, 1.0f);
            [CATransaction commit];
        }
            break;
        case eHeaderRefreshNormal:
        {
            if (_state == eHeaderRefreshPulling) 
            {
                [CATransaction begin];
                [CATransaction setAnimationDuration:.18];
                _arrowImage.transform = CATransform3DIdentity;
                [CATransaction commit];
            }
            
            _arrowImage.hidden = NO;
            _activityView.hidden = YES;
            _statusLabel.text = NSLocalizedString(@"下拉可以刷新...",@"");
            [_activityView stopAnimating];
            
            [CATransaction begin];
            [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
            _arrowImage.hidden = NO;
            _arrowImage.transform = CATransform3DIdentity;
            [CATransaction commit];
        }
            break;
        case eHeaderRefreshLoading:
        {
            _statusLabel.text = NSLocalizedString(@"刷新中...",@"");
            
            _arrowImage.hidden = YES;
            _activityView.hidden = NO;
            [_activityView startAnimating];
            [CATransaction begin];
            [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
            _arrowImage.hidden = YES;
            [CATransaction commit];
        }
            break;
        case eFooterReloadPulling:
        {
            _statusLabel.text = NSLocalizedString(@"松开即可开始加载...",@"");
            _arrowImage.hidden = NO;
            _activityView.hidden = YES;
            [CATransaction begin];
            [CATransaction setAnimationDuration:.18];
            _arrowImage.transform = CATransform3DMakeRotation(M_PI, 0.0f, 0.0f, 1.0f);
            [CATransaction commit];
        }
            break;
        case eFooterReloadNormal:
        {
            if (_state == eFooterReloadPulling) 
            {
                [CATransaction begin];
                [CATransaction setAnimationDuration:.18];
                _arrowImage.transform = CATransform3DIdentity;
                [CATransaction commit];
            }
            
            _arrowImage.hidden = NO;
            _activityView.hidden = YES;
            _statusLabel.text = NSLocalizedString(@"上拉可以加载更多...",@"");
            [_activityView stopAnimating];
            
            [CATransaction begin];
            [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
            _arrowImage.hidden = NO;
            _arrowImage.transform = CATransform3DIdentity;
            [CATransaction commit];
        }
            break;
        case eFooterReloadLoading:
        {
            _statusLabel.text = NSLocalizedString(@"加载中...",@"");
            _activityView.hidden = NO;
            [_activityView startAnimating];
            [CATransaction begin];
            [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
            _arrowImage.hidden = YES;
            [CATransaction commit];
        }
            break;
        case eFooterReloadReachEnd:
        {
            _activityView.hidden    = YES;
            _arrowImage.hidden      = YES;
            _statusLabel.text       = NSLocalizedString(@"没有了哦", @"");
        }
            break;
            
        default:
            break;
    }
    _state = aState;
}

- (void)drawRect:(CGRect)rect
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextDrawPath(context, kCGPathFillStroke);
	[CONTENT_BORDER_COLOR setStroke];
	CGContextBeginPath(context);
	CGContextMoveToPoint(context, 0.0f, self.bounds.size.height);
	CGContextAddLineToPoint(context, self.bounds.size.width, self.bounds.size.height);
	CGContextStrokePath(context);
}

- (void)dealloc 
{
	[_activityView release ],       _activityView       = nil;
	[_statusLabel release ],        _statusLabel        = nil;
	[_arrowImage release ],         _arrowImage         = nil;
	[_lastUpdatedLabel release],    _lastUpdatedLabel   = nil;
    
    [super dealloc];
}

@end

#pragma mark -- WASEXTableView

@interface WASEXTableView() 
{
    BOOL            _isFooterInAction;
    UILabel         *_msgLabel;
    CGRect          headerFrame;
    CGRect          footerFrame;
}
@property (nonatomic, retain) RefreshTableHeader *headerView;
@property (nonatomic, retain) RefreshTableHeader *footerView;

- (void)flashMessage:(NSString *)msg;

@end

@implementation WASEXTableView
@synthesize headerView  = _headerView;
@synthesize footerView  = _footerView;
@synthesize exDelegate  = _exDelegate;
@synthesize didReachTheEnd          = _didReachTheEnd;
@synthesize autoScrollToNextPage    = _autoScrollToNextPage;

- (id)initWithFrame:(CGRect)frame
{
    [NSException raise:@"Incomplete initializer" 
                format:@"WASEXTableView must be initialized with a delegate and a eViewType.\
     Use the initWithFrame:style:type:delegate: method."];
    return nil;
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style type:(eViewType)theType delegate:(id) theDelegate
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
        self.exDelegate = theDelegate;
        
        CGRect rect = CGRectZero;
        
        /*if the theType contains eTypeHeader , then create it*/
        if (eTypeHeader == (theType & eTypeHeader)) {
            rect = CGRectMake(0, - frame.size.height, frame.size.width, frame.size.height);
            _headerView = [[RefreshTableHeader alloc] initWithFrame:rect type:eTypeHeader];
            [self addSubview:_headerView];
            headerFrame = _headerView.frame;            
        }
        
        /*if the theType contains eTypeFooter , then create it*/
        if (eTypeFooter == (theType & eTypeFooter)) {
            rect = CGRectMake(0, frame.size.height, frame.size.width, frame.size.height);
            _footerView = [[RefreshTableHeader alloc] initWithFrame:rect type:eTypeFooter];
            [self addSubview:_footerView];
            footerFrame = rect;
        }
        
        [self addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];        
    }
    return self;
}

- (void)dealloc 
{
	[_headerView release ], _headerView  = nil;
	[_footerView release ], _footerView  = nil;
    [_msgLabel release],    _msgLabel    = nil;
    _exDelegate = nil;
    
    [super dealloc];
}


#pragma mark -- scrollDelegate

- (void)scrollToNextPage 
{
    float h = self.frame.size.height;
    float y = self.contentOffset.y + h;
    y = y > self.contentSize.height ? self.contentSize.height : y;
    
    [UIView animateWithDuration:.7f 
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut 
                     animations:^{
                         self.contentOffset = CGPointMake(0, y);  
                     }
                     completion:^(BOOL bl){
                     }];
}

- (void)tableViewDidEndDragging:(UIScrollView *)scrollView
{
    if ((_headerView && _headerView.state == eHeaderRefreshLoading) || 
        (_footerView && _footerView.state == eFooterReloadLoading)) 
        return;
    
    if (_headerView && _headerView.state == eHeaderRefreshPulling) {
        
        _isFooterInAction = NO;
        _headerView.state = eHeaderRefreshLoading;
        
        [UIView animateWithDuration:kRefreshAnimationDuration animations:^{
            self.contentInset = UIEdgeInsetsMake(kRefreshOffsetY, 0, 0, 0);
            _headerView.frame = headerFrame;

        }];
        
        if (_exDelegate && [_exDelegate respondsToSelector:@selector(tableViewDidStartRefreshing:)]) {
            [_exDelegate tableViewDidStartRefreshing:self];
        }
    } 
    else if (_footerView && _footerView.state == eFooterReloadPulling)  {
        if (self.didReachTheEnd) 
            return;
        
        _isFooterInAction = YES;
        _footerView.state = eFooterReloadLoading;
        [UIView animateWithDuration:kRefreshAnimationDuration animations:^{
            self.contentInset = UIEdgeInsetsMake(0, 0, kRefreshOffsetY, 0);
//            NSLog(@"_footerView.frame.origin.y = %f",_footerView.frame.origin.y);
            _footerView.frame = footerFrame;
//            NSLog(@"_footerView.frame.origin.y =----------- %f",_footerView.frame.origin.y);


        }];
        if (_exDelegate && [_exDelegate respondsToSelector:@selector(tableViewDidStartLoading:)]) {
            [_exDelegate tableViewDidStartLoading:self];
        }
    }
    
}

- (void)tableViewDidScroll:(UIScrollView *)scrollView {
    
    CGPoint offset      = scrollView.contentOffset;
    CGSize size         = scrollView.frame.size;
    CGSize contentSize  = scrollView.contentSize;
    
    float yMargin = offset.y + size.height - contentSize.height;
    
//    NSLog(@"offset.y = %f,  yMargin= %f ,header.frame.origin.y= %f",offset.y,  yMargin, _headerView.frame.origin.y);
    
    if (_headerView && offset.y < -kRefreshOffsetY )                        //header totally appeard
    {
        CGRect rect = headerFrame;
        rect.origin.y =  headerFrame.origin.y +  (offset.y + kRefreshOffsetY)/2;
        _headerView.frame = rect;
        if (_headerView.state != eHeaderRefreshLoading) {
            _headerView.state = eHeaderRefreshPulling;
        }
    } 
    else if (_headerView && offset.y > -kRefreshOffsetY && offset.y < 0)   //header part appeared
    {
        if (_headerView.state != eHeaderRefreshLoading) {
            _headerView.state = eHeaderRefreshNormal;
        }
    } 
    else if (_footerView && yMargin > kReloadOffsetY)                     //footer totally appeared
    {  
        
        CGRect rect     = footerFrame;  //no
        rect.origin.y   =  footerFrame.origin.y  + (yMargin - kReloadOffsetY )/2 ;
        _footerView.frame = rect;
        if (_footerView.state == eFooterReloadLoading) {
            return;
        }
        else if (_footerView.state != eFooterReloadReachEnd) {
            _footerView.state = eFooterReloadPulling;
        }
    } 
    else if (_footerView && yMargin < kReloadOffsetY && yMargin > 0)      //footer part appeared
    {
        if (_footerView.state == eFooterReloadLoading) {
            return;
        }
        else if (_footerView.state != eFooterReloadReachEnd) {
            _footerView.state = eFooterReloadNormal;
        }
    }
}


- (void)flashMessage:(NSString *)msg
{
    
    __block CGRect rect = CGRectMake(0, self.contentOffset.y - 20, self.bounds.size.width, 20);
    
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.font = [UIFont systemFontOfSize:14.f];
        _msgLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _msgLabel.backgroundColor = [UIColor orangeColor];
        _msgLabel.textAlignment = UITextAlignmentCenter;
    }
    else  {
        _msgLabel.frame = rect;
        _msgLabel.text = msg;
        [self addSubview:_msgLabel];    
    }
    rect.origin.y += 20;
    
    [UIView animateWithDuration:.3f 
                     animations:^ {
         _msgLabel.frame = rect;
     } 
                     completion:^(BOOL finished) {
         rect.origin.y -= 20;
         [UIView animateWithDuration:.3f 
                               delay:1.0f 
                             options:UIViewAnimationOptionCurveLinear 
                          animations:^ {
              _msgLabel.frame = rect;
          } 
                          completion:^(BOOL finished) {
              [_msgLabel removeFromSuperview];
          }];
     }];
}

- (void)launchRefreshing 
{
    [self setContentOffset:CGPointMake(0,0) animated:NO];
    [UIView animateWithDuration:kRefreshAnimationDuration
                     animations:^ {
         self.contentOffset = CGPointMake(0, -kRefreshOffsetY-1);
     } 
                     completion:^(BOOL bl) {
         [self tableViewDidEndDragging:self];
     }];
}

- (void)tableViewDidFinishedLoading 
{
    [self tableViewDidFinishedLoadingWithMessage:nil];  
}

- (void)tableViewDidFinishedLoadingWithMessage:(NSString *)msg
{
    if (_headerView && _headerView.state == eHeaderRefreshLoading) {
        [_headerView setState:eHeaderRefreshNormal];
        [_headerView setCurrentDate];
        
        [UIView animateWithDuration:kRefreshAnimationDuration*2 
                              delay:0 
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^ {
             self.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
         } 
                         completion:^(BOOL bl) {
             if (msg && ![msg isEqualToString:@""]) {
                 [self flashMessage:msg];
             }
         }];
    }
    else if (_footerView /*&& _footerView.state == eFooterReloadLoading*/) {
        [_footerView setState:eFooterReloadNormal];
        [_footerView setCurrentDate];
        
        [UIView animateWithDuration:kRefreshAnimationDuration    //no
                         animations:^ {
             self.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
         } 
                         completion:^(BOOL bl) {
             if (msg && ![msg isEqualToString:@""]) {
                 [self flashMessage:msg];
             }
         }];
    }
}

- (void)setDidReachTheEnd:(BOOL)theDidReachTheEnd
{
    _didReachTheEnd = theDidReachTheEnd;
    if (_didReachTheEnd) {
        if (_footerView)  {
            _footerView.state = eFooterReloadReachEnd;
        }
        if (_footerView.superview) {      //no
            [_footerView removeFromSuperview];
        }
    }
    else {
        if (_footerView) {
            _footerView.state = eFooterReloadNormal;
        }
        if (!_footerView.superview) {     //no
            [self addSubview:_footerView];
        }
    }
}
#pragma mark - 

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context 
{
    CGRect frame = _footerView.frame;
    CGSize contentSize = self.contentSize;
    frame.origin.y = (contentSize.height < self.frame.size.height) ? self.frame.size.height : contentSize.height;
    _footerView.frame = frame;
    footerFrame = frame;

    
//    if (self.autoScrollToNextPage && _isFooterInAction) 
//    {
//        [self scrollToNextPage];  no
//        _isFooterInAction = NO;
//    } 
//    else if (_isFooterInAction) 
//    {
//        CGPoint offset = self.contentOffset;
//        offset.y += 44.0f;
//        self.contentOffset = offset;
//    }
    
    
}

@end
