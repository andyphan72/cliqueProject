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
        
        //this is to add border to image
    }
    else{
        _imageView.image = [UIImage imageNamed:@"no-image.png"];
    }
    
    CAGradientLayer *l = [CAGradientLayer layer];
    l.frame = _imageView.bounds;
    l.colors = [NSArray arrayWithObjects:(id)[[UIColor blackColor] CGColor], (id)[[UIColor clearColor] CGColor], nil];
    
    
    l.startPoint = CGPointMake(0.5f, 0.7);
    l.endPoint = CGPointMake(0.5f, 1.0f);
    
    //you can change the direction, obviously, this would be top to bottom fade
    _imageView.layer.mask = l;

    companylbl.text = [obj.companyData objectForKey:@"CompanyName"];
    businesslbl.text = [obj.companyData objectForKey:@"BusinessName"];
    businesslbl.textColor = [UIColor whiteColor];
    
}

//this is to hide the Status bar
- (BOOL)prefersStatusBarHidden {return YES;}



@end
