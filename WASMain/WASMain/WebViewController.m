//
//  WebViewController.m
//  WASMain
//
//  Created by allen.wang on 7/9/12.
//  Copyright (c) 2012 b5m. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

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
    
    webView  = [[UIWebView alloc] initWithFrame:CGRectMake(0, 100, 320, 400)];
    aProgressView   = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 10, 320, 40)];
    webData  = [[NSMutableData alloc] initWithLength:100];
    
    url = nil;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(doGo:) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 60, 320, 30);
    button.backgroundColor = [UIColor redColor];
    
    [self.view addSubview:button];
    
    [self.view addSubview:webView];
    [self.view addSubview:aProgressView];
	// Do any additional setup after loading the view.
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

-(IBAction)doGo:(id)sender{
    NSURL *urlTmp=[NSURL  URLWithString:@"http://www.sina.com.cn"];
    NSURLRequest *urlRequest=[NSURLRequest requestWithURL:urlTmp];
    [webView loadRequest:urlRequest];
    NSData *allData=[NSData dataWithContentsOfURL:urlTmp];
    n=[allData length];
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [webData appendData:data];
    aProgressView.progress=(float)[webData length]/n;
    
}

@end
