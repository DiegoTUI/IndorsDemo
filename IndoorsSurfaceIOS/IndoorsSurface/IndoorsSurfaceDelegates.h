//
//  IndoorsSurfaceDelegates.h
//  IndoorsSurface
//
//  Created by Mina Haleem on 16.10.13.
//  Copyright (c) 2013 Indoors GmbH. All rights reserved.
//

#ifndef IndoorsSurface_IndoorsSurfaceDelegates_h
#define IndoorsSurface_IndoorsSurfaceDelegates_h

@class IDSCoordinate;
@class IndoorsError;
@class IDSBuilding;

@protocol IndoorsSurfaceServiceDelegate <NSObject>
@required
- (void)connected;
- (void)onError:(IndoorsError*) indoorsError;
- (void)loadingBuilding:(NSNumber*)progress;
- (void)buildingLoaded:(IDSBuilding*)building;
- (void)loadingBuildingFailed;
@end

@protocol IndoorsSurfaceLocationDelegate <NSObject>
@required
- (void)updateFloorLevel:(int)floorLevel name:(NSString*)name;
- (void)updateUserPosition:(IDSCoordinate*)userPosition;
- (void)updateUserOrientation:(float)orientation;
- (void)weakSignal;
@end

#endif
