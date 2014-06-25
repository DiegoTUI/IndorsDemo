//
//  IVMapScrollView.h
//  iViewer
//
//  Created by Mina Haleem on 24.03.13.
//  Copyright (c) 2013 Mina Haleem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Indoors/IDSCoordinate.h>
#import <Indoors/IDSDefaultMap.h>
#import "ISAnnotationView.h"
#import "IndoorsSurfaceEnums.h"

@class ISMapScrollView;

@protocol ISMapScrollViewDelegate <NSObject>
- (void)mapScrollView:(ISMapScrollView*)mapScrollView userDidSelectLocation:(IDSCoordinate*)location;
@end

@interface ISMapScrollView : UIScrollView <UIScrollViewDelegate>

@property (nonatomic, strong) IDSDefaultMap *map;
@property (nonatomic,strong) id<ISMapScrollViewDelegate> routingDelegate;
@property (nonatomic,strong) NSArray* currentRoutingPath;
@property (nonatomic,strong) IDSCoordinate* userCurrentLocation;
@property (nonatomic) int userCurrentFloorLevel;

- (void)enableRoutingFature:(BOOL)enabled;
- (void)letUserSelectLocationFromMap;
- (void)setRoutingPath:(NSArray*)path;
- (void)clearRouting;

- (void)setUserFloorLevel:(int)userFloorLevel;
- (void)setUserPosition:(IDSCoordinate*)coordinate;
- (void)setUserOrientation:(float)orientation;
- (void)setUserLocationHidden:(BOOL)isHidden;
- (void)setMapCenterWithCoordinate:(IDSCoordinate*)coordinate;
- (void)showUserLocation;

- (void)addAnnotation:(ISAnnotationView *)annotationView;
- (void)removeAnnotation:(ISAnnotationView *)annotationView;
- (void)moveAnnotation:(ISAnnotationView *)annotation toCoordinate:(IDSCoordinate *)coordinate;
- (void)setZoneDisplayMode:(IndoorsSurfaceZoneDisplayModes)zoneDisplayMode;
- (void)setUserPositionDisplayMode:(IndoorsSurfaceUserPositionDisplayModes)userPositionDisplayMode;
- (void)setUserPositionIcon:(UIImage*)userPositionIcon;
- (void)didReceiveWeakSignal;
- (void)zonesEntered:(NSArray *)zones;

- (IDSCoordinate*)coordinateForPoint:(CGPoint)point;
- (CGPoint)pointForCoordinate:(IDSCoordinate*) coordinate;
@end
