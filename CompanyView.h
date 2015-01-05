//
//  CompanyView.h
//  CliqueProject
//
//  Created by Andy Phan on 12/31/14.
//  Copyright (c) 2014 CoDeveloper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <sqlite3.h>
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "CompanyListing.h"


@interface CompanyView : UIViewController<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>{
    
    NSString *databasePath;
    sqlite3 *company_businessDB;
    FMDatabase *database2;
    
    NSMutableArray *indexPaths;
    int totalRecords;
    
    NSDictionary *CompanyDetails;

}

@property (nonatomic, strong) IBOutlet UILabel *companylbl;
@property (nonatomic, strong) IBOutlet UILabel *companyDescription;

@property (strong, nonatomic) IBOutlet UITableView *businessTableView;
@property (retain, nonatomic) NSMutableArray *businessID;
@property (retain, nonatomic) NSMutableArray *businessName;
@property (retain, nonatomic) NSMutableArray *businessphoto;

@end
