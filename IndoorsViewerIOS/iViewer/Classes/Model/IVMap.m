//
//  IVMap.m
//  iViewer
//
//  Created by Mina Haleem on 24.03.13.
//  Copyright (c) 2013 Mina Haleem. All rights reserved.
//

#import "IVMap.h"

@implementation IVMap
@synthesize name = _name;
@synthesize tilesPath = _tilesPath;
@synthesize mmPerPixelBase = _mmPerPixelBase;
@synthesize mapSize = _mapSize;
@synthesize levelsOfDetail = _levelsOfDetail;


#pragma mark - Initialization

- (id)initWithName:(NSString *)name
         tilesPath:(NSString *)tilesPath
    mmPerPixelBase:(float)mmPerPixelBase
           mapSize:(CGSize)mapSize
    levelsOfDetail:(NSUInteger)levelsOfDetail
{
    self = [super init];
    
    if (self) {
        _name = [name copy];
        _tilesPath = [tilesPath copy];
        _mmPerPixelBase = mmPerPixelBase;
        _mapSize = mapSize;
        _levelsOfDetail = levelsOfDetail;
    }
    
    return self;
}


#pragma mark - Debug

- (NSString *)description {
    return [NSString stringWithFormat:
            @"[%@](%f, %f, %f, %d)",
            _name,
            _mmPerPixelBase,
            _mapSize.width,
            _mapSize.height,
            _levelsOfDetail];
}


#pragma mark - Map Tiles

- (UIImage *)tileForScale:(CGFloat)scale row:(int)row col:(int)col {
    NSUInteger tileSize = 1.0 / scale;
    
    NSString *tilePath
    = [NSString stringWithFormat:
       @"0/default-map/%d/%d_%d.png",
       tileSize,
       row,
       col];
    
    NSString *path = [_tilesPath stringByAppendingPathComponent:tilePath];
    
    return [UIImage imageWithContentsOfFile:path];
}
@end
