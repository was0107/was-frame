//
//  WASTableDataSource.m
//  WASBinding
//
//  Created by allen.wang on 10/29/12.
//  Copyright (c) 2012 b5m. All rights reserved.
//

#import "WASTableDataSource.h"

@interface WASTableDataSource () <WASTableSectionDelegate>
- (NSArray*) indexPathsForIndexes:(NSIndexSet*) indexes inSection:(NSInteger) section;
@end

@implementation WASTableDataSource {
    NSMutableArray* mutableSections;
}

@synthesize tableView, sections;
@synthesize reloadAnimation, insertAnimation, deleteAnimation;

- (id)initWithTableView:(UITableView *)tv;
{
    self = [super init];
    if (self) {
        self.reloadAnimation = UITableViewRowAnimationFade;
        self.insertAnimation = UITableViewRowAnimationTop;
        self.deleteAnimation = UITableViewRowAnimationRight;
        
        mutableSections = [NSMutableArray new];
        
        tableView = [tv retain];
        tv.dataSource = self;
    }
    
    return self;
}

- (void) dealloc;
{
    if (tableView.dataSource == self)
        tableView.dataSource = nil;
    
    [tableView release];
    
    for (id <WASTableSection> section in sections)
        section.delegate = nil;
    
    [sections release];
    
    [super dealloc];
}

#pragma mark - Handling section array changes

- (NSArray *)sections;
{
    return [self mutableArrayValueForKey:@"mutableSections"];
}

- (void) setSectionsArray:(NSArray *) sx;
{
    for (id <WASTableSection> section in mutableSections) {
        if (section.delegate == self)
            section.delegate = nil;
    }
    
    [mutableSections setArray:sx];
    
    for (id <WASTableSection> section in sx)
        section.delegate = self;
    
    [self.tableView reloadData];
}

- (void)insertMutableSections:(NSArray *)array atIndexes:(NSIndexSet *)indexes;
{
    for (id <WASTableSection> section in array)
        section.delegate = self;
    
    [mutableSections insertObjects:array atIndexes:indexes];
    
    [self.tableView insertSections:indexes withRowAnimation:self.insertAnimation];
}

- (void) removeMutableSectionsAtIndexes:(NSIndexSet *)indexes;
{
    for (id <WASTableSection> section in [mutableSections objectsAtIndexes:indexes]) {
        if (section.delegate == self)
            section.delegate = nil;
    }
    
    [mutableSections removeObjectsAtIndexes:indexes];
    
    [self.tableView deleteSections:indexes withRowAnimation:self.deleteAnimation];
}

#pragma mark - Handling intra-section changes

- (NSArray*) indexPathsForIndexes:(NSIndexSet*) indexes inSection:(NSInteger) section;
{
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:indexes.count];
    
    NSInteger i = [indexes firstIndex];
    while (i != NSNotFound) {
        [array addObject:[NSIndexPath indexPathForRow:i inSection:section]];
        i = [indexes indexGreaterThanIndex:i];
    }
    
    return array;
}

- (void)section:(id<WASTableSection>)section didAddRowsAtIndexes:(NSIndexSet *)indexes;
{
    NSInteger sectionIndex = [mutableSections indexOfObject:section];
    NSAssert(sectionIndex != NSNotFound, @"All calls to section delegate methods should be done only by known sections");
    
    [self.tableView insertRowsAtIndexPaths:[self indexPathsForIndexes:indexes inSection:sectionIndex] withRowAnimation:self.insertAnimation];
}

- (void)section:(id<WASTableSection>)section didRemoveRowsAtIndexes:(NSIndexSet *)indexes;
{
    NSInteger sectionIndex = [mutableSections indexOfObject:section];
    NSAssert(sectionIndex != NSNotFound, @"All calls to section delegate methods should be done only by known sections");
    
    [self.tableView deleteRowsAtIndexPaths:[self indexPathsForIndexes:indexes inSection:sectionIndex] withRowAnimation:self.deleteAnimation];
}

- (void)section:(id<WASTableSection>)section didChangeRowsAtIndexes:(NSIndexSet *)indexes;
{
    NSInteger sectionIndex = [mutableSections indexOfObject:section];
    NSAssert(sectionIndex != NSNotFound, @"All calls to section delegate methods should be done only by known sections");
    
    [self.tableView reloadRowsAtIndexPaths:[self indexPathsForIndexes:indexes inSection:sectionIndex] withRowAnimation:self.reloadAnimation];
}

- (void)sectionDidChangeAllRows:(id<WASTableSection>)section;
{
    NSInteger sectionIndex = [mutableSections indexOfObject:section];
    NSAssert(sectionIndex != NSNotFound, @"All calls to section delegate methods should be done only by known sections");
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:self.reloadAnimation];    
}

#pragma mark - Table delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return [mutableSections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex;
{
    id <WASTableSection> section = [mutableSections objectAtIndex:sectionIndex];
    
    return section.countOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    id <WASTableSection> section = [mutableSections objectAtIndex:indexPath.section];
    
    return [section cellForRowAtIndex:indexPath.row ofTableView:tv];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)sectionIndex;
{
    id <WASTableSection> section = [mutableSections objectAtIndex:sectionIndex];
    return section.headerTitle;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)sectionIndex;
{
    id <WASTableSection> section = [mutableSections objectAtIndex:sectionIndex];
    return section.footerTitle;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index;
{
    for (NSInteger i = 0; i < mutableSections.count; i++) {
        id <WASTableSection> section = [mutableSections objectAtIndex:i];
        
        if (section.indexTitle) {
            if (index == 0)
                return i;
            else
                index--;
        }
    }
    
    return NSNotFound;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath;
{
    id <WASTableSection> section = [mutableSections objectAtIndex:indexPath.section];
    
    if (![section respondsToSelector:@selector(canEditRowAtIndex:)])
        return NO;
    
    return [section canEditRowAtIndex:indexPath.row];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath;
{
    id <WASTableSection> section = [mutableSections objectAtIndex:indexPath.section];
    
    if (![section respondsToSelector:@selector(canMoveRowAtIndex:)])
        return NO;
    
    return [section canMoveRowAtIndex:indexPath.row];
}
@end
