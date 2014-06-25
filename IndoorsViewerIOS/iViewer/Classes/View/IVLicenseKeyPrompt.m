//
//  IVLicenseKeyPrompt.m
//  iViewer
//
//  Created by Jonas Keisel on 7/8/13.
//  Copyright (c) 2013 Mina Haleem. All rights reserved.
//

#import "IVLicenseKeyPrompt.h"

@interface IVLicenseKeyPrompt () <UITextFieldDelegate>
@property (readonly) UITextField *textField;
@end

@implementation IVLicenseKeyPrompt

- (id)initWithDelegate:(id)delegate {
    self = [super initWithTitle:NSLocalizedString(@"API Key", @"")
                        message:NSLocalizedString(@"Please enter or scan your API key.\nYou can create a new key at\nmy.indoo.rs", @"")
                       delegate:delegate
              cancelButtonTitle:nil
              otherButtonTitles:NSLocalizedString(@"Validate", @""),NSLocalizedString(@"Scan QR",@""), nil];
    
    if (self) {
        self.alertViewStyle = UIAlertViewStylePlainTextInput;
    }
    
    return self;
}

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
           delegate:(id)delegate
  cancelButtonTitle:(NSString *)cancelButtonTitle
      okButtonTitle:(NSString *)okButtonTitle;
{
    self = [super initWithTitle:title
                        message:message
                       delegate:delegate
              cancelButtonTitle:nil
              otherButtonTitles:okButtonTitle,@"Scan QR", nil];
    
    if (self) {
        self.alertViewStyle = UIAlertViewStylePlainTextInput;
    }
    
    return self;
}

- (UITextField *)textField {
    return [self textFieldAtIndex:0];
}

- (void)show {
    [self.textField becomeFirstResponder];
    [super show];
}

- (NSString *)enteredLicenseKey {
    return self.textField.text;
}

- (void)setEnteredLicenseKey:(NSString *)enteredLicenseKey {
    self.textField.text = enteredLicenseKey;
}

@end
