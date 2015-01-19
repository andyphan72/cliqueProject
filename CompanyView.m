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
    
    // setting navigation bar transparent
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    
    
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
    _businessphoto = [[NSMutableArray alloc] init];
    _tbusinessphoto = [[NSMutableArray alloc] init];
    _verifiedBusiness = [[NSMutableArray alloc] init];
    
    FMResultSet *results = [database executeQuery:@"select businessID, businessname, verified from company_business where companyID = ?",[obj.companyData objectForKey:@"CompanyID"]];
    
    while([results next]) {
        NSString *businessID = [results stringForColumn:@"businessID"];
        NSString *businessname = [results stringForColumn:@"businessname"];
        NSString *verifiedpartner = [results stringForColumn:@"verified"];
        
        totalRecords = totalRecords +1;
        
        [_businessID addObject:businessID];
        [_businessName addObject:businessname];
        [_verifiedBusiness addObject:verifiedpartner];
        
        FMResultSet *results2 = [database executeQuery:@"select businessID, filename from business_photos where businessID = ? and seq = 1",businessID];
        totalPhotos = 0;
        NSString *businessphoto;
        while([results2 next]) {
            businessphoto = [results2 stringForColumn:@"filename"];
            totalPhotos = totalPhotos +1;
        }
        NSString *getTotal = [NSString stringWithFormat:@"%d",totalPhotos];
        [_tbusinessphoto addObject:getTotal];
        if ([getTotal isEqualToString:@"0"]) {
            businessphoto = @" ";
        }
        [_businessphoto addObject:businessphoto];
        
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

//#pragma mark state preservation / restoration
//
//- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
//{
//    NSLog(@"%s", __PRETTY_FUNCTION__);
//    
//    // Save what you need here
//    //    [coder encodeObject: _text forKey: @"text"];
//    //    [coder encodeObject: _color forKey: @"color"];
//    
//    [super encodeRestorableStateWithCoder:coder];
//}
//
//
//- (void)decodeRestorableStateWithCoder:(NSCoder *)coder
//{
//    NSLog(@"%s", __PRETTY_FUNCTION__);
//    
//    // Restore what you need here
//    //    _color = [coder decodeObjectForKey: @"color"];
//    //    _text = [coder decodeObjectForKey: @"text"];
//    
//    [super decodeRestorableStateWithCoder:coder];
//}
//
//
//- (void)applicationFinishedRestoringState
//{
//    NSLog(@"%s", __PRETTY_FUNCTION__);
//    
//    // Call whatever function you need to visually restore
//    [self customSetup];
//}


// to load database to tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return [_businessName count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
        //to display business photos
    if (![[_tbusinessphoto objectAtIndex:indexPath.row] isEqualToString:@"0"]) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString* path = [documentsDirectory stringByAppendingPathComponent:[_businessphoto objectAtIndex:indexPath.row]];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 250)];
        imgView.image = [UIImage imageNamed:path];
        //this is to add border to image
        [imgView.layer setBorderColor: [[UIColor darkGrayColor] CGColor]];
        [imgView.layer setBorderWidth: 1.0];
        //this is show only center part of image
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.clipsToBounds = YES;
        [cell.contentView addSubview:imgView];

    }
    else{
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 250)];
        imgView.image = [UIImage imageNamed:@"no-image.png"];
        //this is to add border to image
        [imgView.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
        [imgView.layer setBorderWidth: 1.0];
        //this is show only center part of image
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.clipsToBounds = YES;        
        [cell.contentView addSubview:imgView];
        
    
    }

    if ([[_verifiedBusiness objectAtIndex:indexPath.row] isEqualToString:@"Yes"]) {
        //add verified partner uiview
        UIView *verifiedLabelview = [[UIView alloc] initWithFrame: CGRectMake ( 0, 20, 130, 20)];
        verifiedLabelview.backgroundColor = [UIColor lightGrayColor];
        verifiedLabelview.alpha = 0.7;
        verifiedLabelview.opaque = NO;
        [cell.contentView addSubview:verifiedLabelview];
        
        //verified partner label
        [[cell.contentView viewWithTag:3001] removeFromSuperview ];
        NSString *verified_label= @"Verified Partner";
        CGRect frameV=CGRectMake(5, 22, 140, 16);
        UILabel *labelV=[[UILabel alloc]init];
        labelV.frame=frameV;
        labelV.text= verified_label;
        labelV.tag = 3001;
        labelV.font = [UIFont fontWithName:@"TreBuchet MS" size:15];
        labelV.textColor = [UIColor whiteColor];
        [cell.contentView addSubview:labelV];
    }
    
        //add transparent uiview
        UIView *businesslblview = [[UIView alloc] initWithFrame: CGRectMake ( 0, 185, 320, 50)];
        businesslblview.backgroundColor = [UIColor blackColor];
        businesslblview.alpha = 0.3;
        businesslblview.opaque = NO;
        [cell.contentView addSubview:businesslblview];

    
        //businessname
        [[cell.contentView viewWithTag:2001] removeFromSuperview ];
        NSString *business_name= [_businessName objectAtIndex:indexPath.row];
        CGRect frame=CGRectMake(10, 190, 320, 30);
        UILabel *label1=[[UILabel alloc]init];
        label1.frame=frame;
        label1.text= business_name;
        label1.tag = 2001;
        label1.font = [UIFont fontWithName:@"TreBuchet MS" size:20];
        label1.textColor = [UIColor whiteColor];
        [cell.contentView addSubview:label1];

        //companyname
        [[cell.contentView viewWithTag:2002] removeFromSuperview ];
        NSString *company_name= [obj.companyData objectForKey:@"CompanyName"];
        CGRect frame2=CGRectMake(10, 215, 320, 20);
        UILabel *label2=[[UILabel alloc]init];
        label2.frame=frame2;
        label2.text= company_name;
        label2.tag = 2002;
        label2.font = [UIFont fontWithName:@"TreBuchet MS" size:12];
        label2.textColor = [UIColor whiteColor];
        [cell.contentView addSubview:label2];
    
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
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
        NSString *eventIDtoDelete;
        NSString *servicesIDtoDelete;
        NSString *productIDtoDelete;
        
        NSString *dbName = @"cliqueDB.rdb";
        NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDir = [documentPaths objectAtIndex:0];
        NSString *dbPath = [documentsDir   stringByAppendingPathComponent:dbName];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:dbName];
        [fileManager copyItemAtPath:databasePathFromApp toPath:dbPath error:nil];
        
        FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
        [database open];
        
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
    [obj.companyData setObject:[_verifiedBusiness objectAtIndex:indexPath.row] forKey:@"VerifiedBusiness"];
    
    
    NSString *segueString = [NSString stringWithFormat:@"PushBusiness"];
    //Since contentArray is an array of strings, we can use it to build a unique
    //identifier for each segue.
    
    //Perform a segue.
    [self performSegueWithIdentifier:segueString
                              sender:[_businessName objectAtIndex:indexPath.row]];
    
}


@end

