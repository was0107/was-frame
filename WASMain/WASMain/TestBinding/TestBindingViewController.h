//
//  TestBindingViewController.h
//  WASMain
//
//  Created by allen.wang on 10/29/12.
//  Copyright (c) 2012 b5m. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestBindingViewController : UIViewController


@property (nonatomic, retain) IBOutlet UIButton *bindingBtn;
@property (nonatomic, retain) IBOutlet UIButton *unbindingBtn;
@property (nonatomic, retain) IBOutlet UIButton *dismissButton;
@property (nonatomic, retain) IBOutlet UIButton *increaseButton;
@property (nonatomic, retain) IBOutlet UIButton *decreaseButton;
@property (nonatomic, retain) IBOutlet UIButton *showLog;
@property (nonatomic, retain) IBOutlet UITextField *textField1;
@property (nonatomic, retain) IBOutlet UITextField *textField2;
@property (nonatomic, retain) IBOutlet UISlider    *slider;
@property (nonatomic, retain) IBOutlet UILabel  *tipLabel;


- (IBAction)bindingAction:(id)sender;
- (IBAction)unbindingAction:(id)sender;
- (IBAction)logAction:(id)sender;

- (IBAction)increaseAction:(id)sender;
- (IBAction)decreaseAction:(id)sender;

- (IBAction)dismissAction:(id)sender;
@end
