//
//  AddServices.h
//  CliqueProject
//
//  Created by Andy Phan on 1/7/15.
//  Copyright (c) 2015 CoDeveloper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "FMDatabase.h"
#import "FMResultSet.h"


@interface AddServices : UIViewController<UIPickerViewDelegate,UITextFieldDelegate>{
    
    NSDictionary *CompanyDetails;
    NSString *photo_filename;
    int servicesID;
    int photoID;
    
    
}

@property (strong, nonatomic) IBOutlet UILabel *businessNamelbl;
@property (strong, nonatomic) IBOutlet UILabel *companyNamelbl;
@property (strong, nonatomic) IBOutlet UITextField *txtServicesName;
@property (strong, nonatomic) IBOutlet UITextField *txtServicesLabel;
@property (strong, nonatomic) IBOutlet UITextView *txtServicesDescription;
@property (strong, nonatomic) IBOutlet UIImageView *imgServicesPhoto;
@property (strong, nonatomic) IBOutlet UITextField *txtServicesDescDummy;


- (IBAction)btnSaveServices:(id)sender;
- (IBAction)selectPhoto:(UIButton *)sender;
- (IBAction)takePhoto:  (UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIButton *takePhoto;
@property (strong, nonatomic) IBOutlet UIButton *selectPhoto;




@end