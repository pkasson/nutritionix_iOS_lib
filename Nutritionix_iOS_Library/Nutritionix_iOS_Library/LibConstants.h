//
//  Constants.h
//  Nutrionix iOS Library
//
//  Created by Peter Kasson on 6/4/14.
//  Copyright (c) 2014 Peter Kasson. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>
#import <AudioToolbox/AudioServices.h>
#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>

#import "AFHTTPRequestOperationManager.h"

#import "LibConstants.h"


@interface LibConstants : NSObject


extern NSString * const APP_ID;
extern NSString * const APP_KEY;
extern NSString * const APP_API_URL;

extern NSString * const PLIST_FILENAME;

extern NSString * const BARCODE_SCANNED;

@end
