//
//  Nutritionix_iOS_Library.m
//  Nutritionix_iOS_Library
//
//  Created by Peter Kasson on 6/7/14.
//  Copyright (c) 2014 Peter Kasson. All rights reserved.
//

#import "Nutritionix_iOS_Library.h"



@implementation Nutritionix_iOS_Library


AVAudioPlayer *avAudioPlayer;

AFHTTPRequestOperationManager *manager;

NSDictionary *infoDict;

id response;

NSString *apiIUrl;
NSString *appId;
NSString *appKey;


/*
 * load properties (app id, app key)
 */
+ (void) initProperties
{
 if(apiIUrl == nil)
 {
  apiIUrl = [Nutritionix_iOS_Library readPlist:APP_API_URL];
  appId   = [Nutritionix_iOS_Library readPlist:APP_ID];
  appKey  = [Nutritionix_iOS_Library readPlist:APP_KEY];
  
  NSLog(@"appId:  %@, appKey:  %@", appId, appKey);
 }
}


/*
 * load properties - for testing (cant/shouldnt include plists in library)
 */
+ (void) initProperties :(NSString *) apiUrlSent :(NSString *) appIdSent :(NSString *) appKeySent
{
 apiIUrl = apiUrlSent;
 appId   = appIdSent;
 appKey  = appKeySent;
 
 NSLog(@"apiUrl:  %@, appId:  %@, appKey:  %@", apiIUrl, appId, appKey);
}


/*
 * call Nutritionix API - using completion block (asynch call structure, preferred approach, but requires notification to service layer / UI)
 *
 *     // https://api.nutritionix.com/v1_1/item?upc=49000036756&appId=[YOURID]&appKey=[YOURKEY]
 */
+ (id) callNutritionixWithUPC :(NSString *) upc
{
 if(manager == nil)
 {
  manager = [AFHTTPRequestOperationManager manager];
 }
 
 [manager GET:[Nutritionix_iOS_Library getUPCUrlString:upc] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
  {
   response = responseObject;
   
   NSMutableDictionary *jsonDictionary = (NSMutableDictionary *)response;
   
   NSMutableArray *data = [[NSMutableArray alloc] init];
   
   [data addObject:upc];
   [data addObject:jsonDictionary];
   
   [[NSNotificationCenter defaultCenter] postNotificationName: BARCODE_SCANNED object: data];    // calback - update UI
  }
  
  failure:^(AFHTTPRequestOperation *operation, NSError *error)
  {
   response = nil;
   
   NSLog(@">>>  Nutritionix API call error:  %@", error);
  }
 ];
 
 return response;
}


/*
 * call Nutitionix with wait (ensuring 'synchronous' call structure)
 */
+ (NSDictionary *) callNutritionixWithUPCAndWait :(NSString *) upc
{
 NSDictionary *response;

 NSError *error;

 if(apiIUrl == nil)
 {
  [Nutritionix_iOS_Library initProperties];
 }
 
 NSMutableURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[Nutritionix_iOS_Library getUPCUrlString:upc]]];

// NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]
//                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
//                                       timeoutInterval:5.0];
 
 AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
 
 [operation start];
 [operation waitUntilFinished];
 
 long httpStatus = [operation.response statusCode];
 
 if(httpStatus >= 200 && httpStatus < 300)
 {
  // convert NSData response to JSON, via dictionary converter
  response = [NSJSONSerialization JSONObjectWithData: [operation responseObject] options: NSJSONReadingMutableContainers error: &error];
  
  if(!error)
  {
   NSLog(@"Nutritionix API - successful response:  %@", response);
  }
 }
 else
 {
  NSLog(@">>>  Nutritionix API call error:  %ld, message:  %@", httpStatus, error);
 }
 
 return response;
}


/*
 * convert the JSON response from the API call into a Dictionary
 */
+ (NSMutableDictionary *) parseJSON :(id) json
{
 NSError *error;
 
 NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
 
 NSMutableDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
 
 return jsonResponse;
}


/*
 * read from app plist, using provided key
 */
+ (NSString *) readPlist :(NSString *) key
{
 if(!infoDict)
 {
  infoDict = [[NSBundle mainBundle] infoDictionary];
 }
 
 return [infoDict objectForKey:key];
}


/*
 * read a plist
 */
+ (NSDictionary *) readPList:(NSString *) fileName
{
 NSLog(@"bundle path:  %@", [NSBundle mainBundle]);
 
 NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
 
 if(!infoDict)
 {
  infoDict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
 }
 
 return infoDict;
}


/*
 * build the URL for a upc lookup
 */
+ (NSString *) getUPCUrlString :(NSString *) upc
{
 NSLog(@"Nutritionix API call:  %@", [apiIUrl stringByAppendingFormat:@"item?upc=%@&appId=%@&appKey=%@", upc, appId, appKey]);

 return [apiIUrl stringByAppendingFormat:@"item?upc=%@&appId=%@&appKey=%@", upc, appId, appKey];
}



@end


