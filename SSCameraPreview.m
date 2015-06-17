//
//  OTCameraView.m
//  OverThere
//
//  Created by Patrick McGonigle on 9/18/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SSCameraPreview.h"
#import "RTSLog.h"
#import "SSErrorReporter.h"

/*
 * Hidden/internal interface
 */
@interface SSCameraPreview ()

@property (nonatomic, strong) AVCaptureVideoPreviewLayer* avCapturePreviewLayer;
@property (nonatomic, strong) AVCaptureSession* avCaptureSess;

-(void) startSessionAsync;

@end

/*
 Implementation
 */
@implementation SSCameraPreview

@synthesize avCapturePreviewLayer = _avCapturePreviewLayer;
@synthesize avCaptureSess = _avCaptureSess;

#pragma mark Object lifecycle

- (id)initWithFrame:(CGRect)frame
{
    LOG_OBJ_LIFECYCLE(@"initWithFrame");
    
    self = [super initWithFrame:frame];
    
    if (self) {
                
        // This is not an interactive view; it is view-only
        self.userInteractionEnabled = NO;
        self.multipleTouchEnabled = NO;
        
        // Make a basic session with no input or outputs
        if ( ! _avCaptureSess ) {
            
            LOG_OBJ_LIFECYCLE(@"creating myAVCapSess");
            
            _avCaptureSess = [[AVCaptureSession alloc] init];
            // TODO Try -sessionPreset to adjust quality.  Have to call -canSetSessionPreset first.
            
            AVCaptureDevice* videoCaptureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
            
            if ( ! videoCaptureDevice.connected ) {
                [[SSErrorReporter sharedReporter] disableAppWithMessageKey:@"CAMERA_PREVIEW_VIDEO_NOT_CONNECTED"
                                                                     error:nil
                                                                 debugInfo:@"videoCaptureDevice not connected"];
            }
            
            NSError* error = nil;
            AVCaptureDeviceInput* videoInput = [AVCaptureDeviceInput deviceInputWithDevice:videoCaptureDevice error:&error];
            
            if ( error ) {
                [[SSErrorReporter sharedReporter] disableAppWithMessageKey:@"CAMERA_VIEW_ERROR"
                                                                     error:error
                                                                 debugInfo:@"camera preview : adding video input"];
            }
            
            if (videoInput) {
                [_avCaptureSess addInput:videoInput];
            }    
            else {
                [[SSErrorReporter sharedReporter] disableAppWithMessageKey:@"CAMERA_VIEW_ERROR"
                                                                     error:nil
                                                                 debugInfo:@"camera preview : missing video input"];
            }
        }
        else {
            LOG_INTERNAL_ERROR(@"myAVCapSess already initialized!?!?!?");
        }
        

        if ( ! _avCapturePreviewLayer ) {
            
            LOG_OBJ_LIFECYCLE(@"creating myAVCapPreviewLayer");
            
            _avCapturePreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_avCaptureSess];
            [_avCapturePreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
            
            [_avCapturePreviewLayer setFrame:frame];    
            
            CALayer* layer = [self layer];        
            [layer insertSublayer:_avCapturePreviewLayer 
                            below:[[layer sublayers] objectAtIndex:0]];
        } 
        else {
            LOG_INTERNAL_ERROR(@"myAVCapPreviewLayer already initialized!?!?!?");
        }
        
        [self startSessionAsync];
    }
    
    return self;
}

- (void)dealloc 
{
    LOG_OBJ_LIFECYCLE(@"dealloc");
    
    [self pause];    
    _avCaptureSess = nil;    
    _avCapturePreviewLayer = nil;
}


#pragma mark Pausable

- (void) pause 
{
    LOG_APP_LIFECYCLE(@"pause");

    // As per OTHERE-80, this causes flicker on resume.  Disabling for now; does not seem critical atm.
    /*
    if ( _avCaptureSess.running ) {
        [_avCaptureSess stopRunning];
    }
     */
}

-(void) startSessionAsync 
{
    LOG_APP_LIFECYCLE(@"Starting session");
    // This is done asychronously since -startRunning doesn't return until the session is running.
    if ( ! _avCaptureSess.running ) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [_avCaptureSess startRunning];
        });
    }
}

- (void) resume 
{
    LOG_APP_LIFECYCLE(@"resume");
    
    // As per OTHERE-80, this causes flicker.  Disabling for now; does not seem critical atm.
    //[self startSessionAsync];
}

@end
