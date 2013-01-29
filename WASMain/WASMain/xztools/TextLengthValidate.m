//
//  TextLengthValidate.m
//   RssReader
//
//  Created by 営業支援開発機 on 10/12/28.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TextLengthValidate.h"


@implementation TextLengthValidate
@synthesize maxLength;

-(id)initWithValidate:(id)anTarget forLength:(NSInteger)anMaxLength
{
	
	self=[super init];
	
	if (self) {
		
		[super registerValidate:anTarget
					   property:@"text" autoValidate:YES];
		
		self.maxLength=anMaxLength;
		
		
	}
	return self;
}
-(void)autoBindAndExecValidate
{
if ([target isKindOfClass:[UITextView class]]) {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(validate) name:UITextViewTextDidChangeNotification object:target];
}else {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(validate) name:UITextFieldTextDidChangeNotification object:target];
}


}
-(BOOL)execValidate{
	[super execValidate];
	if(nil==target){
		return FALSE;
	}
	NSString * text=[target valueForKey:self.keyPath];
	NSInteger textlength=[text length];
	if (textlength>maxLength) {
		[target setValue:[text substringToIndex:maxLength]forKey:self.keyPath];
		return FALSE;
	}
	return TRUE;
}
-(void)removeValidate
{
	[super removeValidate];
	if ([target isKindOfClass:[UITextView class]]) {
		[[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:target];
	}else {
		[[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:target];
		
	}
}
-(void)dealloc
{
	[self removeValidate];
	[super dealloc];
}

@end
