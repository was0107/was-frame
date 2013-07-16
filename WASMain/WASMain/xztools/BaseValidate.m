//
//  BaseValidate.m
//   RssReader
//
//  Created by allen.wang on 10/12/28.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BaseValidate.h"


@implementation BaseValidate

@synthesize message=_message;
@synthesize keyPath=_keyPath;

-(id)registerValidate:(id)anTarget property:(NSString*) aProperty autoValidate:(BOOL)isAuto
{
//	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(validate) name:anValidateType object:anTarget];
	if (isAuto) {
		[self autoBindAndExecValidate];
	}
	target=anTarget;
	self.keyPath=aProperty;
	return self;
	
}
/** 目标属性值改变自动验证　*/
 
-(void)autoBindAndExecValidate
{

}
-(void)onFail:(ExecBlock)exec
{
	if (exec!=nil) {
		_onFail=exec;
		
	}
}
-(void)onSucc:(ExecBlock)exec
{
	if (exec!=nil) {
		_onSucc=exec;
		
	}
}
-(BOOL)onValidateBefore:(ExecBlock)exec
{
	if (exec!=nil) {
		exec(target);
		
	}
	return TRUE;
}
-(BOOL)onValidateAfter:(ExecBlock)exec
{
    return TRUE;
}

-(BOOL)validate{
	if (![self onValidateBefore:nil]) {
		return FALSE;
	}
	
	if ([self execValidate]) {
		if (_onSucc) {
			_onSucc(target);
		}
		return TRUE;
	}else {
		if(_onFail){
			_onFail(target);
		}
		return FALSE;
	}
	
	if (![self onValidateAfter:nil]) {
		return FALSE;
	}
	
}
-(BOOL)execValidate{
	NSLog(@"execValidate %@",[target class]);
	return TRUE;
}
-(void)removeValidate
{
	//[[NSNotificationCenter defaultCenter] removeObserver:self];
	self.keyPath=nil;
	
}
-(void)dealloc
{
	[self removeValidate];
	[super dealloc];
}
@end
