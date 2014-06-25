//
//  IVBuildingFloorsView.h
//  IndoorsSurface
//
//  Created by Mina Haleem on 25.07.13.
//  Copyright (c) 2013 Indoors GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Indoors/IDSBuilding.h>
#import <Indoors/IDSFloor.h>

@class IVBuildingFloorsView;

@protocol IVBuildingFloorsViewDelegate <NSObject>
- (void)buildingFloorsView:(IVBuildingFloorsView*)floorsView didSelectFloor:(IDSFloor*)floor;
@end

@interface IVBuildingFloorsView : UIView
- (void)setCurrentBuilding:(IDSBuilding*)building;
- (void)highlightFloorAtLevel:(int)floorLevel;
- (void)markFloorAtLevel:(int)floorLevel;
@property (nonatomic, strong) id<IVBuildingFloorsViewDelegate> delegate;
@end
