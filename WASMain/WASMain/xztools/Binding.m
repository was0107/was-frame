//
//  Binding.m
//   RssReader
//
//  Created by allen.wang on 10/12/24.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Binding.h"


@implementation Binding
-(void)bind:(id)bindObj keyPath:(NSString*) bindObjPath target:(id)targetObj targetKeypath:(NSString*) _targetKeypath
{	
	if (nil==targetObj) {
		return;
	}
	if(_bindObjMap==nil){
		_bindObjMap=[[NSMutableDictionary alloc] init];
		_bindTargetMap=[[NSMutableDictionary alloc] init];
	}
	
	[_bindObjMap setObject:bindObj forKey:bindObjPath];
	[_bindTargetMap setObject:_targetKeypath forKey:targetObj];

	[targetObj addObserver:self forKeyPath:_targetKeypath options:NSKeyValueObservingOptionNew context:(void *)bindObjPath];
	
	
}


-(void)observeValueForKeyPath:(NSString *)keyPath 

					 ofObject:(id)object

					   change:(NSDictionary *)change

					  context:(void *)context

{
	NSString * bindKeyPath=(NSString*)context;
    id bindObj=[_bindObjMap objectForKey:bindKeyPath];
	NSString* value=(NSString*)[object valueForKey:keyPath];
	[bindObj setValue:value forKey:bindKeyPath];	
}
-(void)removeObservers
{
	NSArray *keyArr=[_bindTargetMap allKeys];  
	for(NSString *keyPath in keyArr){  
		id target=[_bindObjMap objectForKey:keyPath];
		[target removeObserver:self forKeyPath:keyPath];
		
	}  
}
-(void)dealloc
{
	[self removeObservers];
	[_bindObjMap removeAllObjects];
	[_bindTargetMap removeAllObjects];
	[_bindObjMap release];
	[_bindTargetMap release];
	[super dealloc];
}
@end
