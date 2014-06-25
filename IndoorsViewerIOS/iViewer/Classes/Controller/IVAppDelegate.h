//
//  IVAppDelegate.h
//  iViewer
//
//  Created by Mina Haleem on 24.03.13.
//  Copyright (c) 2013 Mina Haleem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Indoors/IndoorsDelegate.h>
#import <Indoors/Indoors.h>
#import "IVMainViewController.h"

@interface IVAppDelegate : UIResponder <UIApplicationDelegate, IndoorsServiceDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) Indoors* indoors;
@property (strong, nonatomic) IVMainViewController *mainViewController;

@end
