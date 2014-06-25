//
//  TUI2DCartesianCoordinatesSystem.h
//  Rooms
//
//  Created by Diego Lafuente on 29/05/14.
//  Copyright (c) 2014 Tui Travel A&D. All rights reserved.
//

#import "TUIBaseModel.h"

/**
 TUICircle is the model of a 2D Cartesian Coordinates System defined 
 by its position and rotation with respect to an "absolute" system 
 (one located at (0,0) and with rotation 0)
 */
@interface TUI2DCartesianCoordinatesSystem : TUIBaseModel

/**
 The origin of the coordinates system referred to the "absolute" system.
 */
@property (nonatomic, assign) CGPoint origin;

/**
 The rotation of the coordinates system (in radians) referred to the "absolute" system.
 */
@property (nonatomic, assign) CGFloat rotation;

/**
 @methodName initWithOrigin:andRotation:
 @abstract Creates a 2D Cartesian Coordinates system with a given origin and rotation
 @discussion This method will initalize a a 2D Cartesian Coordinates system with a given origin and rotation
 
 @param origin The origin of the 2D Cartesian system referred to the "absolute" system
 @param rotation The rotation (in radians) of the 2D Cartesian system referred to the "absolute" system
 
 @return The initialized 2D Cartesian Coordinates system
 */
- (TUI2DCartesianCoordinatesSystem *)initWithOrigin:(CGPoint)origin
                                        andRotation:(CGFloat)rotation NS_REQUIRES_SUPER;

@end
