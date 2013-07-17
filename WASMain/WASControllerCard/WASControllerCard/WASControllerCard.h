//
//  WASControllerCard.h
//  WASControllerCard
//
//  Created by allen.wang on 7/16/13.
//  Copyright (c) 2013 allen.wang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    WASControllerCardStateDefault,
    WASControllerCardStateFullScreen,
    WASControllerCardStateHiddenBottom,
    WASControllerCardStateHiddenTop
} WASControllerCardState;

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
@property (nonatomic, retain) UINavigationController    *navigationController;
@property (nonatomic, retain) WASCardViewController     *cardController;
@property (nonatomic, assign) CGPoint                   origin;
@property (nonatomic, assign) CGFloat                   panOriginOffsetY;
@property (nonatomic, assign) WASControllerCardState    state;
@property (nonatomic, assign) id<WASControllerCardDelegate>   delegate;


- (id) initWithController:(WASCardViewController *) controller navigationController:(UINavigationController *) navigationController index:(NSInteger) index;

- (void) setState:(WASControllerCardState) state animated:(BOOL) animated;

- (void) setYCoordinate:(CGFloat) yValue;

- (CGFloat) percentageDistanceTravelled;

@end



#pragma mark ==
#pragma mark WASCardViewController

@interface WASCardViewController : UIViewController<WASControllerCardDelegate>
{
    NSInteger _totalCards;
}
@property (nonatomic, assign) id<WASCardViewControllerDelegate>   delegate;
@property (nonatomic, assign) id<WASCardViewControllerDatasource> dataSource;
@property (nonatomic, retain) NSArray *controllerCards;

- (void) reloadData;

- (NSInteger) numberOfControllerCardsInController:(WASCardViewController *) controller;

- (UIViewController *) controller:(WASCardViewController *) controller viewControllerAtIndex:(NSUInteger) index;

- (NSUInteger ) indexForControllerCard:(WASControllerCard *) controllerCard;

- (void) controller:(WASCardViewController *) controller didUpdateControllerCard:(WASControllerCard*)controllerCard toState:(WASControllerCardState) toState fromState:(WASControllerCardState) fromState;

@end



@protocol WASCardViewControllerDelegate <NSObject>
@optional

- (void) controller:(WASCardViewController *) controller didUpdateControllerCard:(WASControllerCard*)controllerCard toState:(WASControllerCardState) toState fromState:(WASControllerCardState) fromState;

@end


@protocol WASCardViewControllerDatasource <NSObject>
@required

- (NSInteger) numberOfControllerCardsInController:(WASCardViewController *) controller;

- (UIViewController *) controller:(WASCardViewController *) controller viewControllerAtIndex:(NSInteger) index;

@end