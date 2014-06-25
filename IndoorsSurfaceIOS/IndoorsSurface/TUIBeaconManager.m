//
//  TUIBeaconManager.m
//  IndoorsSurface
//
//  Created by Diego Lafuente on 25/06/14.
//  Copyright (c) 2014 Indoors GmbH. All rights reserved.
//

#import "TUIBeaconManager.h"
#import "TUIBeacon.h"
#import "TUIBeaconsPlan.h"

@interface TUIBeaconManager ()

@property (strong, nonatomic) NSMutableArray *beacons;

@end

@implementation TUIBeaconManager

- (TUIBeaconManager *)init
{
    self = [super init];
    
    if (self)
    {
        _beacons = [NSMutableArray array];
    }
    
    return self;
}

- (void)feedWithBeacons:(NSArray *)clbeacons
{
    // go through the CLBeacons in the Array
    for (CLBeacon *clbeacon in clbeacons)
    {
        TUIBeacon *beacon = [self beaconForCLBeacon:clbeacon];
         // if the beacon is in the array, feed it
        if (beacon)
        {
            BOOL shouldRemove = [beacon feedWithAccuracy:clbeacon.accuracy];
            if (shouldRemove)
            {
                [_beacons removeObject:beacon];
            }
        }
        else if (clbeacon.accuracy > -1.0)//add the beacon to the array
        {
            beacon = [[TUIBeacon alloc] init];
            beacon.minor = clbeacon.minor;
            [beacon feedWithAccuracy:clbeacon.accuracy];
            [_beacons addObject:beacon];
        }
    }
    // purge beacons
    NSMutableIndexSet *discardedBeacons = [NSMutableIndexSet indexSet];
    NSUInteger index = 0;
    
    for (TUIBeacon *beacon in _beacons) {
        if (beacon.check)
        {
            beacon.check = false;
        }
        else
        {
            [discardedBeacons addIndex:index];
        }
        index++;
    }
    [_beacons removeObjectsAtIndexes:discardedBeacons];
}

- (IDSCoordinate *)userLocation
{
    // return nil if the array is empty
    if (_beacons.count == 0)
    {
        return nil;
    }
    // return the beacon's location if there is only one beacon
    if (_beacons.count == 1)
    {
        CGPoint beaconLocation = [[TUIBeaconsPlan sharedInstance] locationForBeacon:[[(TUIBeacon *)_beacons[0] minor] stringValue]];
        return [[IDSCoordinate alloc] initWithX:beaconLocation.x andY:beaconLocation.y andFloorLevel:5];
    }
    // More than one beacon. Sort them
    NSArray *sortedBeacons = [_beacons sortedArrayUsingComparator:^NSComparisonResult(TUIBeacon *a, TUIBeacon *b) {
        if (a.accuracy > b.accuracy)
        {
            return NSOrderedAscending;
        }
        return NSOrderedDescending;
    }];
    
    CLProximity accuracy1 = [(TUIBeacon *)sortedBeacons[0] accuracy];
    CLProximity accuracy2 = [(TUIBeacon *)sortedBeacons[1] accuracy];
    
    CGPoint beaconLocation1 = [[TUIBeaconsPlan sharedInstance] locationForBeacon:[[(CLBeacon *)sortedBeacons[0] minor] stringValue]];
    CGPoint beaconLocation2 = [[TUIBeaconsPlan sharedInstance] locationForBeacon:[[(CLBeacon *)sortedBeacons[1] minor] stringValue]];
    
    NSInteger x = ((accuracy1 * beaconLocation2.x) + (accuracy2 * beaconLocation1.x)) / (accuracy1 + accuracy2);
    NSInteger y = ((accuracy1 * beaconLocation2.y) + (accuracy2 * beaconLocation1.y)) / (accuracy1 + accuracy2);
    
    return [[IDSCoordinate alloc] initWithX:x andY:y andFloorLevel:5];
}

- (TUIBeacon *)beaconForCLBeacon:(CLBeacon *)clbeacon
{
    for (TUIBeacon *beacon in _beacons)
    {
        if ([beacon.minor compare:clbeacon.minor] == NSOrderedSame)
        {
            return beacon;
        }
    }
    // CLBeacon not found. Return nil.
    return nil;
}

@end
