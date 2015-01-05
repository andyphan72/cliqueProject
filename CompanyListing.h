//
//  CompanyListing.h
//  SingleView
//
//  Created by Andy Phan on 12/24/14.
//  Copyright (c) 2014 Andy Phan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "AppDelegate.h"


@interface CompanyListing : UIViewController<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>{
    
    NSString *databasePath;
    sqlite3 *MerchantDB;
    FMDatabase *database2;
    
    NSMutableArray *indexPaths;
    int totalRecords;
    NSString *numberOfBusiness;
    
    
}

@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) NSMutableArray *clientData;
@property (retain, nonatomic) NSMutableArray *companyID;
@property (retain, nonatomic) NSMutableArray *companyName;
@property (retain, nonatomic) NSMutableArray *category;
@property (retain, nonatomic) NSMutableArray *subcategory;
@property (retain, nonatomic) NSMutableArray *companyDescription;
@property (retain, nonatomic) NSMutableArray *businessCount;
@property (retain, nonatomic) NSString *strBusinessCount;



@end
