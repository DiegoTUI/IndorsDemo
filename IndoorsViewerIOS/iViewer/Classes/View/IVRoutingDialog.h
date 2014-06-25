//
//  IVRoutingDialog.h
//  iViewer
//
//  Created by Mina Haleem on 25.04.13.
//  Copyright (c) 2013 Mina Haleem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Indoors/IDSCoordinate.h>

@class IVRoutingDialog;

@protocol IVRoutingDialogDelegate <NSObject>
- (void)routingDialogLetUserSelectLocation:(IVRoutingDialog*)routingDialog;
- (void)routingDialogUserDidCancel:(IVRoutingDialog*)routingDialog;
- (void)routingDialog:(IVRoutingDialog*)routingDialog routeUserFromLocation:(IDSCoordinate*)from toLocation:(IDSCoordinate*)to;
@end

@interface IVRoutingDialog : UIViewController
@property(nonatomic,strong)id<IVRoutingDialogDelegate> delegate;
@property (nonatomic) BOOL waitingForUserToSelectLocation;
@property (nonatomic, strong) IDSCoordinate* userCurrentLocation;

- (void)setRoutingStartPoint:(IDSCoordinate*) fromCoordinate;
- (void)setRoutingEndPoint:(IDSCoordinate*) toCoordinate;
- (void)userDidSelectLocationFromMap:(IDSCoordinate*)coordinate;
@end
