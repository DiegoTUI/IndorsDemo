//
//  IVBuildingFloorsView.m
//  IndoorsSurface
//
//  Created by Mina Haleem on 25.07.13.
//  Copyright (c) 2013 Indoors GmbH. All rights reserved.
//

#import "IVBuildingFloorsView.h"
#import <QuartzCore/QuartzCore.h>

#define WIDTH 40

@interface IVBuildingFloorsView()
@property (nonatomic, strong) IDSBuilding* building;
@property (nonatomic, strong) NSMutableDictionary* floorsButtons;
@property (nonatomic) int currentMarkedFloorLevel;
@end

@implementation IVBuildingFloorsView
@synthesize building;
@synthesize floorsButtons;
@synthesize currentMarkedFloorLevel;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark - Private

- (BOOL)isValidFloorLevel:(int)floorLevel {
    if (building) {
        IDSFloor* floor = [self floorAtLevel:floorLevel];
        if (floor) {
            return YES;
        }
    }
    
    return NO;
}

- (void) setFloorButtonBackgroundColor:(UIButton*)btn isSelected:(BOOL)isSelected {
    UIColor* backgroundColor;
    
    if (isSelected) {
        backgroundColor = [UIColor colorWithRed:3/255.0 green:171/255.0 blue:180/255.0 alpha:1.0];
    } else {
        backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:0.7];
    }
    
    [btn setBackgroundColor:backgroundColor];
    
    //Border
    UIColor* borderColor = [UIColor colorWithRed:153/255 green:136/255 blue:136/255 alpha:1.0];
    btn.layer.borderColor = borderColor.CGColor;
    btn.layer.borderWidth = 0.5f;
}

- (void)redrawFloors {
    //Clear All Floors Buttons
    for (UIView* view in self.subviews) {
        [view removeFromSuperview];
    }
    
    self.floorsButtons = [[NSMutableDictionary alloc]init];
    
    //Show Floors only if more than one floor available
    if ([self.building.floors count] > 1) {
        CGSize floorButtonSize = CGSizeMake(30, 40); // change the size of userFloorBackground.png as well. Otherwise it will be stretched
        int verticalSpacing = 0;
        
        //Adjust AvailableFloorsView frame
        float totalHeight = ((floorButtonSize.height + verticalSpacing) * [self.building.floors count]) + verticalSpacing;
        CGRect availableFloorsViewFrame = self.frame;
        availableFloorsViewFrame.size = CGSizeMake(WIDTH, totalHeight);
        self.frame = availableFloorsViewFrame;
        
        //Draw Floors
        
        NSUInteger floorsCount = [self.building.floors allKeys].count;
        NSArray *sortedFloors = [[self.building.floors allKeys] sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES]]];
        int i = 1;
        for (NSNumber* floorLevel in sortedFloors) {
            UIButton* floorButton = [UIButton buttonWithType:UIButtonTypeCustom];
            if ([floorLevel intValue] == self.currentMarkedFloorLevel) {
                [floorButton setBackgroundImage:[UIImage imageNamed:@"userFloorBackground"] forState:UIControlStateNormal];
            } else {
                [floorButton setBackgroundImage:nil forState:UIControlStateNormal];
            }
            
            [floorButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            [self setFloorButtonBackgroundColor:floorButton isSelected:NO];
            
            float x = 4;
            float y = ((floorsCount - i) * (floorButtonSize.height + verticalSpacing )) + verticalSpacing;
            
            floorButton.frame = CGRectMake(x, y, floorButtonSize.width, floorButtonSize.height);
            floorButton.tag = [floorLevel intValue];
            [floorButton setTitle:[NSString stringWithFormat:@"%d",[floorLevel intValue]] forState:UIControlStateNormal];
            [floorButton addTarget:self action:@selector(changeFloorButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:floorButton];
            [self.floorsButtons setObject:floorButton forKey:floorLevel];
            
            i++;
        }
    }
}

- (IDSFloor*)floorAtLevel:(int)floorLevel {
    return [self.building.floors objectForKey:[NSNumber numberWithInt:floorLevel]];
}

#pragma mark - Actions
- (IBAction)changeFloorButtonTapped:(id)sender {
    UIButton* floorButton = (UIButton*) sender;
    int floorLevel = floorButton.tag;
    
    if ([self isValidFloorLevel:floorLevel] && floorLevel != self.currentMarkedFloorLevel) {
        IDSFloor* floor = [self floorAtLevel:floorLevel];
        if (delegate && floor) {
            [delegate buildingFloorsView:self didSelectFloor:floor];
        }
        self.currentMarkedFloorLevel = floorLevel ;
        [self highlightFloorAtLevel:floorLevel];
    }
}

#pragma mark - Public
- (void)setCurrentBuilding:(IDSBuilding*)b {
    self.building = b;
    self.currentMarkedFloorLevel = INT_MAX;
    [self redrawFloors];
}

- (void)markFloorAtLevel:(int)floorLevel {
    if ([self isValidFloorLevel:floorLevel]) {
        for (UIButton* btn in [self.floorsButtons allValues]) {
            
            if (btn.tag == floorLevel) {
                [btn setBackgroundImage:[UIImage imageNamed:@"userFloorBackground"] forState:UIControlStateNormal];
            } else {
                [btn setBackgroundImage:nil forState:UIControlStateNormal];
            }
        }
    }
}

- (void)highlightFloorAtLevel:(int)floorLevel {
    if ([self isValidFloorLevel:floorLevel]) {
        for (UIButton* btn in [self.floorsButtons allValues]) {
            
            if (btn.tag == floorLevel) {
                self.currentMarkedFloorLevel = floorLevel;
                [self setFloorButtonBackgroundColor:btn isSelected:YES];
            } else {
                [self setFloorButtonBackgroundColor:btn isSelected:NO];
            }
        }
    }
}

@end