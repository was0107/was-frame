//
//  WASBaseLayoutViewController.m
//  WASLayoutManager
//
//  Created by allen.wang on 11/19/12.
//  Copyright (c) 2012 b5m. All rights reserved.
//

#import "WASBaseLayoutViewController.h"

@interface WASBaseLayoutViewController()
@property (nonatomic, retain) WASContainer *container;

@end


@implementation WASBaseLayoutViewController
@synthesize container = _container;

- (void) viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.container];
}

- (WASContainer *)container
{
    if (!_container) {
        WASFlowLayout *flow = [[[WASFlowLayout alloc] init] autorelease];
        flow.newAlign = WASFlowLayout.LEFT;
        flow.hgap = flow.vgap = 0;
        CGRect rect = [UIScreen mainScreen] .applicationFrame;
        rect.origin.y = 44.0f;
        rect.size.height -= 44.0f;
        _container = [[WASContainer alloc] initWithFrame: rect];
        _container.backgroundColor = [UIColor grayColor];
        _container.layoutManager = flow;
    }
    return _container;
}

- (void) dealloc
{
    [_container release]; _container = nil;
    [super dealloc];
}

@end
