//
//  IndoorsSurfaceLocationManager.h
//  iViewer
//
//  Created by Mina Haleem on 26.07.13.
//  Copyright (c) 2013 Mina Haleem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Indoors/IDSCoordinate.h>
#import <Indoors/IndoorsLocationAdapter.h>

@class IndoorsSurfaceLocationManager;

@protocol IndoorsSurfaceLocationManagerDelegate <NSObject>
@optional
- (void)indoorsSurfaceLocationManager:(IndoorsSurfaceLocationManager *)manager updateFloorLevel:(int)floorLevel name:(NSString *)name;
- (void)indoorsSurfaceLocationManager:(IndoorsSurfaceLocationManager *)manager updateUserPosition:(IDSCoordinate *)userPosition;
- (void)indoorsSurfaceLocationManager:(IndoorsSurfaceLocationManager *)manager updateUserOrientation:(float)orientation;
- (void)weakSignalInIndoorsSurfaceLocationManager:(IndoorsSurfaceLocationManager *)manager;
- (void)indoorsSurfaceLocationManager:(IndoorsSurfaceLocationManager *)manager zonesEntered:(NSArray *)zones;
@end

@interface IndoorsSurfaceLocationManager : IndoorsLocationAdapter
@property (nonatomic,strong) id<IndoorsSurfaceLocationManagerDelegate> delegate;
@end
