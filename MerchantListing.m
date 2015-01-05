//
//  UITableViewController+MerchantListing.m
//  SingleView
//
//  Created by Andy Phan on 12/24/14.
//  Copyright (c) 2014 Andy Phan. All rights reserved.
//

#import "MerchantListing.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "FMResultSet.h"


@interface MerchantListing ()
 @property (nonatomic) IBOutlet UIBarButtonItem* revealButtonItem;


@end

@implementation MerchantListing
@synthesize clientData;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self customSetup];
    
    //fmdb start
    BOOL success;
    NSString *dbName = @"cliqueDB.rdb";
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [documentPaths objectAtIndex:0];
    NSString *dbPath = [documentsDir   stringByAppendingPathComponent:dbName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    success = [fileManager fileExistsAtPath:dbPath];
    NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:dbName];
    [fileManager copyItemAtPath:databasePathFromApp toPath:dbPath error:nil];
    
    NSLog(@"%@",dbPath);
    
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    
    _MerchantID = [[NSMutableArray alloc] init];
    _MerchantName = [[NSMutableArray alloc] init];
    
    FMResultSet *results = [database executeQuery:@"select MerchantID, MerchantName from MerchantProfile"];
    
    while([results next]) {
        NSString *MerchantID = [results stringForColumn:@"MerchantID"];
        NSString *Merchantname = [results stringForColumn:@"MerchantName"];
        totalRecords = totalRecords +1;

        [_MerchantID addObject:MerchantID];
        [_MerchantName addObject:Merchantname];
        
    }
    [database close];
    [self.myTableView reloadData];;
    
}

- (void)viewDidUnload {

  
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return totalRecords;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    [[cell.contentView viewWithTag:2001] removeFromSuperview ];
    NSString *name= [_MerchantName objectAtIndex:indexPath.row];
    CGRect frame=CGRectMake(20,0, 400, 50);
    UILabel *label1=[[UILabel alloc]init];
    label1.frame=frame;
    label1.text= name;
//    label1.textAlignment = UITextAlignmentLeft;
    label1.tag = 2001;
    label1.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
    [cell.contentView addSubview:label1];
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSString *MerchantIDtoDelete= [_MerchantID objectAtIndex:indexPath.row];
    
    NSString *dbName = @"cliqueDB.rdb";
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [documentPaths objectAtIndex:0];
    NSString *dbPath = [documentsDir   stringByAppendingPathComponent:dbName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:dbName];
    [fileManager copyItemAtPath:databasePathFromApp toPath:dbPath error:nil];
    
    NSLog(@"%@",dbPath);
    
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    
//    FMResultSet *del_results = [database executeUpdate:@"Delete from MerchantProfile where MerchantID = ?", MerchantIDtoDelete];

    [database executeUpdate:@"Delete from MerchantProfile where MerchantID = ?", MerchantIDtoDelete, nil];
    
    // Display Alert message after saving into database.
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete MERCHANT "
                                                    message:@"Merchant record deleted." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    
    // reload tableview
    [self.myTableView reloadData];
    
}

//this is for the reveal bar
- (void)customSetup
{
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.revealButtonItem setTarget: revealViewController];
        [self.revealButtonItem setAction: @selector( revealToggle: )];
        [self.navigationController.navigationBar addGestureRecognizer:revealViewController.panGestureRecognizer];
    }
    
    
    
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor clearColor]];
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
                                                           shadow, NSShadowAttributeName,
                                                           [UIFont fontWithName:@"System" size:21.0], NSFontAttributeName, nil]];
    
    
    
    
    
}

#pragma mark state preservation / restoration

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // Save what you need here
    //    [coder encodeObject: _text forKey: @"text"];
    //    [coder encodeObject: _color forKey: @"color"];
    
    [super encodeRestorableStateWithCoder:coder];
}


- (void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // Restore what you need here
    //    _color = [coder decodeObjectForKey: @"color"];
    //    _text = [coder decodeObjectForKey: @"text"];
    
    [super decodeRestorableStateWithCoder:coder];
}


- (void)applicationFinishedRestoringState
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // Call whatever function you need to visually restore
    [self customSetup];
}

//this is to hide the Status bar
- (BOOL)prefersStatusBarHidden {return YES;}



@end

