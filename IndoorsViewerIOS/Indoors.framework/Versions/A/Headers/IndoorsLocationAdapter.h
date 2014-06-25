//
//  IndoorsLocationAdapter.h
//  Indoors
//
//  Created by Gerhard Zeissl on 02.12.12.
//  Copyright (c) 2012 Indoors. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IndoorsLocationListener.h"
#import "IDSBuilding.h"
#import "IDSCoordinate.h"

@class IndoorsException;
@interface IndoorsLocationAdapter : NSObject <IndoorsLocationListener>

@property (nonatomic,strong) id<IndoorsLocationListener> locationListener;
- (id)init;
- (id)initWithIndoorsLocationListener:(id<IndoorsLocationListener>)locationListener;
- (void)onError:(IndoorsException*)indoorsException;
- (void)loadingBuilding:(int)progress;
- (void)buildingLoaded:(IDSBuilding*)building;
- (void)leftBuilding:(IDSBuilding*) building;
- (void)positionUpdated:(IDSCoordinate*)c andAccuracy:(int)accuracy;
- (void)orientationUpdated:(float)orientation;
- (void)changedFloor:(int)floorLevel withName:(NSString*)name;
- (void)candidateSpread:(NSArray*)spreadCoordinates;
@end
