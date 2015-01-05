//
//  AddBusinessMain.m
//  CliqueProject
//
//  Created by Andy Phan on 12/30/14.
//  Copyright (c) 2014 CoDeveloper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AddBusinessMain.h"


@interface AddBusinessMain ()

@end

@implementation AddBusinessMain

- (void)viewDidLoad {
    [super viewDidLoad];
    _companylbl.text = _labelString;
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    tap.cancelsTouchesInView = NO;
    tap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tap];
    
    // to hide keyboard
    [self.view endEditing:YES];
    
    
}





//this is to hide the Status bar
- (BOOL)prefersStatusBarHidden {return YES;}

@end

