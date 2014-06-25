//
//  TUIGeometry.m
//  Rooms
//
//  Created by Diego Lafuente on 29/05/14.
//  Copyright (c) 2014 Tui Travel A&D. All rights reserved.
//

#import "TUIGeometry.h"

#pragma mark - Implementation

@implementation TUIGeometry

+ (CGFloat)distanceBetweenPoint:(CGPoint)firstPoint
                       andPoint:(CGPoint)secondPoint
{
    CGFloat xDistance = secondPoint.x - firstPoint.x;
    CGFloat yDistance = secondPoint.y - firstPoint.y;
    return sqrt((xDistance * xDistance) + (yDistance * yDistance));
}

+ (CGFloat)angleBetweenVector:(CGPoint)firstVector
                    andVector:(CGPoint)secondVector
{
    //return zero if any of the vectors is zero
    if ((firstVector.x == ZERO_FLOAT && firstVector.y == ZERO_FLOAT) || (secondVector.x == ZERO_FLOAT && secondVector.y == ZERO_FLOAT))
    {
        return ZERO_FLOAT;
    }
    CGFloat result = atan2(secondVector.y, secondVector.x) - atan2(firstVector.y, firstVector.x);
    // correct the angle
    while (result < ZERO_FLOAT)
    {
        result += TWO_PI;
    }
    while (result > TWO_PI)
    {
        result -= TWO_PI;
    }
    
    return result;
}

+ (CGFloat)angleWithTheXAxisAndLineDefinedByPoint:(CGPoint)firstPoint
                                         andPoint:(CGPoint)secondPoint
{
    CGPoint vector = CGPointMake(secondPoint.x - firstPoint.x, secondPoint.y - firstPoint.y);
    CGPoint i = CGPointMake(ONE_FLOAT, ZERO_FLOAT);
    
    return [TUIGeometry angleBetweenVector:i andVector:vector];
}

+ (CGPoint)absoluteCoordinatesOfPoint:(CGPoint)point
              givenInCoordinateSystem:(TUI2DCartesianCoordinatesSystem *)coordinateSystem
{
    CGFloat sinAlpha = sin(coordinateSystem.rotation);
    CGFloat cosAlpha = cos(coordinateSystem.rotation);
    
    return CGPointMake((coordinateSystem.origin.x + (point.x * cosAlpha) - (point.y * sinAlpha)),
                       (coordinateSystem.origin.y + (point.x * sinAlpha) + (point.y * cosAlpha)));
}

+ (NSArray *)intersectionOfCircle:(TUICircle *)firstCircle
                        andCircle:(TUICircle *)secondCircle
{
    NSArray *relativeIntersectionPoints = nil;
    CGFloat distance = [TUIGeometry distanceBetweenPoint:firstCircle.center andPoint:secondCircle.center];
    
    // if the distance is zero or higher that firstCircle.radius + secondCircle.radius, then return an empy array
    if (distance == ZERO_FLOAT || distance > (firstCircle.radius + secondCircle.radius))
    {
        return @[];
    }
    
    // We calculate the intersection point referred to a system centered on firstCircle with the x axis "looking at" secondCircle
    CGFloat relativeX = ((distance * distance) + (firstCircle.radius * firstCircle.radius) - (secondCircle.radius * secondCircle.radius)) / (TWO_INT * distance);
    CGFloat relativeSquareY = (firstCircle.radius * firstCircle.radius) - (relativeX * relativeX);
    // Check if relativeSquareY is a positive number
    if (relativeSquareY < ZERO_FLOAT)
    {
        return @[];
    }
    // check if the circles are tangent
    if (relativeSquareY == ZERO_FLOAT)
    {
        relativeIntersectionPoints = @[[NSValue valueWithCGPoint:CGPointMake(relativeX, ZERO_FLOAT)]];
    }
    else
    {
        CGFloat relativeY = sqrt(relativeSquareY);
        relativeIntersectionPoints = @[[NSValue valueWithCGPoint:CGPointMake(relativeX, relativeY)], [NSValue valueWithCGPoint:CGPointMake(relativeX, -relativeY)]];
    }
    
    //Create the relative coordinates system to perform the transformation
    CGFloat rotation = [TUIGeometry angleWithTheXAxisAndLineDefinedByPoint:firstCircle.center andPoint:secondCircle.center];
    
    TUI2DCartesianCoordinatesSystem *relativeCoordinatesSystem = [[TUI2DCartesianCoordinatesSystem alloc] initWithOrigin:firstCircle.center
                                                                                                             andRotation:rotation];
    // return the absolute coordinates of the intersection points
    NSMutableArray *absoluteIntersectionPoints = [NSMutableArray array];
    
    for (NSValue *relativePoint in relativeIntersectionPoints)
    {
        CGPoint absolutePoint = [TUIGeometry absoluteCoordinatesOfPoint:[relativePoint CGPointValue] givenInCoordinateSystem:relativeCoordinatesSystem];
        [absoluteIntersectionPoints addObject:[NSValue valueWithCGPoint:absolutePoint]];
    }
    //return result
    return absoluteIntersectionPoints;
}

@end
