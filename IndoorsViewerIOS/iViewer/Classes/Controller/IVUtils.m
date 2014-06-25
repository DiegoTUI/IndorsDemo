//
//  IVUtils.m
//  iViewer
//
//  Created by Mina Haleem on 26.03.13.
//  Copyright (c) 2013 Mina Haleem. All rights reserved.
//

#import "IVUtils.h"
#import <Indoors/IDSZonePoint.h>

@implementation IVUtils

+ (void)setButtonImages:(UIButton*) btn normalStateImage:(UIImage*)image selectedStateImage:(UIImage*)selectedImage disabledStateImage:(UIImage*)disabledStateImage {
    [btn setImage:image forState:UIControlStateNormal];
    
    [btn setImage:selectedImage forState:UIControlStateSelected];
    [btn setImage:selectedImage forState:UIControlStateHighlighted];
    
    [btn setImage:disabledStateImage forState:UIControlStateDisabled];
    
    btn.showsTouchWhenHighlighted = YES;
}

+ (UIButton*)btnWithImage:(UIImage*) btnImage andSelectedImage:(UIImage*)btnSelectedImage {
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [[self class]setButtonImages:button normalStateImage:btnImage selectedStateImage:btnSelectedImage disabledStateImage:nil];
    
    return button;
}

+ (UIBarButtonItem*) barButtonItemWithImage:(UIImage*) btnImage andSelectedImage:(UIImage*)btnSelectedImage width:(float)btnWidth target:(id)target action:(SEL)selector {
    UIButton* button = [[self class]btnWithImage:btnImage andSelectedImage:btnSelectedImage];
    
    [button setFrame:CGRectMake(0, 0, btnWidth, 34)];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    return barButtonItem;
}
@end
