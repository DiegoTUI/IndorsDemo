//
//  IndoorsLocationListener.m
//  Indoors
//
//  Created by Gerhard Zeissl on 02.12.12.
//  Copyright (c) 2012 Indoors. All rights reserved.
//


#import "IDSBuilding.h"
#import "IDSCoordinate.h"
#import "IndoorsDelegate.h"

/**
 * Main interface for localization updates from the indoo.rs service.
 *
 *
 */
@protocol IndoorsLocationListener //extends <LoadingBuildingCallback, IndoorsError>
    
/**
 * Service located a building and is processing all necessary information to
 * make it available to the client. Depending on the building this may take
 * some time.
 *
 * <p>
 * After loading finished
 * {@link IndoorsLocationListener#buildingLoaded(Building)} will be called.
 * </p>
 *
 * <p>
 * Any errors will be reported in
 * {@link IndoorsLocationListener#onError(IndoorsException)}.
 * </p>
 *
 * @see IndoorsLocationListener#buildingLoaded(Building)
 * @see IndoorsLocationListener#onError(IndoorsException)
 * @param progress Progress as int.
 */
- (void)loadingBuilding:(int)progress;
    
/**
 * Service finished processing the building and is starting to provide
 * location updates. Any building meta data (floors, tiles, etc.) is
 * available in the building object.
 *
 * <p>
 * Called after {@link IndoorsLocationListener#loadingBuilding(int)}.
 * </p>
 *
 * @param building
 *            a fully resolved object of the entered building
 *
 * @see IndoorsLocationListener#positionUpdated(Coordinate, int)
 * @see IndoorsLocationListener#changedFloor(int, String)
 * @see IndoorsLocationListener#orientationUpdated(float)
 */
- (void)buildingLoaded:(IDSBuilding*) building;
    
/**
 * Client is no longer inside the building. You can use this for reminders
 * or other events, or you can switch to a world map (e.g. Google maps) now.
 *
 * @param building
 */
- (void)leftBuilding:(IDSBuilding*) building;
    
/**
 * New user position in form of x/y/z.
 *
 * <p>
 * Gets called about every second.
 * </p>
 *
 * <p>
 * X and y coordinate are your position on the current floor. The coordinate
 * origin is the top-left corner in the building. Units are millimeter. Z is
 * the current floor level (..., -1=Sub1, 0=Ground, 1=Floor1,...). If the
 * floor can not be computed due to bad signal Z will be Interger.MAX_VALUE.
 * {@link Building#getFloorByLevel(int)}.
 * </p>
 *
 * <p>
 * For example if x=1500, y=10000, z=2 you are on the second floor and 1,5m
 * from the left-most and 10m from the top-most corner in the building map.
 * </p>
 *
 * @param userPosition
 *            current user position
 * @param accuracy
 *            the accuracy radius in mm as int
 *
 * @see com.customlbs.shared.Coordinate
 * @see Building#getFloorByLevel(int)
 */
- (void)positionUpdated:(IDSCoordinate*)userPosition;

/**
 * 
 */
- (void)weakSignal;
    
/**
 * Current orientation in degrees.
 *
 * <p>
 * For convenience the angle is
 * <em>relative to the building map, not relative to North</em>. More
 * precisely the returned value is the clockwise oriented angle on the x,y
 * plane starting at the y-axis.
 * </p>
 *
 * @param orientation
 *            current orientation in degrees as float
 */
- (void)orientationUpdated:(float)orientation;
    
/**
 * The floor has changed.
 *
 * <p>
 * This will be called <em>before</em> you receive position updates for the
 * new floor.
 * </p>
 *
 * @param floorLevel
 *            level of the floor (..., -1=Sub1, 0=Ground, 1=Floor1,...). if
 *            the floor can temporary not be computed you get
 *            Integer.MAX_VALUE you may use this to display a warning like
 *            "low signal, computing..." as int.
 * @param name
 *
 * @see IndoorsLocationListener#positionUpdated(Coordinate, int)
 * @see Building#getFloorByLevel(int)
 */
- (void)changedFloor:(int)floorLevel withName:(NSString*)name;

@end
