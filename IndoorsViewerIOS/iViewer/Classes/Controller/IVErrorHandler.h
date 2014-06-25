//
//  IVErrorHandler.h
//  iViewer
//
//  Created by Mina Haleem on 04.04.13.
//  Copyright (c) 2013 Mina Haleem. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IVErrorHandler : NSObject
+(IVErrorHandler*)shareHandler;

- (void)showErrorWithTitle:(NSString*)errorTitle message:(NSString*)msg;
@end
