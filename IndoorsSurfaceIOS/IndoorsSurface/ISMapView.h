//
//  IVMapView.h
//  iViewer
//
//  Created by Mina Haleem on 24.03.13.
//  Copyright (c) 2013 Mina Haleem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Indoors/Indoors.h>
#import "ISZoneAnnotation.h"

@interface ISMapView : UIView

@property (nonatomic, strong) IDSDefaultMap *map;
@property (nonatomic, assign) BOOL showsGrid;
@property (nonatomic, assign) int zoomLevel;
@property (nonatomic, retain) ISZoneAnnotation* zoneAnnotation;

- (id)initWithMap:(IDSDefaultMap *)map andZoom:(int)zoomLevel;
- (void)setRoutingPath:(NSArray*)path;
- (void)clearRouting;
- (void)showZones:(NSMutableArray*)zones;
- (void)hideAllZones;

/// Point in mapView coordinate system
- (IDSCoordinate *)coordinateAtPoint:(CGPoint)point;
/// Point in mapView coordinate system
- (CGPoint)pointAtCoordinate:(IDSCoordinate *)coordinate;

@end
