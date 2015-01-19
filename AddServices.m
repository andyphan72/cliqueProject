//
//  AddServices.m
//  CliqueProject
//
//  Created by Andy Phan on 1/7/15.
//  Copyright (c) 2015 CoDeveloper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AddServices.h"
#import "DataClass.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "FMResultSet.h"



@interface AddServices (){
    DataClass *obj;
}
@end


@implementation AddServices{

}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    tap.cancelsTouchesInView = NO;
    tap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tap];
    
    [self.view endEditing:YES];
    
    self.navigationController.navigationBarHidden = NO;
    
    //for textview border
    CGRect frameRect = _txtServicesDescDummy.frame;
    frameRect.size.height = 92;
    _txtServicesDescDummy.frame = frameRect;
    
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


- (IBAction)btnSaveServices:(id)sender {
    if ([self Validation] == TRUE) {
        [self saveData];
    }
    
}

//this is for textfield validation
- (bool) Validation{
    
    if([[_txtServicesName.text stringByReplacingOccurrencesOfString:@" " withString:@"" ] isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"SERVICES"
                                                        message:@"Services Name is required." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [_txtServicesName becomeFirstResponder];
        
        [alert show];
        return false;
    }
    else if([[_txtServicesLabel.text stringByReplacingOccurrencesOfString:@" " withString:@"" ] isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"SERVICES"
                                                        message:@"Services Label is required." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [_txtServicesLabel becomeFirstResponder];
        
        [alert show];
        return false;
    }
    else if([[_txtServicesDescription.text stringByReplacingOccurrencesOfString:@" " withString:@"" ] isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"SERVICES"
                                                        message:@"Services Description is required." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [_txtServicesDescription becomeFirstResponder];
        
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
    
    NSString *query = [NSString stringWithFormat:@"INSERT INTO services ('services_name', 'services_label', 'services_description', 'businessID') VALUES('%@','%@','%@','%@')",_txtServicesName.text,_txtServicesLabel.text,_txtServicesDescription.text,[obj.companyData objectForKey:@"BusinessID"]];
    
    [database executeUpdate:query];
    
    FMResultSet *resultsServices = [database executeQuery:@"select * from services order by servicesID"];
    servicesID = 0;
    while([resultsServices next]) {
        servicesID = [resultsServices intForColumn:@"servicesID"];
    }
    
    NSString *servicesID_str = [NSString stringWithFormat:@"%d",servicesID];
    NSString *seq = @"1";
    NSString *query2 = [NSString stringWithFormat:@"INSERT INTO services_photos ('seq', 'servicesID', 'filename') VALUES('%@','%@','%@')",seq,servicesID_str,photo_filename];
    [database executeUpdate:query2];
    
    // Display Alert message after saving into database.
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Add Services "
                                                    message:@"New Services record saved." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
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
    
    NSString *query = [NSString stringWithFormat:@"INSERT INTO photoID ('type') VALUES('%@')",@"Services"];
    
    [database executeUpdate:query];
    
    FMResultSet *resultsPhotoName = [database executeQuery:@"select * from photoID order by photoID"];
    photoID = 0;
    while([resultsPhotoName next]) {
        photoID = [resultsPhotoName intForColumn:@"photoID"];
    }
    
    
    self.imgServicesPhoto.image = chosenImage;
    // saving image to Document folder
    NSString *strFromInt = [NSString stringWithFormat:@"%d",photoID];
    NSString *fname1 = [NSString stringWithFormat:@"%@_services",[strFromInt stringByReplacingOccurrencesOfString:@" " withString:@""]];
    [self saveImage:self.imgServicesPhoto.image forPerson:fname1];
    photo_filename = [[strFromInt stringByReplacingOccurrencesOfString:@" " withString:@""] stringByAppendingString:@"_services.png"];
    
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

