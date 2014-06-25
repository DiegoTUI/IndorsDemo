//
//  main.m
//  iViewer
//
//  Created by Mina Haleem on 24.03.13.
//  Copyright (c) 2013 Mina Haleem. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "IVAppDelegate.h"

int main(int argc, char *argv[])
{
    // Run this application as root (on jailbroken devices only)
    //setuid(0);
    //setgid(0);
    
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([IVAppDelegate class]));
    } 
}
