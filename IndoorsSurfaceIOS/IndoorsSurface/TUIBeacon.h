//
//  TUIBeacon.h
//  IndoorsSurface
//
//  Created by Diego Lafuente on 25/06/14.
//  Copyright (c) 2014 Indoors GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface TUIBeacon : NSObject

@property (strong, nonatomic) NSNumber *minor;

@property (nonatomic) CLProximity accuracy;

@property (nonatomic) NSInteger count;

@property (nonatomic) BOOL check;


- (BOOL)feedWithAccuracy:(CLProximity)accuracy;

@end
