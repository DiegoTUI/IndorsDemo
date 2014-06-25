//
//  TUIBeaconsPlan.h
//  IndoorsSurface
//
//  Created by Diego Lafuente on 24/06/14.
//  Copyright (c) 2014 Indoors GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TUIBeaconsPlan : NSObject

+ (TUIBeaconsPlan *)sharedInstance;

- (CGPoint)locationForBeacon:(NSString *)minor;

@end
