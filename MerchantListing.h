//
//  UITableViewController+MerchantListing.h
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


@interface MerchantListing : UIViewController<UITableViewDelegate,UITableViewDataSource>{
   
    NSString *databasePath;
    sqlite3 *MerchantDB;
    FMDatabase *database2;
    
    NSMutableArray *indexPaths;
    int totalRecords;    
    
}

@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) NSMutableArray *clientData;
@property (retain, nonatomic) NSMutableArray *MerchantID;
@property (retain, nonatomic) NSMutableArray *MerchantName;


@end
