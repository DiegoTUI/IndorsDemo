//
//  IVUserLocationAccuracyView.m
//  iViewer
//
//  Created by Mina Haleem on 06.04.13.
//  Copyright (c) 2013 Mina Haleem. All rights reserved.
//

#import "ISUserLocationAccuracyView.h"

@implementation ISUserLocationAccuracyView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(ctx);

    CGContextSetRGBFillColor(ctx, 0, 120/255.0, 210/255.0, 0.2);
    CGContextFillEllipseInRect(ctx, rect);
    UIGraphicsPopContext();
}


@end
