//
//  Nutritionix_iOS_Library.h
//  Nutritionix_iOS_Library
//
//  Created by Peter Kasson on 6/7/14.
//  Copyright (c) 2014 Peter Kasson. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LibConstants.h"

@interface Nutritionix_iOS_Library : NSObject


+ (void) initProperties :(NSString *) apiUrlSent :(NSString *) appIdSent :(NSString *) appKeySent;


+ (id) callNutritionixWithUPC :(NSString *) upc;                      // requires nsnotification call back


+ (NSDictionary *) callNutritionixWithUPCAndWait :(NSString *) upc;   // returns json directly



@end
