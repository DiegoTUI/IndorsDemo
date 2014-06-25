//
//  IVEmptyMainViewController.m
//  iViewer
//
//  Created by Mina Haleem on 30.08.13.
//  Copyright (c) 2013 Mina Haleem. All rights reserved.
//

#import "IVEmptyMainViewController.h"

@interface IVEmptyMainViewController ()

@end

@implementation IVEmptyMainViewController

- (void)viewDidLoad {
    UIImageView* splashScreenView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    splashScreenView.image = [UIImage imageNamed:@"Default"];
    
    [self.view addSubview:splashScreenView];
}
@end
