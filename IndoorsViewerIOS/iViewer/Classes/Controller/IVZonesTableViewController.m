#import "IVZonesTableViewController.h"
#import "IVAppDelegate.h"
#import "IVMainViewController.h"
#import <Indoors/IDSBuilding.h>

@interface IVZonesTableViewController () <UISearchDisplayDelegate>
@property (nonatomic) NSMutableArray *tableData;
@property (nonatomic) NSMutableArray *searchResult;
@property (nonatomic) UISearchDisplayController *searchController;
@end

@implementation IVZonesTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    IDSBuilding *building = self.mainViewController.loadedBuilding;
    NSAssert(building, @"Main view controller not set.");
    
    if (building) {
        self.tableData = [NSMutableArray array];
        for (IDSFloor *floor in building.floors.allValues) {
            [self.tableData addObjectsFromArray:floor.zones];
        }
    }
    
    self.searchResult = [NSMutableArray arrayWithCapacity:[self.tableData count]];
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 38)];
    self.searchController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    self.searchController.delegate = self;
    self.searchController.searchResultsDelegate = self;
    self.searchController.searchResultsDataSource = self;

    self.tableView.tableHeaderView = searchBar;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)setFrame:(CGRect)frame
{
    self.view.frame = frame;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.searchResult count];
    } else {
        return [self.tableData count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"UITableViewCellStyleDefault";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    IDSZone *zone;
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        zone = [self.searchResult objectAtIndex:indexPath.row];
    } else {
        zone = self.tableData[indexPath.row];
    }
    
    cell.textLabel.text = zone.name;
    
    return cell;
}

#pragma mark - UISearchDisplayDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    IDSZone *zone;
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        zone = [self.searchResult objectAtIndex:indexPath.row];
    } else {
        zone = self.tableData[indexPath.row];
    }
    
    [self.mainViewController showRouteToZone:zone];
    self.searchDisplayController.active = NO;
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    [self.searchResult removeAllObjects];
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF.name contains[c] %@", searchText];
    
    self.searchResult = [NSMutableArray arrayWithArray: [self.tableData filteredArrayUsingPredicate:resultPredicate]];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    return YES;
}

@end
