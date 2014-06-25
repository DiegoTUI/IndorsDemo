//
//  IVZoneAnnotation.h
//  iViewer
//
//  Created by Mina Haleem on 21.04.13.
//  Copyright (c) 2013 Mina Haleem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Indoors/IDSDefaultMap.h>

@interface ISZoneAnnotation : UIView
- (id)initWithFrame:(CGRect)frame Map:(IDSDefaultMap *)defaultMap;

- (void)hideAllZones;
- (void)showZones:(NSMutableArray*)zones;

@property(nonatomic,strong)UIColor* zoneNameColor;
@property(nonatomic,strong)UIFont* zoneNameFont;
@property(nonatomic,strong)UIColor* zoneColor;
@property (nonatomic, strong) UIColor* zoneBorderColor;
@end
