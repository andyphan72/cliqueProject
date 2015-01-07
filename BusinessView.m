//
//  BusinessView.m
//  CliqueProject
//
//  Created by Andy Phan on 1/3/15.
//  Copyright (c) 2015 CoDeveloper. All rights reserved.
//

#import "BusinessView.h"
#import "DataClass.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "FMResultSet.h"

@interface BusinessView (){
    DataClass *obj;
}
@property (nonatomic) IBOutlet UIBarButtonItem* revealButtonItem;

@end

@implementation BusinessView

@synthesize companylbl;
@synthesize companyDescription;
@synthesize businesslbl;


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    
    obj = [DataClass getInstance];
    CompanyDetails = [[NSDictionary alloc] init];
    
    // setting navigation bar transparent
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
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
    
    FMResultSet *results = [database executeQuery:@"select photoID, filename from business_photos where businessID = ? and seq = 1",[obj.companyData objectForKey:@"BusinessID"]];
    
    while([results next]) {
        _businessphotos = [results stringForColumn:@"filename"];
        totalPhotos = totalPhotos +1;
    }
    [database close];
    
    //to display business photos
    if (totalPhotos > 0) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString* path = [documentsDirectory stringByAppendingPathComponent:_businessphotos];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        _imageView.image = [UIImage imageNamed:path];
        
    }
    else{
        _imageView.image = [UIImage imageNamed:@"no-image.png"];
    }
    
//    CAGradientLayer *l = [CAGradientLayer layer];
//    l.frame = _imageView.bounds;
//    l.colors = [NSArray arrayWithObjects:(id)[[UIColor blackColor] CGColor], (id)[[UIColor clearColor] CGColor], nil];
//    
//    
//    l.startPoint = CGPointMake(0.5f, 0.7);
//    l.endPoint = CGPointMake(0.5f, 1.0f);
//    
//    //you can change the direction, obviously, this would be top to bottom fade
//    _imageView.layer.mask = l;

    companylbl.text = [obj.companyData objectForKey:@"CompanyName"];
    businesslbl.text = [obj.companyData objectForKey:@"BusinessName"];
    businesslbl.textColor = [UIColor whiteColor];
    
    // Initialized the screen button
    EventScreen = @"Down";
    ServicesScreen = @"Down";
    ProductScreen = @"Down";
    
    _eventView.hidden = YES;
    _servicesView.hidden = YES;
    _productsView.hidden = YES;
    
    //This is to count the number of records in Event table
    FMDatabase *eventdb = [FMDatabase databaseWithPath:dbPath];
    [eventdb open];
    FMResultSet *event1 = [eventdb executeQuery:@"select count(*) as eventcount from event where businessID = ?",[obj.companyData objectForKey:@"BusinessID"]];
    while([event1 next]) {
        totalEventRecords = [event1 intForColumn:@"eventcount"];
    }
    _eventCountlbl.text = [NSString stringWithFormat:@"%d",totalEventRecords];
    [eventdb close];

    //This is to count the number of records in Services table
    FMDatabase *servicesdb = [FMDatabase databaseWithPath:dbPath];
    [servicesdb open];
    FMResultSet *services1 = [servicesdb executeQuery:@"select count(*) as servicescount from services where businessID = ?",[obj.companyData objectForKey:@"BusinessID"]];
    while([services1 next]) {
        totalServicesRecords = [services1 intForColumn:@"servicescount"];
    }
    _servicesCountlbl.text = [NSString stringWithFormat:@"%d",totalServicesRecords];
    [servicesdb close];
    
    //This is to count the number of records in Products table
    FMDatabase *productdb = [FMDatabase databaseWithPath:dbPath];
    [productdb open];
    FMResultSet *product1 = [servicesdb executeQuery:@"select count(*) as productcount from product where businessID = ?",[obj.companyData objectForKey:@"BusinessID"]];
    while([product1 next]) {
        totalProductRecords = [product1 intForColumn:@"productcount"];
    }
    _productCountlbl.text = [NSString stringWithFormat:@"%d",totalProductRecords];
    [productdb close];
    
}

- (IBAction)btnEventView:(id)sender {
    
    
    if ([sender tag] == 1001) { // if event button is pressed
        
        _eventView.hidden = NO;
        _servicesView.hidden = YES;
        _productsView.hidden = YES;
        
        //uiview transition
        self.eventView.alpha = 0.0;
        [UIView beginAnimations:@"flip" context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
        [UIView setAnimationDuration:1.0f];
        self.eventView.alpha = 1.0;
        [UIView commitAnimations];

        // animate move labelview up
        [UIView animateWithDuration:0.8f delay:0.1f options:UIViewAnimationCurveEaseInOut animations:^{
            _labelView.frame = CGRectMake(_labelView.frame.origin.x, 80, _labelView.bounds.size.width, 80);
            
        }completion:^(BOOL finished) {
            NSLog(@"Animation is complete");
        }];
        
        // animate move eventview up
        [UIView animateWithDuration:0.8f delay:0.1f options:UIViewAnimationCurveEaseInOut animations:^{
            _botomView.frame = CGRectMake(_botomView.frame.origin.x, 150, _botomView.bounds.size.width, 418);
            
        }completion:^(BOOL finished) {
            NSLog(@"Animation is complete");
        }];
        EventScreen = @"Up";
        ServicesScreen = @"Down";
        ProductScreen = @"Down";
        
        //Load Event Table
        BOOL success;
        NSString *dbName = @"cliqueDB.rdb";
        NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDir = [documentPaths objectAtIndex:0];
        NSString *dbPath = [documentsDir   stringByAppendingPathComponent:dbName];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        success = [fileManager fileExistsAtPath:dbPath];
        NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:dbName];
        [fileManager copyItemAtPath:databasePathFromApp toPath:dbPath error:nil];
        
        FMDatabase *eventdatabase = [FMDatabase databaseWithPath:dbPath];
        [eventdatabase open];
        
        _eventID = [[NSMutableArray alloc] init];
        _eventName = [[NSMutableArray alloc] init];
        
        FMResultSet *results_event = [eventdatabase executeQuery:@"select eventID, event_title from event where businessID = ?",[obj.companyData objectForKey:@"BusinessID"]];
        
        while([results_event next]) {
            NSString *eventID = [results_event stringForColumn:@"eventID"];
            NSString *eventtitle = [results_event stringForColumn:@"event_title"];
            
            totalRecords = totalRecords +1;
            
            [_eventID addObject:eventID];
            [_eventName addObject:eventtitle];
            
        }
        [eventdatabase close];
        _myEventTableView.userInteractionEnabled = YES;        
        [self.myEventTableView reloadData];
        
    }
    else if ([sender tag] == 1002) {
        
        _eventView.hidden = YES;
        _servicesView.hidden = NO;
        _productsView.hidden = YES;
        
        //uiview transition
        self.servicesView.alpha = 0.0;
        [UIView beginAnimations:@"flip" context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
        [UIView setAnimationDuration:1.0f];
        self.servicesView.alpha = 1.0;
        [UIView commitAnimations];
        
        // animate move labelview up
        [UIView animateWithDuration:0.8f delay:0.1f options:UIViewAnimationCurveEaseInOut animations:^{
            _labelView.frame = CGRectMake(_labelView.frame.origin.x, 80, _labelView.bounds.size.width, 80);
            
        }completion:^(BOOL finished) {
            NSLog(@"Animation is complete");
        }];
        // animate move Services viw up
        [UIView animateWithDuration:0.8f delay:0.1f options:UIViewAnimationCurveEaseInOut animations:^{
            _botomView.frame = CGRectMake(_botomView.frame.origin.x, 150, _botomView.bounds.size.width, 418);
            
        }completion:^(BOOL finished) {
            NSLog(@"Animation is complete");
        }];
        EventScreen = @"Down";
        ServicesScreen = @"Up";
        ProductScreen = @"Down";
        
        
        //Load Services Table
        BOOL success;
        NSString *dbName = @"cliqueDB.rdb";
        NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDir = [documentPaths objectAtIndex:0];
        NSString *dbPath = [documentsDir   stringByAppendingPathComponent:dbName];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        success = [fileManager fileExistsAtPath:dbPath];
        NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:dbName];
        [fileManager copyItemAtPath:databasePathFromApp toPath:dbPath error:nil];
        
        FMDatabase *servicesdatabase = [FMDatabase databaseWithPath:dbPath];
        [servicesdatabase open];
        
        _servicesID = [[NSMutableArray alloc] init];
        _servicesName = [[NSMutableArray alloc] init];
        
        FMResultSet *results_services = [servicesdatabase executeQuery:@"select servicesID, services_name from services where businessID = ?",[obj.companyData objectForKey:@"BusinessID"]];
        
        while([results_services next]) {
            NSString *servicesID = [results_services stringForColumn:@"servicesID"];
            NSString *servicestitle = [results_services stringForColumn:@"services_name"];
            
            totalRecords = totalRecords +1;
            
            [_servicesID addObject:servicesID];
            [_servicesName addObject:servicestitle];
            
        }
        [servicesdatabase close];
        [self.myServicesTableView reloadData];
        

    }
    else if ([sender tag] == 1003) {
        
        _eventView.hidden = YES;
        _servicesView.hidden = YES;
        _productsView.hidden = NO;
        
        //uiview transition
        self.productsView.alpha = 0.0;
        [UIView beginAnimations:@"flip" context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
        [UIView setAnimationDuration:1.0f];
        self.productsView.alpha = 1.0;
        [UIView commitAnimations];
        
        

        // animate move labelview up
        [UIView animateWithDuration:0.8f delay:0.1f options:UIViewAnimationCurveEaseInOut animations:^{
            _labelView.frame = CGRectMake(_labelView.frame.origin.x, 80, _labelView.bounds.size.width, 80);
            
        }completion:^(BOOL finished) {
            NSLog(@"Animation is complete");
        }];
        
        // animate move Products view up
        [UIView animateWithDuration:0.8f delay:0.1f options:UIViewAnimationCurveEaseInOut animations:^{
            _botomView.frame = CGRectMake(_botomView.frame.origin.x, 150, _botomView.bounds.size.width, 418);
            
        }completion:^(BOOL finished) {
            NSLog(@"Animation is complete");
        }];
        EventScreen = @"Down";
        ServicesScreen = @"Down";
        ProductScreen = @"Up";
        
        //Load Products Table
        BOOL success;
        NSString *dbName = @"cliqueDB.rdb";
        NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDir = [documentPaths objectAtIndex:0];
        NSString *dbPath = [documentsDir   stringByAppendingPathComponent:dbName];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        success = [fileManager fileExistsAtPath:dbPath];
        NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:dbName];
        [fileManager copyItemAtPath:databasePathFromApp toPath:dbPath error:nil];
        
        FMDatabase *productsdatabase = [FMDatabase databaseWithPath:dbPath];
        [productsdatabase open];
        
        _productID = [[NSMutableArray alloc] init];
        _productName = [[NSMutableArray alloc] init];
        
        FMResultSet *results_products = [productsdatabase executeQuery:@"select productID, product_name from product where businessID = ?",[obj.companyData objectForKey:@"BusinessID"]];
        
        while([results_products next]) {
            NSString *productID = [results_products stringForColumn:@"productID"];
            NSString *productname = [results_products stringForColumn:@"product_name"];
            
            totalRecords = totalRecords +1;
            
            [_productID addObject:productID];
            [_productName addObject:productname];
            
        }
        [productsdatabase close];
        [self.myProductTableView reloadData];
        
        
        
    }
    else if ([sender tag] == 1004) {
        
        _eventView.hidden = YES;
        _servicesView.hidden = YES;
        _productsView.hidden = YES;
        

        // animate move labelview down
        [UIView animateWithDuration:0.8f delay:0.1f options:UIViewAnimationCurveEaseInOut animations:^{
            _labelView.frame = CGRectMake(_labelView.frame.origin.x, 420, _labelView.bounds.size.width, 80);
            
        }completion:^(BOOL finished) {
            NSLog(@"Animation is complete");
        }];

        // animate move bottomview down
        [UIView animateWithDuration:0.8f delay:0.1f options:UIViewAnimationCurveEaseInOut animations:^{
            _botomView.frame = CGRectMake(_botomView.frame.origin.x, 489, _botomView.bounds.size.width, 418);
            
        }completion:^(BOOL finished) {
            NSLog(@"Animation is complete");
        }];
        EventScreen = @"Down";
        ServicesScreen = @"Down";
        ProductScreen = @"Down";
    }

    
}


// to load database to tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([EventScreen isEqualToString:@"Up"]) {
        return [_eventName count];
    }
    else if ([ServicesScreen isEqualToString:@"Up"]) {
        return [_servicesName count];
    }
    else if ([ProductScreen isEqualToString:@"Up"]) {
        return [_productName count];
    }
    else
    {
        return 0;
    }

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    
    if ([EventScreen isEqualToString:@"Up"]) {
        
        //Event Name
        [[cell.contentView viewWithTag:2001] removeFromSuperview ];
        NSString *event_name= [_eventName objectAtIndex:indexPath.row];
        CGRect frame=CGRectMake(16,5, 250, 20);
        UILabel *label1=[[UILabel alloc]init];
        label1.frame=frame;
        label1.text= event_name;
        label1.tag = 2001;
        label1.font = [UIFont fontWithName:@"Helvetica" size:14];
        [cell.contentView addSubview:label1];
    
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    else if ([ServicesScreen isEqualToString:@"Up"]) {
        
        //Services Name
        [[cell.contentView viewWithTag:2001] removeFromSuperview ];
        NSString *services_name= [_servicesName objectAtIndex:indexPath.row];
        CGRect frame=CGRectMake(16,5, 250, 20);
        UILabel *label1=[[UILabel alloc]init];
        label1.frame=frame;
        label1.text= services_name;
        label1.tag = 2001;
        label1.font = [UIFont fontWithName:@"Helvetica" size:14];
        [cell.contentView addSubview:label1];
        
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    else if ([ProductScreen isEqualToString:@"Up"]) {
        
        //Product Name
        [[cell.contentView viewWithTag:2001] removeFromSuperview ];
        NSString *products_name= [_productName objectAtIndex:indexPath.row];
        CGRect frame=CGRectMake(16,5, 250, 20);
        UILabel *label1=[[UILabel alloc]init];
        label1.frame=frame;
        label1.text= products_name;
        label1.tag = 2001;
        label1.font = [UIFont fontWithName:@"Helvetica" size:14];
        [cell.contentView addSubview:label1];
        
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
        
        
        NSString *eventIDtoDelete= [_eventID objectAtIndex:indexPath.row];
        
        NSString *dbName = @"cliqueDB.rdb";
        NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDir = [documentPaths objectAtIndex:0];
        NSString *dbPath = [documentsDir   stringByAppendingPathComponent:dbName];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:dbName];
        [fileManager copyItemAtPath:databasePathFromApp toPath:dbPath error:nil];
        
        FMDatabase *eventdatabase = [FMDatabase databaseWithPath:dbPath];
        [eventdatabase open];
        
        [eventdatabase executeUpdate:@"Delete from event where eventID = ?", eventIDtoDelete, nil];
        [eventdatabase close];
        
        // Display Alert message after saving into database.
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"EVENT "
                                                        message:@"Event record deleted." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
        
    }
    
    // reload tableview
    [self ReloadTableData];
    [self.myEventTableView reloadData];
}


- (void) ReloadTableData
{
    totalRecords = 0;
    //reload Event table
    BOOL success;
    NSString *dbName = @"cliqueDB.rdb";
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [documentPaths objectAtIndex:0];
    NSString *dbPath = [documentsDir   stringByAppendingPathComponent:dbName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    success = [fileManager fileExistsAtPath:dbPath];
    NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:dbName];
    [fileManager copyItemAtPath:databasePathFromApp toPath:dbPath error:nil];
    
    FMDatabase *eventdatabase = [FMDatabase databaseWithPath:dbPath];
    [eventdatabase open];
    
    _eventID = [[NSMutableArray alloc] init];
    _eventName = [[NSMutableArray alloc] init];
    
    FMResultSet *results_event = [eventdatabase executeQuery:@"select eventID, event_title from event where businessID = ?",[obj.companyData objectForKey:@"BusinessID"]];
    
    while([results_event next]) {
        NSString *eventID = [results_event stringForColumn:@"eventID"];
        NSString *eventtitle = [results_event stringForColumn:@"event_title"];
        
        totalRecords = totalRecords +1;
        
        [_eventID addObject:eventID];
        [_eventName addObject:eventtitle];
        
    }
    [eventdatabase close];
    [self.myEventTableView reloadData];

    
}

//this is to hide the Status bar
- (BOOL)prefersStatusBarHidden {return YES;}



@end
