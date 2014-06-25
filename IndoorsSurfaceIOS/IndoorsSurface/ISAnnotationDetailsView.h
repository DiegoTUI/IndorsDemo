//
//  IVAnnotationDetailsView.h
//  iViewer
//
//  Created by Mina Haleem on 24.03.13.
//  Copyright (c) 2013 Mina Haleem. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ISAnnotationDetailsView : UIView
@property (nonatomic, strong, readonly) UILabel *textLabel;
@property (nonatomic, strong, readonly) UILabel *detailTextLabel;
@property (nonatomic, copy) dispatch_block_t callButtonTappedBlock;
@property (nonatomic, assign) BOOL callButtonEnabled;
@end
