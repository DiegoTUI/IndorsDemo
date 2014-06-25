//
//  TUICircle.h
//  Rooms
//
//  Created by Diego Lafuente on 29/05/14.
//  Copyright (c) 2014 Tui Travel A&D. All rights reserved.
//

#import "TUIBaseModel.h"

/**
 TUICircle is the model of a circle
 */
@interface TUICircle : TUIBaseModel

/**
 The center of the circle.
 */
@property (nonatomic, assign) CGPoint center;

/**
 The radius of the circle.
 */
@property (nonatomic, assign) CGFloat radius;

/**
 @methodName initWithCenter:andRadius:
 @abstract Creates a circle with the given center and radius
 @discussion This method will initalize a circle with the given center and radius
 
 @param center The center of the circle
 @param radius The radius of the circle
 
 @return The initialized circle
 */
- (TUICircle *)initWithCenter:(CGPoint)center
                    andRadius:(CGFloat)radius NS_REQUIRES_SUPER;
@end
