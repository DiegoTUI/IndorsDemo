//
//  IDSCoordinate+String.m
//  iViewer
//
//  Created by Mina Haleem on 26.04.13.
//  Copyright (c) 2013 Mina Haleem. All rights reserved.
//

#import "IDSCoordinate+String.h"

@implementation IDSCoordinate (String)
- (NSString*) string {
    return [NSString stringWithFormat:@"%d, %d, %d",self.x,self.y,self.z];
}

+ (IDSCoordinate*) coordinateWithString:(NSString*)str {
    NSArray *coordinateItems = [str componentsSeparatedByString:@"/ "];
    
    if ([coordinateItems count] != 3) {
        return nil;
    }

    NSInteger x = [[coordinateItems objectAtIndex:0] integerValue];
    NSInteger y = [[coordinateItems objectAtIndex:1] integerValue];
    NSInteger z = [[coordinateItems objectAtIndex:2] integerValue];
    IDSCoordinate* coordinate = [[IDSCoordinate alloc] initWithX:x andY:y andFloorLevel:z];
    return coordinate;
}
@end
