//
//  IVMainViewController.h
//  iViewer
//
//  Created by Mina Haleem on 24.03.13.
//  Copyright (c) 2013 Mina Haleem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IVViewController.h"
#import <Indoors/IDSBuilding.h>
#import <Indoors/IDSZone.h>

@interface IVMainViewController : IVViewController <UIToolbarDelegate>
@property (nonatomic) IDSBuilding *loadedBuilding;

- (void)showWebViewWithFilePath:(NSString *)filePath;
- (void)showRouteToZone:(IDSZone *)zone;
@end
