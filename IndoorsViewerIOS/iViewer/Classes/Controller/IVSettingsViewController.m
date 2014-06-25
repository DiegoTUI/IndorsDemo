//
//  IVSettingsViewController.m
//  iViewer
//
//  Created by Mina Haleem on 04.05.13.
//  Copyright (c) 2013 Mina Haleem. All rights reserved.
//

#import "IVSettingsViewController.h"
#import "IVAppSettings.h"

@interface IVSettingsViewController () <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (nonatomic,strong) NSMutableArray* settings;

@property (nonatomic,strong) UITableView* settingsTable;
@property (nonatomic,strong) UITextField* userNameTextField;
@property (nonatomic,strong) IVAppSettings* appSettings;
@end

@implementation IVSettingsViewController
@synthesize settings;
@synthesize settingsTable;
@synthesize appSettings;
@synthesize userNameTextField;


- (id)init
{
    self = [super init];
    if (self) {
        [self setupView];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.appSettings = [[IVAppSettings alloc]init];
	
    CGFloat fontSize = 18;
    
    self.navigationController.navigationBar.titleTextAttributes
    = [NSDictionary dictionaryWithObjectsAndKeys:
       [UIFont fontWithName:@"PTSans-Bold" size:fontSize], UITextAttributeFont,
       [UIColor whiteColor], UITextAttributeTextColor,
       [UIColor blackColor], UITextAttributeTextShadowColor,
       [NSValue valueWithCGPoint:CGPointMake(0, -1)], UITextAttributeTextShadowOffset,
       nil];
    
    self.title = NSLocalizedString(@"Settings", @"Settings");
    
    UIBarButtonItem* cancelBarButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonTapped:)];
    
    self.navigationItem.leftBarButtonItem = cancelBarButton;
    
    UIBarButtonItem* saveBarButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveButtonTapped:)];
    
    self.navigationItem.rightBarButtonItem = saveBarButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SetupView
- (void)setupView {
    
    //Setup Sections and Rows
    self.settings = [[NSMutableArray alloc]initWithCapacity:0];
    
    NSMutableArray* userSettings = [[NSMutableArray alloc] initWithCapacity:0];
    [userSettings addObject:@"name"];
    
    [self.settings addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"user",@"name",userSettings,@"rows", nil]];
    
    //Setup Table
    self.settingsTable = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.settingsTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.settingsTable.backgroundColor = [UIColor clearColor];
    self.settingsTable.delegate = self;
    self.settingsTable.dataSource = self;
    
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    [self.view addSubview:self.settingsTable];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableDictionary* dic = [self.settings objectAtIndex:indexPath.section];
    NSMutableArray* rows = [dic objectForKey:@"rows"];
    NSString* section = [dic objectForKey:@"name"];
    NSString* row = [rows objectAtIndex:indexPath.row];
    
    if ([section isEqualToString:@"user"]) {
        if ([row isEqualToString:@"name"]) {
            
        }
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSMutableDictionary* dic = [self.settings objectAtIndex:section];
    NSMutableArray* rows = [dic objectForKey:@"rows"];
    return [rows count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.settings count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableDictionary* dic = [self.settings objectAtIndex:indexPath.section];
    NSMutableArray* rows = [dic objectForKey:@"rows"];
    NSString* section = [dic objectForKey:@"name"];
    NSString* row = [rows objectAtIndex:indexPath.row];
    
    UITableViewCell* cell;
    
    NSString *CellIdentifier = @"settingsCell";
    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    
    
    
    if ([section isEqualToString:@"user"]) {
        if ([row isEqualToString:@"name"]) {
            static NSString *CellIdentifier = @"timerNameCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                float x = 70;
                self.userNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(x, 0, cell.frame.size.width - x - 30, cell.frame.size.height)];
                self.userNameTextField.delegate = self;
                if (![[self.appSettings getUserName] isEqualToString:@""]) {
                    self.userNameTextField.textColor  = [UIColor whiteColor];
                    self.userNameTextField.text = [self.appSettings getUserName];
                } else {
                    self.userNameTextField.textColor  = [UIColor lightGrayColor];
                    self.userNameTextField.text = NSLocalizedString(@"User Name", @"User Name");
                }
                
                self.userNameTextField.textAlignment = UITextAlignmentRight ;
                self.userNameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                [cell.contentView addSubview:self.userNameTextField];
                cell.textLabel.text = NSLocalizedString(@"Name:", @"Name:");
            }
        }
    }
    
    //Configure General Look&feel for Cell
    cell.imageView.autoresizesSubviews = NO;
    cell.imageView.autoresizingMask = UIViewAutoresizingNone;
    cell.imageView.contentMode = UIViewContentModeCenter;
    cell.textLabel.shadowColor = [UIColor colorWithRed:0.118 green:0.118 blue:0.118 alpha:1];
    cell.textLabel.textColor = [UIColor lightGrayColor];
    
    return cell;
}

#pragma mark - IBActions
- (IBAction)saveButtonTapped:(id)sender {
    [appSettings saveUserName:self.userNameTextField.text];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}
#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField.textColor == [UIColor lightGrayColor]) {
        textField.text = @"";
        textField.textColor = [UIColor whiteColor];
    }
    return YES;
}

- (void) textFieldDidEndEditing:(UITextField *)textField {
    if(textField.text.length == 0){
        textField.textColor = [UIColor lightGrayColor];
        if (textField == self.userNameTextField) {
            textField.text = NSLocalizedString(@"User Name", @"User Name");
        }        
    }
}
@end
