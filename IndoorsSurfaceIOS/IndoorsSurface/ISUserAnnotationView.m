//
//  IVUserAnnotationView.m
//  iViewer
//
//  Created by Jonas Keisel on 7/18/13.
//  Copyright (c) 2013 Mina Haleem. All rights reserved.
//

#import "ISUserAnnotationView.h"
#import <QuartzCore/QuartzCore.h>
#import "ISUserLocationAccuracyView.h"

#define MIN_ACCURACY_SCALE 50
#define MAX_ACCURACY_SCALE 200

#define degreesToRadians(degrees) (M_PI * degrees / 180.0)

@interface ISUserAnnotationView ()
{
    NSInteger _accuracy;
}
@property (nonatomic,strong) UIImageView* locationPointerImage;
@property (nonatomic,strong) ISUserLocationAccuracyView* accuracyView;
@end

@implementation ISUserAnnotationView

- (instancetype)initWithCoordinate:(IDSCoordinate *)coordinate customImage:(UIImage*)customImage
{
    self = [super initWithCoordinate:coordinate];
    
    if (self)
    {        
        self.contentSize = CGSizeMake(MAX_ACCURACY_SCALE, MAX_ACCURACY_SCALE);
        _accuracy = MIN_ACCURACY_SCALE;
        
        if (customImage) {
            self.locationPointerImage = [[UIImageView alloc]initWithImage:customImage];
        } else {
            CGRect rect = CGRectMake(0.0, 0.0, 20.0, 20.0);
            UIBezierPath *ovalPath = [UIBezierPath bezierPathWithOvalInRect:rect];
            ovalPath.lineWidth = 0.0;

            UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
            
            [[UIColor blackColor] setFill];
            [ovalPath fill];
            [ovalPath stroke];
            
            UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            self.locationPointerImage = [[UIImageView alloc]initWithImage:image];
        }
        
        self.locationPointerImage.center = CGPointMake(self.contentSize.width / 2, self.contentSize.height / 2);
        
        self.accuracyView = [[ISUserLocationAccuracyView alloc]initWithFrame:CGRectMake(0, 0, MIN_ACCURACY_SCALE, MIN_ACCURACY_SCALE)];
        self.accuracyView.center = self.locationPointerImage.center;
        
        [self addSubview:self.accuracyView];
        [self addSubview:self.locationPointerImage];
    }
    
    return self;
}

- (void)updateAccuracy:(NSInteger)accuracyWithScale
{    
    if (accuracyWithScale > MIN_ACCURACY_SCALE) {
        [self.accuracyView setHidden:NO];
        _accuracy = accuracyWithScale;
        
        float centerX = (self.contentSize.width - accuracyWithScale) / 2;
        
        CGRect accuracyViewFrame = CGRectMake(centerX, centerX, accuracyWithScale, accuracyWithScale);
        
        [UIView animateWithDuration:0.3 animations:^{
            [self.accuracyView setFrame:accuracyViewFrame];;
        }];
    }else if (accuracyWithScale == 0) {
        [self.accuracyView setHidden:YES];
    }
}

- (void)setOrientation:(CGFloat)orientation
{
    CGAffineTransform rotationTransform = CGAffineTransformMakeRotation(degreesToRadians(orientation));
    [self.locationPointerImage setTransform:rotationTransform];
}

@end
