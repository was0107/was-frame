//
//  Validator.h
//   RssReader
//
//  Created by allen.wang on 10/12/28.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TextLengthValidate.h"
@interface Validator : NSObject {
	NSMutableArray * _validateList;
}
-(void)textLengthValiDate:(id)textWithObject maxLength:(NSInteger)aMaxLength onFail:(ExecBlock)failExec;
-(void)textLengthValiDate:(id)textWithObject maxLength:(NSInteger)aMaxLength;
@end
