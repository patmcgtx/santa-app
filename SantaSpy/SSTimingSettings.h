//
//  OTTimingSettings.h
//  OverThere
//
//  Created by Patrick McGonigle on 12/17/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#ifndef SantaSpy_SSTimingSettings_h
#define SantaSpy_SSTimingSettings_h

// How often (in seconds) we start the "ping" for Santa
#define SS_PING_INTERVAL 2.0f

// How long (in seconds) for the "ping" to fade in
#define SS_PING_FADE_IN_TIME 0.5f

// How long (in seconds) for the "ping" to fade out
#define SS_PING_FADE_OUT_TIME 0.5f

// Core Motion update interval (hertz with the /60.0 part added);
// TODO Will higher frequency make the app more acurate?
#define RTS_CORE_MOTION_UPDATE_INTERVAL 2.0 / 60.0

#endif
