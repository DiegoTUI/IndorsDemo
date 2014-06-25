//
//  IndoorsSurfaceView.h
//  IndoorsSurface
//
//  Created by Mina Haleem on 25.07.13.
//  Copyright (c) 2013 Indoors GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Indoors/Indoors.h>
#import "IndoorsSurfaceEnums.h"
#import "ISMapScrollView.h"

@class ISIndoorsSurface;

@protocol IndoorsSurfaceViewDelegate <NSObject>
- (void)indoorsSurface:(ISIndoorsSurface*) surfaceView userDidSelectLocationToStartRouting:(IDSCoordinate*)location userCurrentLocation:(IDSCoordinate*)userCurrentLocation;
@end

@interface ISIndoorsSurface : UIView
@property (nonatomic, strong) id<IndoorsSurfaceViewDelegate> delegate;
@property (nonatomic, readonly) ISMapScrollView* mapScrollView;
@property (nonatomic) BOOL enableAutomaticFloorSelection;
@property (nonatomic) BOOL routeSnappingEnabled;

- (void)setBuildingForSurface:(IDSBuilding*)surfaceBuilding;
- (void)setFloorLevel:(int)floorLevel;
- (void)setSize:(CGRect)newFrame;
- (void)setMapCenterWithCoordinate:(IDSCoordinate*)coordinate;

- (void)letUserSelectLocation;
- (void)showPathWithPoints:(NSArray*)points;
- (BOOL)hasActiveBuilding;
- (void)setZoneDisplayMode:(IndoorsSurfaceZoneDisplayModes)zoneDisplayMode;
- (void)setUserPositionDisplayMode:(IndoorsSurfaceUserPositionDisplayModes)userPositionDisplayMode;
- (void)setUserPositionIcon:(UIImage*)userPositionIcon;
- (void)hideAccuracy:(BOOL)shouldHideAccuracy;
@end
