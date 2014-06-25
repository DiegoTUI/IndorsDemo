//
//  IVPointAnnotationView.m
//  iViewer
//
//  Created by Jonas Keisel on 7/19/13.
//  Copyright (c) 2013 Jonas Keisel. All rights reserved.
//

#import "ISPointAnnotationView.h"
#import <QuartzCore/QuartzCore.h>
#import <math.h>

#define RAD2DEG(rad) (180.0 * (rad) / (M_PI))
#define DEG2RAD(deg) ((deg) / 180.0 * (M_PI))

#define DIAMETER 20

@interface ISPointAnnotationView ()
@property (nonatomic, strong) CAShapeLayer *whiteCircle;
@property (nonatomic, strong) CAShapeLayer *pulsingCircle;
@end

@implementation ISPointAnnotationView

- (instancetype)initWithCoordinate:(IDSCoordinate *)coordinate
{
    self = [super initWithCoordinate:coordinate andPosition:kIVAnnotationViewPositionCenter];
    
    if (self)
    {
        self.contentSize = CGSizeMake(DIAMETER, DIAMETER);
        
        self.whiteCircle   = [[CAShapeLayer alloc] init];
        self.pulsingCircle = [[CAShapeLayer alloc] init];
        
        [self.layer addSublayer:self.whiteCircle];
        [self.layer addSublayer:self.pulsingCircle];
    }
    
    return self;
}

#pragma mark Drawing

+ (Class)layerClass
{
    return [CAShapeLayer class];
}

- (void)layoutSubviews
{
    [self createWhiteCircle];
    [self createPulsingCircle];
}

- (void)createWhiteCircle
{
    CGRect drawingBounds = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    CAShapeLayer *layer = self.whiteCircle;
    layer.path          = [UIBezierPath bezierPathWithOvalInRect:drawingBounds].CGPath;
    layer.fillColor     = [UIColor whiteColor].CGColor;
    layer.shadowColor   = [UIColor darkGrayColor].CGColor;
    layer.shadowRadius  = 2.f;
    layer.shadowOpacity = 1.f;
    layer.shadowOffset  = CGSizeMake(0, layer.shadowRadius/2.);
}

- (void)createPulsingCircle {
    CGRect drawingBounds = CGRectInset(CGRectMake(0, 0, self.frame.size.width, self.frame.size.height), 3, 3);
    
    CAShapeLayer *layer = self.pulsingCircle;
    layer.path      = [UIBezierPath bezierPathWithOvalInRect:drawingBounds].CGPath;
    layer.fillColor = [UIColor colorWithHue:250./360 saturation:1 brightness:.8 alpha:1].CGColor;
    
    CABasicAnimation *animation;
    animation                = [self animationWithKeyPath:@"path"];
    animation.toValue        = (__bridge id)[UIBezierPath bezierPathWithOvalInRect:CGRectInset(drawingBounds, 1, 1)].CGPath;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [layer addAnimation:animation forKey:animation.keyPath];
    
    animation           = [self animationWithKeyPath:@"fillColor"];
    animation.fromValue = (__bridge id)[UIColor colorWithHue:250./360 saturation:.9 brightness:.9 alpha:.85].CGColor;
    [layer addAnimation:animation forKey:animation.keyPath];
}

- (CABasicAnimation *)animationWithKeyPath:(NSString *)keyPath {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:keyPath];
    animation.autoreverses = YES;
    animation.repeatCount  = HUGE_VALF;
    animation.duration     = 1;
    return animation;
}

@end
