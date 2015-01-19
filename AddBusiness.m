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
    NSArray *_timepickerCategoryData;
}

@property (nonatomic) IBOutlet UIBarButtonItem* btnSaveBusiness;
@end

// This is to set cell padding to UItextField
//@implementation UITextField (custom)
//- (CGRect)textRectForBounds:(CGRect)bounds {
//    return CGRectMake(bounds.origin.x + 10, bounds.origin.y + 8,
//                      bounds.size.width - 20, bounds.size.height - 16);
//}
//- (CGRect)editingRectForBounds:(CGRect)bounds {
//    return [self textRectForBounds:bounds];
//}
//@end

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
@synthesize photo1_taken;
@synthesize photo2_taken;
@synthesize photo3_taken;

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
    
    // setting date picker for start and end date
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeTime;
    [datePicker addTarget:self action:@selector(updateTextField:)
         forControlEvents:UIControlEventValueChanged];
    [self.start_time setInputView:datePicker];
    [self.end_time setInputView:datePicker];

    
    photo1_taken = @"No";
    photo2_taken = @"No";
    photo3_taken = @"No";
    
    //set textfield delefate for scrolling screen up when keyboard or picker appear. This will call the textFieldDidBeginEditing
    self.address_state.delegate=self;
    self.address_country.delegate=self;
    self.address_location.delegate=self;
    self.phone.delegate=self;
    self.email.delegate=self;
    self.start_time.delegate=self;
    self.end_time.delegate=self;
    
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
    
    NSString *query = [NSString stringWithFormat:@"INSERT INTO company_business ('businessname', 'address_line1', 'address_line2', 'address_postcode', 'address_city', 'address_state', 'address_country', 'contact_phone1', 'contact_email', 'companyID', 'location', 'business_start_time', 'business_end_time','likes','shares','clicks','rating','ratingStar', 'verified') VALUES('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%d','%d','%d','%d','%d','%@')",_businessName.text,_address_line1.text,_address_line2.text,_address_postcode.text,_address_city.text,_address_state.text,_address_country.text,_phone.text,_email.text,_companyID,_address_location_forDB,_start_time.text,_end_time.text,0,0,0,0,0,@"No"];
    
    [database executeUpdate:query];
    
    FMResultSet *resultsBusiness = [database executeQuery:@"select * from company_business order by businessID"];
    businessID = 0;
    while([resultsBusiness next]) {
        businessID = [resultsBusiness intForColumn:@"businessID"];
    }
    
    if ([photo1_taken isEqualToString:@"Yes"]) {
        NSString *seq = @"1";
        NSString *businessID_str = [NSString stringWithFormat:@"%d",businessID];
        NSString *query2 = [NSString stringWithFormat:@"INSERT INTO business_photos ('seq', 'businessID', 'filename') VALUES('%@','%@','%@')",seq,businessID_str,photo_filename1];
        [database executeUpdate:query2];
    }
    if ([photo2_taken isEqualToString:@"Yes"]) {
        NSString *seq = @"2";
        NSString *businessID_str = [NSString stringWithFormat:@"%d",businessID];
        NSString *query2 = [NSString stringWithFormat:@"INSERT INTO business_photos ('seq', 'businessID', 'filename') VALUES('%@','%@','%@')",seq,businessID_str,photo_filename2];
        [database executeUpdate:query2];
    }
    if ([photo3_taken isEqualToString:@"Yes"]) {
        NSString *seq = @"3";
        NSString *businessID_str = [NSString stringWithFormat:@"%d",businessID];
        NSString *query2 = [NSString stringWithFormat:@"INSERT INTO business_photos ('seq', 'businessID', 'filename') VALUES('%@','%@','%@')",seq,businessID_str,photo_filename3];
        [database executeUpdate:query2];
    }
    
    
    // Display Alert message after saving into database.
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"BUSINESS "
                                                    message:@"New Business record saved." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    
    
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
    
    _address_location_forDB = [NSString stringWithFormat:@"%f ,%f", self.locationManager.location.coordinate.latitude, self.locationManager.location.coordinate.longitude];
    
    // This is to convert the latitude and longitude to coordinates for display
    int latSeconds = abs(round(self.locationManager.location.coordinate.latitude * 3600));
    int latDegrees = latSeconds / 3600;
    latSeconds = ABS(latSeconds % 3600);
    int latMinutes = latSeconds / 60;
    latSeconds %= 60;
    
    int longSeconds = abs(round(self.locationManager.location.coordinate.longitude * 3600));
    int longDegrees = longSeconds / 3600;
    longSeconds = ABS(longSeconds % 3600);
    int longMinutes = longSeconds / 60;
    longSeconds %= 60;
    
    NSString* result = [NSString stringWithFormat:@"%d°%d'%d\"%@ %d°%d'%d\"%@",
                        ABS(latDegrees),
                        latMinutes,
                        latSeconds,
                        latDegrees >= 0 ? @"N" : @"S",
                        ABS(longDegrees),
                        longMinutes,
                        longSeconds,
                        longDegrees >= 0 ? @"E" : @"W"];
    
    _address_location.text = result;
    
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


// to scroll view up when keyboard appear
#define kOFFSET_FOR_KEYBOARD 190.0

//this is to move UIView up when keayboard appear
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if ([textField isEqual:_address_state] || [textField isEqual:_address_country] || [textField isEqual:_address_location] || [textField isEqual:_phone] || [textField isEqual:_email] || [textField isEqual:_start_time] || [textField isEqual:_end_time])
    {
        //move the main view, so that the keyboard does not hide it.
        if  (self.view.frame.origin.y >= 0)
        {
            [self setViewMovedUp:YES];
        }
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self setViewMovedUp:NO];

}

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


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


- (IBAction)selectPhoto1:(UIButton *)sender {
    
    photoSeq = @"1";
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];

}
- (IBAction)selectPhoto2:(UIButton *)sender {
    
    photoSeq = @"2";
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];

}
- (IBAction)selectPhoto3:(UIButton *)sender {
    
    photoSeq = @"3";
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];

}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {

    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];

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

    NSString *query = [NSString stringWithFormat:@"INSERT INTO photoID ('type') VALUES('%@')",@"Business"];
    
    [database executeUpdate:query];

    FMResultSet *resultsPhotoName = [database executeQuery:@"select * from photoID order by photoID"];
    photoID = 0;
    while([resultsPhotoName next]) {
        photoID = [resultsPhotoName intForColumn:@"photoID"];
    }
    
    if ([photoSeq isEqualToString:@"1"]) {
        self.imageView1.image = chosenImage;
        // saving image to Document folder
        NSString *strFromInt = [NSString stringWithFormat:@"%d",photoID];
        NSString *fname1 = [NSString stringWithFormat:@"%@_business_1",[strFromInt stringByReplacingOccurrencesOfString:@" " withString:@""]];
        [self saveImage:self.imageView1.image forPerson:fname1];
        photo_filename1 = [[strFromInt stringByReplacingOccurrencesOfString:@" " withString:@""] stringByAppendingString:@"_business_1.png"];
        photo1_taken = @"Yes";
        [_takePhoto2 setEnabled:YES];
        [_selectPhoto2 setEnabled:YES];
        
    }
    else if ([photoSeq isEqualToString:@"2"])
    {
        self.imageView2.image = chosenImage;
        // saving image to Document folder
        NSString *strFromInt = [NSString stringWithFormat:@"%d",photoID];
        NSString *fname2 = [NSString stringWithFormat:@"%@_business_2",[strFromInt stringByReplacingOccurrencesOfString:@" " withString:@""]];
        [self saveImage:self.imageView2.image forPerson:fname2];
        photo_filename2 = [[strFromInt stringByReplacingOccurrencesOfString:@" " withString:@""] stringByAppendingString:@"_business_2.png"];
        photo2_taken = @"Yes";
        [_takePhoto3 setEnabled:YES];
        [_selectPhoto3 setEnabled:YES];
        
    }
    else if ([photoSeq isEqualToString:@"3"])
    {
        self.imageView3.image = chosenImage;
        // saving image to Document folder
        NSString *strFromInt = [NSString stringWithFormat:@"%d",photoID];
        NSString *fname3 = [NSString stringWithFormat:@"%@_business_3",[strFromInt stringByReplacingOccurrencesOfString:@" " withString:@""]];
        [self saveImage:self.imageView3.image forPerson:fname3];
        photo_filename3 = [[strFromInt stringByReplacingOccurrencesOfString:@" " withString:@""] stringByAppendingString:@"_business_3.png"];
        photo3_taken = @"Yes";
        
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
    
    UIImage *chosenImage = image;
    NSData *data = UIImagePNGRepresentation(chosenImage);
    chosenImage = [UIImage imageWithCGImage:[UIImage imageWithData:data].CGImage
                                           scale:chosenImage.scale
                                     orientation:UIImageOrientationDown];
        
    
    //  Now convert the image to PNG/JPEG and write it to the image path
    NSData *imageData = UIImagePNGRepresentation(chosenImage);
    [imageData writeToFile:savedImagePath atomically:NO];
    
    //  Here you save the savedImagePath to your DB
    
}

//- (IBAction)btnSavePhoto:(id)sender {
//    [self saveData];
//    
//}

// update textfield with picker value
-(void)updateTextField:(UIDatePicker *)sender
{
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"HH:mm"];
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"Berlin"]];
    
    if ([self.start_time isEditing]) {
        self.start_time.text = [dateFormat stringFromDate:sender.date];
    }
    else if([self.end_time isEditing]){
        self.end_time.text = [dateFormat stringFromDate:sender.date];
    }
    
    
}

@end
