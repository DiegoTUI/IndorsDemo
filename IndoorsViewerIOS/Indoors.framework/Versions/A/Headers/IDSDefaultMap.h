//
//  DefaultMaps.h
//  Indoors
//
//  Created by Gerhard Zeissl on 05.03.13.
//  Copyright (c) 2013 Indoors. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IDSFloor;
@interface IDSDefaultMap : NSObject
@property (nonatomic) long defaultMapID;
@property (nonatomic) double mmPerPixelBase;
@property (nonatomic) NSInteger maxTileSize;
@property (nonatomic, strong) IDSFloor *floor;

//= new HashMap<Integer, Tiles>()
@property (nonatomic,strong) NSMutableDictionary *tiles;

//private Map<String, ResourceLinkImpl> links;
@property (nonatomic,strong) NSDictionary *links;

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

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *tilesPath;
@property (nonatomic, assign, readonly) CGSize mapSize;
@property (nonatomic, assign, readonly) NSUInteger levelsOfDetail;

- (id)initWithName:(NSString *)name
         tilesPath:(NSString *)tilesPath
    mmPerPixelBase:(float)mmPerPixelBase
           mapSize:(CGSize)mapSize
    levelsOfDetail:(NSUInteger)levelsOfDetail;
- (UIImage *)tileForScale:(CGFloat)scale row:(int)row col:(int)col;



- (void) calculateValues;

@end
