//
//  AddBusiness.h
//  CliqueProject
//
//  Created by Andy Phan on 12/31/14.
//  Copyright (c) 2014 CoDeveloper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "FMDatabase.h"
#import "FMResultSet.h"
#import <CoreLocation/CoreLocation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <MapKit/MapKit.h>


@interface AddBusiness : UIViewController<CLLocationManagerDelegate, MKMapViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextFieldDelegate>
{
    
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    IBOutlet UILabel *latitudeLabel;
    IBOutlet UILabel *longitudeLabel;
    IBOutlet UILabel *addressLabel;
    
    CGPoint svos;
    
}

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UITextField *businessName;
@property (strong, nonatomic) IBOutlet UITextField *address_line1;
@property (strong, nonatomic) IBOutlet UITextField *address_line2;
@property (strong, nonatomic) IBOutlet UITextField *address_postcode;
@property (strong, nonatomic) IBOutlet UITextField *address_city;
@property (strong, nonatomic) IBOutlet UITextField *address_state;
@property (strong, nonatomic) IBOutlet UITextField *address_country;
@property (strong, nonatomic) IBOutlet UITextField *address_location;
@property (strong, nonatomic) IBOutlet UITextField *phone;
@property (strong, nonatomic) IBOutlet UITextField *email;
@property (strong, nonatomic) IBOutlet UILabel *companylbl;
@property (strong, nonatomic) IBOutlet NSString *companyID;

@property (strong, nonatomic) IBOutlet UITextField *txtLatitude;
@property (strong, nonatomic) IBOutlet UITextField *txtLongitude;

// This is for getting Location
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic, strong) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) IBOutlet UITextView *txtMerchantAddress;
@property (strong, nonatomic) NSString  *photoSeq;




- (IBAction)btnSaveBusiness:(id)sender;
- (IBAction)getCurrentLocation:(id)sender;


// This is for Photo capturing
@property (strong, nonatomic) IBOutlet UIImageView *imageView1;
@property (strong, nonatomic) IBOutlet UIImageView *imageView2;
@property (strong, nonatomic) IBOutlet UIImageView *imageView3;
- (IBAction)takePhoto:  (UIButton *)sender;
- (IBAction)takePhoto2:  (UIButton *)sender;
- (IBAction)takePhoto3:  (UIButton *)sender;



@end
