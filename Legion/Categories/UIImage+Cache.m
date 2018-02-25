//
//  UIImage+Cache.m
//  Legion
//
//  Created by Дмитрий Жаров on 10.02.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import "UIImage+Cache.h"
#import <objc/runtime.h>


static void *DAZImageCacheKey;


@interface UIImage (Cache_Properties)

@property (nonatomic, copy, class) NSDictionary *ch_cache;

@end

@implementation UIImage (Cache_Properties)

+ (void)setCh_cache:(NSDictionary *)cache
{
    objc_setAssociatedObject(self, &DAZImageCacheKey, [cache copy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (NSDictionary *)ch_cache
{
    return objc_getAssociatedObject(self, &DAZImageCacheKey) ? : @{};
}

@end

@implementation UIImage (Cache)


#pragma mark - Public Static

+ (void)ch_imageWithContentsOfURL:(NSURL *)url completion:(void (^)(UIImage *))completion
{
    if (!url)
    {
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) , ^{
        UIImage *image = self.ch_cache[url];
        
        if (!image)
        {
            image = [self ch_imageForURL:url];
            self.ch_cache = [self ch_addImage:image forURL:url toCache:self.ch_cache];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(image);
        });
    });
}

#pragma mark - Private Static

+ (NSDictionary *)ch_addImage:(UIImage *)image forURL:(NSURL *)url toCache:(NSDictionary *)cache
{
    if (!image)
    {
        return cache;
    }
    
    NSMutableDictionary *mutableCache = [cache mutableCopy];
    mutableCache[url] = image;
    return mutableCache;
}

+ (UIImage *)ch_imageForURL:(NSURL *)url
{
    NSData *data = [self ch_dataForURL:url];
    if (!data)
    {
        data = [NSData dataWithContentsOfURL:url];
        [self ch_saveData:data forURL:url];
    }
    
    UIImage *image = [UIImage imageWithData:data];
    return image;
}

+ (BOOL)ch_saveData:(NSData *)data forURL:(NSURL *)url
{
    NSString *path = [self ch_pathForURL:url];
    BOOL isSaved = [data writeToFile:path options:NSDataWritingAtomic error:nil];
    return isSaved;
}

+ (NSData *)ch_dataForURL:(NSURL *)url
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = [self ch_pathForURL:url];
    if ([fileManager fileExistsAtPath:path])
    {
        return [NSData dataWithContentsOfFile:path];
    }
    else
    {
        return nil;
    }
}

+ (NSString *)ch_pathForURL:(NSURL *)url
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *urlName = [self ch_nameFromURL:url];
    path = [path stringByAppendingPathComponent:@"images"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:path isDirectory:nil])
    {
        NSError *error;
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
    }
    
    path = [path stringByAppendingPathComponent:urlName];
    return path;
}

+ (NSString *)ch_nameFromURL:(NSURL *)url
{
    NSString *path = url.path;
    path = [path stringByReplacingOccurrencesOfString:@"/" withString:@""];
    return path;
}

@end
