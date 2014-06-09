//
//  BarCodeViewController.m
//  Nutrionix iOS Library
//
//  Created by Peter Kasson on 6/4/14.
//  Copyright (c) 2014 Peter Kasson. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

#import "BarCodeViewController.h"


@interface BarCodeViewController () <AVCaptureMetadataOutputObjectsDelegate>
{
 AVCaptureSession *session;
 AVCaptureDevice *device;
 AVCaptureDeviceInput *input;
 AVCaptureMetadataOutput *output;
 AVCaptureVideoPreviewLayer *prevLayer;

 BarCodeScannerViewController *parentVC;
 
 UIView *highlightView;
}
@end


@implementation BarCodeViewController


NSString *detectionString  = nil;
NSString *lastBarcodeValue = nil;


/*
 *
 */
- (void)viewDidLoad
{
 [super viewDidLoad];
 
 highlightView = [[UIView alloc] init];
 highlightView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
 highlightView.layer.borderColor = [UIColor greenColor].CGColor;
 highlightView.layer.borderWidth = 3;
 
 [self.view addSubview:highlightView];

 session = [[AVCaptureSession alloc] init];
 device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];

 NSError *error = nil;
 
 input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
 
 if (input)
 {
  [session addInput:input];
 }
 else
 {
  NSLog(@"Error: %@", error);
 }
 
 output = [[AVCaptureMetadataOutput alloc] init];
 [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
 [session addOutput:output];
 
 output.metadataObjectTypes = [output availableMetadataObjectTypes];
 
 prevLayer = [AVCaptureVideoPreviewLayer layerWithSession:session];
 prevLayer.frame = self.view.bounds;
 prevLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
 
 [self.view.layer addSublayer:prevLayer];
 
 [session startRunning];
 
 [self.view bringSubviewToFront:highlightView];
}


/*
 * obtain bar code information and play sound when successful
 */
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
 detectionString = nil;
 
 CGRect highlightViewRect = CGRectZero;
 AVMetadataMachineReadableCodeObject *barCodeObject;
 
 NSArray *barCodeTypes = @[AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code,
                           AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeCode128Code,
                           AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeQRCode, AVMetadataObjectTypeAztecCode];
 
 for (AVMetadataObject *metadata in metadataObjects)
 {
  for (NSString *type in barCodeTypes)
  {
   if ([metadata.type isEqualToString:type])
   {
    barCodeObject = (AVMetadataMachineReadableCodeObject *)[prevLayer transformedMetadataObjectForMetadataObject:(AVMetadataMachineReadableCodeObject *)metadata];
    highlightViewRect = barCodeObject.bounds;
    
    detectionString = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
    
    break;
   }
  }
 }
 
 if (detectionString != nil)
 {
  if([detectionString isEqualToString:lastBarcodeValue])
  {
   return;
  }
  
  lastBarcodeValue = detectionString;

  [self returnToCallingController];
 }
  
 highlightView.frame = highlightViewRect;
}


/*
 * return to calling VC
 */
- (void) returnToCallingController
{
// [parentVC setBarcode :lastBarcodeValue];
 
// lastBarcodeValue = nil;     // allow re-scanning of same barcode when re-activated
 
 [self dismissViewControllerAnimated:YES completion:nil];
}


- (void) setParentVC:(BarCodeScannerViewController *) vc
{
 parentVC = vc;
}



- (NSString *) getBarcode
{
 detectionString = nil;
 
 return lastBarcodeValue;
}

@end

