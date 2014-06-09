//
//  ViewController.m
//  Nutrionix iOS Library
//
//  Created by Peter Kasson on 6/4/14.
//  Copyright (c) 2014 Peter Kasson. All rights reserved.
//

#import "NutritionixDefines.h"

#import "Utility.h"
#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController


// ------------------------------------------------------------
//
// View management
//
// ------------------------------------------------------------
#pragma mark - View


/*
 * on load, check version of iOS
 */
- (void)viewDidLoad
{
 [super viewDidLoad];
 
 [self initAfterLoad];
}



// ------------------------------------------------------------
//
// Logic
//
// ------------------------------------------------------------
#pragma mark - logic


/*
 * post load events
 */
- (void) initAfterLoad
{
 if(!IS_IOS7_OR_GREATER)
 {
  [Utility alertError:@"iOS version must be 7 or higher"];
  
  // disable buttons
 }
}



// ------------------------------------------------------------
//
// segue handling
//
// ------------------------------------------------------------
#pragma mark - segue handling


/*
 * this is how to pass data between views when a seque occurs
 */
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
 NSLog(@"seque:  %@", segue.identifier);
 
 BarCodeScannerViewController *bcvc = [segue destinationViewController];
 
 bcvc.selectedItem = segue.identifier;
}


- (IBAction) unwindToMain:(UIStoryboardSegue *) unwindSegue
{
 // returning from BarCode VC
}



// ------------------------------------------------------------
//
// Misc
//
// ------------------------------------------------------------
#pragma mark - Misc


- (void)didReceiveMemoryWarning
{
 [super didReceiveMemoryWarning];
}


@end
