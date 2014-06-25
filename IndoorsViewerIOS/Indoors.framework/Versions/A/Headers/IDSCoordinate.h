//
//  Coordinate.h
//  FMDBTest
//
//  Created by Gerhard Zeissl on 04.03.13.
//
//

#import <Foundation/Foundation.h>

@interface IDSCoordinate : NSObject
//@property (nonatomic)private static final long serialVersionUID = 6016897278218835753L;

/**
 * Horizontal distance in millimeter from the top-left origin.
 */
@property (nonatomic) NSInteger x;
/**
 * Vertical distance in millimeter from the top-left origin.
 */
@property (nonatomic) NSInteger y;
/**
 * Floor-ID
 */
@property (nonatomic) NSInteger z;
/**
 * Accuracy
 */
@property (nonatomic) NSInteger accuracy;

/**
 * Hash code
 */
@property (nonatomic) NSInteger hashcode;

/**
 * Coordinate score
 */
@property (atomic) double score;
- (id)initWithX:(NSInteger)x andY:(NSInteger)y andFloorLevel:(NSInteger)z;
- (id)initWithX:(NSInteger)x andY:(NSInteger)y andFloorLevel:(NSInteger)z withScore:(double)score;
- (NSInteger)hashCode;
- (id)initWithX:(NSInteger)x Y:(NSInteger)y z:(NSInteger)z accuracy:(int)accuracy;
- (NSMutableDictionary*) dictionaryWithBuildingId:(NSInteger)buildingId;
- (BOOL)isEqualToCoordinate:(IDSCoordinate*)coordinate;

@end
