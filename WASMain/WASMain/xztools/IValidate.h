//
//  Validate.h
//   RssReader
//
//  Created by allen.wang on 10/12/28.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ExecBlock)(id obj);
typedef BOOL (^invokeBlock)(void);
@protocol IValidate
-(id)registerValidate:(id)anTarget property:(NSString*) aProperty autoValidate:(BOOL)isAuto;
-(BOOL)execValidate;

-(void)removeValidate;
/** 目标属性值改变自动验证　*/

-(void)autoBindAndExecValidate;

-(void)onFail:(ExecBlock)exec;
-(void)onSucc:(ExecBlock)exec;

@end
