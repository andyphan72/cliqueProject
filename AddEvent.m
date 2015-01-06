//
//  AddEvent.m
//  CliqueProject
//
//  Created by Andy Phan on 1/6/15.
//  Copyright (c) 2015 CoDeveloper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AddEvent.h"
#import "DataClass.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "FMResultSet.h"



@interface AddEvent (){
    DataClass *obj;
}
@end


@implementation AddEvent{
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    tap.cancelsTouchesInView = NO;
    tap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tap];
    
    [self.view endEditing:YES];
    
    self.navigationController.navigationBarHidden = NO;
    
    obj = [DataClass getInstance];
    CompanyDetails = [[NSDictionary alloc] init];
    obj = [DataClass getInstance];
    _businessNamelbl.text = [obj.companyData objectForKey:@"BusinessName"];
    _companyNamelbl.text = [obj.companyData objectForKey:@"CompanyName"];
    
    
    // setting navigation bar transparent
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    
    
    
    
}


- (IBAction)btnSaveEvent:(id)sender {
    if ([self Validation] == TRUE) {
        [self saveData];
    }
    
}

//this is for textfield validation
- (bool) Validation{
    
    if([[_txtEventTitle.text stringByReplacingOccurrencesOfString:@" " withString:@"" ] isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"EVENT"
                                                        message:@"Event Title is required." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [_txtEventTitle becomeFirstResponder];
        
        [alert show];
        return false;
    }
    
    return true;
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
    NSLog(@"%@",dbPath);
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    
    NSString *query = [NSString stringWithFormat:@"INSERT INTO event ('event_title', 'event_description', 'event_location', 'event_venue', 'date_time_start', 'date_time_end', 'businessID') VALUES('%@','%@','%@','%@','%@','%@','%@')",_txtEventTitle.text,_txtEventDescription.text,_txtEventLocation.text,_txtEventVenue.text,_txtStartDate.text,_txtEndDate.text,[obj.companyData objectForKey:@"BusinessID"]];
    
    [database executeUpdate:query];
    
    FMResultSet *resultsEvent = [database executeQuery:@"select * from event order by eventID"];
    eventID = 0;
    while([resultsEvent next]) {
        eventID = [resultsEvent intForColumn:@"eventID"];
    }
    
        NSString *eventID_str = [NSString stringWithFormat:@"%d",eventID];
        NSString *seq = @"1";
        NSString *query2 = [NSString stringWithFormat:@"INSERT INTO event_photos ('seq', 'eventID', 'filename') VALUES('%@','%@','%@')",seq,eventID_str,photo_filename];
        [database executeUpdate:query2];
    
    
    
    
    // Display Alert message after saving into database.
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Add Event "
                                                    message:@"New Event record saved." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    
    // To dismiss keyboard after save
    [self.view endEditing:YES];
    
}


//this is to capture photo of the event
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
    
        self.imgEventPhoto.image = chosenImage;
        // saving image to Document folder
        NSString *fname1 = [NSString stringWithFormat:@"%@",[_txtEventTitle.text stringByReplacingOccurrencesOfString:@" " withString:@""]];
        [self saveImage:self.imgEventPhoto.image forPerson:fname1];
        photo_filename = [[_txtEventTitle.text stringByReplacingOccurrencesOfString:@" " withString:@""] stringByAppendingString:@".png"];
    
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

// to hide keyboard
- (void)hideKeyboard{
    
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
}

//this is to hide the Status bar
- (BOOL)prefersStatusBarHidden {return YES;}



@end


