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
    
    //for textview border
    CGRect frameRect = _txtEventDescDummy.frame;
    frameRect.size.height = 92;
    _txtEventDescDummy.frame = frameRect;
    
    
    obj = [DataClass getInstance];
    CompanyDetails = [[NSDictionary alloc] init];
    obj = [DataClass getInstance];
    _businessNamelbl.text = [obj.companyData objectForKey:@"BusinessName"];
    _companyNamelbl.text = [obj.companyData objectForKey:@"CompanyName"];
    
    
    // setting navigation bar transparent
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    
    // setting date picker for start and end date
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    [datePicker addTarget:self action:@selector(updateTextField:)
         forControlEvents:UIControlEventValueChanged];
    [self.txtStartDate setInputView:datePicker];
    [self.txtEndDate setInputView:datePicker];
    
    //set textfield delefate for scrolling screen up when keyboard or picker appear. This will call the textFieldDidBeginEditing
    self.txtStartDate.delegate=self;
    self.txtEndDate.delegate=self;
    self.txtEventVenue.delegate=self;
    
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
    else if([[_txtEventDescription.text stringByReplacingOccurrencesOfString:@" " withString:@"" ] isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"EVENT"
                                                        message:@"Event Description is required." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [_txtEventDescription becomeFirstResponder];
        
        [alert show];
        return false;
    }
    else if([[_txtEventVenue.text stringByReplacingOccurrencesOfString:@" " withString:@"" ] isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"EVENT"
                                                        message:@"Event Venue is required." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [_txtEventVenue becomeFirstResponder];
        
        [alert show];
        return false;
    }
    else if([[_txtStartDate.text stringByReplacingOccurrencesOfString:@" " withString:@"" ] isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"EVENT"
                                                        message:@"Event Start Date is required." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [_txtStartDate becomeFirstResponder];
        
        [alert show];
        return false;
    }
    else if([[_txtEndDate.text stringByReplacingOccurrencesOfString:@" " withString:@"" ] isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"EVENT"
                                                        message:@"Event End Date is required." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [_txtEndDate becomeFirstResponder];
        
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


//this is to select photo from camera roll of the event
- (IBAction)selectPhoto:(UIButton *)sender {
    
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
    
    NSString *query = [NSString stringWithFormat:@"INSERT INTO photoID ('type') VALUES('%@')",@"Event"];
    
    [database executeUpdate:query];
    
    FMResultSet *resultsPhotoName = [database executeQuery:@"select * from photoID order by photoID"];
    photoID = 0;
    while([resultsPhotoName next]) {
        photoID = [resultsPhotoName intForColumn:@"photoID"];
    }
    
        self.imgEventPhoto.image = chosenImage;
        // saving image to Document folder
        NSString *strFromInt = [NSString stringWithFormat:@"%d",photoID];
        NSString *fname1 = [NSString stringWithFormat:@"%@_event",[strFromInt stringByReplacingOccurrencesOfString:@" " withString:@""]];
        [self saveImage:self.imgEventPhoto.image forPerson:fname1];
        photo_filename = [[strFromInt stringByReplacingOccurrencesOfString:@" " withString:@""] stringByAppendingString:@"_event.png"];
    
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

// update textfield with picker value
-(void)updateTextField:(UIDatePicker *)sender
{

    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd-MM-yyyy HH:mm"];
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"Berlin"]];
    
    if ([self.txtStartDate isEditing]) {
        self.txtStartDate.text = [dateFormat stringFromDate:sender.date];
    }
    else if([self.txtEndDate isEditing]){
        self.txtEndDate.text = [dateFormat stringFromDate:sender.date];
    }
}

// to scroll view up when keyboard appear
#define kOFFSET_FOR_KEYBOARD 170.0

-(void)textFieldDidBeginEditing:(UITextField *)sender
{
    if ([sender isEqual:_txtStartDate] || [sender isEqual:_txtEndDate] || [sender isEqual:_txtEventVenue])
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
    [self setViewMovedUp:NO];}

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

// to hide keyboard
- (void)hideKeyboard{
    
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
}

//this is to hide the Status bar
- (BOOL)prefersStatusBarHidden {return YES;}



@end


