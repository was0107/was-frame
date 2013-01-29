//
//  WASEXTableView.h
//  WASMain
//
//  Created by allen.wang on 7/12/12.
//  Copyright (c) 2012 b5m. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum 
{
    eTypeNone       = 0,
    eTypeHeader     = 1<<0,
    eTypeFooter     = 1<<1,
}eViewType;

typedef enum
{
    /*Header enum values*/
	eHeaderRefreshPulling   = 0,
	eHeaderRefreshNormal    = 1<<0,
	eHeaderRefreshLoading   = 1<<1,
    
    /*Footer enum values*/
	eFooterReloadPulling    = 1<<2,
    eFooterReloadNormal     = 1<<3,
    eFooterReloadLoading    = 1<<4,
    eFooterReloadReachEnd   = 1<<5,
    
} eRefreshAndReloadState;

@interface RefreshTableHeader : UIView

@property(nonatomic,assign) eRefreshAndReloadState state;

- (id) initWithFrame:(CGRect) frame type:(eViewType) theType;

- (void)setCurrentDate;

@end

@protocol WASEXTableViewDelegate;

@interface WASEXTableView : UITableView<UIScrollViewDelegate>

@property (nonatomic, assign) BOOL didReachTheEnd;
@property (nonatomic, assign) BOOL autoScrollToNextPage;
@property (nonatomic, assign) id<WASEXTableViewDelegate> exDelegate;


- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style type:(eViewType)theType delegate:(id) theDelegate;

- (void)tableViewDidEndDragging:(UIScrollView *)scrollView;

//- (void)tableViewDidEndDecelerating:(UIScrollView *)scrollView;

- (void)tableViewDidScroll:(UIScrollView *)scrollView;

- (void)launchRefreshing;

- (void)tableViewDidFinishedLoading ;

- (void)tableViewDidFinishedLoadingWithMessage:(NSString *)msg;

@end



@protocol WASEXTableViewDelegate <NSObject>

@optional

- (void)tableViewDidStartRefreshing:(WASEXTableView *)tableView;

- (void)tableViewDidStartLoading:(WASEXTableView *)tableView;

@end
