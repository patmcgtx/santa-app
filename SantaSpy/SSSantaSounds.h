//
//  SSSantaSounds.h
//  SantaSpy
//
//  Created by Patrick McGonigle on 11/11/12.
//
//

#import <Foundation/Foundation.h>

/*
 * This is the base class for all the various Santa environmental
 * sounds, which can play themselves.
 */
@interface SSSantaSounds : NSObject

//
// Okay, okay, okay...
//
// So this ended up being over-engineered.
//
// I was originally thinking we would combine sounds at runtime,
// so I would need classes to manage the combinations.  Luckily,
// all the sound mixing was actually done in Garage Band ahead
// of time, making this set of classes sort of overkill.
// Would like to refactor these classes out, but not worth
// the time now. :-|
//

-(void) play;

// At the moment, no -stop is needed because that is always
// handled by the SSSoundDirector.

@end
