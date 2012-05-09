//
//  TQImageCache.m
//
//
//  Created by Tang Qiao on 12-5-9.
//  Copyright (c) 2012年 blog.devtang.com. All rights reserved.
//

#import "TQImageCache.h"

@interface TQImageCache()

@property (nonatomic, retain) NSString * cachePath;
@property (nonatomic, retain) NSFileManager * fileManager;
@property (nonatomic, retain) NSMutableDictionary * memoryCache;
@property (nonatomic, retain) NSMutableArray *memoryCacheKeys;

@end

@implementation TQImageCache;

@synthesize maxMemoryCacheNumber;
@synthesize cachePath;
@synthesize fileManager;
@synthesize memoryCache;
@synthesize memoryCacheKeys;

static BOOL debugMode = YES;

#ifdef DEBUG
#define debugLog(...) NSLog(__VA_ARGS__)
#define debugMethod() NSLog(@"%s", __func__)
#else
#define debugLog(...)
#define debugMethod()
#endif

- (id) init {
    return [self initWithCachePath:@"TQImageCache" andMaxMemoryCacheNumber:50];
}

- (id) initWithCachePath:(NSString*)path andMaxMemoryCacheNumber:(NSInteger)maxNumber {
    if ([path hasPrefix:NSTemporaryDirectory()]) {
        self.cachePath = path;
    } else {
        if ([path length] != 0) {
            self.cachePath = [NSTemporaryDirectory() stringByAppendingPathComponent:path];
        } else {
            return nil;
        }
    }
    self.maxMemoryCacheNumber = maxNumber;

    if (self = [super init]) {
        self.fileManager = [NSFileManager defaultManager];
        if ([self.fileManager fileExistsAtPath:self.cachePath isDirectory:nil] == NO) {
            // create the directory
            BOOL res = [self.fileManager createDirectoryAtPath:self.cachePath withIntermediateDirectories:YES attributes:nil error:nil];
            if (!res) {
                debugLog(@"file cache directory create failed! The path is %@", self.cachePath);
                return nil;
            }
        }
        self.memoryCache = [[[NSMutableDictionary alloc] initWithCapacity:maxMemoryCacheNumber] autorelease];
        self.memoryCacheKeys = [[[NSMutableArray alloc] initWithCapacity:maxMemoryCacheNumber] autorelease];
        return self;
    }
    return self;
}

- (void)clear {
    self.memoryCache = [[[NSMutableDictionary alloc] initWithCapacity:maxMemoryCacheNumber] autorelease];
    self.memoryCacheKeys = [[[NSMutableArray alloc] initWithCapacity:maxMemoryCacheNumber] autorelease];

    // remove all the file in temporary
    NSArray * files = [self.fileManager contentsOfDirectoryAtPath:self.cachePath error:nil];
    for (NSString * file in files) {
        if (debugMode) {
            debugLog(@"remove cache file: %@", file);
        }
        [self.fileManager removeItemAtPath:file error:nil];
    }
}

- (void) putImage:(NSData *) imageData withName:(NSString*)imageName {
    [self.memoryCache setObject:imageData forKey:imageName];
    [self.memoryCacheKeys addObject:imageName];
    if ([self.memoryCache count] > self.maxMemoryCacheNumber) {
        // Retain the `key` varible otherwise
        // it maybe dealloc after it is removed from memoryCahceKyes array
        NSString * key = [[self.memoryCacheKeys objectAtIndex:0] retain];
        [self.memoryCache removeObjectForKey:key];
        [self.memoryCacheKeys removeObjectAtIndex:0];
        if (debugMode) {
            debugLog(@"remove oldest cache from memory: %@", key);
        }
        [key release];
    }
    NSString * path = [self.cachePath stringByAppendingPathComponent:imageName];
    [imageData writeToFile:path atomically:YES];
    if (debugMode) {
        debugLog(@"TQImageCache put cache image to %@", path);
    }
}

- (NSData *) getImage:(NSString *)imageName {
    NSData * data = [self.memoryCache objectForKey:imageName];
    if (data != nil) {
        if (debugMode) {
            debugLog(@"TQImageCache hit cache from memory: %@", imageName);
        }
        return data;
    }
    NSString * path = [self.cachePath stringByAppendingPathComponent:imageName];
    if ([self.fileManager fileExistsAtPath:path]) {
        if (debugMode) {
            debugLog(@"TQImageCache hit cache from file %@", path);
        }
        return [NSData dataWithContentsOfFile:path];
    }
    return nil;
}

@end
