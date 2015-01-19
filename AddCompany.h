//
//  AddCompany.h
//  SingleView
//
//  Created by Andy Phan on 12/24/14.
//  Copyright (c) 2014 Andy Phan. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "FMDatabase.h"
#import "FMResultSet.h"


@interface AddCompany : UIViewController<UIPickerViewDelegate,UITextFieldDelegate>{

   

}

@property (strong, nonatomic) IBOutlet UITextField *txtCompanyName;
@property (strong, nonatomic) IBOutlet UITextField *txtCompanyCatergory;
@property (strong, nonatomic) IBOutlet UITextField *txtCompanySubCategory;
@property (strong, nonatomic) IBOutlet UITextView *txtCompanyDescription;
@property (strong, nonatomic) IBOutlet UIButton *btnCategoryList;
@property (strong, nonatomic) IBOutlet UIButton *btnAddBusiness;
@property (strong, nonatomic) IBOutlet UITextField *txtCompanyDescDummy;

@property (strong, nonatomic) IBOutlet UIPickerView *pickerCategory;

- (IBAction)btnSaveCompany:(id)sender;
- (IBAction)btnCategoryList:(id)sender;


@end
