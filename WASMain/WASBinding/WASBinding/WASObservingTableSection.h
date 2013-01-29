//
//  WASObservingTableSection.h
//  WASBinding
//
//  Created by allen.wang on 10/29/12.
//  Copyright (c) 2012 b5m. All rights reserved.
//

#import <Foundation/Foundation.h>

#if TARGET_OS_IPHONE

#import <UIKit/UIKit.h>
#import "WASTableDataSource.h"

@interface WASObservingTableSection : NSObject <WASTableSection>

@property(copy, nonatomic) NSString* indexTitle;
@property(copy, nonatomic) NSString* headerTitle, * footerTitle;

- initWithCellCreationBlock:(UITableViewCell*(^)(id object, UITableView* tv)) block;

- (void) setObservedKeyPath:(NSString*) kp ofSourceObject:(id) object;
- (void) endObservingSourceObject;

@end

#endif