//
//  AddProduct.h
//  CliqueProject
//
//  Created by Andy Phan on 1/7/15.
//  Copyright (c) 2015 CoDeveloper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "FMDatabase.h"
#import "FMResultSet.h"


@interface AddProduct : UIViewController<UIPickerViewDelegate,UITextFieldDelegate>{
    
    NSDictionary *CompanyDetails;
    NSString *photo_filename;
    int productID;
    
}

@property (strong, nonatomic) IBOutlet UILabel *businessNamelbl;
@property (strong, nonatomic) IBOutlet UILabel *companyNamelbl;
@property (strong, nonatomic) IBOutlet UITextField *txtProductName;
@property (strong, nonatomic) IBOutlet UITextField *txtProductLabel;
@property (strong, nonatomic) IBOutlet UITextView *txtProductDescription;
@property (strong, nonatomic) IBOutlet UIImageView *imgProductPhoto;
@property (strong, nonatomic) IBOutlet UITextField *txtProductDescDummy;


- (IBAction)btnSaveProduct:(id)sender;
- (IBAction)selectPhoto:(UIButton *)sender;
- (IBAction)takePhoto:  (UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIButton *takePhoto;
@property (strong, nonatomic) IBOutlet UIButton *selectPhoto;


@end