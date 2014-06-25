//
//  IVAnnotaionView.m
//  iViewer
//
//  Created by Jonas Keisel on 7/18/13.
//  Copyright (c) 2013 Jonas Keisel. All rights reserved.
//

#import "ISAnnotationView.h"
#import "ISMapScrollView.h"
#import "ISMapView.h"

@interface ISAnnotationView ()
@end

@implementation ISAnnotationView

- (instancetype)initWithCoordinate:(IDSCoordinate *)coordinate
{
    return [self initWithCoordinate:coordinate andPosition:kIVAnnotationViewPositionCenter];
}

- (instancetype)initWithCoordinate:(IDSCoordinate *)coordinate andPosition:(kIVAnnotationViewPosition)position
{
    self = [super initWithFrame:CGRectMake(0, 0, 10, 10)];
    if (self)
    {
        _coordinate = coordinate;
        _position   = position;
        
        self.backgroundColor = [UIColor clearColor];
        self.fixedSize = YES;
        
        self.positionShiftingSize = CGSizeZero;
    }
    return self;
}

- (void)resizeWithScale:(CGSize)scale
{
    CGRect frame = self.frame;
    
    if (!self.fixedSize) {
        frame.size.width  = self.contentSize.width  * scale.width;
        frame.size.height = self.contentSize.height * scale.height;
    }
    else {
        frame.size = self.contentSize;
    }
    
    self.frame = frame;
}

- (void)positionWithScale:(CGSize)scale atPoint:(CGPoint)point
{
    CGPoint pointOnMap = point;
    CGPoint newOrigin  = CGPointZero;
    switch (self.position) {
        case kIVAnnotationViewPositionCenter:
            newOrigin.x = pointOnMap.x - self.frame.size.width  / 2;
            newOrigin.y = pointOnMap.y - self.frame.size.height / 2;
            break;
        case kIVAnnotationViewPositionTop:
            newOrigin.x = pointOnMap.x - self.frame.size.width / 2.;
            newOrigin.y = pointOnMap.y - self.frame.size.height;
            break;
        case kIVAnnotationViewPositionBottom:
            newOrigin.x = pointOnMap.x - self.frame.size.width / 2.;
            newOrigin.y = pointOnMap.y;
            break;
        case kIVAnnotationViewPositionLeft:
            newOrigin.x = pointOnMap.x - self.frame.size.width;
            newOrigin.y = pointOnMap.y - self.frame.size.height / 2;
            break;
        case kIVAnnotationViewPositionRight:
            newOrigin.x = pointOnMap.x;
            newOrigin.y = pointOnMap.y - self.frame.size.height / 2;
        default:
            break;
    }
    
    newOrigin.x += self.positionShiftingSize.width;
    newOrigin.y += self.positionShiftingSize.height;
    
    CGRect frame = self.frame;
    frame.origin = newOrigin;
    
    self.frame = frame;
}

@end
