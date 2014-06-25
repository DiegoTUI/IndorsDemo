//
//  IVSurfaceViewController.m
//  iViewer
//
//  Created by Mina Haleem on 11.08.13.
//  Copyright (c) 2013 Mina Haleem. All rights reserved.
//

#import "IVSurfaceViewController.h"
#import <Indoors/IndoorsBuilder.h>
#import <IndoorsSurface/IndoorsSurfaceBuilder.h>
#import <IndoorsSurface/IndoorsSurfaceDelegates.h>
#import "MBProgressHUD.h"

@interface IVSurfaceViewController () <IndoorsSurfaceLocationDelegate, IndoorsSurfaceServiceDelegate>
@property (nonatomic, strong) IndoorsSurfaceBuilder* surfaceBuilder;
@property (nonatomic, strong) MBProgressHUD* progressHUD;
@end

@implementation IVSurfaceViewController
@synthesize surfaceBuilder;

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    
    IndoorsBuilder* builder = [[IndoorsBuilder alloc] init];
    [builder setApiKey:@"84a77655-fc9c-44a5-a299-a1635f5d525a"];
    [builder setBuildingId:108712520];
    
    surfaceBuilder = [[IndoorsSurfaceBuilder alloc] initWithIndoorsBuilder:builder inView:self.view];
    [surfaceBuilder setZoneDisplayMode:IndoorsSurfaceZoneDisplayModeAllAvailable];
    [surfaceBuilder registerForSurfaceServiceUpdates:self];
    //User can set UserPositionDisplayMode to NONE to hide the user position & Accuracy
    [surfaceBuilder setUserPositionDisplayMode:IndoorsSurfaceUserPositionDisplayModeNone];
    
    //If user set icon for userPosition, UserPositionDislayMode set to custom by default
    //[surfaceBuilder setUserPositionIcon:[UIImage imageNamed:@"location-green"]];
    
    [surfaceBuilder build];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Service Delegate
- (void)connected {
    if (self.progressHUD) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
    
    [surfaceBuilder registerForSurfaceLocationUpdates:self];
}

- (void) onError:(IndoorsError*) indoorsError {
}

- (void)loadingBuilding:(NSNumber*)progress {
    if (!self.progressHUD) {
        self.progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.progressHUD hideCancelOption];
    }

    if ([progress intValue] == 100) {
        self.progressHUD.labelText = NSLocalizedString(@"Loading Map...", @"");
    } else {
        NSString* progressMessage = NSLocalizedString(@"Downloading %d%%", @"Downloading %d%%");
        progressMessage = [NSString stringWithFormat:progressMessage, progress];
        self.progressHUD.labelText = progressMessage;
    }
}

- (void)buildingLoaded:(IDSBuilding*)building {
}

- (void)loadingBuildingFailed {
}

#pragma mark - IndoorsSurfaceLocationManagerDelegate
- (void)updateFloorLevel:(int)floorLevel name:(NSString*)name {
}

- (void)updateUserPosition:(IDSCoordinate*)userPosition {
}

- (void)updateUserOrientation:(float)orientation {
}

- (void)weakSignal {
    ;
}
@end
