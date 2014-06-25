//
//  IndoorsSurfaceLocationManager.m
//  iViewer
//
//  Created by Mina Haleem on 26.07.13.
//  Copyright (c) 2013 Mina Haleem. All rights reserved.
//

#import "IndoorsSurfaceLocationManager.h"
#import <Indoors/Indoors.h>

@implementation IndoorsSurfaceLocationManager
@synthesize delegate;

- (id)init {
    self = [super init];
    
    if (self) {
        [self performSelectorInBackground:@selector(registerListener) withObject:nil];
    }
    
    return self;
}

#pragma mark - Private
- (void)registerListener {
    [[NSThread currentThread] setName:@"Register listener"];
    [[Indoors instance] registerLocationListener:self];
}

#pragma mark - Public

- (void)positionUpdated:(IDSCoordinate*)c
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(indoorsSurfaceLocationManager:updateUserPosition:)])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate indoorsSurfaceLocationManager:self updateUserPosition:c];
        });
    }
}

- (void)weakSignal
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(weakSignalInIndoorsSurfaceLocationManager:)])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate weakSignalInIndoorsSurfaceLocationManager:self];
        });
    }
}

- (void)changedFloor:(int)floorLevel withName:(NSString*)name
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(indoorsSurfaceLocationManager:updateFloorLevel:name:)])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate indoorsSurfaceLocationManager:self updateFloorLevel:floorLevel name:name];
        });
    }
}

- (void)orientationUpdated:(float)orientation {
    if (self.delegate && [self.delegate respondsToSelector:@selector(indoorsSurfaceLocationManager:updateUserOrientation:)])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate indoorsSurfaceLocationManager:self updateUserOrientation:orientation];
        });
    }
}
@end
