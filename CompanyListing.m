//
//  CompanyListing.m
//  SingleView
//
//  Created by Andy Phan on 12/24/14.
//  Copyright (c) 2014 Andy Phan. All rights reserved.
//

#import "CompanyListing.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "FMResultSet.h"
#import "CompanyView.h"
#import "DataClass.h"


@interface CompanyListing (){
	DataClass *obj;
}
@property (nonatomic) IBOutlet UIBarButtonItem* revealButtonItem;


@end

@implementation CompanyListing
NSArray *searchResults;


@synthesize clientData;
@synthesize myTableView;
@synthesize strBusinessCount;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self customSetup];
    obj = [DataClass getInstance];
    
    myTableView.userInteractionEnabled = YES;
    
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
    
    _companyID = [[NSMutableArray alloc] init];
    _companyName = [[NSMutableArray alloc] init];
    _category = [[NSMutableArray alloc] init];
    _subcategory = [[NSMutableArray alloc] init];
    _companyDescription = [[NSMutableArray alloc] init];
    _businessCount = [[NSMutableArray alloc] init];
    
    FMResultSet *results = [database executeQuery:@"select companyID, companyName, category, subCategory, companyDescription from company"];
    
    while([results next]) {
        NSString *companyID = [results stringForColumn:@"companyID"];
        NSString *companyname = [results stringForColumn:@"companyName"];
        NSString *category = [results stringForColumn:@"category"];
        NSString *subcategory = [results stringForColumn:@"subcategory"];
        NSString *companydescription = [results stringForColumn:@"companyDescription"];
        
        //This is to count how many business the company has
        FMResultSet *results2 = [database executeQuery:@"select COUNT(*) as bCount from company_business where companyID = ?",companyID];
            while([results2 next]) {
                numberOfBusiness = [results2 stringForColumn:@"bCount"];
            }
        
        totalRecords = totalRecords +1;
        
        [_companyID addObject:companyID];
        [_companyName addObject:companyname];
        [_category addObject:category];
        [_subcategory addObject:subcategory];
        [_companyDescription addObject:companydescription];
        [_businessCount addObject:numberOfBusiness];
        
        
    }
    [database close];
    [self.myTableView reloadData];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.myTableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    // this is to make the search bar hidden, when pull down only appear
    self.myTableView.contentOffset = CGPointMake(0, 0);
}

- (void)viewDidUnload {
    
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


// to load database to tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [searchResults count];
        
    } else {
        return [_companyName count];
        
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
//        cell.textLabel.text = [searchResults objectAtIndex:indexPath.row];
        
        //companyname
        [[cell.contentView viewWithTag:2001] removeFromSuperview ];
        NSString *company_name= [searchResults objectAtIndex:indexPath.row];
        NSString *bussiness_count= [_businessCount objectAtIndex:indexPath.row];
        CGRect frame=CGRectMake(20,0, 250, 50);
        UILabel *label1=[[UILabel alloc]init];
        label1.frame=frame;
        NSString *labelToDisplay1 = [NSString stringWithFormat:@"%@ (%@)", company_name, bussiness_count];
        label1.text= labelToDisplay1;
        label1.tag = 2001;
        label1.font = [UIFont fontWithName:@"TreBuchet MS Bold" size:16];
        [cell.contentView addSubview:label1];
        
        //category
        [[cell.contentView viewWithTag:2002] removeFromSuperview ];
        NSString *categorylbl= [_category objectAtIndex:indexPath.row];
        NSString *subcategorylbl= [_subcategory objectAtIndex:indexPath.row];
        CGRect frame2=CGRectMake(20,15, 200, 50);
        UILabel *label2=[[UILabel alloc]init];
        label2.frame=frame2;
        NSString *labelToDisplay = [NSString stringWithFormat:@"Category : %@ (%@)", categorylbl, subcategorylbl];
        label2.text= labelToDisplay;
        label2.tag = 2002;
        label2.font = [UIFont fontWithName:@"TreBuchet MS" size:10];
        label2.textColor = [UIColor grayColor];
        [cell.contentView addSubview:label2];
        
        //Description
        [[cell.contentView viewWithTag:2003] removeFromSuperview ];
        NSString *descriptionlbl= [_companyDescription objectAtIndex:indexPath.row];
        CGRect frame3=CGRectMake(20,27, 280, 50);
        UILabel *label3=[[UILabel alloc]init];
        label3.frame=frame3;
        label3.text= descriptionlbl;
        label3.tag = 2003;
        label3.font = [UIFont fontWithName:@"TreBuchet MS" size:10];
        label3.textColor = [UIColor lightGrayColor];
        [cell.contentView addSubview:label3];
        
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        
        
    } else {
//        cell.textLabel.text = [_companyName objectAtIndex:indexPath.row];
        
        //companyname
        [[cell.contentView viewWithTag:2001] removeFromSuperview ];
        NSString *company_name= [_companyName objectAtIndex:indexPath.row];
        NSString *bussiness_count= [_businessCount objectAtIndex:indexPath.row];
        CGRect frame=CGRectMake(20,0, 250, 50);
        UILabel *label1=[[UILabel alloc]init];
        label1.frame=frame;
        NSString *labelToDisplay1 = [NSString stringWithFormat:@"%@ (%@)", company_name, bussiness_count];
        label1.text= labelToDisplay1;
        label1.text= labelToDisplay1;
        label1.tag = 2001;
        label1.font = [UIFont fontWithName:@"TreBuchet MS Bold" size:16];
        [cell.contentView addSubview:label1];
        
        //category
        [[cell.contentView viewWithTag:2002] removeFromSuperview ];
        NSString *categorylbl= [_category objectAtIndex:indexPath.row];
        NSString *subcategorylbl= [_subcategory objectAtIndex:indexPath.row];
        CGRect frame2=CGRectMake(20,15, 200, 50);
        UILabel *label2=[[UILabel alloc]init];
        label2.frame=frame2;
        NSString *labelToDisplay = [NSString stringWithFormat:@"Category : %@ (%@)", categorylbl, subcategorylbl];
        label2.text= labelToDisplay;
        label2.tag = 2002;
        label2.font = [UIFont fontWithName:@"TreBuchet MS" size:10];
        label2.textColor = [UIColor grayColor];
        [cell.contentView addSubview:label2];
        
        //Description
        [[cell.contentView viewWithTag:2003] removeFromSuperview ];
        NSString *descriptionlbl= [_companyDescription objectAtIndex:indexPath.row];
        CGRect frame3=CGRectMake(20,27, 280, 50);
        UILabel *label3=[[UILabel alloc]init];
        label3.frame=frame3;
        label3.text= descriptionlbl;
        label3.tag = 2003;
        label3.font = [UIFont fontWithName:@"TreBuchet MS" size:10];
        label3.textColor = [UIColor lightGrayColor];
        [cell.contentView addSubview:label3];
        
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
    }
    
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
    
    
    NSString *CompanyIDtoDelete= [_companyID objectAtIndex:indexPath.row];
    
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
    
        //Get BusinessID
        FMResultSet *getBusinessID = [database executeQuery:@"select businessID from company_business where companyID = ?",CompanyIDtoDelete];
        
        while ([getBusinessID next]) {
            
            NSString *businessIDtoDelete= [getBusinessID stringForColumn:@"businessID"];
            NSString *eventIDtoDelete;
            NSString *servicesIDtoDelete;
            NSString *productIDtoDelete;
            
            
            //Get EventID
            FMResultSet *getEvenID = [database executeQuery:@"select eventID from event where businessID = ?",businessIDtoDelete];
            
            //Remove event photos
            while ([getEvenID next]) {
                eventIDtoDelete = [getEvenID stringForColumn:@"eventID"];
                
                FMResultSet *deleteEventPhoto = [database executeQuery:@"select eventID, filename from event_photos where eventID = ? and seq = 1",eventIDtoDelete];
                
                while ([deleteEventPhoto next]) {
                    NSString *phototodelete = [deleteEventPhoto stringForColumn:@"filename"];
                    
                    NSFileManager *fileManager = [NSFileManager defaultManager];
                    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                    
                    NSString *filePath = [documentsPath stringByAppendingPathComponent:phototodelete];
                    NSError *error;
                    BOOL success = [fileManager removeItemAtPath:filePath error:&error];
                    if (success) {
                        //                UIAlertView *removeSuccessFulAlert=[[UIAlertView alloc]initWithTitle:@"Congratulation:" message:@"Successfully removed" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
                        //                [removeSuccessFulAlert show];
                    }
                    else
                    {
                        NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
                    }
                }
                
                
                //remove records from event_photos table
                [database executeUpdate:@"Delete from event_photos where eventID = ?", eventIDtoDelete, nil];
                
            }
            
            
            //Get servicesID
            FMResultSet *getServicesID = [database executeQuery:@"select servicesID from services where businessID = ?",businessIDtoDelete];
            
            //Remove services photos
            while ([getServicesID next]) {
                servicesIDtoDelete = [getServicesID stringForColumn:@"servicesID"];
                
                FMResultSet *deleteServicesPhoto = [database executeQuery:@"select servicesID, filename from services_photos where servicesID = ? and seq = 1",servicesIDtoDelete];
                
                while ([deleteServicesPhoto next]) {
                    NSString *phototodelete = [deleteServicesPhoto stringForColumn:@"filename"];
                    
                    NSFileManager *fileManager = [NSFileManager defaultManager];
                    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                    
                    NSString *filePath = [documentsPath stringByAppendingPathComponent:phototodelete];
                    NSError *error;
                    BOOL success = [fileManager removeItemAtPath:filePath error:&error];
                    if (success) {
                        //                UIAlertView *removeSuccessFulAlert=[[UIAlertView alloc]initWithTitle:@"Congratulation:" message:@"Successfully removed" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
                        //                [removeSuccessFulAlert show];
                    }
                    else
                    {
                        NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
                    }
                }
                
                
                //remove records from services_photos table
                [database executeUpdate:@"Delete from services_photos where servicesID = ?", servicesIDtoDelete, nil];
                
            }
            
            
            //Get productID
            FMResultSet *getProductID = [database executeQuery:@"select productID from product where businessID = ?",businessIDtoDelete];
            
            //Remove product photos
            while ([getProductID next]) {
                productIDtoDelete = [getProductID stringForColumn:@"productID"];
                
                FMResultSet *deleteProductPhoto = [database executeQuery:@"select productID, filename from product_photos where productID = ? and seq = 1",productIDtoDelete];
                
                while ([deleteProductPhoto next]) {
                    NSString *phototodelete = [deleteProductPhoto stringForColumn:@"filename"];
                    
                    NSFileManager *fileManager = [NSFileManager defaultManager];
                    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                    
                    NSString *filePath = [documentsPath stringByAppendingPathComponent:phototodelete];
                    NSError *error;
                    BOOL success = [fileManager removeItemAtPath:filePath error:&error];
                    if (success) {
                        //                UIAlertView *removeSuccessFulAlert=[[UIAlertView alloc]initWithTitle:@"Congratulation:" message:@"Successfully removed" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
                        //                [removeSuccessFulAlert show];
                    }
                    else
                    {
                        NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
                    }
                }
                
                
                //remove records from product_photos table
                [database executeUpdate:@"Delete from product_photos where productID = ?", productIDtoDelete, nil];
                
            }
            
            
            //remove records from event table
            [database executeUpdate:@"Delete from event where businessID = ?", businessIDtoDelete, nil];
            
            //remove records from services table
            [database executeUpdate:@"Delete from services where businessID = ?", businessIDtoDelete, nil];
            
            //remove records from product table
            [database executeUpdate:@"Delete from product where businessID = ?", businessIDtoDelete, nil];
            
            //remove business photos from folder
            FMResultSet *deleteBusinessPhoto = [database executeQuery:@"select businessID, filename from business_photos where businessID = ?",businessIDtoDelete];
            
            while ([deleteBusinessPhoto next]) {
                NSString *phototodelete = [deleteBusinessPhoto stringForColumn:@"filename"];
                
                NSFileManager *fileManager = [NSFileManager defaultManager];
                NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                
                NSString *filePath = [documentsPath stringByAppendingPathComponent:phototodelete];
                NSError *error;
                BOOL success = [fileManager removeItemAtPath:filePath error:&error];
                if (success) {
                    //                UIAlertView *removeSuccessFulAlert=[[UIAlertView alloc]initWithTitle:@"Congratulation:" message:@"Successfully removed" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
                    //                [removeSuccessFulAlert show];
                }
                else
                {
                    NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
                }
            }
            
            //remove records from business_photos table
            [database executeUpdate:@"Delete from business_photos where businessID = ?", businessIDtoDelete, nil];
            
            //remove records from company_business table
            [database executeUpdate:@"Delete from company_business where businessID = ?", businessIDtoDelete, nil];
            
        }
        
    //remove records from company table
    [database executeUpdate:@"Delete from company where companyID = ?", CompanyIDtoDelete, nil];
    
    // Display Alert message after saving into database.
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"COMPANY "
                                                    message:@"Company record deleted." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    
    }

    // reload tableview
    [self ReloadTableData];
    [self.myTableView reloadData];
    
    
    
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
    
    NSLog(@"%@",dbPath);
    
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    
    _companyID = [[NSMutableArray alloc] init];
    _companyName = [[NSMutableArray alloc] init];
    _category = [[NSMutableArray alloc] init];
    _subcategory = [[NSMutableArray alloc] init];
    _companyDescription = [[NSMutableArray alloc] init];
    _businessCount = [[NSMutableArray alloc] init];
    
    FMResultSet *results = [database executeQuery:@"select companyID, companyName, category, subCategory, companyDescription from company"];
    
    while([results next]) {
        NSString *companyID = [results stringForColumn:@"companyID"];
        NSString *companyname = [results stringForColumn:@"companyName"];
        NSString *category = [results stringForColumn:@"category"];
        NSString *subcategory = [results stringForColumn:@"subcategory"];
        NSString *companydescription = [results stringForColumn:@"companyDescription"];
        
        //This is to count how many business the company has
        FMResultSet *results2 = [database executeQuery:@"select COUNT(*) as bCount from company_business where companyID = ?",companyID];
        while([results2 next]) {
            numberOfBusiness = [results2 stringForColumn:@"bCount"];
        }
        
        
        totalRecords = totalRecords +1;
        
        [_companyID addObject:companyID];
        [_companyName addObject:companyname];
        [_category addObject:category];
        [_subcategory addObject:subcategory];
        [_companyDescription addObject:companydescription];
        [_businessCount addObject:numberOfBusiness];
        
        
    }
    [database close];
    [self.myTableView reloadData];;
 
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


// this is for search bar
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate
                                    predicateWithFormat:@"SELF contains[cd] %@",
                                    searchText];
    
    searchResults = [_companyName filteredArrayUsingPredicate:resultPredicate];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

// to pass data to view controller and call CompanyView controller
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    

    obj = [DataClass getInstance];
    obj.companyData = [[NSMutableDictionary alloc]init];
    [obj.companyData setObject:[_companyID objectAtIndex:indexPath.row] forKey:@"CompanyID"];
    [obj.companyData setObject:[_companyName objectAtIndex:indexPath.row] forKey:@"CompanyName"];
    [obj.companyData setObject:[_category objectAtIndex:indexPath.row] forKey:@"Category"];
    [obj.companyData setObject:[_subcategory objectAtIndex:indexPath.row] forKey:@"SubCategory"];
    [obj.companyData setObject:[_companyDescription objectAtIndex:indexPath.row] forKey:@"CompanyDescription"];
    
    
    NSString *segueString = [NSString stringWithFormat:@"PushCompany"];
    //Since contentArray is an array of strings, we can use it to build a unique
    //identifier for each segue.
    
    //Perform a segue.
    [self performSegueWithIdentifier:segueString
                              sender:[_companyName objectAtIndex:indexPath.row]];
    
}

@end

