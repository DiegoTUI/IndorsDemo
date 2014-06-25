//
//  IVUtils.h
//  iViewer
//
//  Created by Mina Haleem on 26.03.13.
//  Copyright (c) 2013 Mina Haleem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Indoors/IDSZone.h>

@interface IVUtils : NSObject
+ (void)setButtonImages:(UIButton*) btn normalStateImage:(UIImage*)image selectedStateImage:(UIImage*)selectedImage disabledStateImage:(UIImage*)disabledStateImage;
+ (UIButton*)btnWithImage:(UIImage*) btnImage andSelectedImage:(UIImage*)btnSelectedImage;
+ (UIBarButtonItem*) barButtonItemWithImage:(UIImage*) btnImage andSelectedImage:(UIImage*)btnSelectedImage width:(float)btnWidth target:(id)target action:(SEL)selector;
@end
