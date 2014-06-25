//
//  Tiles.h
//  Indoors
//
//  Created by Gerhard Zeissl on 02.12.12.
//  Copyright (c) 2012 Indoors. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IDSTile : NSObject

/**
 * Mm per pixel of this tile size.
 *
 * @param tileID ID as int.
 */
@property (nonatomic) long *tileID;

/**
 * Tiles Array.
 *
 * @param tileID ID as int.
 */
@property (nonatomic, strong) NSArray *tiles;

/**
 * Mm per pixel of this tile size.
 *
 * @param meterPerPixel Meter per pixel as int.
 */
@property (nonatomic) NSUInteger meterPerPixel;

/**
 * The tile size (a power of 2). 1 is the most detailed tile size.
 *
 * @param tileSize Tilesize as int.
 */
@property (nonatomic) NSUInteger tileSize;

/**
 * Height of the map with this tile size in pixel.
 *
 * @param summaryPixelHeight Height value as int.
 */
@property (nonatomic) NSUInteger summaryPixelHeight;

/**
 * Width of the map with this tile size in pixel.
 *
 * @param summaryPixelWidth Width as int.
 */
@property (nonatomic) NSUInteger summaryPixelWidth;

/**
 * Number of horizontal tiles.
 *
 * @param countHorziontalTiles Number of horizontal tiles as int.
 */
@property (nonatomic) NSUInteger countHorizontalTiles;

/**
 * Number of vertical tiles.
 *
 * @param countVerticalTiles Number of vertical tiles as int.
 */
@property (nonatomic) NSUInteger countHVerticalTiles;


@end
