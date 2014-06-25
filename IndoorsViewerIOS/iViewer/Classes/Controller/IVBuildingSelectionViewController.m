//
//  IVBuildingSelectionViewController.m
//  iViewer
//
//  Created by Mina Haleem on 24.03.13.
//  Copyright (c) 2013 Mina Haleem. All rights reserved.
//

#import "IVBuildingSelectionViewController.h"
#import "IVAppSettings.h"

@interface IVBuildingSelectionViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic,strong) UITableView* buildingsTable;
@end

@implementation IVBuildingSelectionViewController

@synthesize buildings = _buildings;
@synthesize buildingSelectionBlock = _buildingSelectionBlock;

- (id)init {
    self = [super init];
    
    if (self) {
        self.buildingsTable = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        self.buildingsTable.dataSource = self;
        self.buildingsTable.delegate = self;
        [self.view addSubview:self.buildingsTable];
    }
    
    return self;
}

- (void)loadBuildings {
    [self.buildingsTable reloadData];
}

- (void)viewDidLoad {
    if ([IVAppSettings deviceSystemMajorVersion] >= 7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.buildingsTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

#pragma mark - Rotation

- (BOOL)isIPhoneLandscape:(UIInterfaceOrientation)orientation {
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone
    && UIInterfaceOrientationIsLandscape(orientation);
}

- (void)setFrame:(CGRect)frame {
    self.view.frame = frame;
    self.buildingsTable.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_buildings count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    IDSBuilding *building = [_buildings objectAtIndex:indexPath.row];
    
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.text = building.name;
    
    cell.detailTextLabel.textColor = [UIColor blackColor];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", building.buildingID];
    
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    IDSBuilding *building = [_buildings objectAtIndex:indexPath.row];
    
    if (_buildingSelectionBlock) {
        _buildingSelectionBlock(building);
    }
}

@end
