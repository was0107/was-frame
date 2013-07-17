//
//  WASControllerCard.h
//  WASControllerCard
//
//  Created by allen.wang on 7/16/13.
//  Copyright (c) 2013 allen.wang. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum {
    WASControllerCardStateDefault;
    WASControllerCardStateFullScreen;
    WASControllerCardStateHiddenBottom;
    WASControllerCardStateHideenTop;
}WASControllerCardState;

@class WASControllerCard;
@class WASCardViewController;
@protocol WASCardViewControllerDelegate;
@protocol WASCardViewControllerDatasource;

#pragma mark ==
#pragma mark WASControllerCardDelegate
@protocol WASControllerCardDelegate <NSObject>
@optional

- (void) controllerCard:(WASControllerCard *)controllerCard didChangedToState:(WASControllerCardState )toState from:(WASControllerCardState)fromState;

- (void) controllerCard:(WASControllerCard *)controllerCard didUpdatePanPercentage:(CGFloat) percentage;

@end

#pragma mark ==
#pragma mark WASControllerCard

@interface WASControllerCard : UIView
{
@private
    CGFloat     _originY;
    CGFloat     _scalingFactor;
    NSInteger   _index;
}
@property (nonatomic, assign) UINavigationController    *navigationController;
@property (nonatomic, assign) WASCardViewController     *cardController;
@property (nonatomic, assign) id<WASControllerCardDelegate>    *delegate;
@property (nonatomic, assign) CGPoint                   *origin;
@property (nonatomic, assign) CGFloat                   *panOriginOffsetY;
@property (nonatomic, assign) WASControllerCardState    state;

- (id) initWithController:(WASCardViewController *) controller navigationController:(UINavigationController *) navigationController index:(NSInteger) index;

- (void) setState:(WASControllerCard)state animated:(BOOL) animated;

- (void) setYCoordinate:(CGFloat) yValue;

- (CGFloat) percentageDistanceTravelled;

@end





#pragma mark ==
#pragma mark WASCardViewController

@interface WASCardViewController : UIViewController

@end



@protocol WASCardViewControllerDelegate <NSObject>



@end


@protocol WASCardViewControllerDatasource <NSObject>


@end