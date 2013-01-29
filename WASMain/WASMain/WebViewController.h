//
//  WebViewController.h
//  WASMain
//
//  Created by allen.wang on 7/9/12.
//  Copyright (c) 2012 b5m. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController
{
    UIWebView *webView;
    UIProgressView *aProgressView;
    NSMutableData *webData;
    NSInteger n;
    NSURLConnection *url;
}
@end
