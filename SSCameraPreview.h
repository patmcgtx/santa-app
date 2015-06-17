//
//  OTCameraView.h
//  OverThere
//
//  Created by Patrick McGonigle on 9/18/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "RTSPausable.h"

@interface SSCameraPreview : UIView <RTSPausable> 

- (id)initWithFrame:(CGRect)frame;

@end
