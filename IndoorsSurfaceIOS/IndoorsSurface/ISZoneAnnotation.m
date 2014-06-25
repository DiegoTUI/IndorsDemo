//
//  IVZoneAnnotation.m
//  iViewer
//
//  Created by Mina Haleem on 21.04.13.
//  Copyright (c) 2013 Mina Haleem. All rights reserved.
//

#import <CoreText/CoreText.h>
#import "ISZoneAnnotation.h"
#import <Indoors/Indoors.h>

@interface  ISZoneAnnotation()
@property(nonatomic,strong)IDSDefaultMap* map;
@property(nonatomic,strong)NSMutableArray* zones;
@end

@implementation ISZoneAnnotation
@synthesize map;
@synthesize zones;
@synthesize zoneNameFont,zoneNameColor;
@synthesize zoneColor;
@synthesize zoneBorderColor;

- (id)initWithFrame:(CGRect)frame Map:(IDSDefaultMap *)defaultMap {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.map = defaultMap;
        
        self.zoneColor = [UIColor colorWithRed:1.0 green:0 blue:0.1 alpha:0.5];
        self.zoneBorderColor = [UIColor colorWithRed:1.0 green:0 blue:0.1 alpha:0.9];
        self.zoneNameFont = [UIFont boldSystemFontOfSize:25.0];
        self.zoneNameColor = [UIColor blackColor];
    }
    
    return self;
}

- (void)hideAllZones {
    self.zones = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self setNeedsDisplay];
}

- (void)showZones:(NSMutableArray*)showZones {
    self.zones = showZones;
    
    [self setNeedsDisplay];
}
#pragma mark - UIView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    float widthRatio = self.frame.size.width / self.map.floor.mmWidth;
    float heightRatio = self.frame.size.height / self.map.floor.mmHeight;
    
    //Draw all zones available
    for (int zoneIndex = 0;zoneIndex < [self.zones count];zoneIndex++) {
        
        IDSZone* zone = [self.zones objectAtIndex:zoneIndex];
        //We should have more than 2 points to draw shape
        if ([zone.points count] > 2) {
            //Polygon with all given points
            UIBezierPath* bezierPath = [zone poloygonWithXScale:widthRatio yScale:heightRatio];
            
            bezierPath.lineWidth = 3.0;
            [self.zoneColor setFill];
            [self.zoneBorderColor setStroke];
            
            [bezierPath fill];
            [bezierPath stroke];
            
            //Drawing Zone Name Here
            if (zone.name && zone.name.length > 0 && ![zone.name isEqualToString:@""]) {
                //Get bounds of Zone as Rect
                CGRect box = CGPathGetPathBoundingBox(bezierPath.CGPath);
                
                //Font Color
                [self.zoneNameColor setFill];

                //Calculate center point of zone to draw name
                float fontHeight = zoneNameFont.lineHeight;
                float textYOffset = (box.size.height -  fontHeight) / 2;
                box.origin.y = box.origin.y + textYOffset;
                box.size.height = fontHeight;
                
                [zone.name drawInRect:box withFont:zoneNameFont lineBreakMode:NSLineBreakByTruncatingMiddle alignment:NSTextAlignmentCenter];
            }
        }
    }
}

@end
