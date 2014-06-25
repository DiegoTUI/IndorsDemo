//
//  IVRoutingDialog.m
//  iViewer
//
//  Created by Mina Haleem on 25.04.13.
//  Copyright (c) 2013 Mina Haleem. All rights reserved.
//

#import "IVRoutingDialog.h"
#import "IDSCoordinate+String.h"
#import "IVErrorHandler.h"
#import "ConstantsStrings.h"
#import <QuartzCore/QuartzCore.h>

typedef enum {
    IVRoutingStartPoint,
    IVRoutingEndPoint,
    IVRoutingNotDefinedPoint
} IVRoutingPoint;

@interface IVRoutingDialog() <UIActionSheetDelegate>

@property (nonatomic,strong)IBOutlet UILabel* fromLabel;
@property (nonatomic,strong)IBOutlet UILabel* toLabel;

@property (nonatomic,strong)IBOutlet UIButton* fromLocationFromMapButton;
@property (nonatomic,strong)IBOutlet UIButton* toLocationFromMapButton;

@property (nonatomic,strong) IDSCoordinate* startPointCoordinate;
@property (nonatomic,strong) IDSCoordinate* endPointCoordinate;

@property (nonatomic,strong) UIColor* selectedTextColor;
@property (nonatomic,strong) UIColor* notSelectedTextColor;

@property (nonatomic)IVRoutingPoint currentSelectedRoutingPoint;

@end

@implementation IVRoutingDialog

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        self.selectedTextColor = [UIColor colorWithRed:3/255.0 green:171/255.0 blue:180/255.0 alpha:1.0];
        self.notSelectedTextColor = [UIColor lightGrayColor];
        
        self.currentSelectedRoutingPoint = IVRoutingNotDefinedPoint;
    }
    
    return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    [self adjustSelectedButtons];
    
    if (self.startPointCoordinate) {
        [self.fromLocationFromMapButton setTitle:[NSString stringWithFormat:@"Map: %@",[self.startPointCoordinate string]] forState:UIControlStateNormal];
    }
    if (self.endPointCoordinate) {
        [self.toLocationFromMapButton setTitle:[NSString stringWithFormat:@"Map: %@",[self.endPointCoordinate string]] forState:UIControlStateNormal];
    }
    
    self.fromLabel.text = NSLocalizedString(@"Start Point", @"Start Point");
    self.toLabel.text = NSLocalizedString(@"End Point", @"End Point");
    
    self.title = NSLocalizedString(@"Routing", @"Routing");
}

- (BOOL)shouldAutorotate {
    return YES;
}

#pragma mark - IBAction
- (IBAction)routeButtonTapped:(id)sender {    
    [self startRouting];
}

- (IBAction)cancelButtonTapped:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(routingDialogUserDidCancel:)]) {
        [self.delegate routingDialogUserDidCancel:self];
    }
}

- (IBAction)pickFromLocationButtonAction:(id)sender {
    [self presentActionSheetForRoutingPoint:IVRoutingStartPoint];
}

- (IBAction)pickToLocationButtonAction:(id)sender {
    [self presentActionSheetForRoutingPoint:IVRoutingEndPoint];
}

- (void)presentActionSheetForRoutingPoint:(IVRoutingPoint)routingPoint
{
    self.currentSelectedRoutingPoint = routingPoint;
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Please pick a location" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Use current position", @"Pick a location from the map", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    
    [actionSheet showInView:self.view.superview];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            if (self.currentSelectedRoutingPoint == IVRoutingStartPoint) [self setRoutingStartPoint:self.userCurrentLocation];
            else [self setRoutingEndPoint:self.userCurrentLocation];
            break;
        case 1:
            [self pickLocationFromMap];
            break;
        default:
            break;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

#pragma mark - Private
- (void)pickLocationFromMap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(routingDialogLetUserSelectLocation:)]) {
        self.waitingForUserToSelectLocation = YES;
        [self.delegate routingDialogLetUserSelectLocation:self];
    }
}

- (void)adjustSelectedButtons {
    if (self.startPointCoordinate) {
        [self.fromLocationFromMapButton setTitleColor:self.selectedTextColor forState:UIControlStateNormal];
    } else {
        [self.fromLocationFromMapButton setTitleColor:self.notSelectedTextColor forState:UIControlStateNormal];
    }
    
    if (self.endPointCoordinate) {
        [self.toLocationFromMapButton setTitleColor:self.selectedTextColor forState:UIControlStateNormal];
    } else {
        [self.toLocationFromMapButton setTitleColor:self.notSelectedTextColor forState:UIControlStateNormal];
    }
}

- (void)roundCornerView:(UIView*)view {
    view.layer.cornerRadius = 10;
    view.layer.borderWidth = 1.0f;
    view.layer.borderColor = [UIColor blackColor].CGColor;
    view.layer.masksToBounds = YES;
}

- (void)startRouting {
    if (self.startPointCoordinate != nil && self.endPointCoordinate != nil) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(routingDialog:routeUserFromLocation:toLocation:)]) {
            [self.delegate routingDialog:self routeUserFromLocation:self.startPointCoordinate toLocation:self.endPointCoordinate];
        }
    } else {
        [[IVErrorHandler shareHandler] showErrorWithTitle:nil message:ERROR_MSG_ROUTING_SHOULD_SELECT_START_END];
    }
}

#pragma mark - Public
- (void)setRoutingStartPoint:(IDSCoordinate*) coordinate {
    self.startPointCoordinate = coordinate;
    NSString* str = [NSString stringWithFormat:@"Map: %@",[coordinate string]];
    [self.fromLocationFromMapButton setTitle:str forState:UIControlStateNormal];
    [self adjustSelectedButtons];
}

- (void)setRoutingEndPoint:(IDSCoordinate*) cooridnate {
    self.endPointCoordinate = cooridnate;
    NSString* str = [NSString stringWithFormat:@"Map: %@",[cooridnate string]];
    [self.toLocationFromMapButton setTitle:str forState:UIControlStateNormal];
    [self adjustSelectedButtons];
}

- (void)userDidSelectLocationFromMap:(IDSCoordinate*)cooridnate {
    
    if (self.currentSelectedRoutingPoint == IVRoutingStartPoint) {
        [self setRoutingStartPoint:cooridnate];
    } else if (self.currentSelectedRoutingPoint == IVRoutingEndPoint) {
        [self setRoutingEndPoint:cooridnate];
    }
    
    self.waitingForUserToSelectLocation = NO;
}
@end
