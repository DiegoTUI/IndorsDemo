//
//  Floor.h
//  Indoors
//
//  Created by Gerhard Zeissl on 02.12.12.
//  Copyright (c) 2012 Indoors. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IDSDefaultMap;
@interface IDSFloor : NSObject

/**
 * floor id of this building.
 */
@property (nonatomic) long floorID;

/**
 * name of this building.
 */
@property (nonatomic, strong) NSString *name;

/**
 * Default map object.
 *
 * There may be other maps (just visually different).
 */
@property (nonatomic, strong) IDSDefaultMap *defaultMap;

/**
 * Width of this building in mm.
 */
@property (nonatomic) int widthInMeter;

/**
 * Length of this building in mm.
 */
@property (nonatomic) int lengthInMeter;

/**
 * Floor level.
 *
 * I.e.: ground-floor = 0
 */
@property (nonatomic) NSUInteger level;

/**
 * Space from left origin of ground floor if this floor has other
 * dimensions.
 *
 * @return
 */
@property (nonatomic) int leftOriginInMeter;

/**
 * Zones available in floor
 *
 * @return
 */
@property (nonatomic,strong) NSMutableArray* zones;

/**
 * Dead Zones available in floor
 *
 * @return
 */
@property (nonatomic,strong) NSMutableArray* deadZones;

/**
 * Space from top origin of ground floor if this floor has other dimensions.
 */
@property (nonatomic) int topOriginInMeter;
@property (nonatomic) NSString *floorDescription;

@property (nonatomic) int mmWidth;
@property (nonatomic) int mmHeight;


@end
