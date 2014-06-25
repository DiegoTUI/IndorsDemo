//
//  Building.h
//  Indoors
//
//  Created by Gerhard Zeissl on 02.12.12.
//  Copyright (c) 2012 Indoors. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IDSMap.h"
#import "IDSFloor.h"
/**
 * <p>
 * Model class representing a building.
 * </p>
 *
 * <p>
 * Note: Buildings retrieved with
 * {@link Indoors#getImportedBuildings(ImportedBuildingCallback)} or
 * {@link Indoors#getOnlineBuildings(OnlineBuildingCallback)} will not be fully
 * initialized with all their members. Floor or tile members will not be set as
 * they are intended to show all available buildings.
 * </p>
 *
 * <p>
 * Buildings retrieved from {@link IndoorsLocationListener} or via
 * {@link Indoors#getBuilding(Building, LoadingBuildingCallback)} will have all
 * their members set.
 * </p>
 *
 * @author customLBS | Philipp Koenig
 *
 */
@interface IDSBuilding : NSObject

@property (nonatomic, strong) NSMutableDictionary *floors;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *buildingDescription;
@property (nonatomic) NSInteger latOrigin, lonOrigin;
@property (nonatomic) float rotation;
@property (nonatomic) NSUInteger buildingID;
@property (nonatomic, strong) NSString *databasePath;

- (int)getInitialFloorLevel;
- (IDSFloor*)floorAtLevel:(NSUInteger)floorLevel;
- (IDSFloor*)getFloorById:(long)floorId;

//#! Added for prototype
@property (nonatomic,strong) IDSMap *map;
@end
