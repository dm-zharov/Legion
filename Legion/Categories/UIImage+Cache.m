//
//  UIImage+Cache.m
//  Legion
//
//  Created by Дмитрий Жаров on 10.02.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import "UIImage+Cache.h"

@implementation UIImage (Cache)

#pragma mark - Instance Accessors

+ (void)ch_imageWithContentsOfURL:(NSURL *)url completion:(void (^)(UIImage *))completion
{
    if (!url)
    {
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) , ^{
        NSData *data = [self ch_dataWithContentsOfURL:url];
        if (!data)
        {
            data = [NSData dataWithContentsOfURL:url];
            [self ch_saveData:data ForUrl:url];
        }
        
        UIImage *image = [UIImage imageWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(image);
        });
    });
}

#pragma mark - Private

+ (void)ch_saveData:(NSData*)data ForUrl: (NSURL*)url
{
    NSString *path = [self ch_getPathForURL:url];
    
    NSError *error = nil;
    if (![data writeToFile:path options:NSDataWritingAtomic error:&error])
    {
        NSLog(@"Error Writing File: %@", error.localizedDescription);
    }
}

+ (NSData*)ch_dataWithContentsOfURL: (NSURL*)url
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = [self ch_getPathForURL:url];
    if ([fileManager fileExistsAtPath:path])
    {
        return [NSData dataWithContentsOfFile:path];
    }
    else
    {
        return nil;
    }
}

+ (NSString*)ch_getPathForURL:(NSURL *)url
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *nameFromURL = [self ch_getNameFromURL:url];
    path = [path stringByAppendingPathComponent:@"images"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:path isDirectory:nil])
    {
        NSError *error;
        if (![fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error])
        {
            NSLog(@"Error Create Image Cache Directory: %@", error.localizedDescription);
            return nil;
        }
    }
    
    path = [path stringByAppendingPathComponent:nameFromURL];
    return path;
}

+ (NSString *)ch_getNameFromURL:(NSURL *)url
{
    NSString *path = url.path;
    path = [path stringByReplacingOccurrencesOfString:@"/" withString:@""];
    return path;
}

@end
