//
//  IndoorsServiceCallbackImp.h
//  IndoorsSurface
//
//  Created by Mina Haleem on 10.08.13.
//  Copyright (c) 2013 Indoors GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Indoors/IndoorsDelegate.h>
#import "ISIndoorsSurface.h"

@interface IndoorsServiceCallbackImp : NSObject <LoadingBuildingDelegate>
- (id)initWithSurface:(ISIndoorsSurface*) surface;
@property (nonatomic, strong) id<LoadingBuildingDelegate> loadingBuildingServiceCallBack;
@end
