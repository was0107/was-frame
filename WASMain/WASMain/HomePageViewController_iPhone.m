//
//  HomePageViewController_iPhone.m
//  WASMain
//
//  Created by allen.wang on 7/9/12.
//  Copyright (c) 2012 b5m. All rights reserved.
//

#import "HomePageViewController_iPhone.h"

#define kAnimationTime 0.08f


#define showRect( rect ) NSLog(@"rect.origin.x = %f,rect.origin.y = %f,rect.size.width = %f,rect.size.height = %f,", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);



@interface HomePageViewController_iPhone ()
{
    WASFullScreenScroll *_fullScreen;
    BOOL                 _isRunning;
    UIView              *_theView;
    UIView              *_theViewex;
}

@property (retain,nonatomic) NSMutableArray *list;
@property (nonatomic) BOOL refreshing;
@property (assign,nonatomic) NSInteger page;


- (IBAction)buttonClicked:(id)sender;

@end

@implementation HomePageViewController_iPhone

@synthesize list = _list;
@synthesize refreshing = _refreshing;
@synthesize page = _page;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
//    contentView.backgroundColor = [UIColor lightTextColor];
    
	// Do any additional setup after loading the view.
    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.backgroundColor = [UIColor redColor];
//    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    button.frame = CGRectMake(0, 0, 100, 100);
//    [contentView addSubview:button];
//    
//    self.view.backgroundColor = [UIColor grayColor];
//    [self.view addSubview:contentView];
    
    _theView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    _theView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_theView];
    
    _theViewex = [[UIView alloc] initWithFrame:CGRectMake(0, 30, 320, 30)];
    _theViewex.backgroundColor = [UIColor greenColor];
    [self.view addSubview:_theViewex];
    
    
    _isRunning = NO;
    _list = [[NSMutableArray alloc] init ];
    
    
    CGRect bounds = CGRectMake(0, 60, 320, 400);
    

    _tableView = [[WASEXTableView alloc] initWithFrame:bounds style:UITableViewStylePlain type:(eTypeHeader|eTypeFooter) delegate:self];
    _tableView.dataSource = self;
    _tableView.delegate = self;

    _tableView.backgroundColor = [UIColor clearColor];
    
    _fullScreen = [[WASFullScreenScroll alloc] initWithView:_tableView];
    
    _fullScreen.delegate = self;

    [self.view addSubview:_tableView];
    
    if (self.page == 0) {
        [_tableView launchRefreshing];
    }
    


    
}

- (IBAction)buttonClicked:(id)sender
{
    Class detail = NSClassFromString(@"DetailViewController_iPhone");
    
    UIViewController *controller = [[detail alloc] init];
    controller.view.backgroundColor = [UIColor greenColor];
    
    [UIView animateWithDuration:0.2f animations:^
    {
        CGRect rect = contentView.frame;
        CGRect rect1 = rect;
        rect.origin.x += 15;
        rect.origin.y += 15;
        
        self.view.frame = rect;
        rect1.origin.x = 320;
        controller.view.frame = rect1;

        [UIView animateWithDuration:0.2f animations:^
         {
             controller.view.frame = CGRectMake(0, 0, 320, 480);

         }];
        
        [self.view addSubview:controller.view];
    }];
    
    
//    [controller release];
    
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


- (void)loadData{
    self.page++;
    if (self.refreshing) {
        self.page = 1;
        self.refreshing = NO;
        [self.list removeAllObjects];
    }
    for (int i = 0; i < 12; i++) {
        [self.list addObject:@"ROW"];
    }
    if (self.page >= 3) {
        [_tableView tableViewDidFinishedLoadingWithMessage:@"All loaded!"];
        _tableView.didReachTheEnd  = YES;
    } else {        
        [_tableView tableViewDidFinishedLoading];         
        _tableView.didReachTheEnd  = NO;
        [_tableView reloadData];
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"_CELL";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil){
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%d",indexPath.row];
    return cell;
}

#pragma mark - Scroll

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_fullScreen scrollViewWillBeginDragging:scrollView];
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    return [_fullScreen scrollViewShouldScrollToTop:scrollView];;
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    [_fullScreen scrollViewDidScrollToTop:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_fullScreen scrollViewDidScroll:scrollView];
    [_tableView tableViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [_tableView tableViewDidEndDragging:scrollView];
}


#pragma mark UIScrollViewDelegate

- (void)tableViewDidStartRefreshing:(WASEXTableView *)tableView
{
    self.refreshing = YES;
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.f];
    return;
}

- (void)tableViewDidStartLoading:(WASEXTableView *)tableView
{
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.f];    

    return;
}

- (void)scrollView:(UIScrollView*)scrollView deltaY:(CGFloat)deltaY
{
    NSLog(@"deltay = %f", deltaY);
    __block CGRect rect     = _theView.frame;
    __block CGRect rectex     = _theViewex.frame;
    __block CGRect rect1    = _tableView.frame;
    
    if (_isRunning) {
        return;
    }
//    showRect(rect);
//    showRect(rect1);

    if (deltaY > 0) {    
        if (rect.origin.y <= -30.0f) {
            return;
        }
        _isRunning = YES;

        //add animation, Allen 
        [UIView animateWithDuration:kAnimationTime 
                         animations:^
        { 
            rect.origin.y = -30.0f;  
            rectex.origin.y = 0.0f;
            
            rect1.origin.y = 30;
            rect1.size.height= 430;
            
            _theView.frame = rect;
            _theViewex.frame = rectex;
            _tableView.frame = rect1;

            
        } 
                         completion:^(BOOL finished)
        {
            [UIView animateWithDuration:kAnimationTime 
                             animations:^
             {
                 rectex.origin.y = -30.0f;    
                 
                 rect1.origin.y = 0;
                 rect1.size.height= 460;
                 
                 _theViewex.frame = rect;
                 _tableView.frame = rect1;
             }
             completion:^(BOOL finished) {
                 _isRunning = NO;

             }];

        }];
//        rect.origin.y   -= deltaY;
//        
//        if (rect.origin.y < -30.0f) {
//            rect.origin.y = -30.0f;
//        }
//        _theView.frame = rect;
//
//        
//        if (rect1.origin.y <= 0)
//            return;
//        
//        rect1.origin.y  -= deltaY;
//        rect1.size.height += deltaY;
//        
//        if (rect1.origin.y < 0) {
//            rect1.origin.y = 0;
//            rect1.size.height= 460;
//        }
//        _tableView.frame = rect1;

    }
    else {
        if (rect.origin.y >=0) {         
            return;
        }
        _isRunning = YES;

        //add animation, Allen 
        [UIView animateWithDuration:kAnimationTime 
                         animations:^
         { 
             rectex.origin.y = 0.0f;    
             
             rect1.origin.y = 30;
             rect1.size.height= 430;
             
             _theViewex.frame = rectex;
             _tableView.frame = rect1;
             
             
         } 
                         completion:^(BOOL finished)
         {
             [UIView animateWithDuration:kAnimationTime 
                              animations:^
             {
                 
                 rect.origin.y = 0.0f;    
                 rectex.origin.y = 30.0f;    
                 
                 rect1.origin.y = 60;
                 rect1.size.height= 400;
                 
                 _theView.frame = rect;
                 _theViewex.frame = rectex;
                 _tableView.frame = rect1;
             }
                              completion:^(BOOL finished) 
             {
                 _isRunning = NO;
             } ];

         }];

        
//        
//        rect.origin.y   -= deltaY;
//        if (rect.origin.y >0) {         
//            rect.origin.y = 0;
//        }
//        _theView.frame = rect;
//
//        if (rect1.origin.y>=30)
//            return;
//        
//        rect1.origin.y  -= deltaY;
//        rect1.size.height += deltaY;
//        
//        if (rect1.origin.y>30) {
//            rect1.origin.y = 30;
//            rect1.size.height = 430;
//        }
//        _tableView.frame = rect1;

    }
    
}





@end
