//
//  TestCardViewController.m
//  WASMain
//
//  Created by allen.wang on 7/17/13.
//
//

#import "TestCardViewController.h"
#import "TestLayoutViewController.h"

@interface TestCardViewController ()

@end

@implementation TestCardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (NSInteger) numberOfControllerCardsInController:(WASCardViewController *) controller
{
    return 7;
}

- (UIViewController *) controller:(WASCardViewController *) controller viewControllerAtIndex:(NSUInteger) index
{
    Class main = NSClassFromString(@"TestLayoutViewController");
    TestLayoutViewController *result   = [[[main alloc] init] autorelease];
    return result;
}


- (void) controller:(WASCardViewController *) controller didUpdateControllerCard:(WASControllerCard*)controllerCard toState:(WASControllerCardState) toState fromState:(WASControllerCardState) fromState
{
    
}
@end
