//
//  GetLocation.h
//  SingleView
//
//  Created by Andy Phan on 12/25/14.
//  Copyright (c) 2014 Andy Phan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <MapKit/MapKit.h>

@interface GetLocation : UIViewController<CLLocationManagerDelegate, MKMapViewDelegate>
{

    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    IBOutlet UILabel *latitudeLabel;
    IBOutlet UILabel *longitudeLabel;
    IBOutlet UILabel *addressLabel;
}

@property (nonatomic, strong) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) IBOutlet UILabel *latitudeLabel;
@property (strong, nonatomic) IBOutlet UILabel *longitudeLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
- (IBAction)getCurrentLocation:(id)sender;

@end
