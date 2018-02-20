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

- (void)processSignInWithParametersDictionary:(NSDictionary *)dictionary;

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

- (void)testProcessAuthorizationURLNil
{
    BOOL success = [self.authorizationService processAuthorizationURL:nil];
    
    expect(success).to.beFalsy();
}

- (void)testProcessAuthorizationURLWrongScheme
{
    NSURL *url = [NSURL URLWithString:@"vk0://"];
    OCMReject([url absoluteString]);
    
    BOOL success = [self.authorizationService processAuthorizationURL:url];
    
    expect(success).to.beFalsy();
}

- (void)testProcessAuthorizationURLRangeOfHashNotFound
{
    NSURL *url = [NSURL URLWithString:@"vk6347345://authorize?access_token"];
    OCMExpect([self.authorizationService completedSignInWithProfile:nil error:OCMOCK_ANY]);
    
    BOOL success = [self.authorizationService processAuthorizationURL:url];
    
    OCMVerify([self.authorizationService completedSignInWithProfile:nil error:[OCMArg isKindOfClass:[NSError class]]]);
    expect(success).to.beFalsy();
}

- (void)testProcessAuthorizationURLParametersStringNull
{
    NSURL *url = [NSURL URLWithString:@"vk6347345://authorize#"];
    OCMExpect([self.authorizationService completedSignInWithProfile:nil error:OCMOCK_ANY]);
    
    BOOL success = [self.authorizationService processAuthorizationURL:url];
    
    OCMVerify([self.authorizationService completedSignInWithProfile:nil error:[OCMArg isKindOfClass:[NSError class]]]);
    expect(success).to.beFalsy();
}

- (void)testProcessAuthorizationURLParametersStringWithError
{
    BOOL success;
    
    OCMExpect([self.authorizationService completedSignInWithProfile:nil error:OCMOCK_ANY]);
    NSURL *urlCancel = [NSURL URLWithString:@"vk6347345://authorize#cancel=error"];
    success = [self.authorizationService processAuthorizationURL:urlCancel];
    expect(success).to.beFalsy();
    
    OCMExpect([self.authorizationService completedSignInWithProfile:nil error:OCMOCK_ANY]);
    NSURL *urlError = [NSURL URLWithString:@"vk6347345://authorize#error=error"];
    success = [self.authorizationService processAuthorizationURL:urlError];
    expect(success).to.beFalsy();
    
    OCMExpect([self.authorizationService completedSignInWithProfile:nil error:OCMOCK_ANY]);
    NSURL *urlFail = [NSURL URLWithString:@"vk6347345://authorize#fail=error"];
    success = [self.authorizationService processAuthorizationURL:urlFail];
    expect(success).to.beFalsy();
    
    id authorizationServiceMock = self.authorizationService;
    OCMVerifyAll(authorizationServiceMock);
}

- (void)testProcessAuthorizationURLParametersStringWithoutAccessToken
{
    NSURL *url = [NSURL URLWithString:@"vk6347345://authorize#hello=world"];
    OCMExpect([self.authorizationService completedSignInWithProfile:nil error:OCMOCK_ANY]);
    
    BOOL success = [self.authorizationService processAuthorizationURL:url];
    
    OCMVerify([self.authorizationService completedSignInWithProfile:nil error:[OCMArg isKindOfClass:[NSError class]]]);
    expect(success).to.beFalsy();
}

- (void)testProcessAuthorizationURL
{
    NSURL *url = [NSURL URLWithString:@"vk6347345://authorize#"
                    "access_token=ab6b3e314b7d24cbbd1c15b88233960ab1ca640913cc696d1d35b7faa56328891916524a14c2d8c775c2a"
                    "&expires_in=0"
                    "&user_id=61157924"
                    "&email=zharov.1512@gmail.com"];
    OCMReject([self.authorizationService completedSignInWithProfile:nil error:OCMOCK_ANY]);
    OCMExpect([self.authorizationService processSignInWithParametersDictionary:[OCMArg isKindOfClass:[NSDictionary class]]]);
    
    BOOL success = [self.authorizationService processAuthorizationURL:url];
    
    OCMVerify([self.authorizationService processSignInWithParametersDictionary:[OCMArg isKindOfClass:[NSDictionary class]]]);
    expect(success).to.beTruthy();
}

- (void)testSignInWithVkontakteApplication
{
    UIApplication *application = OCMClassMock([UIApplication class]);
    OCMExpect(ClassMethod([(id)application sharedApplication])).andReturn(application);
    OCMExpect([self.authorizationService completedSignInWithProfile:nil error:[OCMArg isKindOfClass:[NSError class]]]);

    OCMExpect([application openURL:[OCMArg isKindOfClass:[NSURL class]] options:OCMOCK_ANY completionHandler:[OCMArg invokeBlock]]);
    
    [self.authorizationService signInWithVkontakteApplication];
    
    OCMVerify([self.authorizationService completedSignInWithProfile:nil error:[OCMArg isKindOfClass:[NSError class]]]);
}

@end
