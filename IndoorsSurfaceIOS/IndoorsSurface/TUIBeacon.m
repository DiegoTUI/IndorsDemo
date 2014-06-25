//
//  TUIBeacon.m
//  IndoorsSurface
//
//  Created by Diego Lafuente on 25/06/14.
//  Copyright (c) 2014 Indoors GmbH. All rights reserved.
//

#import "TUIBeacon.h"

#define MAX_COUNT   2

@implementation TUIBeacon

- (TUIBeacon *)init
{
    self = [super init];
    
    if (self)
    {
        _minor = nil;
        _accuracy = -1.0;
        _count = 0;
        _check = false;
    }
    
    return self;
}

- (BOOL)feedWithAccuracy:(CLLocationAccuracy)accuracy
{
    _check = true;
    if (accuracy > -1.0) //valid accuracy
    {
        _accuracy = accuracy;
        _count = 0;
        return false;
    }
    // invalid accuracy 
    _count++;
    if (_count >= MAX_COUNT)
    {
        return true;
    }
    return false;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@: %d", _minor, _accuracy];
}

@end
