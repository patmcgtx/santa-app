//
//  SSLandmarkScreenMapper.m
//  SantaSpy
//
//  Created by Patrick McGonigle on 11/10/12.
//
//

#import "SSLandmarkScreenMapper.h"
#import <CoreMotion/CoreMotion.h>
#import "RTSLog.h"
#import "RTSArrayTypes.h"
#import "RTSECEFCoordinate.h"
#import "RTSENUCoordinate.h"
#import "RTSMotion.h"
#import "SSNotificationNames.h"

// These typedefs are borrowed form the pARk sample app...
#define DEGREES_TO_RADIANS (M_PI/180.0)
#define WGS84_A	(6378137.0)				// WGS 84 semi-major axis constant in meters
#define WGS84_E (8.1819190842622e-2)	// WGS 84 eccentricity
#define degreesToRadians(x) (M_PI * (x) / 180.0)

// Internal methods
@interface SSLandmarkScreenMapper () {
    // These arrays cannot be a properties
	float4x4 _projectionTransform;
    float4x4 _rotateMatrixLandscapeRight;
    float4x4 _rotateMatrixLandscapeLeft;
    float4x4Ptr _activeRotateMatrix;
}

@property (nonatomic) CGRect bounds;
@property (nonatomic, strong) CLLocation* deviceLocation;

-(void) setupInternalMatricesWithFOVy:(float)fovy
                          aspectRatio:(float)aspect
                                nearZ:(float)zNear
                                 farZ:(float)zFar;

+(void) rotationMatrix:(const CMRotationMatrix*)rotMatrix
to4x4RigidBodyTransformationMatrix:(float4x4) resultMatrix;

+(RTSECEFCoordinate) createECEFFromLandmarkLat:(double)lat
                                   landmarkLon:(double)lon
                                   landmarkAlt:(double)alt;

+(RTSENUCoordinate) createENUFromDeviceLat:(double)devLat
                                 deviceLon:(double)devLon
                                deviceEcef:(RTSECEFCoordinate) devEcef
                              landmarkEcef:(RTSECEFCoordinate) landmarkEcef;

+(void) multiplyMatrix:(const float4x4) a
              byMatrix:(const float4x4) b
            intoResult:(float4x4) c;

+(void) multiplyMatrix:(const float4x4)m
              byVector:(const float4x1)v
            intoResult:(float4x1) vout;

@end


@implementation SSLandmarkScreenMapper

@synthesize delegate;
@synthesize bounds = _bounds;
@synthesize deviceLocation = _deviceLocation;
@synthesize landmark = _landmark;

- (id)initWithBounds:(CGRect)boundsVal
      deviceLocation:(CLLocation*) deviceLoc
            landmark:(RTSARLandmark*) landmarkVal
{
    LOG_OBJ_LIFECYCLE(@"initWithBounds %f wide x %f high @ x=%f y=%f",
                      bounds.size.width, bounds.size.height,
                      bounds.origin.x, bounds.origin.y);
    
    self = [super init];
    if (self) {
        
        _bounds = boundsVal;
        _deviceLocation = deviceLoc;
        
        // These values come mostly from the pARk sample app
        [self setupInternalMatricesWithFOVy:60.0f*DEGREES_TO_RADIANS
                                aspectRatio:_bounds.size.width*1.0f / _bounds.size.height
                                      nearZ:0.25f
                                       farZ:1000.0f];
        
        // Call setter so the landmark gets its ENU, etc. refreshed
        self.landmark = landmarkVal;
    }
    return self;
}


-(void) refreshLandmark {
    
    //LOG_DISPLAY_LOOP(@"updateLandmarksWithSensorData");
    
    CMAttitude* tude = [[[RTSMotion sharedMotion] currentMotion] attitude];
    
    //LOG_TMP_DEBUG(@"new attitude %@", [tude description]);
    
    if (tude) {
        
        // Start out with the latets rotation matrix from the phone's sensors
        CMRotationMatrix attitudeRotationMatrix = [tude rotationMatrix];
        
        // Put some extra cells around it for transformation
        float4x4 attitudeTransformationMatrix;
        [SSLandmarkScreenMapper rotationMatrix:&attitudeRotationMatrix
            to4x4RigidBodyTransformationMatrix:attitudeTransformationMatrix];
        
        // The sensor attitude is in portrait mode.  Rotate it on the Z axis for
        // landscape mode.  This was tough to figure out!  See SANTA-29.
        float4x4 rotatedAttitudeMatrix;
        [SSLandmarkScreenMapper multiplyMatrix:_activeRotateMatrix
                                      byMatrix:attitudeTransformationMatrix
                                    intoResult:rotatedAttitudeMatrix];
        
        // Then transform the rotated attitude as projected the screen.
        // This magic is borrowed from Apple's pARk demo app.
        float4x4 projectedAttitudeMatrix;
        [SSLandmarkScreenMapper multiplyMatrix:_projectionTransform
                                      byMatrix:rotatedAttitudeMatrix
                                    intoResult:projectedAttitudeMatrix];
        
        // More magic from pARk pretty much from here on down...
        
        float4x1 landmarkTransformationVector;
        landmarkTransformationVector[0] = (float)self.landmark.enuCoordinates.n;
        landmarkTransformationVector[1] = -(float)self.landmark.enuCoordinates.e;
        landmarkTransformationVector[2] = 0.0f;
        landmarkTransformationVector[3] = 1.0f;
        
        float4x1 projectedLandmarkVector;
        [SSLandmarkScreenMapper multiplyMatrix:projectedAttitudeMatrix
                                      byVector:landmarkTransformationVector
                                    intoResult:projectedLandmarkVector];
        
        float x = (projectedLandmarkVector[0] / projectedLandmarkVector[3] + 1.0f) * 0.5f;
        float y = (projectedLandmarkVector[1] / projectedLandmarkVector[3] + 1.0f) * 0.5f;
        
        float4x1 v;
        [SSLandmarkScreenMapper multiplyMatrix:projectedAttitudeMatrix
                                      byVector:landmarkTransformationVector
                                    intoResult:v];
        
        if (v[2] < 0.0f) {
            CGPoint point = CGPointMake(x*_bounds.size.width, _bounds.size.height-y*_bounds.size.height);
            self.landmark.screenPoint = point;
            //LOG_TMP_DEBUG(@"New point: %.2f/%.2f", self.landmark.screenPoint.x, self.landmark.screenPoint.y);
        } else {
            // Give the landmark a definitevely offscreen position so that it won't show (SANTA-110)
            self.landmark.screenPoint = CGPointMake(_bounds.size.width + 100, _bounds.size.height + 100);
            //LOG_TMP_DEBUG(@"New point won't show");
        }
        
        [self.delegate landmarkWasUpdated:self.landmark];
        
        //LOG_INFO(@"center at x/y: %f/%f", point.x, point.y);
    }
    else {
        LOG_INTERNAL_ERROR(@"No attitude avalable (yet)");
    }
}

/**
 * Notify of a new orientstion, which affects the point transformations
 */
-(void) changedInterfaceOrientation:(UIInterfaceOrientation) toInterfaceOrientation {
    if ( toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft ) {
        _activeRotateMatrix = _rotateMatrixLandscapeLeft;
    }
    else if ( toInterfaceOrientation == UIInterfaceOrientationLandscapeRight ) {
        _activeRotateMatrix = _rotateMatrixLandscapeRight;
    }
    else {
        // TODO
    }
}

#pragma mark - Internal initialization


// All below based on the pARk sample app..

/*
 * This setter internally refreshes the landmark's ENU, etc. based on the latest 
 * landmark and device locations.
 */
- (void) setLandmark:(RTSARLandmark*)landmarkVal
{
    @synchronized(self) { // Protect from potential threading issues
        
        _landmark = landmarkVal;
        
        // Calculate and cache the ENU location from it's lat/lon.
        // The ENU is used to calculate the screen x,y position.
        // The ENU does not change on the fly after being calculated the first time.
        
        RTSECEFCoordinate landmarkEcef = [SSLandmarkScreenMapper createECEFFromLandmarkLat:_landmark.location.latitude
                                                                               landmarkLon:_landmark.location.longitude
                                                                               landmarkAlt:0.0]; // Ignore altitude for now
        
        // TODO Only get loc on startup and when it changes a lot
        // or when a flag is set to get it (as in going to BG?)
        // Maybe something like if (!location) ...
        
        //LOG_SENSORS(@"device loc: %@", [deviceLoc description]);
        
        RTSECEFCoordinate deviceECEF = [SSLandmarkScreenMapper createECEFFromLandmarkLat:self.deviceLocation.coordinate.latitude
                                                                             landmarkLon:self.deviceLocation.coordinate.longitude
                                                                             landmarkAlt:0.0]; // Ignore altitude for now
        
        RTSENUCoordinate enu = [SSLandmarkScreenMapper createENUFromDeviceLat:self.deviceLocation.coordinate.latitude
                                                                    deviceLon:self.deviceLocation.coordinate.longitude
                                                                   deviceEcef:deviceECEF
                                                                 landmarkEcef:landmarkEcef];
        _landmark.enuCoordinates = enu;
    }
    
    // To tell main controller, etc.
    
    // Send along the landmark too for more details.
    NSDictionary* userInfo = [NSDictionary dictionaryWithObject:_landmark forKey:SSNotificationKeyLandmark];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SSNotificationScreenMapperLandmarkChanged
                                                        object:nil
                                                      userInfo:userInfo];
}

/**
 * Initializes the internal matrices using the given y-axis field-of-view, aspect ratio,
 * and near and far clipping planes
 */
-(void) setupInternalMatricesWithFOVy:(float)fovy
                          aspectRatio:(float)aspect
                                nearZ:(float)zNear
                                 farZ:(float)zFar
{
    //
    // Set up the projection transformation
    //
    
	float f = 1.0f / tanf(fovy/2.0f);
	
	_projectionTransform[0] = f / aspect;
	_projectionTransform[1] = 0.0f;
	_projectionTransform[2] = 0.0f;
	_projectionTransform[3] = 0.0f;
	
	_projectionTransform[4] = 0.0f;
	_projectionTransform[5] = f;
	_projectionTransform[6] = 0.0f;
	_projectionTransform[7] = 0.0f;
	
	_projectionTransform[8] = 0.0f;
	_projectionTransform[9] = 0.0f;
	_projectionTransform[10] = (zFar+zNear) / (zNear-zFar);
	_projectionTransform[11] = -1.0f;
	
	_projectionTransform[12] = 0.0f;
	_projectionTransform[13] = 0.0f;
	_projectionTransform[14] = 2 * zFar * zNear /  (zNear-zFar);
	_projectionTransform[15] = 0.0f;
    
    //
    // Set up the rotation matrices - See links in SANTA-29
    //
    
    _rotateMatrixLandscapeRight[0] = cos(90.0);
    _rotateMatrixLandscapeRight[1] = sin(90.0) * -1.0;
    _rotateMatrixLandscapeRight[2] = 0.0;
    _rotateMatrixLandscapeRight[3] = 0.0;
    
    _rotateMatrixLandscapeRight[4] = sin(90.0) * -1.0;
    _rotateMatrixLandscapeRight[5] = cos(90.0);
    _rotateMatrixLandscapeRight[6] = 0.0;
    _rotateMatrixLandscapeRight[7] = 0.0;
    
    _rotateMatrixLandscapeRight[8] = 0.0;
    _rotateMatrixLandscapeRight[9] = 0.0;
    _rotateMatrixLandscapeRight[10] = 1.0;
    _rotateMatrixLandscapeRight[11] = 0.0;
    
    _rotateMatrixLandscapeRight[12] = 0.0;
    _rotateMatrixLandscapeRight[13] = 0.0;
    _rotateMatrixLandscapeRight[14] = 0.0;
    _rotateMatrixLandscapeRight[15] = 1.0;
    
    // Landscape-left is the same idea as landscape-right,
    // but an angle of -90 instead of 90.
    // An angle of 270 does not work, oddly enough (SANTA-42).
    
    _rotateMatrixLandscapeLeft[0] = cos(-90.0);
    _rotateMatrixLandscapeLeft[1] = sin(-90.0) * -1.0;
    _rotateMatrixLandscapeLeft[2] = 0.0;
    _rotateMatrixLandscapeLeft[3] = 0.0;
    
    _rotateMatrixLandscapeLeft[4] = sin(-90.0)  * -1.0;
    _rotateMatrixLandscapeLeft[5] = cos(-90.0);
    _rotateMatrixLandscapeLeft[6] = 0.0;
    _rotateMatrixLandscapeLeft[7] = 0.0;
    
    _rotateMatrixLandscapeLeft[8] = 0.0;
    _rotateMatrixLandscapeLeft[9] = 0.0;
    _rotateMatrixLandscapeLeft[10] = 1.0;
    _rotateMatrixLandscapeLeft[11] = 0.0;
    
    _rotateMatrixLandscapeLeft[12] = 0.0;
    _rotateMatrixLandscapeLeft[13] = 0.0;
    _rotateMatrixLandscapeLeft[14] = 0.0;
    _rotateMatrixLandscapeLeft[15] = 1.0;
    
    // Should match SantaSpy-Info.plist - "Initial interface orientation"
    _activeRotateMatrix = _rotateMatrixLandscapeLeft;
}

#pragma mark - Matrix transformations

// Matrix-vector multiplication routine
+(void) multiplyMatrix:(const float4x4)m
              byVector:(const float4x1)v
            intoResult:(float4x1) vout
{
	vout[0] = m[0]*v[0] + m[4]*v[1] + m[8]*v[2] + m[12]*v[3];
	vout[1] = m[1]*v[0] + m[5]*v[1] + m[9]*v[2] + m[13]*v[3];
	vout[2] = m[2]*v[0] + m[6]*v[1] + m[10]*v[2] + m[14]*v[3];
	vout[3] = m[3]*v[0] + m[7]*v[1] + m[11]*v[2] + m[15]*v[3];
}

// Matrix-matric multiplication routine
+(void) multiplyMatrix:(const float4x4) a
              byMatrix:(const float4x4) b
            intoResult:(float4x4) c
{
	uint8_t col, row, i;
	memset(c, 0, 16*sizeof(float));
	
	for (col = 0; col < 4; col++) {
		for (row = 0; row < 4; row++) {
			for (i = 0; i < 4; i++) {
				c[col*4+row] += a[i*4+row]*b[col*4+i];
			}
		}
	}
}

/*
 * Take a standard rotation matrix and get it ready for rigid
 * body transformations.  Thanks to the pARk demo, as always.
 */
+(void) rotationMatrix:(const CMRotationMatrix*)rotMatrix
to4x4RigidBodyTransformationMatrix:(float4x4) resultMatrix
{
	resultMatrix[0] = (float)rotMatrix->m11;
	resultMatrix[1] = (float)rotMatrix->m21;
	resultMatrix[2] = (float)rotMatrix->m31;
	resultMatrix[3] = 0.0f;
	
	resultMatrix[4] = (float)rotMatrix->m12;
	resultMatrix[5] = (float)rotMatrix->m22;
	resultMatrix[6] = (float)rotMatrix->m32;
	resultMatrix[7] = 0.0f;
	
	resultMatrix[8] = (float)rotMatrix->m13;
	resultMatrix[9] = (float)rotMatrix->m23;
	resultMatrix[10] = (float)rotMatrix->m33;
	resultMatrix[11] = 0.0f;
	
	resultMatrix[12] = 0.0f;
	resultMatrix[13] = 0.0f;
	resultMatrix[14] = 0.0f;
	resultMatrix[15] = 1.0f;
}

#pragma mark - Geodetic utilities definition
// From pARk sample app

// References to ECEF and ECEF to ENU conversion may be found on the web.

// Converts latitude, longitude to ECEF coordinate system
+(RTSECEFCoordinate) createECEFFromLandmarkLat:(double)lat
                                   landmarkLon:(double)lon
                                   landmarkAlt:(double)alt
{
    RTSECEFCoordinate retval;
    
	double clat = cos(lat * DEGREES_TO_RADIANS);
	double slat = sin(lat * DEGREES_TO_RADIANS);
	double clon = cos(lon * DEGREES_TO_RADIANS);
	double slon = sin(lon * DEGREES_TO_RADIANS);
	
	double N = WGS84_A / sqrt(1.0 - WGS84_E * WGS84_E * slat * slat);
	
	retval.x = (N + alt) * clat * clon;
	retval.y = (N + alt) * clat * slon;
	retval.z = (N * (1.0 - WGS84_E * WGS84_E) + alt) * slat;
    
    LOG_INFO(@"createECEFFromLat:%f lon:%f, alt:%f => %f/%f/%f",
             lat, lon, alt, retval.x, retval.y, retval.z);
    return retval;
}

// Coverts ECEF to ENU coordinates centered at given lat, lon
+(RTSENUCoordinate) createENUFromDeviceLat:(double)devLat
                                 deviceLon:(double)devLon
                                deviceEcef:(RTSECEFCoordinate) devEcef
                              landmarkEcef:(RTSECEFCoordinate) landmarkEcef
{
    RTSENUCoordinate retval;
    
	double clat = cos(devLat * DEGREES_TO_RADIANS);
	double slat = sin(devLat * DEGREES_TO_RADIANS);
	double clon = cos(devLon * DEGREES_TO_RADIANS);
	double slon = sin(devLon * DEGREES_TO_RADIANS);
    
	double dx = devEcef.x - landmarkEcef.x;
	double dy = devEcef.y - landmarkEcef.y;
	double dz = devEcef.z - landmarkEcef.z;
	
	retval.e = -slon*dx  + clon*dy;
	retval.n = -slat*clon*dx - slat*slon*dy + clat*dz;
	retval.u = clat*clon*dx + clat*slon*dy + slat*dz;
    
    LOG_INFO(@"createENUFromECEFDeviceLat:%f deviceLon:%f deviceEcef:%f/%f/%f landmarkEcef:%f/%f/%f => %f/%f/%f",
             devLat, devLon, devEcef.x, devEcef.y, devEcef.z,
             landmarkEcef.x, landmarkEcef.y, landmarkEcef.z,
             retval.e, retval.n, retval.u);
    return retval;
}

@end
