//
//  WASBindingTests.m
//  WASBindingTests
//
//  Created by allen.wang on 10/17/12.
//  Copyright (c) 2012 b5m. All rights reserved.
//

#import "WASBindingTests.h"

#import "WASBinding.h"

@interface WASBindingTestObject : NSObject
@property(copy, nonatomic) NSString* someString;
@end

@implementation WASBindingTestObject
@synthesize someString;
@end


@interface WASBindingTests ()
@property(retain, nonatomic) WASBindingTestObject* a, * b;
@end

@implementation WASBindingTests

@synthesize a, b;

- (void)setUp
{
    [super setUp];
    
    self.a = [[WASBindingTestObject new] autorelease];
    self.b = [[WASBindingTestObject new] autorelease];
}

- (void)tearDown
{
    self.a = nil;
    self.b = nil;
    
    [super tearDown];
}


- (void) testSimpleBinding;
{
    NSString* const kWASBindingTestKey = @"someString";
    
    WASBinding* binding = [[[WASBinding alloc] initWithKeyPath:kWASBindingTestKey ofSourceObject:self.a boundToKeyPath:kWASBindingTestKey ofTargetObject:self.b options:[WASBindingOptions optionsWithDefaultValues]] autorelease];
    
    self.a.someString = @"This is a test";
    STAssertEqualObjects(self.b.someString, self.a.someString, @"The binding changed the string key on setting.");
    
    self.b.someString = @"This is a reciprocal test b";
    STAssertEqualObjects(self.b.someString, self.a.someString, @"The binding changed the string key on setting.");
    
    self.a.someString = @"This is a reciprocal test a";
    STAssertEqualObjects(self.b.someString, self.a.someString, @"The binding changed the string key on setting.");
    
    [binding unbind];
    
    self.a.someString = @"This is another test";
    STAssertFalse([self.b.someString isEqual:self.a.someString], @"The binding did not change the string key on setting after unbinding.");
}

- (void) testOneWayBinding;
{
    NSString* const kWASBindingTestKey = @"someString";
    
    WASBindingOptions* options = [WASBindingOptions optionsWithDefaultValues];
    options.direction = kWASBindingDirectionSourceToTargetOnly;
    
    WASBinding* binding = [[[WASBinding alloc] initWithKeyPath:kWASBindingTestKey ofSourceObject:self.a boundToKeyPath:kWASBindingTestKey ofTargetObject:self.b options:options] autorelease];
    
    self.a.someString = @"This is a test";
    STAssertEqualObjects(self.b.someString, self.a.someString, @"The binding changed the string key on setting.");
    
    self.b.someString = @"This is a reciprocal test";

    STAssertFalse([self.b.someString isEqual:self.a.someString], @"The binding did not change the string key on setting because the binding is one-way.");
    
    [binding unbind];
    
    self.a.someString = @"This is another test";
    STAssertFalse([self.b.someString isEqual:self.a.someString], @"The binding did not change the string key on setting after unbinding.");
}

@end
