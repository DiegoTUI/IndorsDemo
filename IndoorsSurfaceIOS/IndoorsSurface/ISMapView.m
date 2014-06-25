//
//  IVMapView.m
//  iViewer
//
//  Created by Mina Haleem on 24.03.13.
//  Copyright (c) 2013 Mina Haleem. All rights reserved.
//

#import "ISMapView.h"
#import <QuartzCore/CATiledLayer.h>
#import "ISMapRoutingView.h"
#import <Indoors/Indoors.h>

@interface ISMapView()
@property(nonatomic,strong) ISMapRoutingView* routingView;
@end

@implementation ISMapView
@synthesize routingView;
@synthesize zoneAnnotation;

+ (Class)layerClass
{
	return [CATiledLayer class];
}

- (id)initWithMap:(IDSDefaultMap*)map andZoom:(int)level
{
    self.zoomLevel = level;
    
    IDSTile *tile = [map.tiles objectForKey:[NSNumber numberWithInt:self.zoomLevel]];
    
    for (NSNumber* key in map.tiles.allKeys) {
        // NSLog(@"Size: %d",[key intValue]);
    }
    
    self = [super initWithFrame:CGRectMake(0, 0, tile.summaryPixelWidth, tile.summaryPixelHeight)];
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.map = map;
        self.routingView = [[ISMapRoutingView alloc]initWithFrame:self.frame map:self.map];
        self.zoneAnnotation = [[ISZoneAnnotation alloc]initWithFrame:self.frame Map:self.map];
        
        [self addSubview:self.routingView];

        [self addSubview:self.zoneAnnotation];
    }
    
    return self;
}

// Make sure the content scale factor is always set to 1.0.
- (void)didMoveToWindow {
    self.contentScaleFactor = 1.0;
}


- (void)drawRect:(CGRect)rect
{
 	CGContextRef context = UIGraphicsGetCurrentContext();
    
    // get the scale from the context by getting the current transform matrix, then asking for
    // its "a" component, which is one of the two scale components. We could also ask for "d".
    // This assumes (safely) that the view is being scaled equally in both dimensions.
    CGFloat scale = CGContextGetCTM(context).a;
    //NSLog(@"Scale:%f",scale);
    
    //NSLog(@"drawRect: %f, %f, %@", scale, self.contentScaleFactor, NSStringFromCGRect(rect));
    
    CATiledLayer *tiledLayer = (CATiledLayer *)[self layer];
    CGSize tileSize = tiledLayer.tileSize;
    
    // Even at scales lower than 100%, we are drawing into a rect in the coordinate system of the full
    // image. One tile at 50% covers the width (in original image coordinates) of two tiles at 100%.
    // So at 50% we need to stretch our tiles to double the width and height; at 25% we need to stretch
    // them to quadruple the width and height; and so on.
    // (Note that this means that we are drawing very blurry images as the scale gets low. At 12.5%,
    // our lowest scale, we are stretching about 6 small tiles to fill the entire original image area.
    // But this is okay, because the big blurry image we're drawing here will be scaled way down before
    // it is displayed.)
    tileSize.width /= scale;
    tileSize.height /= scale;
    
    // calculate the rows and columns of tiles that intersect the rect we have been asked to draw
    int firstCol = floorf(CGRectGetMinX(rect) / tileSize.width);
    int lastCol = floorf((CGRectGetMaxX(rect)-1) / tileSize.width);
    int firstRow = floorf(CGRectGetMinY(rect) / tileSize.height);
    int lastRow = floorf((CGRectGetMaxY(rect)-1) / tileSize.height);
    
    for (int row = firstRow; row <= lastRow; row++) {
        for (int col = firstCol; col <= lastCol; col++) {
            UIImage *tile = [_map tileForScale:self.zoomLevel row:row col:col];
            CGRect tileRect = CGRectMake(tileSize.width * col, tileSize.height * row,
                                         tileSize.width, tileSize.height);
            
            // if the tile would stick outside of our bounds, we need to truncate it so as to avoid
            // stretching out the partial tiles at the right and bottom edges
            tileRect = CGRectIntersection(self.bounds, tileRect);
            
            [tile drawInRect:tileRect];
            self.showsGrid = false;
            if (self.showsGrid) {
                [[UIColor redColor] set];
                CGContextSetLineWidth(context, 4.0 / scale);
                CGContextStrokeRect(context, tileRect);
            }
        }
    }
}

#pragma mark - Public
- (void)setRoutingPath:(NSArray *)path {
    [self.routingView showPath:path];
}

/*!
 @method clearRouting
 @discussion 
 Clear the routing path if any path drawn
 */
-(void)clearRouting {
    [self.routingView clearPaths];
}

/*!
 @method hideAllZones
 @discussion 
 Hide all zones.
 */
- (void)hideAllZones {
    [self.zoneAnnotation hideAllZones];
}

/*!
 @method showZones:
 @param zones
 Array of IDSZone to displayed on current building
 @discussion
 Highlight given list of zones (IDSZone)
 */
- (void)showZones:(NSMutableArray*)zones {
    [self.zoneAnnotation showZones:zones];
}

/*!
 @method coordinateAtPoint:
 @param point
 Point at screen (X,Y) (relative to screen)
 @discussion
 Calculate the correct coorodinate on the map for the given point.
 Calculated coordinate will be different given current zoom level.
 
 @return Coordinate
 */
- (IDSCoordinate *)coordinateAtPoint:(CGPoint)point
{
    IDSTile *tiles = self.map.tiles[@(self.zoomLevel)];
    
    //Calculate relative (how many mm per pixel)
    int mmPerPixelX = self.map.floor.mmWidth  / tiles.summaryPixelWidth;
    int mmPerPixelY = self.map.floor.mmHeight / tiles.summaryPixelHeight;
    
    return [[IDSCoordinate alloc] initWithX:point.x * mmPerPixelX
                                          Y:point.y * mmPerPixelY
                                          z:self.map.floor.level
                                   accuracy:INT_MAX];
}

/*!
 @method pointAtCoordinate:
 @param coordinate
 Coordinate on the map
 @discussion 
 Calculate point which is equivalent to a coordinate on the map
 @return point wich reflects the coorindate on the screen or (0,0) in case of failure
 */
- (CGPoint)pointAtCoordinate:(IDSCoordinate *)coordinate
{
    IDSTile *tiles = self.map.tiles[@(self.zoomLevel)];
    
    if (tiles) {
        int mmPerPixelX = self.map.floor.mmWidth  / tiles.summaryPixelWidth;
        int mmPerPixelY = self.map.floor.mmHeight / tiles.summaryPixelHeight;
        
        return CGPointMake(coordinate.x / mmPerPixelX, coordinate.y / mmPerPixelY);
    }
    return CGPointMake(0, 0);
}

@end
