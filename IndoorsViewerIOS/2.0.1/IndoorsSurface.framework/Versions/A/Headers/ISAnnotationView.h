//
//  IVAnnotaionView.h
//  iViewer
//
//  Created by Jonas Keisel on 7/18/13.
//  Copyright (c) 2013 Mina Haleem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Indoors/Indoors.h>

typedef enum {
    kIVAnnotationViewPositionTop,
    kIVAnnotationViewPositionRight,
    kIVAnnotationViewPositionBottom,
    kIVAnnotationViewPositionLeft,
    kIVAnnotationViewPositionCenter
} kIVAnnotationViewPosition;

@interface ISAnnotationView : UIView

@property CGSize contentSize; /// in px if fixedSize == YES. Otherwise in mm
@property BOOL   fixedSize;   /// Default is YES. Important! If this is NO, the content size has to declared in millimetres!
@property CGSize positionShiftingSize; /// in pixels
@property kIVAnnotationViewPosition position; /// Where should the annotation appear in realtion to the coordinate? Default is kIVAnnotationViewPositionCenter
@property (strong) IDSCoordinate *coordinate;

- (instancetype)initWithCoordinate:(IDSCoordinate *)coordinate;
- (instancetype)initWithCoordinate:(IDSCoordinate *)coordinate andPosition:(kIVAnnotationViewPosition)position;

/// Overwrite this method to do custom scaling. Call [super resizeWithScale:] immediately
- (void)resizeWithScale:(CGSize)scale;
/// Overwrite this method to do custom positioning. Call [super positionWithScale:atPoint:] immediately
- (void)positionWithScale:(CGSize)scale atPoint:(CGPoint)point;

@end
