//
//  CallOutView.h
//  CallOutView
//
//  Created by Hendrik Holtmann on 18.01.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISAnnotationView.h"
#import <Indoors/IDSCoordinate.h>

@interface ISCallOutView : UIView {

	UIImageView *calloutLeft;
	UIImageView *calloutCenter;
	UIImageView *calloutRight;
	UIButton *calloutButton;
	UILabel *calloutLabel;
	NSString *text;
	CGAffineTransform transform;
}

+ (ISCallOutView*) addCalloutView:(UIView*)parent text:(NSString*)text point:(CGPoint)pt target:(id)target action:(SEL)selector;
-(id)initWithText:(NSString*)atext point:(CGPoint)aPoint target:(id)object action:(SEL)selector;
-(void) showWithAnimiation:(UIView*)parent;
- (void)repositionWithPoint:(CGPoint) aPoint;

@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) IDSCoordinate* coordinate;
@end
