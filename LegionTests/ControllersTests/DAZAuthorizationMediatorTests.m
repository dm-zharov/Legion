//
//  DAZAuthorizationMediatorTests.m
//  LegionTests
//
//  Created by Дмитрий Жаров on 18.02.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import <Expecta/Expecta.h>

#import "DAZAuthorizationMediator.h"
#import "DAZVkontakteAuthorizationService.h"
#import "DAZFirebaseAuthorizationService.h"
#import "DAZUserProfile.h"

@interface DAZAuthorizationMediator (Tests) <DAZAuthorizationServiceDelegate>

@property (nonatomic, strong) DAZVkontakteAuthorizationService *vkontakteAuthorizationService;
@property (nonatomic, strong) DAZFirebaseAuthorizationService *firebaseAuthorizationService;

@end

@interface DAZAuthorizationMediatorTests : XCTestCase

@property (nonatomic, strong) DAZAuthorizationMediator *authorizationMediator;

@end

@implementation DAZAuthorizationMediatorTests

- (void)setUp
{
    [super setUp];
    
    DAZVkontakteAuthorizationService *vkontakteService = OCMClassMock([DAZVkontakteAuthorizationService class]);
    OCMStub(ClassMethod([(id)vkontakteService alloc])).andReturn(vkontakteService);;
    
    DAZFirebaseAuthorizationService *firebaseService = OCMClassMock([DAZFirebaseAuthorizationService class]);
    OCMStub(ClassMethod([(id)firebaseService alloc])).andReturn(firebaseService);;
    OCMStub([firebaseService initWithMediator:OCMOCK_ANY]).andReturn(firebaseService);
    
    self.authorizationMediator = OCMPartialMock([[DAZAuthorizationMediator alloc] init]);
}

- (void)tearDown
{
    self.authorizationMediator = nil;
    
    [super tearDown];
}

- (void)testSignInWithWrongAuthorizationType
{
    DAZAuthorizationType authorizationType = 0;

    OCMStub([self.authorizationMediator authorizationServiceDidFinishSignInWithProfile:OCMOCK_ANY error:OCMOCK_ANY]);

    [self.authorizationMediator signInWithAuthorizationType:authorizationType];

    OCMExpect([self.authorizationMediator authorizationServiceDidFinishSignInWithProfile:nil error:OCMOCK_ANY]);;
}

- (void)testSignInWithAuthorizationVkontakte
{
    OCMStub([self.authorizationMediator.vkontakteAuthorizationService signIn]);

    [self.authorizationMediator signInWithAuthorizationType:DAZAuthorizationVkontakte];

    OCMExpect([self.authorizationMediator.vkontakteAuthorizationService signIn]);
}

- (void)testSignInWithAuthorizationFirebase
{
    OCMStub([self.authorizationMediator.firebaseAuthorizationService signInAnonymously]);
    
    [self.authorizationMediator signInWithAuthorizationType:DAZAuthorizationAnonymously];
    
    OCMExpect([self.authorizationMediator.firebaseAuthorizationService signInAnonymously]);
}

- (void)testSignOut
{
    OCMStub([self.authorizationMediator.firebaseAuthorizationService signOut]);
    
    [self.authorizationMediator signOut];
    
    OCMExpect([self.authorizationMediator.firebaseAuthorizationService signOut]);
}

- (void)testProcessNilAuthorizationURL
{
    [self.authorizationMediator processAuthorizationURL:nil];
    
    OCMReject([self.authorizationMediator.vkontakteAuthorizationService processAuthorizationURL:OCMOCK_ANY]);
}

- (void)testProcessAuthorizationURL
{
    OCMStub([self.authorizationMediator.vkontakteAuthorizationService processAuthorizationURL:OCMOCK_ANY]);
    
    NSURL *url = [NSURL URLWithString:@"https://test"];
    [self.authorizationMediator processAuthorizationURL:url];
    
    OCMExpect([self.authorizationMediator.vkontakteAuthorizationService processAuthorizationURL:url]);
}

- (void)testAuthorizationServiceDidFinishSignInWithNilProfile
{
    id <DAZAuthorizationServiceDelegate> delegate = OCMProtocolMock(@protocol(DAZAuthorizationServiceDelegate));
    self.authorizationMediator.delegate = delegate;
    
    NSError *error = [NSError new];
    [self.authorizationMediator authorizationServiceDidFinishSignInWithProfile:nil error:error];
    
    OCMExpect([delegate authorizationServiceDidFinishSignInWithProfile:nil error:error]);
}

- (void)testAuthorizationServiceDidFinishSignInWithProfileByVkontakteAuthorization
{
    DAZUserProfile *profile = OCMClassMock([DAZUserProfile class]);
    
    OCMStub(profile.authorizationType).andReturn(DAZAuthorizationVkontakte);
    
    OCMStub(profile.userID).andReturn(@"12345");
    
    OCMStub([self.authorizationMediator.firebaseAuthorizationService signInWithUserID:OCMOCK_ANY]);
    
    [self.authorizationMediator authorizationServiceDidFinishSignInWithProfile:profile error:nil];
    
    OCMExpect([self.authorizationMediator.firebaseAuthorizationService signInWithUserID:profile.userID]);
}

- (void)testAuthorizationServiceDidFinishSignInWithProfileByAnonymouslyAuthorization
{
    id <DAZAuthorizationServiceDelegate> delegate = OCMProtocolMock(@protocol(DAZAuthorizationServiceDelegate));
    self.authorizationMediator.delegate = delegate;
    
    DAZUserProfile *profile = OCMClassMock([DAZUserProfile class]);
    
    OCMStub(profile.authorizationType).andReturn(DAZAuthorizationAnonymously);
    
    [self.authorizationMediator authorizationServiceDidFinishSignInWithProfile:profile error:nil];
    
    OCMExpect([delegate authorizationServiceDidFinishSignInWithProfile:profile error:nil]);
}

- (void)testAuthorizationServiceDidFinishSignOut
{
    id <DAZAuthorizationServiceDelegate> delegate = OCMProtocolMock(@protocol(DAZAuthorizationServiceDelegate));
    self.authorizationMediator.delegate = delegate;
    
    [self.authorizationMediator authorizationServiceDidFinishSignOut];
    
    OCMExpect([delegate authorizationServiceDidFinishSignOut]);
}

@end
