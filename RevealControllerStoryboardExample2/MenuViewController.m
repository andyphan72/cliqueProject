//
//  MenuViewController.m
//  RevealControllerStoryboardExample
//
//  Created by Nick Hodapp on 1/9/13.
//  Copyright (c) 2013 CoDeveloper. All rights reserved.
//

#import "MenuViewController.h"
#import "ColorViewController.h"

@implementation SWUITableViewCell
@end

@implementation MenuViewController


- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
    // configure the destination view controller:
    if ( [sender isKindOfClass:[UITableViewCell class]] )
    {
        UILabel* c = [(SWUITableViewCell *)sender label];
        UINavigationController *navController = segue.destinationViewController;
        ColorViewController* cvc = [navController childViewControllers].firstObject;
        if ( [cvc isKindOfClass:[ColorViewController class]] )
        {
            cvc.color = c.textColor;
            cvc.text = c.text;
        }
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 9;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";

    switch ( indexPath.row )
    {
        case 0:
            CellIdentifier = @"newsfeed";
            break;
            
        case 1:
            CellIdentifier = @"wtd";
            break;

        case 2:
            CellIdentifier = @"weekend";
            break;
            
        case 3:
            CellIdentifier = @"hot";
            break;

        case 4:
            CellIdentifier = @"lookAround";
            break;

        case 5:
            CellIdentifier = @"blank";
            break;

            
        case 6:
            CellIdentifier = @"blank2";
            break;
            
        case 7:
            CellIdentifier = @"companylisting";
            break;
            
        case 8:
            CellIdentifier = @"companyadd";
            break;
            
            
    }

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier forIndexPath: indexPath];
 
    return cell;
}

#pragma mark state preservation / restoration
- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // TODO save what you need here
    
    [super encodeRestorableStateWithCoder:coder];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // TODO restore what you need here
    
    [super decodeRestorableStateWithCoder:coder];
}

- (void)applicationFinishedRestoringState {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // TODO call whatever function you need to visually restore
}

//this is to hide the Status bar
- (BOOL)prefersStatusBarHidden {return YES;}



@end
