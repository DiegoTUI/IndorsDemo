//
//  Indoors.h
//  Indoors
//
//  Created by Gerhard Zeissl on 02.12.12.
//  Copyright (c) 2012 Indoors. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IndoorsBuilder.h"
#import "IndoorsError.h"
#import "IndoorsErrorCode.h"
#import "IndoorsLocationAdapter.h"
#import "IndoorsDelegate.h"
#import "IDSBuilding.h"
#import "IDSCoordinate.h"
#import "IDSFloor.h"
#import "IDSMap.h"
#import "IDSTile.h"
#import "IDSDefaultMap.h"
#import "IDSZone.h"
#import "IDSZonePoint.h"
#import "IndoorsBuilder.h"

@class IDSCoordinate;
@interface Indoors : NSObject

@property (nonatomic, strong) NSString *tilesPath;

+ (Indoors *)instance;

/*!
 @method initWithLicenseKey:andServiceDelegate:
 @abstract Initialize indoo.rs API to be able to call any method, automatically authenticate indoo.rs service.
 @discussion
 Initialize indoo.rs instance.
 Use given licenseKey to authenticate to indoo.rs service.
 OnSuccess call delegate IndoorsServiceDelegate(connected)
 OnFail call delegate IndoorsServiceDelegate(onError:)
 
 @param licenseKey 
 Your indoo.rs API key
 @param serviceDelegate 
 Service delegate to be called on success or failure
 
 @result indoo.rs instance - You should not use it to call any API, instead use the shared instance
 */
- (Indoors *)initWithLicenseKey:(NSString *)licenseKey andServiceDelegate:(id<IndoorsServiceDelegate>)serviceDelegate;


/*!
 @discussion
 Register location listener to recieve any location updates.
 
 @param listner 
 IndoorsLocationAdapter instance to be added as listener
 */
- (void)registerLocationListener:(IndoorsLocationAdapter *)listener;

/*!
 @discussion
 Remove location listener, you should remove your listener before releasing it.
 
 @param listner 
 IndoorsLocationAdapter instance to be removed from list of existing listeners if exists.
 */
- (void)removeLocationListener:(IndoorsLocationAdapter *)listener;

/*!
 @discussion
 Start localization service, starting updating user location.
 */
- (void)startLocalization;

/*!
 @discussion
 Stop localization service.
 */
- (void)stopLocalization;


- (void)getBuilding:(IDSBuilding*) building forRequestDelegate:(id<LoadingBuildingDelegate>)delegate;
- (void)cancelGetBuilding;

- (void)getOnlineBuildings:(id<OnlineBuildingDelegate>) onlineBuildingDelegate;

- (NSString *)getCurrentDatabasePath;

- (void)routeFromLocation:(IDSCoordinate *) from toLocation:(IDSCoordinate *)to delegate:(id<RoutingDelegate>)routingDelegate;

- (IDSCoordinate *)snapPosition:(IDSCoordinate *)position toRoute:(NSArray *)path;

- (void)enableEvaluationMode:(BOOL)isEvaluationModeEnabled;

- (void)positionUpdated:(IDSCoordinate *)newPosition;

- (void)passLocationToLocator:(IDSCoordinate *)location;
@end
