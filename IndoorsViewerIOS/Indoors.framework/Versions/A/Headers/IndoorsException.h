//
//  IndoorsException.h
//  Indoors
//
//  Created by Gerhard Zeissl on 02.12.12.
//  Copyright (c) 2012 Indoors. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IndoorsErrorCode.h"

@interface IndoorsException : NSException

/**
 * Exception for the Indoors library.
 *
 * <p>
 * We're using RuntimeException for now to not force the caller to handle this.
 * Might change this later on.
 * <p>
 *
 * @author customlbs | Markus Krainz
 *
 */

+ (id)raiseWithException:(NSException*)e;
+ (void)raiseWithMessage:(NSString*)message;
+ (void)raise:(NSString*)name andMessage:(NSString*)message;
+ (void) raiseWithException:(NSException*)exception withMessage:(NSString*)message andErrorCode:(IndoorsErrorCode)errorcode;
- (id)init;
- (IndoorsErrorCode) getErrorCode;

@end
