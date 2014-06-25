//
//  IVMap.h
//  iViewer
//
//  Created by Mina Haleem on 24.03.13.
//  Copyright (c) 2013 Mina Haleem. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IVMap : NSObject
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *tilesPath;
@property (nonatomic, assign, readonly) float mmPerPixelBase;
@property (nonatomic, assign, readonly) CGSize mapSize;
@property (nonatomic, assign, readonly) NSUInteger levelsOfDetail;

- (id)initWithName:(NSString *)name
         tilesPath:(NSString *)tilesPath
    mmPerPixelBase:(float)mmPerPixelBase
           mapSize:(CGSize)mapSize
    levelsOfDetail:(NSUInteger)levelsOfDetail;
- (UIImage *)tileForScale:(CGFloat)scale row:(int)row col:(int)col;
@end
