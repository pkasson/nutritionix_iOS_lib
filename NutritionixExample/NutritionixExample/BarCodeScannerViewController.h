//
//  BarCodeScannerViewController.h
//  Nutrionix iOS Library
//
//  Created by Peter Kasson on 6/4/14.
//  Copyright (c) 2014 Peter Kasson. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BarCodeViewController.h"
#import "Constants.h"
#import "Utility.h"

@interface BarCodeScannerViewController : UIViewController
{
 __weak IBOutlet UILabel *lblBarcode;
 __weak IBOutlet UILabel *lblItem;
 __weak IBOutlet UILabel *lblBrand;
 __weak IBOutlet UILabel *lblDescription;
 __weak IBOutlet UILabel *lblCalories;
 
 NSString *selectedItem;
}

@property (weak, nonatomic) IBOutlet UILabel *lblBarcode;
@property (weak, nonatomic) IBOutlet UILabel *lblItem;
@property (weak, nonatomic) IBOutlet UILabel *lblBrand;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;
@property (weak, nonatomic) IBOutlet UILabel *lblCalories;


@property (strong, nonatomic) NSString *selectedItem;


- (void) setBarcode :(NSString *) barcode;

@end
