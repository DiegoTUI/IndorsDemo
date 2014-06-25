//
//  IVUserAnnotationView.h
//  iViewer
//
//  Created by Jonas Keisel on 7/18/13.
//  Copyright (c) 2013 Mina Haleem. All rights reserved.
//

#import "ISAnnotationView.h"

@interface ISUserAnnotationView : ISAnnotationView

@property (nonatomic) CGFloat orientation;

- (instancetype)initWithCoordinate:(IDSCoordinate *)coordinate customImage:(UIImage*)customImage;
- (void)updateAccuracy:(NSInteger)accuracyWithScale;

@end
