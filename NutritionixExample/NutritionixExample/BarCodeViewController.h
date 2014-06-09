//
//  BarCodeViewController.h
//  Nutrionix iOS Library
//
//  Created by Peter Kasson on 6/4/14.
//  Copyright (c) 2014 Peter Kasson. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BarCodeScannerViewController.h"
#import "Constants.h"
#import "Utility.h"


@interface BarCodeViewController : UIViewController


- (void) setParentVC :(UIViewController *) vc;


- (NSString *) getBarcode;


@end