//
//  IVBuildingSelectionViewController.h
//  iViewer
//
//  Created by Mina Haleem on 24.03.13.
//  Copyright (c) 2013 Mina Haleem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Indoors/IDSBuilding.h>

typedef void(^PDBuildingSelectionBlock)(IDSBuilding *building);

@interface IVBuildingSelectionViewController : UIViewController

@property (nonatomic, strong) NSArray *buildings;
@property (nonatomic, copy) PDBuildingSelectionBlock buildingSelectionBlock;

- (void)loadBuildings;
- (void)setFrame:(CGRect)frame;
@end
