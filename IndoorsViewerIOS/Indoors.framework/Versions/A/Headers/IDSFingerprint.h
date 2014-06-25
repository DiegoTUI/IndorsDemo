//
//  Fingerprint.h
//  FMDBTest
//
//  Created by Gerhard Zeissl on 04.03.13.
//
//

#import <Foundation/Foundation.h>
#import "IDSFingerprintPoint.h"
#import "IDSNetwork.h"

@interface IDSFingerprint : NSObject <NSCopying>
//@property (nonatomic) long serialVersionUID = -1502907216021383866L;
@property (nonatomic) long fingerprintID;
@property (nonatomic, strong) IDSFingerprintPoint* point;
@property (nonatomic, strong) NSMutableArray *statistics;
//@property (nonatomic, strong)private Map<Device, Statistic> statisticByDevice = Maps.newHashMap();
@property (nonatomic, strong) NSMutableDictionary *statisticByDevice;
@property (nonatomic, strong) IDSNetwork *network;
@end
