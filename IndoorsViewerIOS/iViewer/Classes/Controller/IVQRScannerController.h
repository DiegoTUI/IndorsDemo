//
//  IVQRScannerController.h
//  indoo.rs
//
//  Created by Dominik Hofer on 08/04/14.
//  Copyright (c) 2014 indoo.rs. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AVFoundation/AVFoundation.h>

@protocol IVQRScannerControllerDelegate;

@interface IVQRScannerController : UIViewController <AVCaptureMetadataOutputObjectsDelegate>
@property (weak, nonatomic) id<IVQRScannerControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIView *viewPreview;
@end

@protocol IVQRScannerControllerDelegate <NSObject>
- (void)qrScannerController:(IVQRScannerController *)controller didScanResult:(NSString *)result;
- (void)qrScannerControllerDidCancel:(IVQRScannerController *)controller;
@end