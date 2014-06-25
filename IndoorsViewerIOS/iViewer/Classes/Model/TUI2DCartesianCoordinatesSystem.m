//
//  TUI2DCartesianCoordinatesSystem.m
//  Rooms
//
//  Created by Diego Lafuente on 29/05/14.
//  Copyright (c) 2014 Tui Travel A&D. All rights reserved.
//

#import "TUI2DCartesianCoordinatesSystem.h"


#pragma mark - Implementation

@implementation TUI2DCartesianCoordinatesSystem


#pragma mark - Init

- (TUI2DCartesianCoordinatesSystem *)initWithOrigin:(CGPoint)origin
                                        andRotation:(CGFloat)rotation
{
    self = [super init];
    if (self)
    {
        _origin = origin;
        _rotation = rotation;
    }
    return self;
}

@end
