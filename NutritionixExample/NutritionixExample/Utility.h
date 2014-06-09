//
//  Utility.h
//  Nutrionix iOS Library
//
//  Created by Peter Kasson on 6/4/14.
//  Copyright (c) 2014 Peter Kasson. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>
#import <AudioToolbox/AudioServices.h>
#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>

#import "Constants.h"

#import "Nutritionix_iOS_Library.h"


@interface Utility : NSObject


+ (NSDictionary *) callNutritionixWithUPC :(NSString *) upc;


+ (void) playSound:(NSString *) soundFile;

+ (void) alertError:(NSString *) message;

+ (NSString *) intToString:(int) intValue;


@end
