//
//  IVMapRoutingView.h
//  iViewer
//
//  Created by Mina Haleem on 29.04.13.
//  Copyright (c) 2013 Mina Haleem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Indoors/IDSDefaultMap.h>

@interface ISMapRoutingView : UIView
- (id)initWithFrame:(CGRect)frame map:(IDSDefaultMap*)map;

- (void)clearPaths;
- (void)showPaths:(NSMutableArray*)paths;
- (void)showPath:(NSArray*)path;
@end
