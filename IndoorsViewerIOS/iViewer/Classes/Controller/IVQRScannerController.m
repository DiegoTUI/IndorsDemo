//
//  IVQRScannerController.m
//  indoo.rs
//
//  Created by Dominik Hofer on 08/04/14.
//  Copyright (c) 2014 indoo.rs. All rights reserved.
//

#import "IVQRScannerController.h"

@interface IVQRScannerController ()
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@end

@implementation IVQRScannerController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _captureSession = nil;
    [self loadBeepSound];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self startReading];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)cancelButtonPressed:(id)sender
{
    if ([_delegate respondsToSelector:@selector(qrScannerControllerDidCancel:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_delegate qrScannerControllerDidCancel:self];
        });
    }
}

#pragma mark - Private method implementation

- (BOOL)startReading {
    NSError *error;
    
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    
    if (!input) {
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    
    _captureSession = [[AVCaptureSession alloc] init];
    [_captureSession addInput:input];
    
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [_captureSession addOutput:captureMetadataOutput];
    
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("rs.indoo.qrscanner", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:_viewPreview.layer.bounds];
    [_viewPreview.layer addSublayer:_videoPreviewLayer];
    
    [_captureSession startRunning];
    
    return YES;
}

- (void)stopReading{
    [_captureSession stopRunning];
    _captureSession = nil;
    
    [_videoPreviewLayer removeFromSuperlayer];
}


-(void)loadBeepSound{
    NSString *beepFilePath = [[NSBundle mainBundle] pathForResource:@"beep" ofType:@"mp3"];
    NSURL *beepURL = [NSURL URLWithString:beepFilePath];
    
    NSError *error;
    
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:beepURL error:&error];
    if (error) {
        NSLog(@"Could not play beep file.");
        NSLog(@"%@", [error localizedDescription]);
    } else {
        [_audioPlayer prepareToPlay];
    }
}


#pragma mark - AVCaptureMetadataOutputObjectsDelegate method implementation

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects firstObject];
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            [self performSelectorOnMainThread:@selector(stopReading) withObject:nil waitUntilDone:NO];
            
            if ([_delegate respondsToSelector:@selector(qrScannerController:didScanResult:)]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_delegate qrScannerController:self didScanResult:[metadataObj stringValue]];
                });
            }
            
            if (_audioPlayer) {
                [_audioPlayer play];
            }
        }
    }
}

@end
