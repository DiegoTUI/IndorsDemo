//
//  IndoorsServiceCallbackImp.m
//  IndoorsSurface
//
//  Created by Mina Haleem on 10.08.13.
//  Copyright (c) 2013 Indoors GmbH. All rights reserved.
//

#import "IndoorsServiceCallbackImp.h"

@interface IndoorsServiceCallbackImp()
@property (nonatomic, strong) ISIndoorsSurface* indoorsSurface;
@property (nonatomic) BOOL isBuildingLoaded;
@end

@implementation IndoorsServiceCallbackImp
@synthesize indoorsSurface;
@synthesize isBuildingLoaded;
@synthesize loadingBuildingServiceCallBack;

- (id)initWithSurface:(ISIndoorsSurface*) surface {
    self = [super init];
    
    if (self) {
        self.indoorsSurface = surface;
    }
    
    return self;
}

#pragma mark - Building Protocol

- (void)buildingLoaded:(IDSBuilding*)loadedBuilding {
    self.isBuildingLoaded = YES;
    [self performSelectorOnMainThread:@selector(loadBuildingInSurface:) withObject:loadedBuilding waitUntilDone:YES];
    
    if (self.loadingBuildingServiceCallBack) {
        [self.loadingBuildingServiceCallBack buildingLoaded:loadedBuilding];
    }
}

- (void)loadingBuilding:(NSNumber*)progress {
    if (!self.isBuildingLoaded) {
        if (self.loadingBuildingServiceCallBack) {
            [self.loadingBuildingServiceCallBack loadingBuilding:progress];
        }
    }
}

- (void)loadingBuildingFailed {
    if (self.loadingBuildingServiceCallBack) {
        [self.loadingBuildingServiceCallBack loadingBuildingFailed];
    }
}

#pragma mark - Private
- (void)loadBuildingInSurface:(IDSBuilding*)building {
    
    int initialFloorLevel = [building getInitialFloorLevel];
    
    if (initialFloorLevel != INT_MAX) {
        [self.indoorsSurface setBuildingForSurface:building];
        self.indoorsSurface.enableAutomaticFloorSelection = YES;
        [self.indoorsSurface setFloorLevel:initialFloorLevel];
    }
}
@end
