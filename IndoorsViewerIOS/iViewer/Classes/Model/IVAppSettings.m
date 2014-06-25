//
//  IVAppSettings.m
//  iViewer
//
//  Created by Mina Haleem on 24.03.13.
//  Copyright (c) 2013 Mina Haleem. All rights reserved.
//

#import "IVAppSettings.h"

@interface IVAppSettings()
@property(nonatomic,strong) NSUserDefaults *userDefaults;
@end

@implementation IVAppSettings
@synthesize userDefaults;

static NSString *kServerUpdateInterval = @"server_update_interval";
static NSString *kUserName = @"user_name";
static NSString *kIsResetAPIKey = @"is_reset_api_key_option";

+ (IVAppSettings *)appSettings {
    static IVAppSettings *_appSettings;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
		_appSettings = [IVAppSettings new];
    });
    
	return _appSettings;
}

+ (NSUInteger) deviceSystemMajorVersion {
    static NSUInteger _deviceSystemMajorVersion = -1;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *systemVersion = [UIDevice currentDevice].systemVersion;
        _deviceSystemMajorVersion = [[systemVersion componentsSeparatedByString:@"."][0] intValue];
    });
    return _deviceSystemMajorVersion;
}


#pragma mark - Initialization

- (id)init {
	if ((self = [super init])) {
		userDefaults = [NSUserDefaults standardUserDefaults];
		
		// Registers the "default defaults".
		[self registerDefaults];
	}
	
	return self;
}

- (void)registerDefaults {
	NSString *pathStr = [[NSBundle mainBundle] bundlePath];
	NSString *settingsBundlePath = [pathStr stringByAppendingPathComponent:@"Settings.bundle"];
	NSString *finalPath = [settingsBundlePath stringByAppendingPathComponent:@"Root.plist"];
	NSDictionary *settingsDict = [NSDictionary dictionaryWithContentsOfFile:finalPath];
	NSArray *prefSpecifierArray = [settingsDict objectForKey:@"PreferenceSpecifiers"];
	
	// Defaults edited via the settings app.
	NSMutableDictionary *appDefaults = [NSMutableDictionary dictionary];
	for (NSDictionary *prefItem in prefSpecifierArray)
	{
		NSString *keyValueStr = [prefItem objectForKey:@"Key"];
		id defaultValue = [prefItem objectForKey:@"DefaultValue"];
		
		if (keyValueStr != nil) {
			[appDefaults setObject:defaultValue forKey:keyValueStr];
		}
	}
	
	// Register the "default defaults".
	[userDefaults registerDefaults:appDefaults];
}

#pragma mark - Accessors

- (BOOL)isResetAPIKeyOptionSelected {
    return [userDefaults boolForKey:kIsResetAPIKey];
}

- (void)setResetAPIKeyOption:(BOOL)isResetAPIOptionSelected {
    [self.userDefaults setBool:isResetAPIOptionSelected forKey:kIsResetAPIKey];
    [self.userDefaults synchronize];
}

- (NSTimeInterval)serverUpdateInterval {
	return [userDefaults doubleForKey:kServerUpdateInterval];
}

- (void)saveUserName:(NSString*)userName {
    [self.userDefaults setObject:userName forKey:kUserName];
    [self.userDefaults synchronize];
}

- (NSString*)getUserName {
    NSString* userName = [self.userDefaults objectForKey:kUserName];
    
    if (userName && userName!= nil) {
        return userName;
    }
    
    return @"";
}

@end
