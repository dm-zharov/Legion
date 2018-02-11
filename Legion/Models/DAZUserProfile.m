//
//  VKUserProfile.m
//  Legion
//
//  Created by Дмитрий Жаров on 09.02.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import "DAZUserProfile.h"

static NSString *const DAZUserAuthorizationTypeKey = @"authorizationType";
static NSString *const DAZUserIDKey = @"userID";
static NSString *const DAZUserFirstNameKey = @"firstName";
static NSString *const DAZUserLastNameKey = @"lastName";
static NSString *const DAZUserEmailKey = @"email";
static NSString *const DAZUserPhotoURLKey = @"photoURL";

@interface DAZUserProfile ()

@property (nonatomic, strong) NSUserDefaults *userDefaults;

@end

@implementation DAZUserProfile

+ (NSUserDefaults *)userDefaults
{
    return [NSUserDefaults standardUserDefaults];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _userDefaults = [DAZUserProfile userDefaults];
    }
    return self;
}

#pragma mark - Setters

- (void)setAuthorizationType:(DAZAuthorizationType)authorizationType
{
    [self.userDefaults setInteger:authorizationType forKey:DAZUserAuthorizationTypeKey];
}

- (void)setUserID:(NSString *)userID
{
    [self.userDefaults setValue:userID forKey:DAZUserIDKey];
}

- (void)setFirstName:(NSString *)firstName
{
    [self.userDefaults setValue:firstName forKey:DAZUserFirstNameKey];
}

- (void)setLastName:(NSString *)lastName
{
    [self.userDefaults setValue:lastName forKey:DAZUserLastNameKey];
}

- (void)setEmail:(NSString *)email
{
    [self.userDefaults setValue:email forKey:DAZUserEmailKey];
}

- (void)setPhotoURL:(NSURL *)photoURL
{
    [self.userDefaults setURL:photoURL forKey:DAZUserPhotoURLKey];
}

#pragma mark - Getters

- (DAZAuthorizationType)authorizationType
{
    return [self.userDefaults integerForKey:DAZUserAuthorizationTypeKey];
}

- (NSString *)fullName
{
    return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
}

- (NSString *)userID
{
    return [self.userDefaults stringForKey:DAZUserIDKey];
}

- (NSString *)firstName
{
    return [self.userDefaults stringForKey:DAZUserFirstNameKey];
}

- (NSString *)lastName
{
    return [self.userDefaults stringForKey:DAZUserLastNameKey];
}

- (NSString *)secondName
{
    return [self.userDefaults stringForKey:DAZUserLastNameKey];
}

- (NSString *)email
{
    return [self.userDefaults stringForKey:DAZUserEmailKey];
}

- (NSURL *)photoURL
{
    return [self.userDefaults URLForKey:DAZUserPhotoURLKey];
}

@end
