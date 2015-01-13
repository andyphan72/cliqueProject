//
//  BusinessView.h
//  CliqueProject
//
//  Created by Andy Phan on 1/3/15.
//  Copyright (c) 2015 CoDeveloper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <sqlite3.h>
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "CompanyListing.h"
#import <MapKit/MapKit.h>

@interface BusinessView : UIViewController<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,UIImagePickerControllerDelegate>{
    
    NSString *databasePath;
    sqlite3 *company_businessDB;
    FMDatabase *database2;
    
    NSMutableArray *indexPaths;
    int totalRecords;
    int totalPhotos;
    int totalEventPhotos;
    int totalServicesPhotos;
    int totalProductsPhotos;
    
    int totalEventRecords;
    int totalServicesRecords;
    int totalProductRecords;
    
    NSString *totalEventRecords_str;
    NSString *totalServicesRecords_str;
    NSString *totalProductRecords_str;
    
    NSDictionary *CompanyDetails;
    NSString *EventScreen;
    NSString *ServicesScreen;
    NSString *ProductScreen;
}

@property (nonatomic, strong) IBOutlet UILabel *companylbl;
@property (nonatomic, strong) IBOutlet UILabel *companyDescription;
@property (nonatomic, strong) IBOutlet UILabel *businesslbl;

// event
@property (retain, nonatomic) NSMutableArray *eventID;
@property (retain, nonatomic) NSMutableArray *eventName;
@property (retain, nonatomic) NSMutableArray *eventDescription;
@property (retain, nonatomic) NSMutableArray *eventStartDate;
@property (retain, nonatomic) NSMutableArray *eventEndDate;
@property (retain, nonatomic) NSMutableArray *eventPhoto;
@property (retain, nonatomic) NSMutableArray *teventphoto;
@property (strong, nonatomic) IBOutlet UITableView *myEventTableView;
@property (nonatomic, weak) IBOutlet UILabel* myEventTableTitle;
@property (strong, nonatomic) IBOutlet UILabel *eventCountlbl;

// services
@property (retain, nonatomic) NSMutableArray *servicesID;
@property (retain, nonatomic) NSMutableArray *servicesName;
@property (strong, nonatomic) IBOutlet UITableView *myServicesTableView;
@property (strong, nonatomic) IBOutlet UILabel *servicesCountlbl;

// producrs
@property (retain, nonatomic) NSMutableArray *productID;
@property (retain, nonatomic) NSMutableArray *productName;
@property (strong, nonatomic) IBOutlet UITableView *myProductTableView;
@property (strong, nonatomic) IBOutlet UILabel *productCountlbl;

@property (retain, nonatomic) NSString *businessphotos;

@property (strong, nonatomic) IBOutlet UIView *labelView;
@property (strong, nonatomic) IBOutlet UIView *botomView;
@property (strong, nonatomic) IBOutlet UIView *eventView;
@property (strong, nonatomic) IBOutlet UIView *servicesView;
@property (strong, nonatomic) IBOutlet UIView *productsView;
@property (strong, nonatomic) IBOutlet UIButton *btnEventView;
@property (strong, nonatomic) IBOutlet UIButton *btnServicesView;
@property (strong, nonatomic) IBOutlet UIView *sideDetailView; 
@property (strong, nonatomic) IBOutlet UIButton *btnSideView;
@property (strong, nonatomic) IBOutlet UIButton *btnSideViewRight;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;

// This is for Photo capturing
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

// Label for SideView
@property (strong, nonatomic) IBOutlet UILabel *fullAddress;
@property (strong, nonatomic) IBOutlet UILabel *likesLBL;
@property (strong, nonatomic) IBOutlet UILabel *sharesLBL;
@property (strong, nonatomic) IBOutlet UILabel *clicksLBL;
@property (strong, nonatomic) IBOutlet UILabel *discussionLBL;
@property (strong, nonatomic) IBOutlet NSString *ratingStar;


@end