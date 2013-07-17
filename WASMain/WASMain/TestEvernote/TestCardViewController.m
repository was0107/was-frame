//
//  TestCardViewController.m
//  WASMain
//
//  Created by allen.wang on 7/17/13.
//
//

#import "TestCardViewController.h"

@interface TestCardViewController ()

@end

@implementation TestCardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}


- (NSInteger) numberOfControllerCardsInController:(WASCardViewController *) controller
{
    return 5;
}

- (UIViewController *) controller:(WASCardViewController *) controller viewControllerAtIndex:(NSUInteger) index
{
    Class main = NSClassFromString(@"TestLayoutViewController");
    UIViewController *result   = [[[main alloc] init] autorelease];
    result.view.backgroundColor = [UIColor redColor];
    result.view.bounds = self.view.bounds;
    return result;
}


- (void) controller:(WASCardViewController *) controller didUpdateControllerCard:(WASControllerCard*)controllerCard toState:(WASControllerCardState) toState fromState:(WASControllerCardState) fromState
{
    
}
@end
