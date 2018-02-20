//
//  DAZAuthorizationFacadeTests.m
//  LegionTests
//
//  Created by Дмитрий Жаров on 18.02.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import <Expecta/Expecta.h>

#import "DAZAuthorizationFacade.h"
#import "DAZVkontakteAuthorizationService.h"
#import "DAZFirebaseAuthorizationService.h"
#import "DAZUserProfile.h"

@interface DAZAuthorizationFacade (Tests) <DAZAuthorizationServiceDelegate>

@property (nonatomic, strong) DAZVkontakteAuthorizationService *vkontakteAuthorizationService;
@property (nonatomic, strong) DAZFirebaseAuthorizationService *firebaseAuthorizationService;

@end

@interface DAZAuthorizationFacadeTests : XCTestCase

@property (nonatomic, strong) DAZAuthorizationFacade *authorizationFacade;

@end

@implementation DAZAuthorizationFacadeTests

- (void)setUp
{
    [super setUp];
    
    DAZVkontakteAuthorizationService *vkontakteService = OCMClassMock([DAZVkontakteAuthorizationService class]);
    OCMExpect(ClassMethod([(id)vkontakteService alloc])).andReturn(vkontakteService);
    OCMExpect([vkontakteService initWithMediator:OCMOCK_ANY]).andReturn(vkontakteService);
    
    DAZFirebaseAuthorizationService *firebaseService = OCMClassMock([DAZFirebaseAuthorizationService class]);
    OCMExpect(ClassMethod([(id)firebaseService alloc])).andReturn(firebaseService);
    OCMExpect([firebaseService initWithMediator:OCMOCK_ANY]).andReturn(firebaseService);
    
    self.authorizationFacade = OCMPartialMock([[DAZAuthorizationFacade alloc] init]);
}

- (void)tearDown
{
    self.authorizationFacade = nil;
    
    [super tearDown];
}

- (void)testSignInWithWrongAuthorizationType
{
    DAZAuthorizationType authorizationType = 0;

    OCMExpect([self.authorizationFacade authorizationServiceDidFinishSignInWithProfile:OCMOCK_ANY error:OCMOCK_ANY]);

    [self.authorizationFacade signInWithAuthorizationType:authorizationType];

    OCMVerify([self.authorizationFacade authorizationServiceDidFinishSignInWithProfile:nil error:OCMOCK_ANY]);
}

- (void)testSignInWithAuthorizationVkontakte
{
    id vkontakteAuthorizationService = self.authorizationFacade.vkontakteAuthorizationService;
    OCMExpect([vkontakteAuthorizationService signIn]);

    [self.authorizationFacade signInWithAuthorizationType:DAZAuthorizationVkontakte];

    OCMVerify([vkontakteAuthorizationService signIn]);
}

- (void)testSignInWithAuthorizationFirebase
{
    id firebaseAuthorizationService = self.authorizationFacade.firebaseAuthorizationService;
    OCMExpect([firebaseAuthorizationService signInAnonymously]);

    [self.authorizationFacade signInWithAuthorizationType:DAZAuthorizationAnonymously];

    OCMVerify([firebaseAuthorizationService signInAnonymously]);
}

- (void)testSignOut
{
    id firebaseAuthorizationService = self.authorizationFacade.firebaseAuthorizationService;
    OCMExpect([firebaseAuthorizationService signOut]);

    [self.authorizationFacade signOut];

    OCMVerify([firebaseAuthorizationService signOut]);
}

- (void)testProcessNilAuthorizationURL
{
    id vkontakteAuthorizationService = self.authorizationFacade.vkontakteAuthorizationService;
    OCMReject([vkontakteAuthorizationService processAuthorizationURL:OCMOCK_ANY]);

    [self.authorizationFacade processAuthorizationURL:nil];
}

- (void)testProcessAuthorizationURL
{
    id vkontakteAuthorizationService = self.authorizationFacade.vkontakteAuthorizationService;
    OCMExpect([vkontakteAuthorizationService processAuthorizationURL:OCMOCK_ANY]);

    NSURL *url = [NSURL URLWithString:@"https://test"];
    [self.authorizationFacade processAuthorizationURL:url];

    OCMVerify([vkontakteAuthorizationService processAuthorizationURL:url]);
}

- (void)testAuthorizationServiceDidFinishSignInWithNilProfile
{
    id <DAZAuthorizationServiceDelegate> delegate = OCMProtocolMock(@protocol(DAZAuthorizationServiceDelegate));
    self.authorizationFacade.delegate = delegate;

    NSError *error = [NSError new];
    [self.authorizationFacade authorizationServiceDidFinishSignInWithProfile:nil error:error];

    OCMVerify([delegate authorizationServiceDidFinishSignInWithProfile:nil error:error]);
}

- (void)testAuthorizationServiceDidFinishSignInWithProfileByVkontakteAuthorization
{
    DAZUserProfile *profile = OCMClassMock([DAZUserProfile class]);

    OCMStub(profile.authorizationType).andReturn(DAZAuthorizationVkontakte);

    OCMStub(profile.userID).andReturn(@"12345");

    id firebaseAuthorizationService = self.authorizationFacade.firebaseAuthorizationService;
    OCMExpect([firebaseAuthorizationService signInWithUserID:OCMOCK_ANY]);

    [self.authorizationFacade authorizationServiceDidFinishSignInWithProfile:profile error:nil];

    OCMVerify([firebaseAuthorizationService signInWithUserID:@"12345"]);
}

- (void)testAuthorizationServiceDidFinishSignInWithProfileByAnonymouslyAuthorization
{
    id <DAZAuthorizationServiceDelegate> delegate = OCMProtocolMock(@protocol(DAZAuthorizationServiceDelegate));
    self.authorizationFacade.delegate = delegate;

    DAZUserProfile *profile = OCMClassMock([DAZUserProfile class]);

    OCMStub(profile.authorizationType).andReturn(DAZAuthorizationAnonymously);

    [self.authorizationFacade authorizationServiceDidFinishSignInWithProfile:profile error:nil];

    OCMVerify([delegate authorizationServiceDidFinishSignInWithProfile:profile error:nil]);
}

- (void)testAuthorizationServiceDidFinishSignOut
{
    id <DAZAuthorizationServiceDelegate> delegate = OCMProtocolMock(@protocol(DAZAuthorizationServiceDelegate));
    self.authorizationFacade.delegate = delegate;

    [self.authorizationFacade authorizationServiceDidFinishSignOut];

    OCMVerify([delegate authorizationServiceDidFinishSignOut]);
}

@end
