//
//  BarCodeScannerViewController.m
//  Nutrionix iOS Library
//
//  Created by Peter Kasson on 6/4/14.
//  Copyright (c) 2014 Peter Kasson. All rights reserved.
//

#import "BarCodeScannerViewController.h"

@interface BarCodeScannerViewController ()

@end

@implementation BarCodeScannerViewController

@synthesize lblBarcode;
@synthesize lblItem;
@synthesize lblBrand;
@synthesize lblDescription;
@synthesize lblCalories;

@synthesize selectedItem;

BarCodeViewController *bcvc;

NSString *upc;

BOOL notificationInitialized = NO;



/*
 * init
 */
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
 self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
 
 if (self)
 {
 }
 
 return self;
}


/*
 * init any notifications
 */
- (void) initNotifications
{
// [[NSNotificationCenter defaultCenter] addObserver:self
//                                          selector:@selector(barcodeScanned:)
//                                              name:BARCODE_SCANNED object:nil];
}


// ------------------------------------------------------------
//
// View management
//
// ------------------------------------------------------------
#pragma mark - View


/*
 *
 */
- (void) viewDidLoad
{
 [super viewDidLoad];
 
 if(!notificationInitialized)
 {
  notificationInitialized = YES;
  
  [self initNotifications];
 }
 
 NSLog(@"selectedItem:  %@", selectedItem);
}


/*
 *
 */
- (void) viewWillAppear:(BOOL)animated
{
 [super viewWillAppear:animated];
 
 if(bcvc != nil)
 {
  upc = [bcvc getBarcode];
  
  [self setBarcode:upc];
 }
}


// ------------------------------------------------------------
//
// Events
//
// ------------------------------------------------------------
#pragma mark - Events


/*
 * get item that was scanned
 */
- (IBAction) btnScan:(id)sender
{
 bcvc = [[BarCodeViewController alloc] init];
 
 [bcvc setParentVC:self];
 
 // Create the navigation controller and present it.
 UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:bcvc];
 
 [self presentViewController:navigationController animated:YES completion: nil];
}


/*
 * delegate is preferred way to handle getting data from another VC, but for now ...
 */
- (void) setBarcode :(NSString *) barcode
{
 NSLog(@"barcode:  %@", barcode);
 
 if(barcode)
 {
  [Utility playSound:BARCODE_ACK_SOUND];
  
  NSLog(@"barcode:  %@", barcode);
 }
 
 NSDictionary *jsonDictionary = [Utility callNutritionixWithUPC:barcode];
 
 NSMutableArray *data = [[NSMutableArray alloc] init];
 
 [data addObject:barcode];
 [data addObject:jsonDictionary];

 bcvc = nil;

 [self showScanResults:data];
}


/*
 * catch barcode data from api callback
 */
- (void) barcodeScanned :(NSNotification *) barcodeData
{
 NSLog(@"barcodeScanned");
 
 NSArray *data = [barcodeData object];
 
 [self showScanResults:data];
}


/*
 *
 */
- (void) showScanResults :(NSArray *) data
{
 NSMutableDictionary	*jsonDictionary = [data objectAtIndex:1];
 
 
 lblBarcode.text     = @"";
 lblItem.text        = @"";
 lblBrand.text       = @"";
 lblDescription.text = @"";
 lblCalories.text    = @"";
 
 NSString *barcode         = [data objectAtIndex:0];
// NSString *itemId          = [jsonDictionary objectForKey:@"item_id"];
 NSString *itemName        = [jsonDictionary objectForKey:@"item_name"];
 NSString *brandName       = [jsonDictionary objectForKey:@"brand_name"];
 NSString *itemDescription = [jsonDictionary objectForKey:@"item_description"];
 NSObject *calories        = [jsonDictionary objectForKey:@"nf_calories"];
 
 if(barcode != nil)
 {
  lblBarcode.text = barcode;
 }
 
 if(![itemName isKindOfClass:[NSNull class]])
 {
  lblItem.text = itemName;
 }
 
 if(![brandName isKindOfClass:[NSNull class]])
 {
  lblBrand.text = brandName;
 }
 
 if(![itemDescription isKindOfClass:[NSNull class]])
 {
  lblDescription.text = itemDescription;
 }
 
 if(calories)
 {
  if(![calories isKindOfClass:[NSNull class]])
  {
   NSNumber *caloriesNumber = (NSNumber *) calories;
   
   lblCalories.text    = [Utility intToString:[caloriesNumber intValue]];
  }
 }
 
 // NSLog(@"item:  %@, name:  %@, brand:  %@, description:  %@, calories:  %@", itemId, itemName, brandName, itemDescription, calories);
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
