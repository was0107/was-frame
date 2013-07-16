//
//  TextLengthValidate.h
//   RssReader
//
//  Created by allen.wang on 10/12/28.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BaseValidate.h"
@interface TextLengthValidate : BaseValidate {
	NSInteger maxLength;

}
@property(nonatomic,assign)NSInteger maxLength;
-(id)initWithValidate:(id)anTarget forLength:(NSInteger)anMaxLength;
@end
