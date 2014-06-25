//
//  IVMainViewController.m
//  iViewer
//
//  Created by Mina Haleem on 24.03.13.
//  Copyright (c) 2013 Mina Haleem. All rights reserved.
//

#import "IVMainViewController.h"
#import "MBProgressHUD.h"
#import "IVBuildingSelectionViewController.h"
#import <Indoors/Indoors.h>
#import <Indoors/IDSCoordinate.h>
#import "IVUtils.h"
#import <Indoors/IndoorsDelegate.h>
#import "ConstantsStrings.h"
#import "IVSettingsViewController.h"
#import "IVErrorHandler.h"
#import "IVAppDelegate.h"
#import "IVRoutingDialog.h"
#import "IVAppSettings.h"
#import <IndoorsSurface/ISIndoorsSurface.h>
#import "IVBuildingFloorsView.h"
#import <IndoorsSurface/IndoorsSurfaceLocationManager.h>
#import "MZFormSheetController.h"
#import "IVLegalTableViewController.h"
#import "IVZonesTableViewController.h"
#import "ISToast+UIView.h"

#define ROUTING_ALERT_DIALOG_TAG 0
#define ROUTING_ALERT_NO_MAP_SELECTED_DIALOG_TAG 1

@interface IVMainViewController () <IVRoutingDialogDelegate, RoutingDelegate, IndoorsSurfaceViewDelegate, IVBuildingFloorsViewDelegate, OnlineBuildingDelegate, LoadingBuildingDelegate, IndoorsSurfaceLocationManagerDelegate>
@property (nonatomic, strong) UIView* contentView;
@property (nonatomic, strong) ISIndoorsSurface* surfaceView;
@property (nonatomic, strong) IVRoutingDialog* routingDialog;

@property (nonatomic, strong) UINavigationController* routingNavigationController;
@property (nonatomic, strong) IVBuildingSelectionViewController *buildingsSelectionVC;
@property (nonatomic, strong) IVLegalTableViewController *legalVC;
@property (nonatomic, strong) IVZonesTableViewController *zonesVC;

@property (nonatomic, strong) UIPopoverController *myPopover;
@property (nonatomic, strong) UIPopoverController *legalPopover;
@property (nonatomic, strong) UIPopoverController *zonesPopover;
@property (nonatomic, strong) UIToolbar* topToolBar;
@property (nonatomic) UIBarButtonItem *selectBuildingBarButton;
@property (nonatomic) UIBarButtonItem *logoBarButton;
@property (nonatomic) UIBarButtonItem *zonesBarButton;

@property (nonatomic, strong) MBProgressHUD* progressHUD;

@property (nonatomic, strong) NSArray* routingPath;

@property (nonatomic, strong) IndoorsSurfaceLocationManager* locationManager;

@property (nonatomic, strong) IVBuildingFloorsView* floorSelectorView;

@property (nonatomic, strong) UIButton* locateMeButton;
@property (nonatomic) int userCurrentFloorLevel;
@property (nonatomic, strong) IDSCoordinate* userCurrentLocation;

@property (nonatomic, strong) UIImageView* logoView;
@end

@implementation IVMainViewController

#pragma mark - Getter and Setter

- (IVRoutingDialog *)routingDialog
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _routingDialog = [[IVRoutingDialog alloc] initWithNibName:@"IVRoutingDialog" bundle:nil];
        _routingDialog.delegate = self;
    });
    
    return _routingDialog;
}

- (UINavigationController *)routingNavigationController
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _routingNavigationController = [[UINavigationController alloc]initWithRootViewController:self.routingDialog];
    });
    
    return _routingNavigationController;
}

- (void)setUserCurrentLocation:(IDSCoordinate *)userCurrentLocation
{
    _userCurrentLocation = userCurrentLocation;
    self.routingDialog.userCurrentLocation = userCurrentLocation;
}

#pragma mark - View Lifecycle

- (void)loadView {
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    self.surfaceView = [[ISIndoorsSurface alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.surfaceView.enableAutomaticFloorSelection = YES;
    self.surfaceView.delegate = self;
    [self.surfaceView setUserPositionIcon:[UIImage imageNamed:@"maps_location_arrow"]];
    
    [self.contentView addSubview:self.surfaceView];
    [self.view addSubview:self.contentView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([IVAppSettings deviceSystemMajorVersion] >= 7) {
        [self setNeedsStatusBarAppearanceUpdate];
    }

    [self addToolBar];
    [self addFloorSelectorView];
    [self addLocateMeButton];
    [self addLogo];
    
    [self relayoutForInterfaceOrientation:self.interfaceOrientation];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.contentView = nil;
}

- (void)viewWillDisappear:(BOOL)animated {
    [self unregisterFromApplicationEvents];
}

#pragma mark - Adding SubViews
- (void)addToolBar {    
    if ([IVAppSettings deviceSystemMajorVersion] >= 7) {
        self.topToolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 44)];
        self.topToolBar.translucent = NO;
        self.topToolBar.delegate = self;
    } else {
        self.topToolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
        self.topToolBar.translucent = NO;
    }
    
    [self adjustToolBarButtons:NO];
    
    [self.contentView addSubview:self.topToolBar];
}

- (void)adjustToolBarButtons:(BOOL)isRoutingActive {
    NSMutableArray* toolBarItems = [[NSMutableArray alloc]initWithCapacity:0];
    
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    button.adjustsImageWhenHighlighted = NO;
    UIImage *logo = [UIImage imageNamed:@"logo_small"];
    [button setImage:logo forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showLegalView) forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, logo.size.width, logo.size.height)];
    
    self.logoBarButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    if (isRoutingActive) {
        UIBarButtonItem* cancelRoutingButton = [IVUtils barButtonItemWithImage:[UIImage imageNamed:@"ic_menu_route_cancel2"] andSelectedImage:nil width:45 target:self action:@selector(cancelRoutingButtonTapped)];
        
        [toolBarItems addObject:flexibleSpace];
        [toolBarItems addObject:self.logoBarButton];
        [toolBarItems addObject:flexibleSpace];
        [toolBarItems addObject:cancelRoutingButton];
    } else {
        self.selectBuildingBarButton = [IVUtils barButtonItemWithImage:[UIImage imageNamed:@"ic_menu_building"] andSelectedImage:nil width:45 target:self action:@selector(selectBuilding)];
        
        UIBarButtonItem *startRoutingBarButton = [IVUtils barButtonItemWithImage:[UIImage imageNamed:@"ic_menu_route"] andSelectedImage:nil width:45 target:self action:@selector(menuShowRouting)];
        
        self.zonesBarButton = [IVUtils barButtonItemWithImage:[UIImage imageNamed:@"ic_menu_zones"] andSelectedImage:nil width:45 target:self action:@selector(showZonesView)];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                               initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                               target:nil action:nil];
            negativeSpacer.width = -16;
            
            [toolBarItems addObject:self.selectBuildingBarButton];
            [toolBarItems addObject:negativeSpacer];
            [toolBarItems addObject:self.zonesBarButton];
            [toolBarItems addObject:self.logoBarButton];
            [toolBarItems addObject:flexibleSpace];
            [toolBarItems addObject:startRoutingBarButton];
        } else {
            [toolBarItems addObject:self.selectBuildingBarButton];
            [toolBarItems addObject:self.zonesBarButton];
            [toolBarItems addObject:startRoutingBarButton];
            [toolBarItems addObject:flexibleSpace];
            [toolBarItems addObject:self.logoBarButton];
            [toolBarItems addObject:flexibleSpace];
        }
    }
    
    [self.topToolBar setItems:toolBarItems animated:NO];
}

- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar {
    return UIBarPositionTopAttached;
}

- (void)addFloorSelectorView {
    self.floorSelectorView = [[IVBuildingFloorsView alloc]initWithFrame:CGRectZero];
    self.floorSelectorView.delegate = self;
    [self.contentView addSubview:self.floorSelectorView];
    [self.contentView bringSubviewToFront:self.floorSelectorView];
}

- (void)addLocateMeButton {
    self.locateMeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.locateMeButton setImage:[UIImage imageNamed:@"button_my_location.png"] forState:UIControlStateNormal];
    [self.locateMeButton addTarget:self action:@selector(locateMeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.locateMeButton setHidden:YES];
    [self adjustLocateMeButtonPosition];
    [self.contentView addSubview:self.locateMeButton];
    [self.contentView bringSubviewToFront:self.locateMeButton];
}

- (void)addLogo {
    self.logoView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo_small"]];
    
    [self adjustLogoPosition];
    
    [self.contentView addSubview:self.logoView];
    [self.contentView bringSubviewToFront:self.logoView];
}

- (void)adjustFloorsViewPosition {
    CGRect floorsViewFrame = self.floorSelectorView.frame;
    float floorsViewWidth = floorsViewFrame.size.width;
    float floorsViewHeight = floorsViewFrame.size.height;
    
    CGPoint floorsViewCoordinate = CGPointMake(self.contentView.frame.size.width - floorsViewWidth, (self.contentView.frame.size.height - floorsViewHeight ) /2);
    floorsViewFrame.origin = floorsViewCoordinate;
    
    self.floorSelectorView.frame = floorsViewFrame;
    [self.contentView bringSubviewToFront:self.floorSelectorView];
}

- (void)adjustLocateMeButtonPosition {
    [self.locateMeButton setFrame:CGRectMake(20, self.contentView.frame.size.height - 60, 46, 46)];
}

- (void)adjustLogoPosition {
    CGRect logoViewFrame = self.logoView.frame;
    logoViewFrame.origin = CGPointMake(self.contentView.frame.size.width - logoViewFrame.size.width - 15, self.contentView.frame.size.height - logoViewFrame.size.height - 15);
    self.logoView.frame = logoViewFrame;
    
    [self.contentView bringSubviewToFront:self.logoView];
}

- (void)bringSubViewsToFront {
    [self.contentView bringSubviewToFront:self.topToolBar];
    [self.contentView bringSubviewToFront:self.floorSelectorView];
    [self.contentView bringSubviewToFront:self.locateMeButton];
    [self.contentView bringSubviewToFront:self.logoView];
}

#pragma mark - Application Events

- (void)registerForApplicationEvents {
    [[NSNotificationCenter defaultCenter]
	 addObserver:self
     selector:@selector(applicationDidBecomeActive)
     name:UIApplicationDidBecomeActiveNotification
	 object:nil];
    
    [[NSNotificationCenter defaultCenter]
	 addObserver:self
     selector:@selector(applicationWillResignActive)
     name:UIApplicationWillResignActiveNotification
	 object:nil];
}

- (void)unregisterFromApplicationEvents {
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:UIApplicationDidBecomeActiveNotification
	 object:nil];
    
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:UIApplicationWillResignActiveNotification
	 object:nil];
}

#pragma mark - Layout

- (void)relayoutForInterfaceOrientation:(UIInterfaceOrientation)orientation {
    // we grab the screen frame first off; these are always
    // in portrait mode
    CGSize size = [self size];
    
    self.contentView.frame = CGRectMake(0, 0 , size.width, size.height  ) ;
    
    float actualY = self.topToolBar.frame.origin.y + self.topToolBar.frame.size.height;
    
    CGRect surfaceFrame = CGRectMake(0, actualY, size.width, self.contentView.frame.size.height - actualY);
    [self.surfaceView setSize:surfaceFrame];
    
    [self.buildingsSelectionVC setFrame:surfaceFrame];
    
    CGRect toolBarFrame = self.topToolBar.frame;
    toolBarFrame.size.width = size.width;
    [self.topToolBar setFrame:toolBarFrame];
    
    [self adjustFloorsViewPosition];
    [self adjustLocateMeButtonPosition];
    [self adjustLogoPosition];
}

#pragma mark - Rotation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad || interfaceOrientation == UIInterfaceOrientationPortrait || UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self relayoutForInterfaceOrientation:toInterfaceOrientation];
}

#pragma mark - Actions

- (IBAction)loadingMapCancelButtonTapped:(id)sender {
    [[Indoors instance]cancelGetBuilding];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (IBAction)locateMeButtonTapped:(id)sender {
    //Set correct Floor
    if (self.userCurrentFloorLevel != INT_MAX) {
        if (self.floorSelectorView) {
            [self.floorSelectorView highlightFloorAtLevel:self.userCurrentFloorLevel];
        }
        if (self.surfaceView) {
            [self.surfaceView setFloorLevel:self.userCurrentFloorLevel];
        }
    }
    
    if (self.userCurrentLocation) {
        [self.surfaceView setMapCenterWithCoordinate:self.userCurrentLocation];
    }
}

#pragma mark - Buildings

/**
 Online Buildings Delegate.
 */
- (void)setOnlineBuildings:(NSArray *)buildings {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self selectBuildingFromBuildings:buildings];
}

- (void)showProgressMessage:(NSString *)progressMessage {
    self.progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.progressHUD.labelText = progressMessage;
}

- (void)selectBuilding {
    [self dismissPopovers];
    [self showProgressMessage:NSLocalizedString(@"Loading Buildings...",@"")];
    [[Indoors instance] getOnlineBuildings:self];
}

- (void)dismissPopovers
{
    [self.myPopover dismissPopoverAnimated:YES];
    self.myPopover = nil;
    
    [self.legalPopover dismissPopoverAnimated:YES];
    self.legalPopover = nil;
    
    [self.zonesPopover dismissPopoverAnimated:YES];
    self.legalPopover = nil;
}

- (void)selectBuildingFromBuildings:(NSArray *)buildings {
    [self changeActionOfBarButton:self.selectBuildingBarButton to:@selector(showMapView)];
    [self changeActionOfBarButton:self.logoBarButton to:@selector(showLegalView)];
    [self changeActionOfBarButton:self.zonesBarButton to:@selector(showZonesView)];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if (self.myPopover == nil) {
            self.buildingsSelectionVC = [[IVBuildingSelectionViewController alloc] init];
            [self.buildingsSelectionVC setFrame:CGRectMake(0, 0, 320, 350 )];
            
            self.myPopover = [[UIPopoverController alloc] initWithContentViewController:self.buildingsSelectionVC];
            self.myPopover.popoverContentSize = CGSizeMake(320, 350);
        }
        
        [self.myPopover presentPopoverFromBarButtonItem:self.selectBuildingBarButton permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    } else {
        if (!self.buildingsSelectionVC) {
            self.buildingsSelectionVC = [[IVBuildingSelectionViewController alloc] init];
            float actualY = self.topToolBar.frame.origin.y + self.topToolBar.frame.size.height;
            [self.buildingsSelectionVC setFrame:CGRectMake(0, actualY , self.contentView.frame.size.width, self.contentView.frame.size.height - actualY)];
            [self.contentView addSubview:self.buildingsSelectionVC.view];
        }
        
        [self.buildingsSelectionVC.view setHidden:NO];
        [self.contentView bringSubviewToFront:self.buildingsSelectionVC.view];
        [self.contentView bringSubviewToFront:self.topToolBar];
    }
    
    self.buildingsSelectionVC.buildings = buildings;
    __weak typeof(self) weakSelf = self;
    self.buildingsSelectionVC.buildingSelectionBlock = ^(IDSBuilding *selectedBuilding) {
        __strong typeof(self) strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf showMapView];
            [strongSelf showProgressMessage:NSLocalizedString(@"Connecting...", @"")];
            [strongSelf.progressHUD showCancelOption:strongSelf action:@selector(loadingMapCancelButtonTapped:)];
            
            [strongSelf performSelectorInBackground:@selector(loadBuilding:) withObject:selectedBuilding];
        }
    };
    
    [self.buildingsSelectionVC loadBuildings];
}

- (void)getOnlineBuildingsFailWithError:(NSError*)error {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    UIAlertView* errorAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"") message:ERROR_MSG_LOADING_BUILDING_FAILED delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
    [errorAlert show];
}

#pragma mark - Building Protocol

- (void)buildingLoaded:(IDSBuilding*)loadedBuilding {
    if (![[NSThread currentThread] isMainThread]) {
        [self performSelectorOnMainThread:@selector(buildingLoaded:) withObject:loadedBuilding waitUntilDone:NO];
        return;
    }
    
    self.loadedBuilding = loadedBuilding;
    
    [self.locateMeButton setHidden:YES];
    self.userCurrentFloorLevel = INT_MAX;
    
    int initialFloorLevel = [loadedBuilding getInitialFloorLevel];
    
    if (initialFloorLevel != INT_MAX) {
        self.locationManager = [[IndoorsSurfaceLocationManager alloc] init];
        self.locationManager.delegate = self;
        
        [self.surfaceView setBuildingForSurface:loadedBuilding];
        [self.floorSelectorView setCurrentBuilding:loadedBuilding];
        [self.surfaceView setFloorLevel:initialFloorLevel];
        [self.floorSelectorView highlightFloorAtLevel:initialFloorLevel];
        [self adjustFloorsViewPosition];
    }
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)loadingBuilding:(NSNumber*)progress {
    float progressFloat = [progress floatValue];
    
    if (progressFloat == 1.0) {
        [self.progressHUD hideCancelOption];
        self.progressHUD.labelText = NSLocalizedString(@"Loading Map...", @"");
        
    } else {
        NSString* progressMessage = NSLocalizedString(@"Downloading %d%%", @"Downloading %d%%");
        int progressInt = (int) (progressFloat * 100) ;
        progressMessage = [NSString stringWithFormat:progressMessage, progressInt];
        self.progressHUD.labelText = progressMessage;
    }
}

- (void)loadingBuildingFailed {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [[IVErrorHandler shareHandler] showErrorWithTitle:nil message:ERROR_MSG_LOADING_BUILDING_FAILED];
}

#pragma mark - IVBuildingFloorsDelegate
- (void)buildingFloorsView:(IVBuildingFloorsView*)floorsView didSelectFloor:(IDSFloor*)floor {
    if (self.surfaceView) {
        int floorLevel = floor.level;
        [self.surfaceView setFloorLevel:floorLevel];
    }
}

#pragma mark - IVMenuDelegate

- (void)menuShowRouting {
    [self dismissPopovers];
    
    if ([self.surfaceView hasActiveBuilding]) {
        [self presentRoutingDialog];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Error", @"") message:ERROR_MSG_ROUTING_NO_MAP_SELECTED delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
        alertView.tag = ROUTING_ALERT_NO_MAP_SELECTED_DIALOG_TAG;
        [alertView show];
    }
}

- (void)showRouteToZone:(IDSZone *)zone
{
    [self dismissPopovers];
    [self showMapView];
    
    int middleX = 0;
    int middleY = 0;
    
    for (IDSZonePoint *c in zone.points) {
        middleX += c.x;
        middleY += c.y;
    }
    
    // Calculate the center of the polygon
    middleX /= zone.points.count;
    middleY /= zone.points.count;
    
    IDSFloor * const floor = [self.loadedBuilding getFloorById:zone.floor_id];
    IDSCoordinate * const zoneCenter = [[IDSCoordinate alloc] initWithX:middleX andY:middleY andFloorLevel:floor.level];
    
    [[Indoors instance] routeFromLocation:self.userCurrentLocation toLocation:zoneCenter delegate:self];
}

#pragma mark - Private

- (void)changeActionOfBarButton:(UIBarButtonItem *)button to:(SEL)selector
{
    [(UIButton *)button.customView removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];
    [(UIButton *)button.customView addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
}

- (void)loadBuilding:(IDSBuilding*)selectedBuilding {
    [[NSThread currentThread] setName:@"Load building"];
    [[Indoors instance]getBuilding:selectedBuilding forRequestDelegate:self];
}

- (void)showMapView {
    [self dismissPopovers];
    [self changeActionOfBarButton:self.selectBuildingBarButton to:@selector(selectBuilding)];
    [self changeActionOfBarButton:self.logoBarButton to:@selector(showLegalView)];
    [self changeActionOfBarButton:self.zonesBarButton to:@selector(showZonesView)];
    
    [self.contentView bringSubviewToFront:self.surfaceView];
    [self.buildingsSelectionVC.view setHidden:YES];
    [self bringSubViewsToFront];
}

- (void)cancelRoutingButtonTapped {
    [self adjustToolBarButtons:NO];
    self.routingPath = nil;
    [self.surfaceView showPathWithPoints:nil];
}

- (void)showZonesView
{
    if (!self.loadedBuilding) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Error", @"") message:ERROR_MSG_ROUTING_NO_MAP_SELECTED delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
        alertView.tag = ROUTING_ALERT_NO_MAP_SELECTED_DIALOG_TAG;
        [alertView show];
        return;
    }
    
    self.zonesVC = [[IVZonesTableViewController alloc] init];
    self.zonesVC.mainViewController = self;
    [self.zonesVC setFrame:CGRectMake(0, 0, 320, 350)];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [self dismissPopovers];
        
        self.zonesPopover = [[UIPopoverController alloc] initWithContentViewController:self.zonesVC];
        self.zonesPopover.popoverContentSize = CGSizeMake(320, 350);
        
        [self.zonesPopover presentPopoverFromBarButtonItem:self.zonesBarButton permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    } else {
        [self changeActionOfBarButton:self.selectBuildingBarButton to:@selector(selectBuilding)];
        [self changeActionOfBarButton:self.zonesBarButton to:@selector(showMapView)];
        [self changeActionOfBarButton:self.logoBarButton to:@selector(showLegalView)];
        
        float actualY = self.topToolBar.frame.origin.y + self.topToolBar.frame.size.height;
        [self.zonesVC setFrame:CGRectMake(0, actualY , self.contentView.frame.size.width, self.contentView.frame.size.height - actualY)];
        [self.contentView addSubview:self.zonesVC.view];
        
        [self.zonesVC.view setHidden:NO];
        [self.contentView bringSubviewToFront:self.zonesVC.view];
        [self.contentView bringSubviewToFront:self.topToolBar];
    }
}

- (void)showLegalView
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [self dismissPopovers];
        
        if (self.legalPopover == nil) {
            self.legalVC = [[IVLegalTableViewController alloc] init];
            [self.legalVC setFrame:CGRectMake(0, 0, 320, 350 )];
            
            self.legalPopover = [[UIPopoverController alloc] initWithContentViewController:self.legalVC];
            self.legalPopover.popoverContentSize = CGSizeMake(320, 350);
        }
        
        [self.legalPopover presentPopoverFromBarButtonItem:self.logoBarButton permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    } else {
        self.legalVC = [[IVLegalTableViewController alloc] init];
        [self changeActionOfBarButton:self.selectBuildingBarButton to:@selector(selectBuilding)];
        [self changeActionOfBarButton:self.logoBarButton to:@selector(showMapView)];
        [self changeActionOfBarButton:self.zonesBarButton to:@selector(showZonesView)];
        
        float actualY = self.topToolBar.frame.origin.y + self.topToolBar.frame.size.height;
        [self.legalVC setFrame:CGRectMake(0, actualY , self.contentView.frame.size.width, self.contentView.frame.size.height - actualY)];
        [self.contentView addSubview:self.legalVC.view];
        
        [self.legalVC.view setHidden:NO];
        [self.contentView bringSubviewToFront:self.legalVC.view];
        [self.contentView bringSubviewToFront:self.topToolBar];
    }
}

- (void)showWebViewWithFilePath:(NSString *)filePath
{
    [self dismissPopovers];
    [self changeActionOfBarButton:self.logoBarButton to:@selector(showMapView)];
    
    static UIWebView *webView;
    
    if (webView) {
        [webView removeFromSuperview];
    }
    
    float actualY = self.topToolBar.frame.origin.y + self.topToolBar.frame.size.height;
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, actualY , self.contentView.frame.size.width, self.contentView.frame.size.height - actualY)];
    webView.scalesPageToFit = NO;
    
    [webView loadData:[NSData dataWithContentsOfFile:filePath] MIMEType:@"text/plain" textEncodingName:@"utf-8" baseURL:nil];
    
    [self.contentView addSubview:webView];
    [self.contentView bringSubviewToFront:webView];
    [self.contentView bringSubviewToFront:self.topToolBar];
}

#pragma mark - IndoorsSurfaceViewDelegate
- (void)indoorsSurface:(ISIndoorsSurface*) surfaceView userDidSelectLocationToStartRouting:(IDSCoordinate *)location userCurrentLocation:(IDSCoordinate *)currentLocation
{
    if (self.routingDialog.waitingForUserToSelectLocation) {
        [self presentRoutingDialog];
        [self.routingDialog userDidSelectLocationFromMap:location];
    } else {
        [self.routingDialog setRoutingEndPoint:location];
        [self.routingDialog setRoutingStartPoint:currentLocation];
        [[Indoors instance] routeFromLocation:currentLocation toLocation:location delegate:self];
    }
}

#pragma mark - Routing dialog

- (void)presentRoutingDialog
{
    [self presentFormSheetWithViewController:self.routingNavigationController animated:NO completionHandler:nil];
}

- (void)dismissRoutingDialog
{
    [self dismissFormSheetControllerAnimated:YES completionHandler:nil];
}

#pragma mark - IVRoutingDialogDelegate
- (void)routingDialog:(IVRoutingDialog*)routingDialog routeUserFromLocation:(IDSCoordinate*)from toLocation:(IDSCoordinate*)to {
    [self dismissRoutingDialog];
    
    [[Indoors instance] routeFromLocation:from toLocation:to delegate:self];
}

- (void)routingDialogLetUserSelectLocation:(IVRoutingDialog*)routingDialog {
    [self dismissRoutingDialog];
    [self.surfaceView letUserSelectLocation];
}

- (void)routingDialogUserDidCancel:(IVRoutingDialog*)routingDialog {
    [self dismissRoutingDialog];
    self.routingPath = nil;
}

#pragma mark - RoutingDelegate
- (void)setRoute:(NSArray*) path {
    if ([path count]<= 0) {
        [[IVErrorHandler shareHandler] showErrorWithTitle:nil message:ERROR_MSG_NO_ROUTING_AVAILABLE];
    } else {
        [self adjustToolBarButtons:YES];
        self.routingPath = path;
        [self.surfaceView showPathWithPoints:path];
    }
}

#pragma mark - AlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == ROUTING_ALERT_DIALOG_TAG) {
        if (buttonIndex == 1) {
            self.routingPath = nil;
            [self.surfaceView showPathWithPoints:nil];
        }
    }
}

#pragma mark - IndoorsSurfaceLocationManagerDelegate
- (void)indoorsSurfaceLocationManager:(IndoorsSurfaceLocationManager*)mananger updateFloorLevel:(int)floorLevel name:(NSString*)name {
    self.userCurrentFloorLevel = floorLevel;
    
    if (self.floorSelectorView) {
        [self.floorSelectorView markFloorAtLevel:floorLevel];
        if (self.surfaceView.enableAutomaticFloorSelection) {
            [self.floorSelectorView highlightFloorAtLevel:floorLevel];
        }
    }
}

- (void)indoorsSurfaceLocationManager:(IndoorsSurfaceLocationManager*)mananger updateUserPosition:(IDSCoordinate*)userPosition {
    if (userPosition.x == INT_MAX && userPosition.y == INT_MAX) {
        self.userCurrentLocation = nil;
    } else {
        self.userCurrentLocation = userPosition;
    }
    
    if (self.userCurrentLocation) {
        [self.locateMeButton setHidden:NO];
        [self adjustLocateMeButtonPosition];
    } else {
        [self.locateMeButton setHidden:YES];
    }
}

- (void)indoorsSurfaceLocationManager:(IndoorsSurfaceLocationManager*)mananger updateUserOrientation:(float)orientation {
    NSLog(@"Orientation changed. SurfaceView Frame: %@", NSStringFromCGRect(self.surfaceView.frame));
    //self.surfaceView.mapScrollView.transform = CGAffineTransformMakeRotation(orientation);
}

- (void)weakSignalInIndoorsSurfaceLocationManager:(IndoorsSurfaceLocationManager *)manager
{
    [self.surfaceView makeToast:NSLocalizedString(@"Weak Signal!", @"")];
}

@end
