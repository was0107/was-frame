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
    
//    self.view.backgroundColor = [UIColor whiteColor];
}


- (NSInteger) numberOfControllerCardsInController:(WASCardViewController *) controller
{
    return 4;
}

- (UIViewController *) controller:(WASCardViewController *) controller viewControllerAtIndex:(NSUInteger) index
{
    Class main = NSClassFromString(@"TestLayoutViewController");
    TestLayoutViewController *result   = [[[main alloc] init] autorelease];
    static NSString * titles[] = {@"布局控件0",@"布局控件1",@"布局控件2",@"布局控件3"};
    result.title = titles[index];
    return result;
}


- (void) controller:(WASCardViewController *) controller didUpdateControllerCard:(WASControllerCard*)controllerCard toState:(WASControllerCardState) toState fromState:(WASControllerCardState) fromState
{
    
}
@end
