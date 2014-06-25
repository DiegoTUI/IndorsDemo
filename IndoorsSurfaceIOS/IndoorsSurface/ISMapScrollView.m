//
//  IVMapScrollView.m
//  iViewer
//
//  Created by Mina Haleem on 24.03.13.
//  Copyright (c) 2013 Mina Haleem. All rights reserved.
//

#import "ISMapScrollView.h"
#import <Indoors/Indoors.h>
#import "ISMapView.h"
#import "ISAnnotationDetailsView.h"
#import "ISCallOutView.h"
#import "ISUserAnnotationView.h"

@interface ISMapScrollView() <UIGestureRecognizerDelegate>
@property (nonatomic, strong) ISMapView *mapView;


@property (strong) NSMutableArray *annotations;

@property (nonatomic, strong) UIView *currentAnnotationView;
@property (nonatomic, strong) ISAnnotationDetailsView *detailsView;

@property (nonatomic) IndoorsSurfaceZoneDisplayModes mapZoneDisplayMode;
@property (nonatomic) IndoorsSurfaceUserPositionDisplayModes mapUserPositionDisplayMode;

@property (nonatomic) int minTileZoomLevel ;

@property (nonatomic, strong) ISUserAnnotationView* userLocationAnnotation;
@property (nonatomic, strong) UIImage* userLocationCustomImage;

@property (nonatomic, strong) ISCallOutView* callout;
@property (nonatomic) BOOL isInSelectLocationMode;
@property (nonatomic) BOOL isRoutingFeatureEnabled;
@end


@implementation ISMapScrollView
@synthesize mapView, currentAnnotationView, detailsView;
@synthesize minTileZoomLevel;
@synthesize userCurrentLocation, userLocationAnnotation;
@synthesize routingDelegate;
@synthesize currentRoutingPath;
@synthesize callout;
@synthesize isInSelectLocationMode;
@synthesize mapZoneDisplayMode;
@synthesize userCurrentFloorLevel;
@synthesize isRoutingFeatureEnabled;
@synthesize mapUserPositionDisplayMode;
@synthesize userLocationCustomImage;


#define ZOOM_STEP 2.0

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.bouncesZoom = NO;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.delegate = self;
        self.isInSelectLocationMode = NO;
        
        self.annotations = [NSMutableArray array];
        self.userLocationCustomImage = nil;
        
        [self addDoubleTapGestureRecognizer];
        [self addTwoFingerTapGestureRecognizer];
        [self addSingleTapGestureRecognizer];
    }
    return self;
}

#pragma mark - Annotations

- (void)addAnnotation:(ISAnnotationView *)annotationView
{
    [self.annotations addObject:annotationView];
    
    CGSize scale = [self getDrawingScale];
    
    CGPoint newOrigin = [self pointForCoordinate:annotationView.coordinate];
    
    [annotationView resizeWithScale:scale];
    [annotationView positionWithScale:scale atPoint:newOrigin];
    
    if (annotationView.coordinate.z == self.map.floor.level)
        [self addSubview:annotationView];
}

- (void)removeAnnotation:(ISAnnotationView *)annotationView
{
    [self.annotations removeObject:annotationView];
    
    if ([annotationView isDescendantOfView:self])
        [annotationView removeFromSuperview];
}

- (void)moveAnnotation:(ISAnnotationView *)annotation toCoordinate:(IDSCoordinate *)coordinate
{
    CGSize scale = [self getDrawingScale];
    CGPoint point = [self pointForCoordinate:coordinate];
    annotation.coordinate = coordinate;
    [annotation positionWithScale:scale atPoint:point];
    
    if (annotation.coordinate.z == self.map.floor.level)
        [self addSubview:annotation];
}

- (void)removeAllAnnotations
{
    for (ISAnnotationView *annotation in self.annotations)
    {
        [annotation removeFromSuperview];
    }
    
    [self.annotations removeAllObjects];
}

- (void)updateAnnotations
{
    [self updateCalloutPosition];
    CGSize scale = [self getDrawingScale];
    for (ISAnnotationView *annotation in self.annotations)
    {
        if (annotation.coordinate.z == self.map.floor.level)
        {
            [self addSubview:annotation];
            [annotation positionWithScale:[self getDrawingScale] atPoint:[self.mapView pointAtCoordinate:annotation.coordinate]];
            [annotation resizeWithScale:scale];
        }
        else
            [annotation removeFromSuperview];
    }
}

//- (void)updateAnnotation

#pragma mark - UI Gestures

- (void)addSingleTapGestureRecognizer {
    UITapGestureRecognizer *singleTapRecognizer
    = [[UITapGestureRecognizer alloc]
       initWithTarget:self
       action:@selector(singleTapRecognized:)];
    
    singleTapRecognizer.delegate = self;
    
    [self addGestureRecognizer:singleTapRecognizer];
}

- (void)addDoubleTapGestureRecognizer {
    UITapGestureRecognizer *doubleTapRecognizer
    = [[UITapGestureRecognizer alloc]
       initWithTarget:self
       action:@selector(doubleTapRecognized:)];
    
    doubleTapRecognizer.numberOfTapsRequired = 2;
    
    [self addGestureRecognizer:doubleTapRecognizer];
}

- (void)addTwoFingerTapGestureRecognizer {
    UITapGestureRecognizer *twoFingerTapGestureRecognizer
    = [[UITapGestureRecognizer alloc]
       initWithTarget:self
       action:@selector(twoFingerTapRecognized:)];
    
    twoFingerTapGestureRecognizer.numberOfTouchesRequired = 2;
    
    [self addGestureRecognizer:twoFingerTapGestureRecognizer];
}

- (void)singleTapRecognized:(UITapGestureRecognizer *)recognizer {
    if (self.isInSelectLocationMode) {
        if (recognizer.state == UIGestureRecognizerStateEnded) {
            CGPoint location = [recognizer locationInView:self];
            [self showPickLocationPopupAtPoint:location title:NSLocalizedString(@"Choose this location!", @"")];
        }
    } else {
        if (self.map != nil && self.isRoutingFeatureEnabled && recognizer.state == UIGestureRecognizerStateEnded) {
            if (self.callout) {
                [self.callout removeFromSuperview];
                self.callout = nil;
            } else {
                CGPoint location = [recognizer locationInView:self];
                [self showPickLocationPopupAtPoint:location title:NSLocalizedString(@"Route to here!", @"")];
            }
        }
    }

    //TEST METHOD

    //    IDSCoordinate* start = [[IDSCoordinate alloc] init];
    //    start.x = 22524;
    //    start.y = 2616;
    //    start.z = 1;
    //    IDSCoordinate* end = [[IDSCoordinate alloc] init];
    //    end.x = 20474;
    //    end.y = 14726;
    //    end.z = 1;
    //
    //    [[Indoors instance] startTestRoutingFrom:start to:end];
    
    
    //TEST METHOD
    
    //[[Indoors instance] startTestLocalization];
    
    //[self hideAnnotationDetailsView];
}

- (void)doubleTapRecognized:(UITapGestureRecognizer *)recognizer {
    if (self.zoomScale < self.maximumZoomScale) {
        float newScale = MIN(self.zoomScale * ZOOM_STEP, self.maximumZoomScale);
        CGPoint location = [recognizer locationInView:mapView];
        
        CGRect zoomRect = [self zoomRectForScale:newScale center:location];
        [self zoomToRect:zoomRect animated:YES];
    }
}

- (void)twoFingerTapRecognized:(UITapGestureRecognizer *)recognizer {
    if (self.zoomScale > self.minimumZoomScale) {
        float newScale = MAX(self.zoomScale / ZOOM_STEP, self.minimumZoomScale);
        
        CGPoint location = [recognizer locationInView:mapView];
        CGRect zoomRect = [self zoomRectForScale:newScale center:location];
        
        [self zoomToRect:zoomRect animated:YES];
    }
}

// the zoom rect is in the content view's coordinates.
//    At a zoom scale of 1.0, it would be the size of the imageScrollView's bounds.
//    As the zoom scale decreases, so more content is visible, the size of the rect grows.
- (CGRect)zoomRectForScale:(float)scale center:(CGPoint)center {
    CGFloat width = CGRectGetWidth(self.frame) / scale;
    CGFloat height = CGRectGetHeight(self.frame) / scale;
    
    CGRect zoomRect
    = CGRectMake(center.x - width / 2.0,
                 center.y - height / 2.0,
                 width, height);
    
    return zoomRect;
}

#pragma mark - UIScrollView delegate methods

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    
    if (self.userCurrentLocation != nil) {
        [self updateUserLocationWithAnimation:NO];
    }
    
    CGSize scale = [self getDrawingScale];
    
    for (ISAnnotationView *annotationView in self.annotations) {
        float xPosition = annotationView.coordinate.x * scale.width;
        float yPosition = annotationView.coordinate.y * scale.height;
        CGPoint newOrigin = CGPointMake(xPosition, yPosition);
        
        [annotationView resizeWithScale:scale];
        [annotationView positionWithScale:scale atPoint:newOrigin];
        [self bringSubviewToFront:annotationView];
    }
    
    [self updateCalloutPosition];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return mapView;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale {
    //calculate the new zoomLevel that match current content size after scale
    int zoomLevel = [self minZoomLevelForMap:self.map withViewSize:self.contentSize];
    
    //If new Zoom not equal to previous loaded map zoom level
    if (zoomLevel != self.mapView.zoomLevel) {
        //Just load zoom level if greater than minimum zoom level allowed for this map
        if (zoomLevel <= self.minTileZoomLevel) {
            [self loadTileForMapWithZoomLevel:zoomLevel];
            [self updateAnnotations];
        }
    }
}

#pragma mark - Configure scrollView to display new tiled image

- (IDSDefaultMap*)map {
    return mapView.map;
}

- (void)calculateMinZoomScale {
    if (self.mapView.zoomLevel == self.minTileZoomLevel) {
        self.minimumZoomScale = 1.0;
        CGSize boundsSize = self.bounds.size;
        CGSize mapSize = self.mapView.bounds.size;
        
        // the scale needed to perfectly fit the map width-wise
        CGFloat xScale = boundsSize.width / mapSize.width;
        
        // the scale needed to perfectly fit the map height-wise
        CGFloat yScale = boundsSize.height / mapSize.height;
        
        // make sure that the map fills the screen
        self.minimumZoomScale = MAX(xScale, yScale);
    } else {
        self.minimumZoomScale = 0.25;
    }
}

- (void)setMap:(IDSDefaultMap*)map {
    if (mapView) {
        [mapView removeFromSuperview];
    }
    
    BOOL isPreviousMapInInitialZoom = NO;
    if (self.mapView && self.mapView!= nil) {
        if(self.mapView.zoomLevel == self.minTileZoomLevel) {
            isPreviousMapInInitialZoom = YES;
        }
    }
    
    self.minTileZoomLevel = [self minZoomLevelForMap:map withViewSize:self.frame.size];
    
    int initialZoomLevel = self.minTileZoomLevel;
    
    if (self.mapView && self.mapView!= nil && !isPreviousMapInInitialZoom) {
        IDSTile* tile = [map.tiles objectForKey:[NSNumber numberWithInt:self.mapView.zoomLevel]];
        
        if (tile && tile != nil) {
            initialZoomLevel = self.mapView.zoomLevel;
        }
    }
    
    mapView = [[ISMapView alloc] initWithMap:map andZoom:initialZoomLevel];
    
    if (self.currentRoutingPath) {
        [self setRoutingPath:self.currentRoutingPath];
    }
    
    mapView.showsGrid = NO;
    
    [self addSubview:mapView];
    [self sendSubviewToBack:mapView];
    //[self addSingleTapGestureRecognizer];
    
    //Reset user current position
    if (!self.userLocationAnnotation) {
        self.userLocationAnnotation = [[ISUserAnnotationView alloc] initWithCoordinate:self.userCurrentLocation customImage:self.userLocationCustomImage];
        [self addAnnotation:self.userLocationAnnotation];
        [self setUserLocationHidden:YES];
    }
    
    self.contentSize = mapView.frame.size;
    
    [self calculateMinZoomScale];
    
    self.maximumZoomScale = 2;
    self.zoomScale = 1.0;
    
    if (self.userCurrentLocation) {
        [self setUserPosition:self.userCurrentLocation];
    } else {
        [self setUserLocationHidden:YES];
    }
    
    [self redrawZonesWithUserPositionUpdate:NO];
    
    [self.callout removeFromSuperview];
    self.callout = nil;
    
}

- (void)loadTileForMapWithZoomLevel:(int)mapZoomLevel {
    //Get previous content center before change tile
    CGPoint contentCenter = [self getContentCenter];
    CGSize contentOldSize = self.contentSize;
    
    //Load new tile
    ISMapView* tempView = [[ISMapView alloc]initWithMap:self.map andZoom:mapZoomLevel];
    [self addSubview:tempView];
    [self.mapView removeFromSuperview];
    self.mapView = tempView;
    
    //Redraw routing path if available
    if (self.currentRoutingPath != nil) {
        [self.mapView setRoutingPath:self.currentRoutingPath];
    }
    
    self.contentSize = self.mapView.frame.size;
    
    //Recalculate the minimum zoom scale, to prevent zoom out more than allowed zoom scale
    [self calculateMinZoomScale];
    
    //Calcualte ratio between new tile size and old size before loading the new tile
    float xRatio = self.contentSize.width / contentOldSize.width;
    float yRatio = self.contentSize.height / contentOldSize.height;
    
    //recalculate the new center of content
    contentCenter.x = contentCenter.x * xRatio;
    contentCenter.y = contentCenter.y * yRatio;
    
    //Set content center
    [self setContentCenter:contentCenter];
    
    //we should show user location
    if (self.userCurrentLocation) {
        [self updateUserLocationWithAnimation:NO];
        [self setUserLocationHidden:NO];
    }
    
    [self redrawZonesWithUserPositionUpdate:NO];
}
#pragma mark - Rotation

// Preserve the zoomScale and the visible portion of the image
- (void)preserveViewportDuringRotation:(dispatch_block_t)rotationBlock {
    
    if (self.map != nil) {
        self.minTileZoomLevel = [self minZoomLevelForMap:self.map withViewSize:self.frame.size];
        
        if(self.minTileZoomLevel < self.mapView.zoomLevel) {
            [self loadTileForMapWithZoomLevel:self.minTileZoomLevel];
        } else {
            [self calculateMinZoomScale];
        }
    }
    
    //CGPoint restorePoint = [self getContentCenter];
    
    if (rotationBlock) {
        rotationBlock();
    }
    
    //[self setContentCenter:restorePoint];
}

#pragma mark - Private (Routing)

- (void)showPickLocationPopupAtPoint:(CGPoint)point title:(NSString*)popupTitle{
    
    if (self.callout) {
        [self.callout removeFromSuperview];
        self.callout = nil;
    }
    
    self.callout = [[ISCallOutView alloc] initWithText:popupTitle point:point target:self action:@selector(userDidSelectLocation:)];
    self.callout.coordinate = [self coordinateForPoint:point];
	[self.callout showWithAnimiation:self];
}

- (void)updateCalloutPosition {
    if (self.callout) {
        [self bringSubviewToFront:self.callout];
        CGPoint point = [self pointForCoordinate:self.callout.coordinate];
        [self.callout repositionWithPoint:point];
    }
}

- (void)userDidSelectLocation:(id)sender {
    self.isInSelectLocationMode = NO;
    
    if (routingDelegate && [routingDelegate respondsToSelector:@selector(mapScrollView:userDidSelectLocation:)]) {
        [routingDelegate mapScrollView:self userDidSelectLocation:self.callout.coordinate];
    }
    
    [self.callout removeFromSuperview];
    self.callout = nil;
}

#pragma mark - Private (Zone)

- (void)redrawZonesWithUserPositionUpdate:(BOOL)isUserPositionUpdate {
    if (self.mapZoneDisplayMode == IndoorsSurfaceZoneDisplayModeNone) {
        [self.mapView hideAllZones];
    } else {
        if (isUserPositionUpdate) {
            if(self.mapZoneDisplayMode == IndoorsSurfaceZoneDisplayModeUserCurrentLocation) {
                [self.mapView hideAllZones];
                [self highlightUserCurrentZones];
            }
        } else {
            if (self.mapZoneDisplayMode == IndoorsSurfaceZoneDisplayModeAllAvailable) {
                [self.mapView showZones:self.map.floor.zones];
            } else if(self.mapZoneDisplayMode == IndoorsSurfaceZoneDisplayModeUserCurrentLocation) {
                [self.mapView hideAllZones];
                [self highlightUserCurrentZones];
            }
        }
    }
}

- (void)highlightUserCurrentZones {
    if (self.userCurrentFloorLevel == self.map.floor.level){
        NSMutableArray* zones = [[NSMutableArray alloc] initWithCapacity:0];
        
        for (IDSZone* zone in self.map.floor.zones) {
            UIBezierPath* polygonPath = [zone poloygonWithXScale:1 yScale:1];
            CGPoint userPoint = CGPointMake(self.userCurrentLocation.x, self.userCurrentLocation.y);
            if([polygonPath containsPoint:userPoint]) {
                [zones addObject:zone];
            }
        }
        
        [self.mapView showZones:zones];
    }
}

- (CGPoint)pointForCoordinate:(IDSCoordinate*) coordinate {
    CGSize scale = [self getDrawingScale];
    
    float xPosition = coordinate.x * scale.width;
    float yPosition = coordinate.y * scale.height;
    CGPoint newOrigin = CGPointMake(xPosition, yPosition);
    
    return newOrigin;
}

- (IDSCoordinate*)coordinateForPoint:(CGPoint)point {
    int x = point.x;
    int y = point.y;
    
    x = (self.map.floor.mmWidth / self.contentSize.width ) * x;
    y = (self.map.floor.mmHeight / self.contentSize.height ) * y;
    
    IDSCoordinate* coordinate = [[IDSCoordinate alloc]initWithX:x andY:y andFloorLevel:self.map.floor.level];
    
    return coordinate;
}

#pragma mark - Private (Map Calculations)

- (CGSize)getDrawingScale {
    float xScale = self.contentSize.width / self.map.floor.mmWidth ;
    float yScale = self.contentSize.height / self.map.floor.mmHeight;
    
    CGSize scale = CGSizeMake(xScale, yScale);
    
    return scale;
}

- (int) minZoomLevelForMap:(IDSDefaultMap*)tileMap withViewSize:(CGSize)size {
    NSNumber* tileLevel = [NSNumber numberWithInt:1];
    float minimumDiff = MAXFLOAT;
    
    for (NSNumber* tileZoomLevel in [tileMap.tiles allKeys]) {
        IDSTile *tile = [tileMap.tiles objectForKey:tileZoomLevel];
        
        float widthDifference = tile.summaryPixelWidth - size.width;
        float heightDifferece = tile.summaryPixelHeight - size.height;
        
        if (widthDifference >= 0 && heightDifferece >= 0) {
            if ((widthDifference + heightDifferece) < minimumDiff) {
                minimumDiff = widthDifference + heightDifferece;
                
                tileLevel = tileZoomLevel;
            }
        }
    }
    
    return [tileLevel intValue];
}

- (void)updateUserLocationWithAnimation:(BOOL)withAnimation {
    if (withAnimation) {
        [UIView animateWithDuration:0.3 animations:^{
            [self moveAnnotation:self.userLocationAnnotation toCoordinate:self.userCurrentLocation];
        }];
    } else {
        [self moveAnnotation:self.userLocationAnnotation toCoordinate:self.userCurrentLocation];
    }
    
    [self bringSubviewToFront:self.userLocationAnnotation];
    
    CGSize scale = [self getDrawingScale];
    CGFloat accuracyInPixel = self.userLocationAnnotation.coordinate.accuracy * scale.width;
    [self.userLocationAnnotation updateAccuracy:accuracyInPixel];
    
    [self redrawZonesWithUserPositionUpdate:YES];
}

#pragma mark - Private (Content Center)
- (CGPoint)getContentCenter {
    float halfWidth = self.frame.size.width / 2;
    float halfHeight = self.frame.size.height / 2;
    
    CGPoint cOffset = self.contentOffset;
    
    CGPoint contentCenter = CGPointMake(cOffset.x + halfWidth, cOffset.y + halfHeight);
    
    return contentCenter;
    
}

- (void)setContentCenter:(CGPoint)contentCenter {
    
    float halfWidth = self.frame.size.width / 2;
    float halfHeight = self.frame.size.height / 2;
    
    //Check if poit out of boundries
    if (contentCenter.x > (self.contentSize.width - halfWidth)) {
        contentCenter.x = (self.contentSize.width - halfWidth);
    }
    
    if (contentCenter.y > (self.contentSize.height - halfHeight)) {
        contentCenter.y = (self.contentSize.height - halfHeight);
    }
    
    CGPoint cOffset = CGPointMake(contentCenter.x - halfWidth, contentCenter.y - halfHeight);
    
    if (cOffset.x < 0) {
        cOffset.x = 0;
    }
    
    if (cOffset.y < 0) {
        cOffset.y = 0;
    }
    
    self.contentOffset = cOffset;
}

#pragma mark - Public

- (void)enableRoutingFature:(BOOL)enabled {
    self.isRoutingFeatureEnabled = enabled;
}

- (void)clearRouting {
    self.currentRoutingPath = nil;
    if (self.mapView && self.mapView != nil) {
        [self.mapView clearRouting];
    }
}

- (void)letUserSelectLocationFromMap {
    self.isInSelectLocationMode = YES;
}

- (void)setRoutingPath:(NSArray*)path {
    self.currentRoutingPath = path;
    if (self.mapView && self.mapView != nil) {
        [self.mapView setRoutingPath:path];
    }
}

- (void)setUserFloorLevel:(int)userFloorLevel {
    if (self.userCurrentFloorLevel != userFloorLevel) {
        self.userCurrentFloorLevel = userFloorLevel;
        
        if (self.userCurrentLocation) {
            self.userCurrentLocation.z = userFloorLevel;
        }
        
        if (userFloorLevel == INT_MAX || self.userCurrentFloorLevel != self.map.floor.level) {
            [self setUserLocationHidden:YES];
        } else {
            [self updateUserLocationWithAnimation:NO];
        }
    }
}

- (void)setUserPosition:(IDSCoordinate*)coordinate {
    coordinate.z = self.userCurrentFloorLevel;
    self.userCurrentLocation = coordinate;
    self.userLocationAnnotation.coordinate = coordinate;
    
    if (self.userCurrentFloorLevel == self.map.floor.level) {
        [self setUserLocationHidden:NO];
    } else {
        [self setUserLocationHidden:YES];
    }
    
    [self updateUserLocationWithAnimation:YES];
}

- (void)showUserLocation {
    [self bringSubviewToFront:self.userLocationAnnotation];
    [self setUserLocationHidden:NO];
    
    CGPoint newOrigin = [self pointForCoordinate:self.userCurrentLocation];
    [self setContentCenter:newOrigin];
}

- (void)setUserLocationHidden:(BOOL)isHidden {
    if (isHidden || self.mapUserPositionDisplayMode != IndoorsSurfaceUserPositionDisplayModeNone) {
        [self.userLocationAnnotation setHidden:isHidden];
    }
    
    if (!isHidden) {
        [self bringSubviewToFront:self.userLocationAnnotation];
    }
}

- (void)setMapCenterWithCoordinate:(IDSCoordinate*)coordinate {
    if (self.userCurrentLocation && self.userCurrentLocation != nil) {
        [self bringSubviewToFront:self.userLocationAnnotation];
        [self setUserLocationHidden:NO];
    }
    
    CGPoint newOrigin = [self pointForCoordinate:coordinate];
    [self setContentCenter:newOrigin];
}

- (void)setUserOrientation:(float)orientation {
    self.userLocationAnnotation.orientation = orientation;
}

- (void)setZoneDisplayMode:(IndoorsSurfaceZoneDisplayModes)zoneDisplayMode {
    self.mapZoneDisplayMode = zoneDisplayMode;
}

- (void)setUserPositionDisplayMode:(IndoorsSurfaceUserPositionDisplayModes)userPositionDisplayMode {
    self.mapUserPositionDisplayMode = userPositionDisplayMode;
}

- (void)setUserPositionIcon:(UIImage*)userPositionIcon {
    self.userLocationCustomImage = userPositionIcon;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return ! ([touch.view isKindOfClass:[UIControl class]]);
}

- (void)didReceiveWeakSignal {
    self.userCurrentLocation = [IDSCoordinate new];
    self.userCurrentLocation.x = INT_MAX;
    self.userCurrentLocation.y = INT_MAX;
    
    //Set Floor Information to INT_MAX to allow set back the floor when receive good signal
    self.userCurrentLocation.z = INT_MAX;
    self.userCurrentFloorLevel = INT_MAX;
    
    [self setUserLocationHidden:YES];
    [self redrawZonesWithUserPositionUpdate:YES];
}

@end
