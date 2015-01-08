//
//  AddEvent.h
//  CliqueProject
//
//  Created by Andy Phan on 1/6/15.
//  Copyright (c) 2015 CoDeveloper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "FMDatabase.h"
#import "FMResultSet.h"


@interface AddEvent : UIViewController<UIPickerViewDelegate,UITextFieldDelegate>{
    
    NSDictionary *CompanyDetails;
    NSString *photo_filename;
    int eventID;
    
    CGPoint textFieldPoint;
    UITextField *curentlyBeingEditingTextField;
    
}

@property (strong, nonatomic) IBOutlet UILabel *businessNamelbl;
@property (strong, nonatomic) IBOutlet UILabel *companyNamelbl;
@property (strong, nonatomic) IBOutlet UITextField *txtEventTitle;
@property (strong, nonatomic) IBOutlet UITextField *txtEventLocation;
@property (strong, nonatomic) IBOutlet UITextView *txtEventDescription;
@property (strong, nonatomic) IBOutlet UITextField *txtEventVenue;
@property (strong, nonatomic) IBOutlet UITextField *txtStartDate;
@property (strong, nonatomic) IBOutlet UITextField *txtEndDate;
@property (strong, nonatomic) IBOutlet UIImageView *imgEventPhoto;

//@property (strong, nonatomic) IBOutlet UIButton *btnTakePhoto;

//@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnSaveEvent;

- (IBAction)btnSaveEvent:(id)sender;
- (IBAction)takePhoto:  (UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIButton *takePhoto;

@property (strong, nonatomic) IBOutlet UIDatePicker *startDatePicker;
@property (weak, nonatomic) IBOutlet UIScrollView *addEventView;



@end
