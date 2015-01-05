//
//  CompanyView.m
//  CliqueProject
//
//  Created by Andy Phan on 12/31/14.
//  Copyright (c) 2014 CoDeveloper. All rights reserved.
//

#import "CompanyView.h"
#import "CompanyListing.h"
#import "DataClass.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "FMResultSet.h"


@interface CompanyView (){
 DataClass *obj;
}
@property (nonatomic) IBOutlet UIBarButtonItem* revealButtonItem;

@end

@implementation CompanyView

@synthesize companylbl;
@synthesize companyDescription;
@synthesize businessTableView;


- (void)viewDidLoad {
    [super viewDidLoad];
    [self customSetup];
    self.navigationController.navigationBarHidden = NO;
    NSLog(@"Navigation Controller %@",self.navigationController);
    
    
    obj = [DataClass getInstance];
    CompanyDetails = [[NSDictionary alloc] init];
    companylbl.text = [obj.companyData objectForKey:@"CompanyName"];
    companyDescription.text = [obj.companyData objectForKey:@"CompanyDescription"];
    
    businessTableView.userInteractionEnabled = YES;
    
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
    
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    
    _businessID = [[NSMutableArray alloc] init];
    _businessName = [[NSMutableArray alloc] init];
    
    FMResultSet *results = [database executeQuery:@"select businessID, businessname from company_business where companyID = ?",[obj.companyData objectForKey:@"CompanyID"]];
    
    while([results next]) {
        NSString *businessID = [results stringForColumn:@"businessID"];
        NSString *businessname = [results stringForColumn:@"businessname"];
        
        
        totalRecords = totalRecords +1;
        
        [_businessID addObject:businessID];
        [_businessName addObject:businessname];
        
        
    }
    [database close];
    [self.businessTableView reloadData];
    
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


// to load database to tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (tableView == self.searchDisplayController.searchResultsTableView) {
//        return [searchResults count];
//        
//    } else {
        return [_businessName count];
        
//    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
//    if (tableView == self.searchDisplayController.searchResultsTableView) {
//        //        cell.textLabel.text = [searchResults objectAtIndex:indexPath.row];
//        
//        //companyname
//        [[cell.contentView viewWithTag:2001] removeFromSuperview ];
//        NSString *company_name= [searchResults objectAtIndex:indexPath.row];
//        CGRect frame=CGRectMake(20,0, 250, 50);
//        UILabel *label1=[[UILabel alloc]init];
//        label1.frame=frame;
//        label1.text= company_name;
//        label1.tag = 2001;
//        label1.font = [UIFont fontWithName:@"TreBuchet MS Bold" size:16];
//        [cell.contentView addSubview:label1];
//        
//        //category
//        [[cell.contentView viewWithTag:2002] removeFromSuperview ];
//        NSString *categorylbl= [_category objectAtIndex:indexPath.row];
//        NSString *subcategorylbl= [_subcategory objectAtIndex:indexPath.row];
//        CGRect frame2=CGRectMake(20,15, 200, 50);
//        UILabel *label2=[[UILabel alloc]init];
//        label2.frame=frame2;
//        NSString *labelToDisplay = [NSString stringWithFormat:@"Category : %@ (%@)", categorylbl, subcategorylbl];
//        label2.text= labelToDisplay;
//        label2.tag = 2002;
//        label2.font = [UIFont fontWithName:@"TreBuchet MS" size:10];
//        label2.textColor = [UIColor grayColor];
//        [cell.contentView addSubview:label2];
//        
//        //Description
//        [[cell.contentView viewWithTag:2003] removeFromSuperview ];
//        NSString *descriptionlbl= [_companyDescription objectAtIndex:indexPath.row];
//        CGRect frame3=CGRectMake(20,27, 280, 50);
//        UILabel *label3=[[UILabel alloc]init];
//        label3.frame=frame3;
//        label3.text= descriptionlbl;
//        label3.tag = 2003;
//        label3.font = [UIFont fontWithName:@"TreBuchet MS" size:10];
//        label3.textColor = [UIColor lightGrayColor];
//        [cell.contentView addSubview:label3];
//        
//        cell.selectionStyle = UITableViewCellSelectionStyleGray;
//        
//        
//        
//    } else {
        //        cell.textLabel.text = [_companyName objectAtIndex:indexPath.row];
    
    
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, 50, 50)];
        imgView.image = [UIImage imageNamed:@"photo1.png"];
//        cell.imageView.image = imgView.image;
        [cell.contentView addSubview:imgView];

        //businessname
        [[cell.contentView viewWithTag:2001] removeFromSuperview ];
        NSString *business_name= [_businessName objectAtIndex:indexPath.row];
        CGRect frame=CGRectMake(80,0, 250, 50);
        UILabel *label1=[[UILabel alloc]init];
        label1.frame=frame;
        label1.text= business_name;
        label1.tag = 2001;
        label1.font = [UIFont fontWithName:@"TreBuchet MS Bold" size:16];
        [cell.contentView addSubview:label1];
        
        //category
//        [[cell.contentView viewWithTag:2002] removeFromSuperview ];
//        NSString *categorylbl= [_category objectAtIndex:indexPath.row];
//        NSString *subcategorylbl= [_subcategory objectAtIndex:indexPath.row];
//        CGRect frame2=CGRectMake(20,15, 200, 50);
//        UILabel *label2=[[UILabel alloc]init];
//        label2.frame=frame2;
//        NSString *labelToDisplay = [NSString stringWithFormat:@"Category : %@ (%@)", categorylbl, subcategorylbl];
//        label2.text= labelToDisplay;
//        label2.tag = 2002;
//        label2.font = [UIFont fontWithName:@"TreBuchet MS" size:10];
//        label2.textColor = [UIColor grayColor];
//        [cell.contentView addSubview:label2];
//        
//        //Description
//        [[cell.contentView viewWithTag:2003] removeFromSuperview ];
//        NSString *descriptionlbl= [_companyDescription objectAtIndex:indexPath.row];
//        CGRect frame3=CGRectMake(20,27, 280, 50);
//        UILabel *label3=[[UILabel alloc]init];
//        label3.frame=frame3;
//        label3.text= descriptionlbl;
//        label3.tag = 2003;
//        label3.font = [UIFont fontWithName:@"TreBuchet MS" size:10];
//        label3.textColor = [UIColor lightGrayColor];
//        [cell.contentView addSubview:label3];
    
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
//    }
    
    return cell;
}

// Override to support conditional editing of the table view.
// This only needs to be implemented if you are going to be returning NO
// for some items. By default, all items are editable.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}



#pragma mark - UITableViewDataSource

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        
        
        NSString *businessIDtoDelete= [_businessID objectAtIndex:indexPath.row];
        
        NSString *dbName = @"cliqueDB.rdb";
        NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDir = [documentPaths objectAtIndex:0];
        NSString *dbPath = [documentsDir   stringByAppendingPathComponent:dbName];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:dbName];
        [fileManager copyItemAtPath:databasePathFromApp toPath:dbPath error:nil];
        
        FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
        [database open];
        
        [database executeUpdate:@"Delete from company_business where businessID = ?", businessIDtoDelete, nil];
        
        // Display Alert message after saving into database.
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"BUSINESS "
                                                        message:@"Business record deleted." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    
    // reload tableview
    [self ReloadTableData];
    [self.businessTableView reloadData];
    
    
    
}

- (void) ReloadTableData
{
    totalRecords = 0;
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
    
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    
    _businessID = [[NSMutableArray alloc] init];
    _businessName = [[NSMutableArray alloc] init];
    
    FMResultSet *results = [database executeQuery:@"select businessID, businessname from company_business where companyID = ?",[obj.companyData objectForKey:@"CompanyID"]];
    
    while([results next]) {
        NSString *businessID = [results stringForColumn:@"businessID"];
        NSString *businessname = [results stringForColumn:@"businessName"];
        
        
        totalRecords = totalRecords +1;
        
        [_businessID addObject:businessID];
        [_businessName addObject:businessname];
        
        
    }
    [database close];
    [self.businessTableView reloadData];;
    
}

//this is to hide the Status bar
- (BOOL)prefersStatusBarHidden {return YES;}


// to pass data to view controller and call BusinessView controller
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
//    obj = [DataClass getInstance];
//    obj.companyData = [[NSMutableDictionary alloc]init];
    [obj.companyData setObject:[_businessID objectAtIndex:indexPath.row] forKey:@"BusinessID"];
    [obj.companyData setObject:[_businessName objectAtIndex:indexPath.row] forKey:@"BusinessName"];
    
    
    NSString *segueString = [NSString stringWithFormat:@"PushBusiness"];
    //Since contentArray is an array of strings, we can use it to build a unique
    //identifier for each segue.
    
    //Perform a segue.
    [self performSegueWithIdentifier:segueString
                              sender:[_businessName objectAtIndex:indexPath.row]];
    
}


@end

