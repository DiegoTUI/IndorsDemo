//
//  IndoorsBuilder.h
//  indoo.rs 
//
//  Created by Mina Haleem on 08.08.13.
//  Copyright (c) 2013 indoo.rs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IndoorsDelegate.h"

@interface IndoorsBuilder : NSObject

/*!
 @method setApiKey:
 @discussion
 Set your indoo.rs License API key to be able to access any indoo.rs service.
 Use given API key to authenticate to indoo.rs service.
 
 @param apiKey
 indoo.rs License API key
 */
- (void)setApiKey:(NSString*)apiKey;

/*!
 @method setBuildingId:
 @discussion
 Set the building ID, that the builder will load once connected successfully to the indoo.rs service.
 
 @param buildingId
 indoo.rs building ID to be loaded.
 */
- (void)setBuildingId:(NSInteger)buildingId;

/*!
 @method getBuildingId
 @discussion
 Get current building ID to be loaded
 
 @return building ID that will be used to load.
 */
- (NSInteger)getBuildingId;

- (void)enableEvaluationMode:(BOOL)isEvaluationModeEnabled;

- (BOOL)isEvaluationModeEnabled;

/*!
 @discussion 
 Build IndoorsBuilder, this method is starting the Authentication and then loading the building.
 You can't change any property or update any values after calling this method.
 If you try to change anything after calling this method the application will throw an error.
 */
- (void)build;


@property (nonatomic, strong) id<LoadingBuildingDelegate> loadingBuildingServiceCallBack;
@property (nonatomic, strong) id<IndoorsServiceDelegate> authenticationServiceCallBack;
@end
