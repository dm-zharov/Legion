//
//  DAZInfoViewTests.m
//  LegionTests
//
//  Created by Дмитрий Жаров on 17.02.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import <Expecta/Expecta.h>
#import <Masonry/Masonry.h>

#import "DAZInfoView.h"

@interface DAZInfoViewTests : XCTestCase

@property (nonatomic, strong) DAZInfoView *infoView;

@end

@implementation DAZInfoViewTests

- (void)setUp
{
    [super setUp];

    self.infoView = OCMPartialMock([[DAZInfoView alloc] init]);
}

- (void)tearDown
{
    self.infoView = nil;
    
    [super tearDown];
}

- (void)testUpdateConstraints
{
    [self.infoView updateConstraints];
    
    OCMVerify([self.infoView.infoLabel mas_remakeConstraints:OCMOCK_ANY]);
}

@end
