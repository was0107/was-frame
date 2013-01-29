//
//  TestBindingViewController.m
//  WASMain
//
//  Created by allen.wang on 10/29/12.
//  Copyright (c) 2012 b5m. All rights reserved.
//

#import "TestBindingViewController.h"

#import "WASBinding.h"

@interface TEMPCLASS1 : NSObject
@property (nonatomic, copy) NSString *name;

@end

@implementation TEMPCLASS1

@synthesize name;

@end

@interface TestBindingViewController ()
@property (nonatomic, retain) WASBinding *binding;
@property (nonatomic, retain) WASBinding *bindingControl;
@property (nonatomic, retain) WASBinding *bindingSlider;
@property (nonatomic, retain) WASBinding *bindingText1;
@property (nonatomic, retain) TEMPCLASS1 *name1;
@property (nonatomic, retain) TEMPCLASS1 *name2;
@property (nonatomic, assign) CGFloat value;
@property (nonatomic, copy) NSString *bindingName;

@end

@implementation TestBindingViewController
@synthesize bindingText1 = _bindingText1;
@synthesize binding = _binding;
@synthesize bindingControl = _bindingControl;
@synthesize bindingSlider = _bindingSlider;
@synthesize name1 = _name1;
@synthesize name2 = _name2;
@synthesize bindingName;
@synthesize decreaseButton;
@synthesize increaseButton;
@synthesize slider;
@synthesize dismissButton;
@synthesize unbindingBtn;
@synthesize bindingBtn;
@synthesize textField1;
@synthesize textField2;
@synthesize tipLabel;
@synthesize value = _value;
@synthesize showLog;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
      
    }
    return self;
}

- (void) printAll
{
    return;
    NSLog(@"self.name1 = %@",self.name1.name);
    NSLog(@"self.name2 = %@",self.name2.name);
    NSLog(@"self.bindingName = %@",self.bindingName);
    
    NSLog(@"self = %@\n\n", self);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.name1 = [[[TEMPCLASS1 alloc] init] autorelease];
    self.name2 = [[[TEMPCLASS1 alloc] init] autorelease];
    
    self.name1.name =@"1";
    
    self.bindingName = @"bindingName1";
    
    [self bindingAction:nil];
}

- (IBAction)bindingAction:(id)sender
{
    
    [self unbindingAction:sender];
    
    if (!self.binding) {
        
        self.binding = [WASBinding bindingWithKeyPath:@"name"
                                       ofSourceObject:self.name1
                                       boundToKeyPath:@"name" 
                                       ofTargetObject:self.name2 
                                              options:[WASBindingOptions optionsWithDefaultValues]];
    }
    
    if (!self.bindingControl) {
//        WASBindingOptions *bindingOptions = [WASBindingOptions optionsWithDefaultValues];
//        bindingOptions.direction = kWASBindingDirectionSourceToTargetOnly;
//        self.bindingControl = [WASBinding bindingWithKeyPath:@"text"
//                                              ofSourceObject:self.textField1 
//                                              boundToKeyPath:@"text" 
//                                           ofTargetUIControl:self.textField2 
//                                                     options:bindingOptions];
    }
    if (!self.bindingText1) {
        WASBindingOptions *bindingOptions = [WASBindingOptions optionsWithDefaultValues];
        bindingOptions.direction = kWASBindingDirectionBoth;
        self.bindingText1 = [WASBinding bindingWithKeyPath:@"text"
                                            ofSourceObject:self.textField2 
                                            boundToKeyPath:@"name" 
                                            ofTargetObject:self.name2 
                                                   options:bindingOptions];
    }
     
    if (!self.bindingSlider) {
        
        WASBindingOptions *bindingOptions = [WASBindingOptions optionsWithDefaultValues];
        bindingOptions.direction = kWASBindingDirectionBoth;
        self.bindingSlider = [WASBinding bindingWithKeyPath:@"value"
                                              ofSourceObject:self 
                                              boundToKeyPath:@"value" 
                                           ofTargetUIControl:self.slider
                                                     options:bindingOptions];
    }
    
    
    
//    self.name1.name = @"1";
    
    [self logAction:nil];
}

- (void) setValue:(CGFloat)value
{
    _value = value;
    if (_value < 0) {
        self.name1.name  = @"<0.0f";
    }
    else if (_value > 1) {
        self.name1.name  = @">1.0f";
    }
    else {
        self.name1.name  = [NSString stringWithFormat:@"%f", _value];
        
    }
    [self logAction:nil];
}

- (IBAction)unbindingAction:(id)sender
{
    [self.binding unbind];
    [self.bindingControl unbind];
    [self.bindingText1 unbind];
    [self.bindingSlider unbind];
    
    
    self.bindingText1 = nil;
    self.binding = nil;
    self.bindingControl = nil;
    self.bindingSlider = nil;
    
    [self logAction:nil];

}

- (IBAction)increaseAction:(id)sender
{
    self.value = self.value + 0.1;
    [self logAction:nil];

}
- (IBAction)decreaseAction:(id)sender
{
    self.value = self.value - 0.1;   
    [self logAction:nil];

}


- (IBAction)logAction:(id)sender
{
    self.tipLabel.text = [NSString stringWithFormat:@"name1 = %@\n name2= %@\n bindingName = %@\n value = %f", self.name1.name, self.name2.name, bindingName,self.value];
    
    [self printAll];
}


- (IBAction)dismissAction:(id)sender
{
    [self.textField1 resignFirstResponder];
    [self.textField2 resignFirstResponder];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    [self.binding unbind];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
