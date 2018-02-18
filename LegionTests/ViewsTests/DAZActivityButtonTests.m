//
//  DAZActivityButtonTests.m
//  LegionTests
//
//  Created by Дмитрий Жаров on 18.02.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import <Expecta/Expecta.h>
#import <Masonry/Masonry.h>

#import "DAZActivityButton.h"

@interface DAZActivityButton (Tests)

@property (nonatomic, strong) NSString *textString;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

@end

@interface DAZActivityButtonTests : XCTestCase

@property (nonatomic, strong) DAZActivityButton *activityButton;

@end

@implementation DAZActivityButtonTests

- (void)setUp
{
    [super setUp];
    
    self.activityButton = OCMPartialMock([[DAZActivityButton alloc] init]);
    [self.activityButton setTitle:@"TEST" forState:UIControlStateNormal];
}

- (void)tearDown
{
    self.activityButton = nil;
    
    [super tearDown];
}

- (void)testStartSpinning
{
    [self.activityButton startSpinning];
    
    expect(self.activityButton.titleLabel.text).to.beNil();
    expect([self.activityButton.activityIndicatorView isAnimating]).to.beTruthy();
}

- (void)testStopSpinning
{
    expect([self.activityButton.activityIndicatorView isAnimating]).to.beFalsy();
    expect(self.activityButton.titleLabel.text).notTo.beNil();
}

- (void)testUpdateConstraints
{
    [self.activityButton updateConstraints];
    
    OCMVerify([self.activityButton.activityIndicatorView mas_remakeConstraints:OCMOCK_ANY]);
}

@end
