//
//  Utility.m
//  Nutrionix iOS Library
//
//  Created by Peter Kasson on 6/4/14.
//  Copyright (c) 2014 Peter Kasson. All rights reserved.
//


#import "Utility.h"



@implementation Utility


AVAudioPlayer *avAudioPlayer;

NSDictionary *infoDict;

id response;


/*
 * call Nutritionix API
 */
+ (NSDictionary *) callNutritionixWithUPC :(NSString *) upc
{
// return [Nutritionix_iOS_Library callNutritionixWithUPC:upc];
 
 return [Nutritionix_iOS_Library callNutritionixWithUPCAndWait:upc];
}


/*
 * show an alert UI with only the OK button showing
 */
+ (void) showAlertOk:(NSString *) title :(NSString *) message
{
 // NSLocalizedString(@"Global.OK", nil)
 
 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message
                                                delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
 [alert show];
}


/*
 * show alert with error message
 */
+ (void) alertError:(NSString *) message
{
 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:message
                                                delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
 
 [alert show];
}


/*
 * show an alert UI with only the OK button showing
 */
+ (void) showAlert:(NSString *) title :(NSString *) message :(NSString *) cancelButtonTitle :(NSString *) otherButtonTitle :(NSObject *) delegateClass
{
 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message
                                                delegate:delegateClass cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitle, nil];
 [alert show];
}


/*
 * convert an int to string
 */
+ (NSString *) intToString:(int) intValue
{
 return [NSString stringWithFormat:@"%d",intValue];
}



/*
 * play sound file
 */
+ (void) playSound:(NSString *) soundFile
{
 NSError *error;
 
 NSString *soundFileName = [@"" stringByAppendingFormat:@"%@/%@", [Utility getBundleDirectory], soundFile];
 NSURL *audioFile        = [NSURL fileURLWithPath:soundFileName];
 
 @try
 {
  avAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioFile error:&error];
  
  if(error)
  {
   NSLog(@"playSound - error:  %@", error);
  }
  else
  {
   [avAudioPlayer prepareToPlay];
   [avAudioPlayer play];
  }
 }
 @catch (NSException *exception)
 {
  NSLog(@"playSound - error:  %@", exception);
 }
 @finally
 {
  // nop
 }
}


/*
 * get the app bundle directory
 */
+ (NSString *) getBundleDirectory
{
 NSBundle *bundle               = [NSBundle mainBundle];
 NSString *bundleExecutablePath = [bundle executablePath];
 NSString *bundleResourcePath   = [bundle resourcePath];
 
 NSLog(@"Utility - bundleExecutablePath : %@", bundleExecutablePath);
 NSLog(@"Utility - bundleResourcePath   : %@", bundleResourcePath);
 
 return bundleResourcePath;
}


@end


