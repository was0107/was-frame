//
//  DetailViewController_iPhone.m
//  WASMain
//
//  Created by allen.wang on 7/9/12.
//  Copyright (c) 2012 b5m. All rights reserved.
//

#import "DetailViewController_iPhone.h"

@interface DetailViewController_iPhone ()
- (IBAction)btnClicked:(id)sender;

@end

@implementation DetailViewController_iPhone

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 130, 100, 100);
    [self.view addSubview:button];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



- (IBAction)btnClicked:(id)sender
{
    
    [UIView animateWithDuration:0.2f animations:^
     {
         UIView *superView = self.view.superview;
         superView.frame = CGRectMake(0, 0, 320, 480);
         
         CGRect rect = self.view.frame;
         rect.origin.x = 320;
     } 
     completion:^(BOOL finished) {
         [self.view removeFromSuperview];

     }];
    
    
    
}

@end
