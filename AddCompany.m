//
//  AddCompany.m
//  SingleView
//
//  Created by Andy Phan on 12/24/14.
//  Copyright (c) 2014 Andy Phan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AddCompany.h"

@interface AddCompany (){
    NSArray *_pickerCategoryData;
    

}

@property (nonatomic) IBOutlet UIBarButtonItem* btnSaveCompany;

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


@implementation AddCompany{
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    tap.cancelsTouchesInView = NO;
    tap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tap];
    
    [self.view endEditing:YES];
    
    //for textview border
    CGRect frameRect = _txtCompanyDescDummy.frame;
    frameRect.size.height = 102;
    _txtCompanyDescDummy.frame = frameRect;
    

    // Category piker
    self.pickerCategory = [[UIPickerView alloc] init];
    // Initialize Data
    _pickerCategoryData = @[@"Accomodation", @"Apparel & Accessories", @"Automotive", @"Baby & Toddler", @"Bakery", @"Beauty", @"Books & Magazine", @"Cafe & Lounge", @"Cameras", @"Cinema", @"Delivery & Take Away", @"Dentist", @"Eyewear & Optics", @"Fast Food", @"Financial Instituition", @"Fitness", @"Florist", @"Furniture", @"Gifts", @"Hair Salon", @"Handbags", @"Hardware", @"Household", @"Jewellery", @"Leisure", @"Luggage", @"Medical", @"Mobile & Gadgets", @"Music", @"Office Supplies", @"Outdoor", @"Pets", @"Pharmacy", @"Pubs & Nightclubs", @"Restaurants", @"Shoes", @"Toys & Hobbies", @"Watches"];
    
    // Connect data
    self.pickerCategory.dataSource = self;
    self.pickerCategory.delegate = self;
//    self.pickerCategory.hidden=YES;
    _txtCompanyCatergory.inputView = self.pickerCategory;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// The number of columns of data
- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _pickerCategoryData.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _pickerCategoryData[row];
}

// Catpure the picker view selection
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    // This method is triggered whenever the user makes a change to the picker selection.
    // The parameter named row and component represents what was selected.
    _txtCompanyCatergory.text = _pickerCategoryData[row];
}


- (IBAction)btnSaveCompany:(id)sender {
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
    NSLog(@"%@",dbPath);
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    
    NSString *query = [NSString stringWithFormat:@"INSERT INTO company ('companyName', 'companyDescription', 'category', 'subCategory') VALUES('%@','%@','%@','%@')",[_txtCompanyName.text uppercaseString],_txtCompanyDescription.text,_txtCompanyCatergory.text,_txtCompanySubCategory.text];
    
    [database executeUpdate:query];
    
    
    
    // Display Alert message after saving into database.
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Add Company "
                                                    message:@"New Company record saved.\n Now you can start adding business for this company." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    
    // Enable Add Business button
     [self enableAddBusinessBtn];
    
    // To dismiss keyboard after save
     [self.view endEditing:YES];
    
}

// To clear text fields
- (void) clearTextfields
{
    _txtCompanyName.text = @"";
    _txtCompanyDescription.text = @"";
    _txtCompanyCatergory.text = @"";
    _txtCompanySubCategory.text = @"";
}

// Enable Add Business button
- (void) enableAddBusinessBtn
{

    _btnAddBusiness.enabled = @"Yes";
    [_btnAddBusiness setTintColor:[UIColor whiteColor]];

}


// to hide keyboard
- (void)hideKeyboard{
    
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
}

//this is to hide the Status bar
- (BOOL)prefersStatusBarHidden {return YES;}

//this is for textfield validation
- (bool) Validation{
    
    if([[_txtCompanyName.text stringByReplacingOccurrencesOfString:@" " withString:@"" ] isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"COMPANY"
                                                        message:@"Company Name is required." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [_txtCompanyName becomeFirstResponder];
        
        [alert show];
        return false;
    }
    else if ([_txtCompanyCatergory.text isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"COMPANY"
                                                        message:@"Company Category is required." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [_txtCompanyCatergory becomeFirstResponder];
        
        [alert show];
        return false;
        
    }
    else if ([_txtCompanyDescription.text isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"COMPANY"
                                                        message:@"Company Description is required." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [_txtCompanyDescription becomeFirstResponder];
        
        [alert show];
        return false;
        
    }
    
    
    
    
    return true;
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if ([textField isEqual:self.txtCompanyCatergory]) {
        
        // Close the keypad if it is showing
        [self.view endEditing:YES];
        
        self.pickerCategory.hidden=NO;
    }
    
    return YES;
}


@end