//
//  SSErrorReporterFrontEnd.h
//  SantaSpy
//
//  Created by Patrick McGonigle on 10/28/12.
//
//

#import <Foundation/Foundation.h>

@protocol SSErrorReporterFrontEnd <NSObject>

@required

-(void) disableApplicaton:(NSString*) messageKey;

@end
