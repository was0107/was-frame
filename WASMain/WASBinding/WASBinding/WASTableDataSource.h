//
//  WASTableDataSource.h
//  WASBinding
//
//  Created by allen.wang on 10/29/12.
//  Copyright (c) 2012 b5m. All rights reserved.
//

#import <Foundation/Foundation.h>


#if TARGET_OS_IPHONE

#import <UIKit/UIKit.h>
@protocol WASTableSectionDelegate;


#pragma mark WASTableDataSource
@interface WASTableDataSource : NSObject <UITableViewDataSource>

@property(readonly, nonatomic) UITableView* tableView;

@property(readonly, nonatomic) NSMutableArray* sections;

@property(nonatomic) UITableViewRowAnimation reloadAnimation, insertAnimation, deleteAnimation;


- (id) initWithTableView:(UITableView*) tv;

- (void) setSectionsArray:(NSArray *)sections;


@end


#pragma mark WASTableSection
@protocol WASTableSection <NSObject>

@property(assign, nonatomic) id <WASTableSectionDelegate> delegate;

- (NSInteger) countOfRows;

- (UITableViewCell*) cellForRowAtIndex:(NSInteger) index ofTableView:(UITableView*) tableView;

@optional

- (NSString*) indexTitle;
- (NSString*) headerTitle;
- (NSString*) footerTitle;

- (BOOL) canEditRowAtIndex:(NSInteger) index;
- (BOOL) canMoveRowAtIndex:(NSInteger) index;

@end

#pragma mark WASTableSectionDelegate
@protocol WASTableSectionDelegate <NSObject>

- (void) section:(id <WASTableSection>) section didAddRowsAtIndexes:(NSIndexSet*) indexes;
- (void) section:(id <WASTableSection>) section didRemoveRowsAtIndexes:(NSIndexSet*) indexes;
- (void) section:(id <WASTableSection>) section didChangeRowsAtIndexes:(NSIndexSet*) indexes;

- (void) sectionDidChangeAllRows:(id <WASTableSection>) section;

@end

#endif
