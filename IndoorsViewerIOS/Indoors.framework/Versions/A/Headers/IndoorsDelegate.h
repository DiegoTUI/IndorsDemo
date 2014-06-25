//
//  IndoorsRequestDelegate.h
//  Indoors
//
//  Created by Gerhard Zeissl on 02.12.12.
//  Copyright (c) 2012 Indoors. All rights reserved.
//

/**
 #! Will be seperated later into single protocol files.
 */

#import <Foundation/Foundation.h>

@class IDSBuilding;
@class IndoorsError;

/**
 * Delegates for asynchronous communication with the service.
 *
 * All calls are made from the applications ui(main) thread so feel free to
 * update your userinterface.
 *
 * @author customLBS | Philipp Koenig
 *
 */
@protocol IndoorsRequestDelegate <NSObject>


@end


/**
 * Delegate to retrieve buildings imported by the client.
 *
 * @see Indoors#getImportedBuildings(ImportedBuildingDelegate)
 *
 * @author customLBS | Philipp Koenig
 *
 */
@protocol ImportedBuildingDelegate <NSObject>

/**
 * List of available buildings imported with
 * {@link Indoors#addMapDirectory(java.io.File, boolean)}.
 *
 * Does not contain {@link Floor} or {@link Tiles} members.
 *
 * Use {@link Indoors#getBuilding(Building, LoadingBuildingDelegate)} to
 * get {@link Floor} and {@link Tiles} objects.
 *
 * @see Indoors#getBuilding(Building, LoadingBuildingDelegate)
 *
 * @param buildings
 */
- (void)setImportedBuildings:(NSArray*) buildings;

@end

/**
 * Delegate to retrieve buildings available from indoo.rs server.
 *
 * @see Indoors#getOnlineBuildings(OnlineBuildingDelegate)
 *
 * @author customLBS | Philipp Koenig
 *
 */
@protocol OnlineBuildingDelegate <NSObject>

/**
 * List of buildings available from indoo.rs server.
 *
 * Does not contain {@link Floor} or {@link Tiles}.
 *
 * Use {@link Indoors#getBuilding(Building, LoadingBuildingDelegate)} to
 * get {@link Floor} and {@link Tiles} objects.
 *
 * @see Indoors#getBuilding(Building, LoadingBuildingDelegate)
 *
 * @param buildings
 */
- (void)setOnlineBuildings:(NSArray*)buildings;

- (void)getOnlineBuildingsFailWithError:(NSError*)error;

@end
    
/**
 * Delegate to retrieve calculated route.
 *
 * @see Indoors#getRouteAToB(Coordinate, Coordinate, RoutingDelegate)
 *
 * @author customLBS | Philipp Koenig
 *
 */
@protocol RoutingDelegate <NSObject>

/**
 * Path coordinates from the given route. Z coordinate may change if
 * routing through different floors.
 *
 * @param path NSArray with Coordinates.
 */
- (void)setRoute:(NSArray*) path;

@end

/**
 * Delegate for progress of loading a building.
 *
 * @see Indoors#getBuilding(Building, LoadingBuildingDelegate)
 * @see IndoorsLocationListener
 * @see IndoorsLocationAdapter
 *
 * @author customLBS | Philipp Koenig
 *
 */

@protocol LoadingBuildingDelegate
/**
 * Consequent calls are made until the building is loaded. Then the
 * building will be set with {@link #buildingLoaded(Building)}.
 *
 * @param progress
 *            (0 - 100)
 */
- (void)loadingBuilding:(NSNumber*)progress;
        
/**
 * Service finished processing building. Building object has
 * {@link Floor} and {@link Tiles} set.
 *
 * @see TileRequester
 *
 * @param building
 */
- (void)buildingLoaded:(IDSBuilding*)building;

/**
 * Call back when loading building failed
 *
 */

- (void)loadingBuildingFailed;

@end

/**
 * Consequent calls are made until the building is loaded. Then the
 * building will be set with {@link #buildingLoaded(Building)}.
 *
 * @param progress
 *            (0 - 100)
 */
@protocol ZoneDelegate <NSObject>
- (void)setZones:(NSArray*)zones;
@end

/**
 * Consequent calls are made until the building is loaded. Then the
 * building will be set with {@link #buildingLoaded(Building)}.
 *
 * @param progress
 *            (0 - 100)
 */
//@protocol  DebugInfoDelegate
//- (void)setDebugInfo:(DebugInfo*)debugInfo;
//@end

/**
 * Retrieve information about the authentication status.
 *
 * @author customLBS | Philipp Koenig
 *
 */
//#! errorprot
@protocol IndoorsServiceDelegate <NSObject>

typedef NS_ENUM(NSUInteger, IDSBluetoothState) {
    IDSBluetoothStateAvailable,
    IDSBluetoothStateUnavailable
};

/**
 * Client successful registered to the indoors service and is free to
 * register {@link IndoorsLocationListener}s or make any calls to
 * {@link Indoors}.
 */
- (void)connected;

/**
 * Exceptions from this method will always have an error code set (
 * {@link IndoorsException#getErrorCode()}).
 *
 * <ul>
 * <li>{@link ErrorCode#AUTH_LICENSE_EXCEEDED} The API key is expired.</li>
 * <li>{@link ErrorCode#AUTH_LICENSE_NOTEXISTING} The API key does not
 * exist.</li>
 * <li>{@link ErrorCode#AUTH_OBLIGATORY_IO_REQUEST} The API key must be
 * checked with the indoors server, so a connection to the server is
 * required. This is only required if the license was never checked.</li>
 * </ul>
 *
 * @param indoorsException
 */
- (void)onError:(IndoorsError*) indoorsError;

- (void)bluetoothStateDidChange:(IDSBluetoothState)bluetoothState;
@end

