//
//  VKUserProfile.m
//  Legion
//
//  Created by Дмитрий Жаров on 09.02.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import "DAZUserProfile.h"

@implementation DAZUserProfile

- (void)setAnonymous:(BOOL)anonymous
{
    [[NSUserDefaults standardUserDefaults] setBool:anonymous forKey:@"isAnonymous"];
}

- (void)setUserID:(NSString *)userID
{
    [[NSUserDefaults standardUserDefaults] setValue:userID forKey:@"userID"];
}

- (void)setFirstName:(NSString *)firstName
{
    [[NSUserDefaults standardUserDefaults] setValue:firstName forKey:@"firstName"];
}

- (void)setLastName:(NSString *)lastName
{
    [[NSUserDefaults standardUserDefaults] setValue:lastName forKey:@"lastName"];
}

- (void)setEmail:(NSString *)email
{
    [[NSUserDefaults standardUserDefaults] setValue:email forKey:@"email"];
}

- (void)setPhotoURL:(NSURL *)photoURL
{
    [[NSUserDefaults standardUserDefaults] setURL:photoURL forKey:@"photoURL"];
}

- (BOOL)isAnonymous
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"isAnonymous"];
}

- (NSString *)userID
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"userID"];
}

- (NSString *)firstName
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"firstName"];
}

- (NSString *)secondName
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"secondName"];
}

- (NSString *)email
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"userID"];
}

- (NSURL *)photoURL
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"photoURL"];
}

@end
