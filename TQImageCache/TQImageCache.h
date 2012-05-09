//
//  TQImageCAche.h
//
//
//  Created by Tang Qiao on 12-5-9.
//  Copyright (c) 2012年 blog.devtang.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TQImageCache : NSObject

@property (nonatomic, assign) NSInteger maxMemoryCacheNumber;


- (id) initWithCachePath:(NSString*)path andMaxMemoryCacheNumber:(NSInteger)maxNumber;

- (void) putImage:(NSData *) imageData withName:(NSString*)imageName ;
- (NSData *) getImage:(NSString *)imageName;
- (void)clear;

@end
