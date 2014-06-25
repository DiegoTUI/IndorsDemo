//
//  IVLicenseKeyPrompt.h
//  iViewer
//
//  Created by Jonas Keisel on 7/8/13.
//  Copyright (c) 2013 Mina Haleem. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IVLicenseKeyPrompt : UIAlertView

@property (strong, readonly) NSString *enteredLicenseKey;

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
           delegate:(id)delegate
  cancelButtonTitle:(NSString *)cancelButtonTitle
      okButtonTitle:(NSString *)okButtonTitle;

- (id)initWithDelegate:(id)delegate;
- (NSString *)enteredLicenseKey;
- (void)setEnteredLicenseKey:(NSString *)enteredLicenseKey;

@end
