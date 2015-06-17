//
// cocos2d Hello World example
// http://www.cocos2d-iphone.org
//

// Import the interfaces
#import "SSCocos2dTestLayer.h"

// HelloWorld implementation
@implementation SSCocos2dTestLayer

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];

	// 'layer' is an autorelease object.
	SSCocos2dTestLayer *layer = [SSCocos2dTestLayer node];

	// add layer as a child to scene
	[scene addChild: layer];
    
    // Add a light label
    CCLabelTTF* label1 = [CCLabelTTF labelWithString:@"Hello!" fontName:@"Thonburi" fontSize:22.0];
    label1.position = ccp(100, 100);
    label1.color = ccWHITE;
    [layer addChild:label1];

    // Add a dark label
    CCLabelTTF* label2 = [CCLabelTTF labelWithString:@"Hello!" fontName:@"Thonburi" fontSize:22.0];
    label2.position = ccp(150, 150);
    label2.color = ccBLACK;
    [layer addChild:label2];
    
	// return the scene
	return scene;
}



// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) {
	}
	return self;
}

@end
