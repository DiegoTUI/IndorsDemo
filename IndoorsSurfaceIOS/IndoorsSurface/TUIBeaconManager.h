//
//  TUIBeaconManager.h
//  IndoorsSurface
//
//  Created by Diego Lafuente on 25/06/14.
//  Copyright (c) 2014 Indoors GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Indoors/IDSCoordinate.h>

@interface TUIBeaconManager : NSObject

- (void)feedWithBeacons:(NSArray *)clbeacons;

- (IDSCoordinate *)userLocation;

@end
