//
//  MapViewController.m
//  RevealControllerStoryboardExample
//
//  Created by Nick Hodapp on 1/9/13.
//  Copyright (c) 2013 CoDeveloper. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()
@property (nonatomic) IBOutlet UIBarButtonItem* revealButtonItem;
@end

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customSetup];
    
    // setting navigation bar transparent
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    
    
    
}

- (void)customSetup
{
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.revealButtonItem setTarget: self.revealViewController];
        [self.revealButtonItem setAction: @selector( revealToggle: )];
        [self.navigationController.navigationBar addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    }
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor clearColor]];
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
                                                           shadow, NSShadowAttributeName,
                                                           [UIFont fontWithName:@"System" size:21.0], NSFontAttributeName, nil]];
    
}

//#pragma mark state preservation / restoration
//
//- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
//{
//    NSLog(@"%s", __PRETTY_FUNCTION__);
//
//    // Save what you need here
//    
//    [super encodeRestorableStateWithCoder:coder];
//}
//
//
//- (void)decodeRestorableStateWithCoder:(NSCoder *)coder
//{
//    NSLog(@"%s", __PRETTY_FUNCTION__);
//    
//    // Restore what you need here
//    
//    [super decodeRestorableStateWithCoder:coder];
//}
//
//
//- (void)applicationFinishedRestoringState
//{
//    NSLog(@"%s", __PRETTY_FUNCTION__);
//    
//    // Call whatever function you need to visually restore
//    [self customSetup];
//}

//this is to hide the Status bar
- (BOOL)prefersStatusBarHidden {return YES;}

@end
