//
//  BusinessView.m
//  CliqueProject
//
//  Created by Andy Phan on 1/3/15.
//  Copyright (c) 2015 CoDeveloper. All rights reserved.
//

#import "BusinessView.h"
#import "DataClass.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "FMResultSet.h"

@interface BusinessView (){
    DataClass *obj;
}
@property (nonatomic) IBOutlet UIBarButtonItem* revealButtonItem;

@end

@implementation BusinessView

@synthesize companylbl;
@synthesize companyDescription;
@synthesize businesslbl;
@synthesize eventsTableView;


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    
    
    obj = [DataClass getInstance];
    CompanyDetails = [[NSDictionary alloc] init];
    companylbl.text = [obj.companyData objectForKey:@"CompanyName"];
    companyDescription.text = [obj.companyData objectForKey:@"CompanyDescription"];
    businesslbl.text = [obj.companyData objectForKey:@"BusinessName"];
    
    
    eventsTableView.userInteractionEnabled = YES;
    
    //fmdb start
//    BOOL success;
//    NSString *dbName = @"cliqueDB.rdb";
//    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDir = [documentPaths objectAtIndex:0];
//    NSString *dbPath = [documentsDir   stringByAppendingPathComponent:dbName];
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    success = [fileManager fileExistsAtPath:dbPath];
//    NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:dbName];
//    [fileManager copyItemAtPath:databasePathFromApp toPath:dbPath error:nil];
//    
//    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
//    [database open];
//    
//    _businessID = [[NSMutableArray alloc] init];
//    _businessName = [[NSMutableArray alloc] init];
//    
//    FMResultSet *results = [database executeQuery:@"select businessID, businessname from company_business where companyID = ?",[obj.companyData objectForKey:@"CompanyID"]];
//    
//    while([results next]) {
//        NSString *businessID = [results stringForColumn:@"businessID"];
//        NSString *businessname = [results stringForColumn:@"businessname"];
//        
//        
//        totalRecords = totalRecords +1;
//        
//        [_businessID addObject:businessID];
//        [_businessName addObject:businessname];
//    
//        
//    }
//    [database close];
//    [self.businessTableView reloadData];
//    
}

//this is to capture photo of the business
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

- (IBAction)btnSavePhoto:(id)sender {
    [self saveData];
    
}

- (void) saveData
{
    // saving image to Document folder
    
    NSString *imagename = [NSString stringWithFormat:@"%@_%@",companylbl.text,businesslbl.text];
    [self saveImage:self.imageView.image forPerson:imagename];
    NSString *imageFilename = [imagename stringByAppendingString:@".png"]; // or .jpg
    NSString *sequence = @"1";
    
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
    
    NSString *query = [NSString stringWithFormat:@"INSERT INTO business_photos ('businessID','seq', 'filename') VALUES('%@','%@','%@')",[obj.companyData objectForKey:@"BusinessID"],sequence,imageFilename];
    
    [database executeUpdate:query];
    
    
    
    // Display Alert message after saving into database.
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Add PHOTO "
                                                    message:@"New Business Photo saved." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    
}



//this is to hide the Status bar
- (BOOL)prefersStatusBarHidden {return YES;}



@end
