#import <Foundation/Foundation.h>

@class CLLocation;
@class IDSCoordinate;
@class IDSBuilding;

@interface IndoorsCoordinateUtil : NSObject
+ (CLLocation *)geoLocationForCoordinate:(IDSCoordinate *)coordinate inBuilding:(IDSBuilding *)building;
@end
