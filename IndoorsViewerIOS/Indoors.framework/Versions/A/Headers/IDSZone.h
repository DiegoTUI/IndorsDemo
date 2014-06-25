//
//  Zone.h
//  Indoors
//
//  Created by Gerhard Zeissl on 02.12.12.
//  Copyright (c) 2012 Indoors. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum  {
    POI,
    DeadZone,
    Inbound
}ZoneType;

@interface IDSZone : NSObject
@property (nonatomic) int zone_id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic) NSUInteger floor_id;
@property (nonatomic, strong) NSString *description;
@property (nonatomic) NSUInteger speed;
@property (nonatomic,strong) NSMutableArray* points;

- (UIBezierPath*)poloygonWithXScale:(float) xScale yScale:(float)yScale;
@end
