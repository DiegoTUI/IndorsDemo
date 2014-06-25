//
//  IVViewController.m
//  iViewer
//
//  Created by Mina Haleem on 28.07.13.
//  Copyright (c) 2013 Mina Haleem. All rights reserved.
//

#import "IVViewController.h"
#import "IVAppSettings.h"

@interface IVViewController ()

@end

@implementation IVViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Public
- (CGSize)size {
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    CGRect bounds = CGRectZero;
    
    if ([IVAppSettings deviceSystemMajorVersion] >= 7) {
        bounds = [[UIScreen mainScreen] bounds];
    }
    else {
         bounds = [[UIScreen mainScreen] applicationFrame];
    }
    
    CGSize size = bounds.size;
    
    // let's figure out if width/height must be swapped
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        // we're going to landscape, which means we gotta swap them
        size.width = bounds.size.height;
        size.height = bounds.size.width;
    }
    
    return size;
}
@end
