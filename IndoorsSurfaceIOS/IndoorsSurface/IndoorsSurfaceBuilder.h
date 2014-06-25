//
//  IndoorsSurfaceBuilder.h
//  IndoorsSurface
//
//  Created by Mina Haleem on 10.08.13.
//  Copyright (c) 2013 Indoors GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Indoors/Indoors.h>
#import "IndoorsSurfaceEnums.h"
#import "IndoorsSurfaceDelegates.h"


@interface IndoorsSurfaceBuilder : NSObject
/*!
 @method initWithIndoorsBuilder:inView:
 @discussion 
 Initialize IndoorsSurfaceBuilder, surface used to present an indoo.rs map.
 
 @param indoorsBuilder
 An instance of IndoorsBuilder, you should intialize the instance with a valid API key and building ID before passing it to surface.
 @param view
 View that planned to add the surface to it, suface will take full width and height of given view
 
 @result Insance of IndoorsSurfaceBuilder
 */

- (id)initWithIndoorsBuilder:(IndoorsBuilder*)indoorsBuilder inView:(UIView*)view;

/*!
 @method setZoneDisplayMode
 @discussion 
 Set DisplayMode of available zones in the map.
 Surface will highlight the zones with the given display mode.
 
 @param zoneDisplayMode
 Default value: IndoorsSurfaceZoneDisplayModeNone
 
 IndoorsSurfaceZoneDisplayModeUserCurrentLocation: Only display user's current zone
 IndoorsSurfaceZoneDisplayModeAllAvailable: Display all zones
 IndoorsSurfaceZoneDisplayModeNone: Will not display any zone
 */
- (void)setZoneDisplayMode:(IndoorsSurfaceZoneDisplayModes)zoneDisplayMode;
- (void)setUserPositionDisplayMode:(IndoorsSurfaceUserPositionDisplayModes)userPositionMode;
- (void)setUserPositionIcon:(UIImage*)userPositionIcon;
- (void)registerForSurfaceLocationUpdates:(id<IndoorsSurfaceLocationDelegate>)locationDelegate;
- (void)registerForSurfaceServiceUpdates:(id<IndoorsSurfaceServiceDelegate>)surfaceServiceDelegate;
- (void)showPathWithPoints:(NSArray*)points;
- (void)hideAccuracyView:(BOOL)shouldHideAccuracy;
- (void)build;

@property (nonatomic, strong) id<LoadingBuildingDelegate> loadingBuildingCallBack;

@end
