#import "IVLegalTableViewController.h"
#import "IVAppDelegate.h"
#import "IVMainViewController.h"

@interface IVLegalTableViewController ()

@end

@implementation IVLegalTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)setFrame:(CGRect)frame {
    self.view.frame = frame;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
    
    // Use this to add EULA
//    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"UITableViewCellStyleDefault";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (0 == indexPath.row) {
        cell.textLabel.text = @"Dependency licences";
    }
    
    // Use this to add EULA
//    else if (1 == indexPath.row) {
//        cell.textLabel.text = @"EULA";
//    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *filePath;
    
    if (0 == indexPath.row) {
        filePath = [[NSBundle mainBundle] pathForResource:@"NOTICE_iOS" ofType:@"txt"];
    }
    
    // Use this to add EULA
//    else if (1 == indexPath.row) {
//        filePath = [[NSBundle mainBundle] pathForResource:@"EULA" ofType:@"txt"];
//    }
    
    IVMainViewController *mainViewController = [(IVAppDelegate *)[[UIApplication sharedApplication] delegate] mainViewController];
    [mainViewController showWebViewWithFilePath:filePath];
}
@end
