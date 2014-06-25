//
//  Map.h
//  Indoors
//
//  Created by Gerhard Zeissl on 02.12.12.
//  Copyright (c) 2012 Indoors. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IDSDefaultMap.h"

@interface IDSMap : NSObject

/**
 * Highest tile size available.
 *
 */
@property (nonatomic) long mapID;

/**
 * DefaultMap.
 *
 */
@property (nonatomic, strong) IDSDefaultMap* defaultMap;

/**
 * Highest tile size available.
 *
 * @return
 */
@property (nonatomic) int tileSizeMaximum;

/**
 * Mm per pixel for tile size 1.
 *
 */
@property (nonatomic) double meterPerPixel;

/**
 * All available tiles.
 *
 * @return
 */
@property (nonatomic, strong) NSMutableArray *tiles;

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *tilesPath;
@property (nonatomic, assign, readonly) CGSize mapSize;
@property (nonatomic, assign, readonly) NSUInteger levelsOfDetail;
@property (nonatomic, assign, readonly) float mmPerPixelBase;

- (id)initWithName:(NSString *)name
         tilesPath:(NSString *)tilesPath
    mmPerPixelBase:(float)mmPerPixelBase
           mapSize:(CGSize)mapSize
    levelsOfDetail:(NSUInteger)levelsOfDetail;
- (UIImage *)tileForScale:(CGFloat)scale row:(int)row col:(int)col;


@end
