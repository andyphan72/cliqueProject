//
//  AddMerchantDetails.m
//  SingleView
//
//  Created by Andy Phan on 12/24/14.
//  Copyright (c) 2014 Andy Phan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AddMerchantDetails.h"

@interface AddMerchantDetails ()
@property (nonatomic) IBOutlet UIBarButtonItem* revealButtonItem;

@end

@implementation AddMerchantDetails{

    CLGeocoder *geocoder;
    CLPlacemark *placemark;

}

@synthesize txtLatitude;
@synthesize txtLongitude;
@synthesize txtMerchantAddress;
@synthesize mapView;



- (void)viewDidLoad {
    [super viewDidLoad];
    [self customSetup];

	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    tap.cancelsTouchesInView = NO;
    tap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tap];

    self.locationManager = [[CLLocationManager alloc] init];
    self.mapView.delegate = self;
    geocoder = [[CLGeocoder alloc] init];
    
    
}

//this is for the reveal bar
- (void)customSetup
{
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.revealButtonItem setTarget: revealViewController];
        [self.revealButtonItem setAction: @selector( revealToggle: )];
        [self.navigationController.navigationBar addGestureRecognizer:revealViewController.panGestureRecognizer];
    }
    
    
    
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor clearColor]];
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
                                                           shadow, NSShadowAttributeName,
                                                           [UIFont fontWithName:@"System" size:21.0], NSFontAttributeName, nil]];
    
    
    
    
    
}

//#pragma mark state preservation / restoration
//
//- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
//{
//    NSLog(@"%s", __PRETTY_FUNCTION__);
//    
//    // Save what you need here
////    [coder encodeObject: _text forKey: @"text"];
////    [coder encodeObject: _color forKey: @"color"];
//    
//    [super encodeRestorableStateWithCoder:coder];
//}
//
//
//- (void)decodeRestorableStateWithCoder:(NSCoder *)coder
//{
//    NSLog(@"%s", __PRETTY_FUNCTION__);
//    
//    // Restore what you need here
////    _color = [coder decodeObjectForKey: @"color"];
////    _text = [coder decodeObjectForKey: @"text"];
//    
//    [super decodeRestorableStateWithCoder:coder];
//}
//
//
//- (void)applicationFinishedRestoringState
//{
//    NSLog(@"%s", __PRETTY_FUNCTION__);
//    
//    // Call whatever function you need to visually restore
//    [self customSetup];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)SaveMerchant:(id)sender {
    [self saveData];
    
}

- (void) saveData
{
    // saving image to Document folder
    [self saveImage:self.imageView.image forPerson:_txtMerchantName.text];
    
    NSString *imageFilename = [_txtMerchantName.text stringByAppendingString:@".png"]; // or .jpg
    
    
    BOOL success;
    NSString *dbName = @"cliqueDB.rdb";
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [documentPaths objectAtIndex:0];
    NSString *dbPath = [documentsDir   stringByAppendingPathComponent:dbName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    success = [fileManager fileExistsAtPath:dbPath];
    NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:dbName];
    [fileManager copyItemAtPath:databasePathFromApp toPath:dbPath error:nil];
    NSLog(@"%@",dbPath);
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    
    NSString *query = [NSString stringWithFormat:@"INSERT INTO MerchantProfile ('MerchantName', 'MerchantAddress', 'MerchantPhone', 'MerchantEmail', 'MerchantHighlights', 'Latitude', 'Longitude', 'Picture') VALUES('%@','%@','%@','%@','%@','%@','%@','%@')",_txtMerchantName.text,txtMerchantAddress.text,_txtMerchantPhone.text,_txtMerchantEmail.text,_txtMerchantHighlights.text,txtLatitude.text,txtLongitude.text,imageFilename];
    
    [database executeUpdate:query];
    
    
    
    // Display Alert message after saving into database.
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Add MERCHANT "
                                                    message:@"New Merchant record saved." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    
    // To clear text fields
    [self clearTextfields];

}

- (void) clearTextfields
{
    _txtMerchantName.text = @"";
    txtMerchantAddress.text = @"";
    _txtMerchantPhone.text = @"";
    _txtMerchantEmail.text = @"";
    _txtMerchantHighlights.text = @"";
    txtLatitude.text = @"";
    txtLongitude.text = @"";
    
}

- (void)hideKeyboard{
    
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
}


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
      //  NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
        if (error == nil && [placemarks count] > 0) {
            placemark = [placemarks lastObject];
            self.txtMerchantAddress.text = [NSString stringWithFormat:@"%@ %@\n%@ %@\n%@\n%@",
                                      placemark.subThoroughfare, placemark.thoroughfare,
                                      placemark.postalCode, placemark.locality,
                                      placemark.administrativeArea,
                                      placemark.country];
        } else {
           // NSLog(@"%@", error.debugDescription);
        }
    } ];
    
}

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


- (IBAction)takePhoto:(UIButton *)sender {
    
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
    self.imageView.image = chosenImage;
    
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

//this is to hide the Status bar
- (BOOL)prefersStatusBarHidden {return YES;}




@end