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
@synthesize eventsTableView;


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
    
    eventsTableView.userInteractionEnabled = YES;
    
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
    
}

- (IBAction)btnEventView:(id)sender {
    
    
    if ([sender tag] == 1001) { // if event button is pressed

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
        [self.myEventTableView reloadData];
        
    }
    else if ([sender tag] == 1002) {

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
        ServicesScreen = @"Up";

    }
    else if ([sender tag] == 1003) {

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
        ProductScreen = @"Up";
    }
    else if ([sender tag] == 1004) {

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
    //    if (tableView == self.searchDisplayController.searchResultsTableView) {
    //        return [searchResults count];
    //
    //    } else {
    return [_eventName count];
    
    //    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
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
