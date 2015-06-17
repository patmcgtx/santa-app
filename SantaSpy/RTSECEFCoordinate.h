//
//  RTSECEFCoordinate.h
//  OverThere
//
//  Created by Patrick McGonigle on 11/25/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#ifndef OverThere_RTSECEFCoordinate_h
#define OverThere_RTSECEFCoordinate_h

/**
 * Represents an ECEF (Earth-Centered, Earth-Fixed) geographical coordinate.
 * See http://en.wikipedia.org/wiki/ECEF
 * Based on Apple's sample "pARk" augmented reality app.
 */
struct RTSECEFCoordinate {
    double x;
    double y;
    double z;
};
typedef struct RTSECEFCoordinate RTSECEFCoordinate;

#endif
