//
//  AddBusinessMain.h
//  CliqueProject
//
//  Created by Andy Phan on 12/30/14.
//  Copyright (c) 2014 CoDeveloper. All rights reserved.
//

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


@interface AddBusinessMain : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *companylbl;
@property (nonatomic, retain) NSString* labelString;




@end
