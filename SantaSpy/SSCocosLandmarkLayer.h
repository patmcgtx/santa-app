//
//  HelloWorldLayer.h
//  OverThere
//
//  Created by Patrick McGonigle on 9/1/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "RTSARLandmark.h"
#import "RTSStartable.h"
#import "SSLandmarkScreenMapper.h"

@interface SSCocosLandmarkLayer : CCLayerColor <RTSStartable>

@property (nonatomic, weak) SSLandmarkScreenMapper* landmarkMapper;

@end
