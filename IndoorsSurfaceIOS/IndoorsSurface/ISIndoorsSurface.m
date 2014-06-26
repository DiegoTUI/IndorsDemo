//
//  IndoorsSurfaceView.m
//  IndoorsSurface
//
//  Created by Mina Haleem on 25.07.13.
//  Copyright (c) 2013 Indoors GmbH. All rights reserved.
//

#import "ISIndoorsSurface.h"
#import "ISMapScrollView.h"
#import "IndoorsSurfaceLocationManager.h"
#import <Indoors/IDSFloor.h>
#import <CoreLocation/CoreLocation.h>
#import "TUIBeaconsPlan.h"
#import "TUIBeaconManager.h"

@interface ISIndoorsSurface() <ISMapScrollViewDelegate, IndoorsSurfaceLocationManagerDelegate, CLLocationManagerDelegate>
@property (nonatomic, strong) ISMapScrollView* mapScrollView;
@property (nonatomic, strong) IDSBuilding* building;
@property (nonatomic, strong) IndoorsSurfaceLocationManager* locationManager;

@property (nonatomic) IndoorsSurfaceUserPositionDisplayModes surfaceUserPositionDisplayMode;
@property (nonatomic) BOOL shouldHideAccurcyView;

@property (nonatomic) NSArray *routingPath;

// Beacons
@property (strong, nonatomic) CLBeaconRegion *beaconRegion;
@property (strong, nonatomic) CLLocationManager *beaconLocationManager;

@property (strong, nonatomic) TUIBeaconManager *beaconManager;

@end

@implementation ISIndoorsSurface
@synthesize mapScrollView;
@synthesize locationManager;
@synthesize delegate;
@synthesize building;
@synthesize surfaceUserPositionDisplayMode;
@synthesize enableAutomaticFloorSelection;
@synthesize shouldHideAccurcyView;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
        _beaconManager = [[TUIBeaconManager alloc] init];
    }
    return self;
}

#pragma mark - Public
- (void)setZoneDisplayMode:(IndoorsSurfaceZoneDisplayModes)zoneDisplayMode {
    if (self.mapScrollView) {
        [self.mapScrollView setZoneDisplayMode:zoneDisplayMode];
    }
}

- (void)setUserPositionDisplayMode:(IndoorsSurfaceUserPositionDisplayModes)userPositionDisplayMode {
    self.surfaceUserPositionDisplayMode = userPositionDisplayMode;
    if (self.mapScrollView) {
        [self.mapScrollView setUserPositionDisplayMode:userPositionDisplayMode];
    }
}

- (void)setUserPositionIcon:(UIImage*)userPositionIcon {
    if (self.mapScrollView) {
        [self.mapScrollView setUserPositionIcon:userPositionIcon];
    }
}

- (void)setFloorLevel:(int)floorLevel {
    if (floorLevel != INT_MAX) {
        if (self.delegate) {
            [self.mapScrollView enableRoutingFature:YES];
        }
        
        IDSFloor* floor = [building floorAtLevel:floorLevel];
        if (floor && floor.defaultMap) {
            [self.mapScrollView setMap:floor.defaultMap];
        }
    }
}

- (void)setBuildingForSurface:(IDSBuilding*)surfaceBuilding {
    self.building = surfaceBuilding;
    
    [self.mapScrollView setUserLocationHidden:YES];
    self.mapScrollView.currentRoutingPath = nil;
    
    [self startLocationService];
    [self setupLocationManager];
}

- (void)setSize:(CGRect)newFrame {
    self.frame = newFrame;
    [self.mapScrollView preserveViewportDuringRotation:^{
        
    }];
}

- (void)showPathWithPoints:(NSArray*)points {
    self.routingPath = points;
    if (points == nil) {
        [self.mapScrollView clearRouting];
    } else {
        [self.mapScrollView setRoutingPath:points];
    }
}

- (void)letUserSelectLocation {
    [self.mapScrollView letUserSelectLocationFromMap];
}

- (void)hideAccuracy:(BOOL)shouldHideAccuracy {
    self.shouldHideAccurcyView = shouldHideAccuracy;
}

- (BOOL)hasActiveBuilding {
    if (self.mapScrollView) {
        if (self.mapScrollView.map) {
            return YES;
        }
    }
    
    return NO;
}

- (void)setMapCenterWithCoordinate:(IDSCoordinate*)coordinate {
    [self.mapScrollView setMapCenterWithCoordinate:coordinate];
}

#pragma mark - Private

- (void)startLocationService {
    if (!self.locationManager || self.locationManager == nil) {
        self.locationManager = [[IndoorsSurfaceLocationManager alloc]init];
        self.locationManager.delegate = self;
    }
}

#pragma mark - Location setup

- (void)setupLocationManager {
    _beaconLocationManager = [[CLLocationManager alloc] init];
    _beaconLocationManager.delegate = self;
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D"];
    _beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid major:11211 identifier:@"demoRegion"];
    
    [_beaconLocationManager startRangingBeaconsInRegion:_beaconRegion];
    
}

#pragma mark - UI Setup

- (void)setupView {
    self.backgroundColor = [UIColor whiteColor];
    [self addMapScrollView];
}

- (void)addMapScrollView {
    self.mapScrollView = [[ISMapScrollView alloc] initWithFrame:self.bounds];
    self.mapScrollView.routingDelegate  = self;
    self.mapScrollView.clipsToBounds = YES;
    
    self.mapScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:self.mapScrollView];
}

#pragma mark - ISMapScrollViewDelegate
- (void)mapScrollView:(ISMapScrollView*)mapScrollView userDidSelectLocation:(IDSCoordinate*)location {
    if (delegate && [delegate respondsToSelector:@selector(indoorsSurface:userDidSelectLocationToStartRouting:userCurrentLocation:)]) {
        IDSCoordinate* userCurrentLocation = nil;
        
        if (self.mapScrollView) {
            if (self.mapScrollView.userCurrentLocation) {
                userCurrentLocation = self.mapScrollView.userCurrentLocation;
            }
        }
        
        [delegate indoorsSurface:self userDidSelectLocationToStartRouting:location userCurrentLocation:userCurrentLocation];
    }
}

#pragma mark - IndoorsSurfaceLocationManagerDelegate
- (void)indoorsSurfaceLocationManager:(IndoorsSurfaceLocationManager*)mananger updateFloorLevel:(int)floorLevel name:(NSString*)name {
    if (self.enableAutomaticFloorSelection) {
        if (self.mapScrollView.userCurrentFloorLevel != floorLevel) {
            [self.mapScrollView setUserCurrentFloorLevel:floorLevel];
        }
        if (floorLevel != self.mapScrollView.map.floor.level) {
            [self setFloorLevel:floorLevel];
        }
    }
}

- (void)indoorsSurfaceLocationManager:(IndoorsSurfaceLocationManager*)mananger updateUserPosition:(IDSCoordinate*)userPosition {
    
    //[self updateUserPosition:userPosition];
}

- (void)indoorsSurfaceLocationManager:(IndoorsSurfaceLocationManager*)mananger updateUserOrientation:(float)orientation {
    [self.mapScrollView setUserOrientation:orientation];
}

- (void)weakSignalInIndoorsSurfaceLocationManager:(IndoorsSurfaceLocationManager *)mananger
{
    [self.mapScrollView didReceiveWeakSignal];
}

- (void)updateUserPosition:(IDSCoordinate*)userPosition
{
    if (self.shouldHideAccurcyView) {
        userPosition.accuracy = 0;
    }
    
    BOOL isInitialLocationUpdates = self.mapScrollView.userCurrentLocation.x == 0 && self.mapScrollView.userCurrentLocation.y == 0 ? YES : NO;
    
    if (self.routeSnappingEnabled && [self.routingPath count]) {
        // Snap to route
        IDSCoordinate *snappedPosition = [[Indoors instance] snapPosition:userPosition toRoute:self.routingPath];
        //            NSLog(@"Original pos: %d, %d, %d", userPosition.x, userPosition.y, userPosition.z);
        //            NSLog(@"Snapped  pos: %d, %d, %d", snappedPosition.x, snappedPosition.y, snappedPosition.z);
        NSLog(@"updated user position ROUTE - x: %d - y: %d", userPosition.x, userPosition.y);
        [self.mapScrollView setUserPosition:snappedPosition];
    } else {
        NSLog(@"updated user position - x: %d - y: %d", userPosition.x, userPosition.y);
        [self.mapScrollView setUserPosition:userPosition];
        [self.mapScrollView setMapCenterWithCoordinate:userPosition];
    }
    
    if (isInitialLocationUpdates) {
        [self.mapScrollView showUserLocation];
    }
}

#pragma mark - CLLocationManagerDelegate methods -

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    [_beaconLocationManager startRangingBeaconsInRegion:_beaconRegion];
    NSLog(@"Entered region");
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    [_beaconLocationManager stopRangingBeaconsInRegion:_beaconRegion];
    NSLog(@"Exited region");
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    NSLog(@"did range beacons: %lu", (unsigned long)beacons.count);
    NSLog(@"%@", beacons);
    
    [_beaconManager feedWithBeacons:beacons];
    
    [self updateUserPosition:[_beaconManager userLocation]];
}

@end
