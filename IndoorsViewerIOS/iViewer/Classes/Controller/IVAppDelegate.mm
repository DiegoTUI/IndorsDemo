//
//  IVAppDelegate.m
//  iViewer
//
//  Created by Mina Haleem on 24.03.13.
//  Copyright (c) 2013 Mina Haleem. All rights reserved.
//

#import "IVAppDelegate.h"

#import <CoreBluetooth/CoreBluetooth.h>

#import "IVMainViewController.h"
#import "ConstantsStrings.h"
#import "IVErrorHandler.h"
#import "IVLicenseKeyPrompt.h"
#import "KeychainItemWrapper.h"
#import "IVEmptyMainViewController.h"
#import "IVAppSettings.h"
#import "IVSurfaceViewController.h"
#import "MBProgressHUD.h"
#import <Indoors/IndoorsError.h>
#import "Crittercism.h"
#import "IVQRScannerController.h"

// app acts pretty much like a MyFirstIndoorsApp when defining this
//#define INDOORS_SHOULD_USE_NEW_API

@interface IVAppDelegate() <IVQRScannerControllerDelegate>
@property (strong, nonatomic) IVEmptyMainViewController *emptyMainViewController;
@property (strong, nonatomic) KeychainItemWrapper *keychainItemWrapper;
@property (strong, nonatomic) NSString *triedAPIKey;
@property (nonatomic) BOOL cachedAPIKeyUsed;
@end

@implementation IVAppDelegate

@synthesize window = _window;
@synthesize indoors;
@synthesize mainViewController;
@synthesize emptyMainViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Crittercism enableWithAppID:@"52d9154097c8f20405000006"];
    
    [self configureAppearance];
    
#ifdef INDOORS_SHOULD_USE_NEW_API
    IVSurfaceViewController* surfaceViewController = [IVSurfaceViewController new];
    
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _window.rootViewController = surfaceViewController;
    [_window makeKeyAndVisible];
#else
    
    //We should have a Window to be able to present and control any ViewController
    self.emptyMainViewController = [IVEmptyMainViewController new];
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _window.rootViewController = self.emptyMainViewController;
    [_window makeKeyAndVisible];
    
    self.keychainItemWrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"Indoors.iViewer" accessGroup:nil];
    
    // DEV: Uncomment to delete API Key stored in Keychain
    //[self.keychainItemWrapper resetKeychainItem];

    
#ifdef INDOORS_LICENSE_KEY
    self.cachedAPIKeyUsed = YES;
    [self setupWithAPIKey:INDOORS_LICENSE_KEY];
#else
    NSString *apiKey = [self.keychainItemWrapper objectForKey:(__bridge id)kSecAttrAccount];
    if (apiKey && ![apiKey isEqualToString:@""]) {
        self.cachedAPIKeyUsed = YES;
        [self setupWithAPIKey:apiKey];
    } else {
        [self showLicenseKeyPrompt];
    }
#endif
    
#endif
    
    return YES;
}

- (void)showLicenseKeyPromptWithValue:(NSString*)licenseKey {
    IVLicenseKeyPrompt *licenseKeyPrompt = [[IVLicenseKeyPrompt alloc] initWithDelegate:self];
    [licenseKeyPrompt setEnteredLicenseKey:licenseKey];
    [licenseKeyPrompt show];
}

- (void)showLicenseKeyPrompt {
    [self showLicenseKeyPromptWithValue:@""];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //Validate button, we can't compare with title as we may implement Localization to the text
    if (buttonIndex == 0) {
        [self setupWithAPIKey:((IVLicenseKeyPrompt *)alertView).enteredLicenseKey];
    } else if (buttonIndex ==1) {
        [self scanLicenseKey];
    } else if (buttonIndex == [alertView cancelButtonIndex]) {
        exit(0);
    }
}

- (void)scanLicenseKey {
    IVQRScannerController *qrScannerVC = [[IVQRScannerController alloc] initWithNibName:nil bundle:nil];
    qrScannerVC.delegate = self;
    [_window.rootViewController presentViewController:qrScannerVC animated:YES completion:nil];
}

- (void)setupWithAPIKey:(NSString *)apiKey {
    self.triedAPIKey = apiKey;
    self.indoors = [[Indoors alloc] initWithLicenseKey:apiKey andServiceDelegate:self];
}

- (UIImage *)stretchableImageNamed:(NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    return [image resizableImageWithCapInsets:UIEdgeInsetsZero];
}

- (void)configureAppearance {
    NSDictionary *titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                         [UIFont fontWithName:@"PTSans-Bold" size:22.0], UITextAttributeFont,
                                         [UIColor whiteColor], UITextAttributeTextColor,
                                         [UIColor blackColor], UITextAttributeTextShadowColor,
                                         [NSValue valueWithCGPoint:CGPointMake(0, -1)], UITextAttributeTextShadowOffset,
                                         nil];
     
    [[UITableViewCell appearance] setSelectionStyle:UITableViewCellSelectionStyleGray];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    //Check if user selected to reset API key
    if ([[IVAppSettings appSettings] isResetAPIKeyOptionSelected]) {
        [self.keychainItemWrapper resetKeychainItem];
        [[IVAppSettings appSettings] setResetAPIKeyOption:NO];
        
#ifndef INDOORS_LICENSE_KEY
        [self showLicenseKeyPrompt];
#endif
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - IndoorsServiceDelegate

- (void)connected {
    NSLog(@"Key authenticated and service connected");
    
    [self.keychainItemWrapper setObject:self.triedAPIKey forKey:(__bridge id)kSecAttrAccount];
    
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.mainViewController = [IVMainViewController new];
    _window.rootViewController = mainViewController;
    [_window makeKeyAndVisible];
    
    if (!self.cachedAPIKeyUsed) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:_window.rootViewController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"API key accepted.";
        [hud hide:YES afterDelay:2.5];
    }
    
    self.cachedAPIKeyUsed = NO;
    self.triedAPIKey = nil;
}

- (void) onError:(IndoorsError*) indoorsError {
    if (indoorsError.errorCode == INDOORS_ERROR_AUTH_LICENSE_NOTEXISTING) {
        [[IVErrorHandler shareHandler] showErrorWithTitle:nil message:ERROR_MSG_API_KEY_NOT_VALID];
        [self showLicenseKeyPromptWithValue:self.triedAPIKey];
    }
    else if (indoorsError.errorCode == INDOORS_ERROR_AUTH_LICENSE_EXCEEDED) {
        [[IVErrorHandler shareHandler] showErrorWithTitle:nil message:ERROR_MSG_API_KEY_EXCEEDED];
        [self showLicenseKeyPrompt];
    }
}

- (void)bluetoothStateDidChange:(IDSBluetoothState)bluetoothState
{
    if (IDSBluetoothStateUnavailable == bluetoothState) {
        NSLog(@"Bluetooth unavailable");
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"
        [[CBCentralManager alloc] initWithDelegate:nil queue:nil options:@{ CBCentralManagerOptionShowPowerAlertKey : [NSNumber numberWithBool:YES] }];
#pragma clang diagnostic pop
    } else if (IDSBluetoothStateAvailable == bluetoothState) {
        NSLog(@"Bluetooth available");
    } else {
        NSAssert(NO, @"Unknown bluetoothstate.");
    }
}

#pragma mark - IVQRScannerViewControllerDelegate

- (void)qrScannerController:(IVQRScannerController *)controller didScanResult:(NSString *)result
{
    [_window.rootViewController dismissViewControllerAnimated:YES completion:^{
        [self setupWithAPIKey:result];
    }];
}

- (void)qrScannerControllerDidCancel:(IVQRScannerController *)controller
{
    [_window.rootViewController dismissViewControllerAnimated:YES completion:^{
        [self showLicenseKeyPrompt];
    }];
}
@end
