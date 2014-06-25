//
//  IVErrorHandler.m
//  iViewer
//
//  Created by Mina Haleem on 04.04.13.
//  Copyright (c) 2013 Mina Haleem. All rights reserved.
//

#import "IVErrorHandler.h"

static IVErrorHandler* sharedInstance = nil;
@interface IVErrorHandler()
@property(strong, nonatomic) UIAlertView* alertView;
@end

@implementation IVErrorHandler
@synthesize alertView;

+(IVErrorHandler*)shareHandler {
    @synchronized(self) {
        if (!sharedInstance || sharedInstance == nil) {
            sharedInstance = [[IVErrorHandler alloc] init];
        }
    }
    
    return sharedInstance;
}

- (id)init {
    self = [super init];
    
    if (self) {
        self.alertView = nil;
    }
    
    return self;
}

#pragma mark - Public methods
- (void)showErrorWithTitle:(NSString*)errorTitle message:(NSString*)msg {
    if (errorTitle == nil) {
        errorTitle = NSLocalizedString(@"Error", @"Error");
    }

    if (self.alertView == nil) {
        self.alertView = [[UIAlertView alloc] initWithTitle:errorTitle message:msg delegate:self cancelButtonTitle:NSLocalizedString(@"Ok", @"Ok") otherButtonTitles:nil];
        [self.alertView performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
    }
}

#pragma mark - UIAlertViewDelegate 
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    self.alertView = nil;
}

@end
