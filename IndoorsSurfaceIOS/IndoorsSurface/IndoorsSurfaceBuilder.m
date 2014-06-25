//
//  IndoorsSurfaceBuilder.m
//  IndoorsSurface
//
//  Created by Mina Haleem on 10.08.13.
//  Copyright (c) 2013 Indoors GmbH. All rights reserved.
//

#import "IndoorsSurfaceBuilder.h"
#import "IndoorsServiceCallbackImp.h"
#import "IndoorsSurfaceLocationManager.h"
#import "ISIndoorsSurface.h"

@interface IndoorsSurfaceBuilder() <IndoorsSurfaceLocationManagerDelegate>
@property (nonatomic, strong) IndoorsBuilder* _indoorsBuilder;
@property (nonatomic, strong) ISIndoorsSurface* indoorsSurface;
@property (nonatomic, strong) UIView* parentView;
@property (nonatomic, strong) IndoorsSurfaceLocationManager* locationManager;
@property (nonatomic, strong) id<IndoorsSurfaceServiceDelegate> surfaceServicedelegate;
@property (nonatomic, strong) id<IndoorsSurfaceLocationDelegate> surfaceLocationlegate;
@end

@implementation IndoorsSurfaceBuilder
@synthesize _indoorsBuilder;
@synthesize indoorsSurface;
@synthesize parentView;
@synthesize surfaceServicedelegate;
@synthesize locationManager;
@synthesize surfaceLocationlegate;

- (id)initWithIndoorsBuilder:(IndoorsBuilder*)indoorsBuilder inView:(UIView*)view {
    self = [super init];
    
    if (self) {
        self._indoorsBuilder = indoorsBuilder;
        self.parentView = view;
        self.indoorsSurface = [[ISIndoorsSurface alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
        [self.indoorsSurface setZoneDisplayMode:IndoorsSurfaceZoneDisplayModeNone];
        [self.indoorsSurface setUserPositionDisplayMode:IndoorsSurfaceUserPositionDisplayModeDefault];
    }
    
    return self;
}

- (void)registerForSurfaceLocationUpdates:(id<IndoorsSurfaceLocationDelegate>)locationDelegate {
    self.surfaceLocationlegate = locationDelegate;
    self.locationManager = [[IndoorsSurfaceLocationManager alloc] init];
    self.locationManager.delegate  = self;
}

- (void)registerForSurfaceServiceUpdates:(id<IndoorsSurfaceServiceDelegate>)sDelegate {
    self.surfaceServicedelegate = sDelegate;
    self._indoorsBuilder.authenticationServiceCallBack = self.surfaceServicedelegate;
}

- (void)setZoneDisplayMode:(IndoorsSurfaceZoneDisplayModes)zoneDisplayMode {
    [self.indoorsSurface setZoneDisplayMode:zoneDisplayMode];
}

- (void)hideAccuracyView:(BOOL)shouldHideAccuracy {
    [self.indoorsSurface hideAccuracy:shouldHideAccuracy];
}

- (void)setUserPositionDisplayMode:(IndoorsSurfaceUserPositionDisplayModes)userPositionMode {
    [self.indoorsSurface setUserPositionDisplayMode:userPositionMode];
}

- (void)setUserPositionIcon:(UIImage*)userPositionIcon {
    [self setUserPositionDisplayMode:IndoorsSurfaceUserPositionDisplayModeCustom];
    [self.indoorsSurface setUserPositionIcon:userPositionIcon];
}

- (void)showPathWithPoints:(NSArray*)points {
    [self.indoorsSurface showPathWithPoints:points];
}

- (void)build {
    IndoorsServiceCallbackImp* serviceCallback = [[IndoorsServiceCallbackImp alloc] initWithSurface:indoorsSurface];
    serviceCallback.loadingBuildingServiceCallBack = self.surfaceServicedelegate;
    self._indoorsBuilder.loadingBuildingServiceCallBack = serviceCallback;
    [self._indoorsBuilder build];
    
    [self.parentView addSubview:self.indoorsSurface];
}

#pragma mark - IndoorsSurfaceLocatoinManagerDelegate
- (void)indoorsSurfaceLocationManager:(IndoorsSurfaceLocationManager*)manager updateFloorLevel:(int)floorLevel name:(NSString*)name {
    if (self.surfaceLocationlegate) {
        [self.surfaceLocationlegate updateFloorLevel:floorLevel name:name];
    }
}

- (void)indoorsSurfaceLocationManager:(IndoorsSurfaceLocationManager*)manager updateUserPosition:(IDSCoordinate*)userPosition {
    if (self.surfaceLocationlegate) {
        [self.surfaceLocationlegate updateUserPosition:userPosition];
    }
}

- (void)indoorsSurfaceLocationManager:(IndoorsSurfaceLocationManager*)manager updateUserOrientation:(float)orientation {
    if (self.surfaceLocationlegate) {
        [self.surfaceLocationlegate updateUserOrientation:orientation];
    }
}

- (void)weakSignalInIndoorsSurfaceLocationManager:(IndoorsSurfaceLocationManager *)manager {
    if (self.surfaceLocationlegate) {
        [self.surfaceLocationlegate weakSignal];
    }
}
@end
