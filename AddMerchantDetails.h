//
//  AddMerchantDetails.h
//  SingleView
//
//  Created by Andy Phan on 12/24/14.
//  Copyright (c) 2014 Andy Phan. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "FMDatabase.h"
#import "FMResultSet.h"
#import <CoreLocation/CoreLocation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <MapKit/MapKit.h>


@interface AddMerchantDetails : UIViewController<CLLocationManagerDelegate, MKMapViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    IBOutlet UILabel *latitudeLabel;
    IBOutlet UILabel *longitudeLabel;
    IBOutlet UILabel *addressLabel;
}

@property (strong, nonatomic) IBOutlet UITextField *txtMerchantName;
@property (strong, nonatomic) IBOutlet UITextView *txtMerchantAddress;
@property (strong, nonatomic) IBOutlet UITextField *txtMerchantPhone;
@property (strong, nonatomic) IBOutlet UITextField *txtMerchantEmail;
@property (strong, nonatomic) IBOutlet UITextView *txtMerchantHighlights;
@property (strong, nonatomic) IBOutlet UITextField *txtLatitude;
@property (strong, nonatomic) IBOutlet UITextField *txtLongitude;

// This is for getting Location
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic, strong) IBOutlet MKMapView *mapView;
//@property (strong, nonatomic) IBOutlet UIButton *btnSaveMerchant;
//@property (nonatomic) IBOutlet UIBarButtonItem* btnSaveMerchant;

// This is for Photo capturing
@property (strong, nonatomic) IBOutlet UIImageView *imageView;


//- (IBAction)btnSaveMerchant:(id)sender;

- (IBAction)getCurrentLocation:(id)sender;


- (IBAction)takePhoto:  (UIButton *)sender;
- (IBAction)selectPhoto:(UIButton *)sender;

@end
