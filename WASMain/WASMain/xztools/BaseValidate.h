//
//  BaseValidate.h
//   RssReader
//
//  Created by allen.wang on 10/12/28.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IValidate.h"


@interface BaseValidate : NSObject<IValidate> {
	
	id target;
	ExecBlock _onSucc;
	ExecBlock _onFail;
	NSString *_keyPath;
	NSString *_message;
}
@property (nonatomic,copy) NSString * message;
@property (nonatomic,copy) NSString * keyPath;


@end
