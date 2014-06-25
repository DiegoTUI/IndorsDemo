//
//  TUICircle.m
//  Rooms
//
//  Created by Diego Lafuente on 29/05/14.
//  Copyright (c) 2014 Tui Travel A&D. All rights reserved.
//

#import "TUICircle.h"

#pragma mark - Private interface

@interface TUICircle ()

@end


#pragma mark - Implementation

@implementation TUICircle


#pragma mark - Init

- (TUICircle *)initWithCenter:(CGPoint)center
                    andRadius:(CGFloat)radius
{
    self = [super init];
    if (self)
    {
        _center = center;
        _radius = radius;
    }
    return self;
}

@end
