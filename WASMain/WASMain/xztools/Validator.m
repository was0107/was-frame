//
//  Validator.m
//   RssReader
//
//  Created by 営業支援開発機 on 10/12/28.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Validator.h"


@implementation Validator
- (id)init;

{
	
	if ((self = [super init]) == nil){
		
		return nil;
	}
	if (nil==_validateList) {
		_validateList=[[NSMutableArray alloc] init];
	}
	
		
	return self;
	
}
-(void)textLengthValiDate:(id)textWithObject maxLength:(NSInteger)aMaxLength onFail:(ExecBlock)failExec
{
	TextLengthValidate *vd=[[TextLengthValidate alloc] initWithValidate:textWithObject forLength:aMaxLength];
	[vd onFail:failExec];
	[_validateList addObject:vd];
	[vd release];
	
}
-(void)textLengthValiDate:(id)textWithObject maxLength:(NSInteger)aMaxLength
{
	[self textLengthValiDate:textWithObject maxLength:aMaxLength onFail:nil];
}
-(void)dealloc
{
	for(NSObject *object in _validateList)
	{
		[object performSelector:@selector(removeValidate)];
	}
	[_validateList release];
	_validateList=nil;
	[super dealloc];
}
@end
