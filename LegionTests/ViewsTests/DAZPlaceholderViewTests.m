//
//  DAZPlaceholderViewTests.m
//  LegionTests
//
//  Created by Дмитрий Жаров on 18.02.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import <Expecta/Expecta.h>
#import <Masonry/Masonry.h>

#import "DAZPlaceholderView.h"

@interface DAZPlaceholderView (Tests)

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;

@end

@interface DAZPlaceholderViewTests : XCTestCase

@property (nonatomic, strong) DAZPlaceholderView *placeholderView;

@end

@implementation DAZPlaceholderViewTests

- (void)setUp
{
    [super setUp];
    
    self.placeholderView = OCMPartialMock([[DAZPlaceholderView alloc] init]);
}

- (void)tearDown
{
    self.placeholderView = nil;
    
    [super tearDown];
}

- (void)testUpdateConstraints
{
    [self.placeholderView updateConstraints];
    
    OCMVerify([self.placeholderView.titleLabel mas_remakeConstraints:OCMOCK_ANY]);
    
    OCMVerify([self.placeholderView.messageLabel mas_remakeConstraints:OCMOCK_ANY]);
}

@end
