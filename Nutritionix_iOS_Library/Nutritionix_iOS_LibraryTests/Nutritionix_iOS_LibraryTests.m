//
//  Nutritionix_iOS_LibraryTests.m
//  Nutritionix_iOS_LibraryTests
//
//  Created by Peter Kasson on 6/8/14.
//  Copyright (c) 2014 Peter Kasson. All rights reserved.
//


//
// These tests are not mocked, but executing against a live end point.  There is no point in mocking up a test that returns
//   simulated data, against an async call, the call either works or it doesnt.  Altering the actual method to handle mock
//   tests does not validate a live call and muddies the library implementation.
//
// Due to the nature of the async web api call, and handling callbacks, these unit tests must handle this call chain anomoly
//   by identifying the condition and expection, so the callback method can correctly determine pass/fail
//
// Two options exist for testing - one async, and one sync.  These tests were changed, as well as an additional library method
//   added to support both call structures.  This test currently exeuctes against the async method only.
//



#import "Nutritionix_iOS_Library.h"
#import "NutritionixDefines.h"

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>


@interface Nutritionix_iOS_LibraryTests : XCTestCase

@end



@implementation Nutritionix_iOS_LibraryTests


NSString *barcode;
NSString *itemId;
NSString *itemName;
NSString *brandName;
NSString *itemDescription;

NSString *methodNameUnderTest;

BOOL methodShouldPass = YES;
BOOL itemNameIsValid  = YES;
BOOL usingCallback    = NO;

/*
 * setup for tests
 */
- (void)setUp
{
 [super setUp];
 
 NSString *appId  = @"";
 NSString *appKey = @"";

 
 [Nutritionix_iOS_Library initProperties:@"https://api.nutritionix.com/v1_1/" :appId :appKey];

 
 if(usingCallback)
 {
  // setup notification handler, from the library, to receive the callback
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(barcodeScanned:)
                                               name:BARCODE_SCANNED object:nil];
 }
}


/*
 * stop all the fun
 */
- (void)tearDown
{
 [super tearDown];
}


/*
 * only iOS 7+ will work
 */
- (void) testOSVersion
{
 if(!IS_IOS7_OR_GREATER)
 {
  XCTFail(@"iOS version is not 7 or higher");
 }
}


/*
 * this test should succeed - returning Brookside Dark Chocolate Pomegranate snack food (yum)
 *
 *        "item_id"   = 51d2fececc9bff111580f3e7;
 *        "item_name" = "Pomegranate, Dark Chocolate";
 *
 */
- (void) testUPCLookupSuccess
{
 NSString *upcCode            = @"068437389082";                     // Brookside Dark Chocolate Pomegranate
 NSString *chocolateSnackName = @"Pomegranate, Dark Chocolate";

 NSDictionary *jsonDictionary = [Nutritionix_iOS_Library callNutritionixWithUPCAndWait:upcCode];

 XCTAssertTrue(jsonDictionary != nil, @"No data returned from Nutritionix API service call");
 
 NSString *itemName = [jsonDictionary objectForKey:@"item_name"];
 
 XCTAssertTrue([itemName hasPrefix:chocolateSnackName], @"Incorrect item name returned from Nutritionix API service call");
}


/*
 * catch barcode data from api callback
 */
- (void) barcodeScanned :(NSNotification *) barcodeData
{
 NSArray *data = [barcodeData object];
 
 NSMutableDictionary	*jsonDictionary = [data objectAtIndex:1];
 
 barcode         = [data objectAtIndex:0];
 itemId          = [jsonDictionary objectForKey:@"item_id"];
 itemName        = [jsonDictionary objectForKey:@"item_name"];
 brandName       = [jsonDictionary objectForKey:@"brand_name"];
 itemDescription = [jsonDictionary objectForKey:@"item_description"];

 
 NSLog(@"barcode        :  %@", barcode);
 NSLog(@"itemId         :  %@", itemId);
 NSLog(@"itemName       :  %@", itemName);
 NSLog(@"brandName      :  %@", brandName);
 NSLog(@"itemDescription:  %@", itemDescription);
}

@end
