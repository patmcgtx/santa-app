//
//  RTSENUCoordinate.h
//  OverThere
//
//  Created by Patrick McGonigle on 11/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#ifndef OverThere_RTSENUCoordinate_h
#define OverThere_RTSENUCoordinate_h

/**
 * Represents an "ENU" (Cartesian?) geographical coordinate.
 * Based on Apple's sample "pARk" augmented reality app.
 */
struct RTSENUCoordinate {
    double e;
    double n;
    double u;
};
typedef struct RTSENUCoordinate RTSENUCoordinate;

#endif
