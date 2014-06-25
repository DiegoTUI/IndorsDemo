//
//  IDSCoordinate+String.h
//  iViewer
//
//  Created by Mina Haleem on 26.04.13.
//  Copyright (c) 2013 Mina Haleem. All rights reserved.
//

#import <Indoors/IDSCoordinate.h>

@interface IDSCoordinate (String)
- (NSString*) string;
+ (IDSCoordinate*) coordinateWithString:(NSString*)str;
@end
