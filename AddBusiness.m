//
//  AddBusiness.m
//  CliqueProject
//
//  Created by Andy Phan on 12/31/14.
//  Copyright (c) 2014 CoDeveloper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AddBusiness.h"
#import "DataClass.h"

@interface AddBusiness (){
    DataClass *obj;
}

@property (nonatomic) IBOutlet UIBarButtonItem* btnSaveBusiness;
@end

// This is to set cell padding to UItextField
@implementation UITextField (custom)
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectMake(bounds.origin.x + 10, bounds.origin.y + 8,
                      bounds.size.width - 20, bounds.size.height - 16);
}
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [self textRectForBounds:bounds];
}
@end

@implementation AddBusiness{
    CLGeocoder *geocoder;
    CLPlacemark *placemark;

}

@synthesize txtLatitude;
@synthesize txtLongitude;
@synthesize mapView;
@synthesize txtMerchantAddress;
@synthesize photoSeq;
@synthesize scrollView = _scrollView;


static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

CGFloat animatedDistance;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.locationManager = [[CLLocationManager alloc] init];
    self.mapView.delegate = self;
    geocoder = [[CLGeocoder alloc] init];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    tap.cancelsTouchesInView = NO;
    tap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tap];
    
    [self.view endEditing:YES];
    
    obj = [DataClass getInstance];
    _companylbl.text = [obj.companyData objectForKey:@"CompanyName"];
    _companyID = [obj.companyData objectForKey:@"CompanyID"];
    

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)btnSaveBusiness:(id)sender {
    if ([self Validation] == TRUE) {
        [self saveData];
    }
    
}

- (void) saveData
{
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
    
    NSString *query = [NSString stringWithFormat:@"INSERT INTO company_business ('businessname', 'address_line1', 'address_line2', 'address_postcode', 'address_city', 'address_state', 'address_country', 'contact_phone1', 'contact_email', 'companyID', 'location') VALUES('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",_businessName.text,_address_line1.text,_address_line2.text,_address_postcode.text,_address_city.text,_address_state.text,_address_country.text,_phone.text,_email.text,_companyID,_address_location.text];
    
    [database executeUpdate:query];
    
    
    // Display Alert message after saving into database.
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"BUSINESS "
                                                    message:@"New Business record saved." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    
    // To clear text fields
    // [self clearTextfields];
    
    // To dismiss keyboard after save
    [self.view endEditing:YES];
    
}


// to hide keyboard
- (void)hideKeyboard{
    
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
}

//this is to hide the Status bar
- (BOOL)prefersStatusBarHidden {return YES;}

//this is for text field validation
- (bool) Validation{
    
    if([[_businessName.text stringByReplacingOccurrencesOfString:@" " withString:@"" ] isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"BUSINESS"
                                                        message:@"Business Name is required." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [_businessName becomeFirstResponder];
        
        [alert show];
        return false;
    }
    
    return true;
}


// this is to get location service GPS
- (IBAction)getCurrentLocation:(id)sender {
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    [self.locationManager requestWhenInUseAuthorization];
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    CLAuthorizationStatus authorizationStatus= [CLLocationManager authorizationStatus];
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized ||
        [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways ||
        [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {
        
        [self.locationManager startUpdatingLocation];
        
    }
    
    
    CLLocation *location = [self.locationManager location];
    
    NSLog(@" lat: %f",self.locationManager.location.coordinate.latitude);
    NSLog(@" lon: %f",self.locationManager.location.coordinate.longitude);
    
    _address_location.text = [NSString stringWithFormat:@"%f ,%f", self.locationManager.location.coordinate.latitude, self.locationManager.location.coordinate.longitude];
    
    
    [self.locationManager stopUpdatingLocation];
    
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        self.txtLatitude.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        self.txtLongitude.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
    }
    
    // Reverse Geocoding
    NSLog(@"Resolving the Address");
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
        if (error == nil && [placemarks count] > 0) {
            placemark = [placemarks lastObject];
            self.txtMerchantAddress.text = [NSString stringWithFormat:@"%@ %@\n%@ %@\n%@\n%@",
                                      placemark.subThoroughfare, placemark.thoroughfare,
                                      placemark.postalCode, placemark.locality,
                                      placemark.administrativeArea,
                                      placemark.country];
            
            self.address_line1.text =placemark.subThoroughfare;
            self.address_line2.text =placemark.thoroughfare;
            self.address_postcode.text =placemark.postalCode;
            self.address_city.text =placemark.locality;
            self.address_state.text =placemark.administrativeArea;
            self.address_country.text =placemark.country;
            
        } else {
            NSLog(@"%@", error.debugDescription);
        }
    } ];
    
}

//- (void)requestAlwaysAuthorization
//{
//    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
//
//    // If the status is denied or only granted for when in use, display an alert
//    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusDenied) {
//        NSString *title;
//        title = (status == kCLAuthorizationStatusDenied) ? @"Location services are off" : @"Background location is not enabled";
//        NSString *message = @"To use background location you must turn on 'Always' in the Location Services Settings";
//
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
//                                                            message:message
//                                                           delegate:self
//                                                  cancelButtonTitle:@"Cancel"
//                                                  otherButtonTitles:@"Settings", nil];
//        [alertView show];
//    }
//    // The user has not enabled any location services. Request background authorization.
//    else if (status == kCLAuthorizationStatusNotDetermined) {
//        [self.locationManager requestAlwaysAuthorization];
//    }
//}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        // Send the user to the Settings for this app
        NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:settingsURL];
    }
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
}

//this is to move UIView up when keayboard appear
//- (void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDuration:0.25];
//    self.view.frame = CGRectMake(0,-10,320,480);
//    [UIView commitAnimations];
//    
//}


//this is to capture photo of the business
- (IBAction)takePhoto:(UIButton *)sender {
    
    photoSeq = @"1";
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
}

- (IBAction)takePhoto2:(UIButton *)sender {
    
    photoSeq = @"2";
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
}

- (IBAction)takePhoto3:(UIButton *)sender {
    
    photoSeq = @"3";
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
}

- (IBAction)selectPhoto:(UIButton *)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];

    if ([photoSeq isEqualToString:@"1"]) {
        self.imageView1.image = chosenImage;
    }
    else if ([photoSeq isEqualToString:@"2"])
    {
        self.imageView2.image = chosenImage;
    }
    else if ([photoSeq isEqualToString:@"3"])
    {
        self.imageView3.image = chosenImage;
    }
        
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)saveImage:(UIImage *)image forPerson:(NSString *)fullName  {
    //  Make file name first
    NSString *filename = [fullName stringByAppendingString:@".png"]; // or .jpg
    
    //  Get the path of the app documents directory
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //  Append the filename and get the full image path
    NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:filename];
    
    //  Now convert the image to PNG/JPEG and write it to the image path
    NSData *imageData = UIImagePNGRepresentation(image);
    [imageData writeToFile:savedImagePath atomically:NO];
    
    //  Here you save the savedImagePath to your DB
    
}

- (IBAction)btnSavePhoto:(id)sender {
    [self saveData];
    
}

@end
