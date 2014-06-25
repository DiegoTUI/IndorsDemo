//
//  IVAppSettings.h
//  iViewer
//
//  Created by Mina Haleem on 24.03.13.
//  Copyright (c) 2013 Mina Haleem. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IVAppSettings : NSObject
@property (nonatomic, readonly) NSTimeInterval serverUpdateInterval;

- (void)saveUserName:(NSString*)userName;
- (NSString*)getUserName;

- (BOOL)isResetAPIKeyOptionSelected;
- (void)setResetAPIKeyOption:(BOOL)isResetAPIOptionSelected;

+ (IVAppSettings *)appSettings;
+ (NSUInteger) deviceSystemMajorVersion;
@end
