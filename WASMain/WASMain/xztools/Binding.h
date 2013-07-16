//
//  Binding.h
//   RssReader
//
//  Created by allen.wang on 10/12/24.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Binding : NSObject {
	NSMutableDictionary* _bindObjMap;
	NSMutableDictionary* _bindTargetMap;
}
-(void)bind:(id)bindObj keyPath:(NSString*) bindObjPath target:(id)targetObj targetKeypath:(NSString*) _targetKeypath;
-(void)removeObservers;
@end
