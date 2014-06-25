//
//  IVMapRoutingView.m
//  iViewer
//
//  Created by Mina Haleem on 29.04.13.
//  Copyright (c) 2013 Mina Haleem. All rights reserved.
//

#import "ISMapRoutingView.h"
#import <Indoors/IDSFloor.h>
#import <Indoors/IDSCoordinate.h>

@interface ISMapRoutingView()
@property(nonatomic,strong) IDSDefaultMap* map;
@property(nonatomic,strong) NSMutableArray* routingPaths;
@property(nonatomic,strong) UIColor* pathColor;
@end

@implementation ISMapRoutingView
@synthesize map;
@synthesize routingPaths;
@synthesize pathColor;

- (id)initWithFrame:(CGRect)frame map:(IDSDefaultMap*)defaultMap
{
    self = [super initWithFrame:frame];
    if (self) {
        self.map = defaultMap;
        self.routingPaths = [[NSMutableArray alloc]initWithCapacity:0];
        self.backgroundColor = [UIColor clearColor];
        self.pathColor = [UIColor blueColor];
    }
    
    return self;
}

#pragma mark - Public
- (void)showPaths:(NSMutableArray*)paths {
    self.routingPaths = paths;
    
    [self setNeedsDisplay];
}

- (void)showPath:(NSArray*)path {
    [self.routingPaths removeAllObjects];
    [self.routingPaths addObject:path];

    [self setNeedsDisplay];
}

- (void)clearPaths {
    [self.routingPaths removeAllObjects];
    
    [self setNeedsDisplay];
}

#pragma mark - Private
- (UIBezierPath*)routingPathWithPath:(NSArray*)path drawingWidthRatio:(float)widthRatio drawingHeightRatio:(float)heightRatio {
    UIBezierPath* bezierPath = [[UIBezierPath alloc]init];
    
    for (int idx = 0 ; idx < [path count] ;idx ++) {
        IDSCoordinate* point = [path objectAtIndex:idx];
        
        float x = point.x * widthRatio;
        float y = point.y * heightRatio;
        
        if(idx == 0) {
            [bezierPath moveToPoint:CGPointMake(x, y)];
        } else {
            [bezierPath addLineToPoint:CGPointMake(x, y)];
        }
    }
    
    return bezierPath;
}

#pragma mark - Drawing
- (void)drawRect:(CGRect)rect
{
    float widthRatio = self.frame.size.width / self.map.floor.mmWidth;
    float heightRatio = self.frame.size.height / self.map.floor.mmHeight;
    
    for (NSArray* path in self.routingPaths) {
        NSMutableArray *floorLevelPath = [NSMutableArray array];
        for (IDSCoordinate *coord in path) {
            if (self.map.floor.level == coord.z) {
                [floorLevelPath addObject:coord];
            }
        }

        //Draw Routing Path here
        UIBezierPath* routingPath = [self routingPathWithPath:floorLevelPath drawingWidthRatio:widthRatio drawingHeightRatio:heightRatio];
        [self.pathColor setStroke];
        routingPath.lineWidth = 4.0f;
        [routingPath stroke];
    }
}


@end
