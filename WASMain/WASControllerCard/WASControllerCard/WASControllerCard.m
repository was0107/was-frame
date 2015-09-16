//
//  WASControllerCard.m
//  WASControllerCard
//
//  Created by allen.wang on 7/16/13.
//  Copyright (c) 2013 allen.wang. All rights reserved.
//

#import "WASControllerCard.h"
#import <QuartzCore/QuartzCore.h>

#define kDefaultMinimizedScalingFactor 0.98
#define kDefaultMaximizedScalingFactor 1.00    
#define kDefaultNavigationBarOverlap 0.9

#define kDefaultAnimationDuration 0.3 

#define kDefaultVerticalOrigin 100           
#define kDefaultCornerRadius 2.0

#define kDefaultShadowEnabled NO
#define kDefaultShadowColor [UIColor blackColor]
#define kDefaultShadowOffset CGSizeMake(0, -5)
#define kDefaultShadowRadius kDefaultCornerRadius
#define kDefaultShadowOpacity 0.60
#define kDefaultMinimumPressDuration 0.2



#pragma mark ==
#pragma mark WASCardViewController


@interface WASCardViewController()<UIGestureRecognizerDelegate>

- (CGFloat) defaultVerticalOriginForControllerCard: (WASControllerCard*) controllerCard atIndex:(NSUInteger) index;

- (CGFloat) scalingFactorForIndex: (NSUInteger) index;

@end

@implementation WASCardViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.view.frame = [[UIScreen mainScreen] bounds];
    [self reloadData];
    [self reloadInputViews];
    
}

- (CGFloat) defaultVerticalOriginForControllerCard: (WASControllerCard*) controllerCard atIndex:(NSUInteger) index
{
    CGFloat originOffset = 0.0f;
    for (int i = 0 ; i < index; i++) {
        CGFloat scalingFactor = [self scalingFactorForIndex:i];
        originOffset += scalingFactor * controllerCard.navigationController.navigationBar.frame.size.height * kDefaultNavigationBarOverlap;
    }
    return kDefaultVerticalOrigin + originOffset;
}

- (CGFloat) scalingFactorForIndex: (NSUInteger) index
{
    return powf(kDefaultMinimizedScalingFactor, (_totalCards - index));
}

- (void) reloadData
{
    _totalCards = [self numberOfControllerCardsInController:self];
    
    NSMutableArray *navigationControllers = [[[NSMutableArray alloc] initWithCapacity:_totalCards] autorelease];
    for (int i = 0 ; i < _totalCards; i++) {
        UIViewController *viewController = [self controller:self viewControllerAtIndex:i];
        UINavigationController *navigationController = [[[UINavigationController alloc] initWithRootViewController:viewController] autorelease];
        WASControllerCard *controllerCard = [[[WASControllerCard alloc] initWithController:self navigationController:navigationController index:i] autorelease];
        [controllerCard setDelegate:self];
        [navigationControllers addObject:controllerCard];
    }
    
    self.controllerCards = [NSArray arrayWithArray:navigationControllers];
}

- (void) reloadInputViews
{
    [super reloadInputViews];
    [self removeNavigationContainersFromSuperView];
    for (WASControllerCard* container in self.controllerCards) {
        [self.view addSubview:container];
    }
}

-(void) removeNavigationContainersFromSuperView {
    for (WASControllerCard* navigationContainer in self.controllerCards) {
        [navigationContainer removeFromSuperview];            // 2
    }
}

- (NSArray *) controllerCardsAboveCards:(WASControllerCard *) card
{
    NSUInteger index = [self.controllerCards indexOfObject:card];
    __block WASCardViewController *blockSelf = self;
    return [self.controllerCards filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        NSUInteger currentIndex = [blockSelf.controllerCards indexOfObject:evaluatedObject];
        return index > currentIndex;
    }]];
}


- (NSArray *) controllerCardsBelowCards:(WASControllerCard *) card
{
    NSUInteger index = [self.controllerCards indexOfObject:card];
    __block WASCardViewController *blockSelf = self;
    return [self.controllerCards filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        NSUInteger currentIndex = [blockSelf.controllerCards indexOfObject:evaluatedObject];
        return index < currentIndex;
    }]];
}

- (NSUInteger) indexForControllerCard:(WASControllerCard *) controllerCard
{
    return [self.controllerCards indexOfObject:controllerCard];
}

- (NSInteger) numberOfControllerCardsInController:(WASCardViewController *) controller
{
    return [self.dataSource numberOfControllerCardsInController:self];
}

- (UIViewController *) controller:(WASCardViewController *) controller viewControllerAtIndex:(NSUInteger) index
{
    return [self.dataSource controller:controller viewControllerAtIndex:index];
}

- (void) controller:(WASCardViewController *) controller didUpdateControllerCard:(WASControllerCard*)controllerCard toState:(WASControllerCardState) toState fromState:(WASControllerCardState) fromState
{
    if ([self.delegate respondsToSelector:@selector(controllerCard:didChangedToState:from:)]) {
        [self.delegate controller:self didUpdateControllerCard:controllerCard toState:toState fromState:fromState];
    }
}

#pragma mark ==
#pragma mark WASControllerCardDelegate

- (void) controllerCard:(WASControllerCard *)controllerCard didChangedToState:(WASControllerCardState )toState from:(WASControllerCardState)fromState
{
    if (WASControllerCardStateDefault == fromState && WASControllerCardStateFullScreen == toState) {
        for (WASControllerCard *currentCard in [self controllerCardsAboveCards:controllerCard]) {
            [currentCard setState:WASControllerCardStateHiddenTop animated:YES];
        }
        for (WASControllerCard *currentCard in [self controllerCardsBelowCards:controllerCard]) {
            [currentCard setState:WASControllerCardStateHiddenBottom animated:YES];
        }
    }
    else if (WASControllerCardStateFullScreen == fromState && WASControllerCardStateDefault == toState) {
        for (WASControllerCard *currentCard in [self controllerCardsAboveCards:controllerCard]) {
            [currentCard setState:WASControllerCardStateDefault animated:YES];
        }
        for (WASControllerCard *currentCard in [self controllerCardsBelowCards:controllerCard]) {
            [currentCard setState:WASControllerCardStateHiddenBottom animated:NO];
            [currentCard setState:WASControllerCardStateDefault animated:YES];
        }
    }
    else if (WASControllerCardStateDefault == fromState && WASControllerCardStateDefault == toState) {
        for (WASControllerCard *currentCard in [self controllerCardsBelowCards:controllerCard]) {
            [currentCard setState:WASControllerCardStateDefault animated:YES];
        }
    }
    
    [self controller:self didUpdateControllerCard:controllerCard toState:toState fromState:fromState];
    
}

- (void) controllerCard:(WASControllerCard *)controllerCard didUpdatePanPercentage:(CGFloat) percentage
{
    if (WASControllerCardStateFullScreen == controllerCard.state) {
        
        for (WASControllerCard *currentCard in [self controllerCardsAboveCards:controllerCard]) {
            CGFloat yCoordinate = (CGFloat) currentCard.origin.y * [controllerCard percentageDistanceTravelled];
            [currentCard setYCoordinate:yCoordinate];
        }
    }
    else if (WASControllerCardStateDefault == controllerCard.state) {
       
        for (WASControllerCard *currentCard in [self controllerCardsBelowCards:controllerCard]) {

            CGFloat deltaDistance = controllerCard.frame.origin.y - controllerCard.origin.y;
            CGFloat yCoordinate = (CGFloat) currentCard.origin.y + deltaDistance;
            if (yCoordinate < currentCard.origin.y) {
                yCoordinate = currentCard.origin.y;
            }
            [currentCard setYCoordinate:yCoordinate];
        }
    }
}

@end



#pragma mark ==
#pragma mark WASControllerCard


@interface WASControllerCard()<UIGestureRecognizerDelegate>
{
    UIScrollView *__otherUIScrollView;
    CGPoint     __otherUIScrollViewOffset;
}
-(void) shrinkCardToScaledSize:(BOOL) animated;

-(void) expandCardToFullSize:(BOOL) animated;

@end

@implementation WASControllerCard
@synthesize navigationController = _navigationController;
@synthesize cardController       = _cardController;
@synthesize delegate             = _delegate;
@synthesize origin               = _origin;
@synthesize panOriginOffsetY     = _panOriginOffsetY;
@synthesize state                = _state;


- (id) initWithController:(WASCardViewController *) controller navigationController:(UINavigationController *) navigationController index:(NSInteger) index
{
    self.cardController = controller;
    self.navigationController = navigationController;
    
    _index = index;
    _originY = [controller defaultVerticalOriginForControllerCard:self atIndex:index];

    self = [super initWithFrame:navigationController.view.bounds];
    if (self) {
        [self setAutoresizesSubviews:YES];
        [self setAutoresizingMask:
         UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin |
         UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
         UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
        
        [self.navigationController.view.layer setCornerRadius:kDefaultCornerRadius];
        [self.navigationController.view setClipsToBounds:YES];
        
        UIPanGestureRecognizer* panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPerformPanGesture:)];
        panGesture.delegate = self;
        UILongPressGestureRecognizer* pressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didPerformLongPress:)];
        [pressGesture setMinimumPressDuration: kDefaultMinimumPressDuration];
        [self.navigationController.view addGestureRecognizer: panGesture];
        [self.navigationController.navigationBar addGestureRecognizer:pressGesture];
        
        [self addSubview:self.navigationController.view];
        
        [self setState:WASControllerCardStateDefault animated:NO];

    }
    return self;
}

- (void) setState:(WASControllerCardState) state animated:(BOOL) animated
{
    if (animated) {
        __block WASControllerCard *blockSelf = self;
        [UIView animateWithDuration:kDefaultAnimationDuration animations:^{
            [blockSelf setState:state animated:NO];
        }];
        return;
    }
    switch (state) {
        case WASControllerCardStateFullScreen:
            [self expandCardToFullSize:YES];
        case WASControllerCardStateHiddenTop:
            [self setYCoordinate:0];
            break;
        case WASControllerCardStateHiddenBottom:
             [self setYCoordinate:(self.cardController.view.frame.size.height + fabs(kDefaultShadowOffset.height)*3)];
            break;
        case WASControllerCardStateDefault:
            [self shrinkCardToScaledSize:YES];
            [self setYCoordinate:_originY];
            break;
        default:
            break;
    }
    WASControllerCardState oldState = self.state;
    [self setState:state];
    if ([self.delegate respondsToSelector:@selector(controllerCard:didChangedToState:from:)]) {
        [self.delegate controllerCard:self didChangedToState:state from:oldState];
    }
}

-(void) redrawShadow {
    if (kDefaultShadowEnabled) {
        UIBezierPath *path  =  [UIBezierPath bezierPathWithRoundedRect:[self bounds] cornerRadius:kDefaultCornerRadius];
        [self.layer setShadowOpacity: kDefaultShadowOpacity];
        [self.layer setShadowOffset: kDefaultShadowOffset];
        [self.layer setShadowRadius: kDefaultShadowRadius];
        [self.layer setShadowColor: [kDefaultShadowColor CGColor]];
        [self.layer setShadowPath: [path CGPath]];
    }
}

-(void) shrinkCardToScaledSize:(BOOL) animated
{
    if (!_scalingFactor) {
        _scalingFactor = [self.cardController scalingFactorForIndex:_index];
    }
    if (animated) {
        __block WASControllerCard *blockSelf = self;
        [UIView animateWithDuration:kDefaultAnimationDuration
                         animations:^
        {
            [blockSelf shrinkCardToScaledSize:NO];
        }];
    }
    else {
        [self setTransform:CGAffineTransformMakeScale(_scalingFactor, _scalingFactor)];
    }
}

-(void) expandCardToFullSize:(BOOL) animated
{
    if (!_scalingFactor) {
        _scalingFactor = [self.cardController scalingFactorForIndex:_index];
    }
    if (animated) {
        __block WASControllerCard *blockSelf = self;
        [UIView animateWithDuration:kDefaultAnimationDuration
                         animations:^
         {
             [blockSelf expandCardToFullSize:NO];
         }];
    }
    else {
        [self setTransform:CGAffineTransformMakeScale(kDefaultMaximizedScalingFactor, kDefaultMaximizedScalingFactor)];
    }
}

-(void) didPerformLongPress:(UILongPressGestureRecognizer*) recognizer {
    
    if (self.state == WASControllerCardStateDefault && recognizer.state == UIGestureRecognizerStateEnded)
        [self setState:WASControllerCardStateFullScreen animated:YES];
}

-(void) didPerformPanGesture:(UIPanGestureRecognizer*) recognizer {
    CGPoint location = [recognizer locationInView:self.cardController.view];
    CGPoint translation = [recognizer translationInView:self];
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
        {
//            if (self.state == WASControllerCardStateFullScreen) {
//                [self shrinkCardToScaledSize:NO];
//            }
            self.panOriginOffsetY = [recognizer locationInView: self].y;
            if (__otherUIScrollView) {
                __otherUIScrollViewOffset = __otherUIScrollView.contentOffset;
            }
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            float yPostion = location.y - self.panOriginOffsetY;
            [self setYCoordinate:yPostion <= 0 ? 0 : yPostion];
            if ((WASControllerCardStateFullScreen == self.state && self.frame.origin.y <= _originY) ||
                (WASControllerCardStateDefault == self.state )) {
                if ([self.delegate respondsToSelector:@selector(controllerCard:didUpdatePanPercentage:)]) {
                    [self.delegate controllerCard:self didUpdatePanPercentage:[self percentageDistanceTravelled]];
                }
            }
            if (__otherUIScrollView && yPostion >= 0) {
                [__otherUIScrollView setContentOffset:CGPointMake(0, __otherUIScrollViewOffset.y)];
            }
        }
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
        {
            if ([self shouldReturnToState:self.state fromPoint:translation]) {
                [self setState:self.state animated:YES];
            } else  {
                [self setState:(WASControllerCardStateFullScreen == self.state) ? WASControllerCardStateDefault : WASControllerCardStateFullScreen animated:YES];
            }
            
            if (__otherUIScrollView) {
                [__otherUIScrollView setContentOffset:CGPointMake(0, __otherUIScrollViewOffset.y) animated:YES];
                __otherUIScrollView = nil;
            }
        }
            break;
        default:
            break;
    }

}

- (CGPoint ) origin
{
    return CGPointMake(0, _originY);
}

- (void) setYCoordinate:(CGFloat) yValue
{
    [self setFrame:CGRectMake(self.frame.origin.x, yValue, self.frame.size.width, self.frame.size.height)];
}

- (CGFloat) percentageDistanceTravelled
{
    return self.frame.origin.y / _originY;
}

-(void) setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self redrawShadow];
}

-(BOOL) shouldReturnToState:(WASControllerCardState) state fromPoint:(CGPoint) point {
    if (WASControllerCardStateFullScreen == state) {
        return ABS(self.frame.origin.y) <= self.navigationController.navigationBar.frame.size.height;
//        return ABS(point.y) <= self.navigationController.navigationBar.frame.size.height;
    }
    else if (WASControllerCardStateDefault == state) {
        return point.y >= -self.navigationController.navigationBar.frame.size.height;
    }
    return NO;
}


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ((WASControllerCardStateDefault == self.state || WASControllerCardStateFullScreen == self.state) &&
        [[self.navigationController viewControllers] count] > 1) {
        return NO;
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([otherGestureRecognizer.view isKindOfClass:[UITableView class]]) {
        __otherUIScrollView = (UIScrollView *)otherGestureRecognizer.view;
        if (__otherUIScrollView && __otherUIScrollView.contentOffset.y <= 0) {
            return YES;
        }
    }
    return gestureRecognizer == otherGestureRecognizer;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return YES;
}


@end


