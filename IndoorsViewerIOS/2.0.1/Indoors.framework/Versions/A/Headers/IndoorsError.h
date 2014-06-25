//
//  IndoorsError.h
//  Indoors
//
//  Created by Gerhard Zeissl on 06.02.13.
//  Copyright (c) 2013 Indoors. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IndoorsErrorCode.h"


#define IndoorsErrorDomain @"IndoorsErrorDomain"

@class IndoorsError;

@protocol IndoorsErrorDelegate <NSObject>

/**
 * Delegate method for Indoors Error.
 * @param indoorsException
 */
- (void)onError:(IndoorsError*)indoorsError;

@end

@interface IndoorsError : NSObject
- (id)initWithErrorCode:(IndoorsErrorCode)error;
@property(nonatomic) IndoorsErrorCode errorCode;
@end