//
//  WASControllerCard.m
//  WASControllerCard
//
//  Created by allen.wang on 7/16/13.
//  Copyright (c) 2013 allen.wang. All rights reserved.
//

#import "WASControllerCard.h"

//Layout properties
#define kDefaultMinimizedScalingFactor 0.98     //Amount to shrink each card from the previous one
#define kDefaultMaximizedScalingFactor 1.00     //Maximum a card can be scaled to
#define kDefaultNavigationBarOverlap 0.90       //Defines vertical overlap of each navigation toolbar. Slight hack that prevents rounding errors from showing the whitespace between navigation toolbars. Can be customized if require more/less packing of navigation toolbars

//Animation properties
#define kDefaultAnimationDuration 0.3           //Amount of time for the animations to occur

//Position for the stack of navigation controllers to originate at
#define kDefaultVerticalOrigin 200              //Vertical origin of the controller card stack. Making this value larger/smaller will make the card shift down/up.

//Corner radius properties
#define kDefaultCornerRadius 5.0

//Shadow Properties - Note : Disabling shadows greatly improves performance and fluidity of animations
#define kDefaultShadowEnabled YES
#define kDefaultShadowColor [UIColor blackColor]
#define kDefaultShadowOffset CGSizeMake(0, -5)
#define kDefaultShadowRadius kDefaultCornerRadius
#define kDefaultShadowOpacity 0.60


@interface WASControllerCard()
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
    _index = index;
    _originY = 0;
    self.cardController = controller;
    self.navigationController = navigationController;
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
        UILongPressGestureRecognizer* pressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didPerformLongPress:)];
        [pressGesture setMinimumPressDuration: kDefaultMinimumPressDuration];

        [self addSubview:self.navigationController.view];
        
    }
    return self;
}

- (void) setState:(WASControllerCard)state animated:(BOOL) animated
{
    
}

- (void) setYCoordinate:(CGFloat) yValue
{
    [self setFrame:CGRectMake(self.frame.origin.x, yValue, self.frame.size.width, self.frame.size.height)];
}

- (CGFloat) percentageDistanceTravelled
{
    return 1.0f;
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
        [self setTransform:CGAffineTransformMakeScale(scalingFactor, scalingFactor)];
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
        [self setState:KLControllerCardStateFullScreen animated:YES];
}

-(void) didPerformPanGesture:(UIPanGestureRecognizer*) recognizer {
    CGPoint location = [recognizer locationInView:self.cardController.view];
    CGPoint translation = [recognizer translationInView:self];

}

@end



@interface WASCardViewController()
//Drawing information for the navigation controllers
- (CGFloat) defaultVerticalOriginForControllerCard: (KLControllerCard*) controllerCard atIndex:(NSInteger) index;

- (CGFloat) scalingFactorForIndex: (NSInteger) index;

@end

@implementation WASCardViewController

- (CGFloat) defaultVerticalOriginForControllerCard: (KLControllerCard*) controllerCard atIndex:(NSInteger) index
{
    return 1;
}

- (CGFloat) scalingFactorForIndex: (NSInteger) index
{
    return 1;
}
@end
