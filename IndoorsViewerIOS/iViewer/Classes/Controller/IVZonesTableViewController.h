#import <UIKit/UIKit.h>
#import "IVMainViewController.h"

@interface IVZonesTableViewController : UITableViewController
@property (nonatomic) IVMainViewController *mainViewController;
- (void)setFrame:(CGRect)frame;
@end
