//
//  TUIBeaconsPlan.m
//  IndoorsSurface
//
//  Created by Diego Lafuente on 24/06/14.
//  Copyright (c) 2014 Indoors GmbH. All rights reserved.
//

#import "TUIBeaconsPlan.h"
#import <sqlite3.h>

@interface TUIBeaconsPlan ()

/**
 The sqlite database where the floor plan is stored
 */
@property (nonatomic) sqlite3 *database;

@end

@implementation TUIBeaconsPlan

+ (TUIBeaconsPlan *)sharedInstance
{
    static TUIBeaconsPlan *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TUIBeaconsPlan alloc] init];
    });
    return sharedInstance;
}

- (TUIBeaconsPlan *)init
{
    self = [super init];
    if (self)
    {
        _database = nil;
        NSString *dbPath = [NSString stringWithFormat:@"%@/building_124034930/indoors.db", [self applicationDocumentsDirectory]];
        if(sqlite3_open([dbPath UTF8String], &_database) != SQLITE_OK)
        {
            NSLog(@"Error opening database: %@", dbPath);
        }
        else
        {
            NSLog(@"Database properly opened: %@", dbPath);
        }
    }
    return self;
}

- (NSString *)applicationDocumentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

- (CGPoint)locationForBeacon:(NSString *)minor
{
    CGPoint result = CGPointZero;
    
    NSString *sqlString = [NSString stringWithFormat:@"SELECT x, y FROM networklocation WHERE id='%d'", [self idForMinor:minor]];
    const char *sql = [sqlString UTF8String];
    sqlite3_stmt *sqlStatement;
    if(sqlite3_prepare(_database, sql, -1, &sqlStatement, NULL) == SQLITE_OK)
    {
        while (sqlite3_step(sqlStatement)==SQLITE_ROW)
        {
            result = CGPointMake(sqlite3_column_int(sqlStatement,0), sqlite3_column_int(sqlStatement,1));
        }
    }

    
    return result;
}

- (NSInteger)idForMinor:(NSString *)minor
{
    NSInteger result = 0;
    NSString *sqlString = [NSString stringWithFormat:@"SELECT network_id FROM networkmetadata WHERE value='%@'", minor];
    const char *sql = [sqlString UTF8String];
    sqlite3_stmt *sqlStatement;
    if(sqlite3_prepare(_database, sql, -1, &sqlStatement, NULL) == SQLITE_OK)
    {
        while (sqlite3_step(sqlStatement)==SQLITE_ROW)
        {
            result = sqlite3_column_int(sqlStatement,0);
        }
    }
    return result;
}

@end
