//
//  DAZVkontakteAuthorizationServiceTests.m
//  LegionTests
//
//  Created by Дмитрий Жаров on 20.02.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import <Expecta/Expecta.h>

#import <SafariServices/SafariServices.h>

#import "DAZVkontakteAuthorizationService.h"
#import "DAZUserProfile.h"

@interface DAZVkontakteAuthorizationService (Tests)

@property (nonatomic, strong) SFAuthenticationSession *session;

- (void)completedSignInWithProfile:(DAZUserProfile *)profile error:(NSError *)error;
- (void)completedSignOut;

- (void)signInWithVkontakteApplication;
- (void)signInWithSafariAuthorizationSession;
- (BOOL)isVkontakteApplicationAvailable;

@end

@interface DAZVkontakteAuthorizationServiceTests : XCTestCase

@property (nonatomic, strong) DAZVkontakteAuthorizationService *authorizationService;

@end

@implementation DAZVkontakteAuthorizationServiceTests

- (void)setUp
{
    [super setUp];
    
    self.authorizationService = OCMPartialMock([DAZVkontakteAuthorizationService new]);
}

- (void)tearDown
{
    self.authorizationService = nil;
    
    [super tearDown];
}

- (void)testSignInWithAuthorizationType
{
    NSUInteger wrongType = NSUIntegerMax;
    
    OCMExpect([self.authorizationService completedSignInWithProfile:[OCMArg isNil] error:[OCMArg isKindOfClass:[NSError class]]]);
    
    [self.authorizationService signInWithAuthorizationType:wrongType];
    
    OCMVerify([self.authorizationService completedSignInWithProfile:[OCMArg isNil] error:[OCMArg isKindOfClass:[NSError class]]]);
}

- (void)testSignInWithAuthorizationVkontakte
{
    DAZAuthorizationType type = DAZAuthorizationVkontakte;
    
    OCMExpect([self.authorizationService signIn]);
    
    [self.authorizationService signInWithAuthorizationType:type];
    
    OCMVerify([self.authorizationService signIn]);
}

- (void)testSignOut
{
    DAZUserProfile *profile = OCMClassMock([DAZUserProfile class]);
    OCMExpect(ClassMethod([(id)profile resetUserProfile]));
    OCMExpect([self.authorizationService completedSignOut]);
    
    [self.authorizationService signOut];
    
    OCMVerify(ClassMethod([(id)profile resetUserProfile]));
    OCMVerify([self.authorizationService completedSignOut]);
}

- (void)testSignInWithVkontakteApplicationAvailable
{
    OCMExpect([self.authorizationService isVkontakteApplicationAvailable]).andReturn(YES);
    
    OCMExpect([self.authorizationService signInWithVkontakteApplication]);
    
    [self.authorizationService signIn];
    
    OCMVerify([self.authorizationService signInWithVkontakteApplication]);
}

- (void)testSignInWithoutVkontakteApplicationAvailable
{
    OCMExpect([self.authorizationService isVkontakteApplicationAvailable]).andReturn(NO);
    
    OCMExpect([self.authorizationService signInWithSafariAuthorizationSession]);
    
    [self.authorizationService signIn];
    
    OCMVerify([self.authorizationService signInWithSafariAuthorizationSession]);
}

@end
