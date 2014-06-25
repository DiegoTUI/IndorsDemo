//
//  CallOutView.m
//  CallOutView
//
//  Created by Hendrik Holtmann on 18.01.10.
//  ported from MonoTouch

#import "ISCallOutView.h"

@interface ISCallOutView()
-(void) initialize;
-(void) addButtonTarget:(id)target action:(SEL)selector;
-(void) showWithAnimiation:(UIView*)parent;
@end

@implementation ISCallOutView
@synthesize text;
@synthesize coordinate;

#define CENTER_IMAGE_WIDTH  31
#define CALLOUT_HEIGHT  70
#define MIN_LEFT_IMAGE_WIDTH  16
#define MIN_RIGHT_IMAGE_WIDTH  16
#define CENTER_IMAGE_ANCHOR_OFFSET_X  15
#define MIN_ANCHOR_X  MIN_LEFT_IMAGE_WIDTH + CENTER_IMAGE_ANCHOR_OFFSET_X
#define BUTTON_WIDTH  0
#define BUTTON_Y  10
#define LABEL_HEIGHT  48
#define LABEL_FONT_SIZE  18
#define ANCHOR_Y  60


#define RECTFRAME CGRectMake (0, 0, 100, CALLOUT_HEIGHT)

static UIImage *CALLOUT_LEFT_IMAGE;
static UIImage *CALLOUT_CENTER_IMAGE;
static UIImage *CALLOUT_RIGHT_IMAGE;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		[self initialize];
    }
    return self;
}

-(id)initWithText:(NSString*)atext point:(CGPoint)aPoint
{
	if (self = [super initWithFrame:RECTFRAME]) {
		[self initialize];
		self.text = atext;
	}	
	return self;
}

-(id)initWithText:(NSString*)atext point:(CGPoint)aPoint target:(id)object action:(SEL)selector
{
    UIFont* textFont = [UIFont boldSystemFontOfSize:LABEL_FONT_SIZE];
    CGSize size = [atext sizeWithFont:textFont];
	
	float width = size.width + MIN_LEFT_IMAGE_WIDTH +  MIN_RIGHT_IMAGE_WIDTH ;
	float height = CALLOUT_HEIGHT;
    float x = aPoint.x - (width/ 2);
    float y =  aPoint.y - height;
	CGRect frame = CGRectMake(x, y, width, height);
    
    self = [super initWithFrame:frame];
	if (self && self != nil) {
		[self initialize];
		self.text = atext;
		[self addButtonTarget:object action:selector];
	}	
	return self;
}

- (void)repositionWithPoint:(CGPoint) aPoint {
    CGRect rect = self.frame;
    float x = aPoint.x - (rect.size.width / 2);
    float y = aPoint.y - rect.size.height;
    
    rect.origin = CGPointMake(x, y);
    self.frame = rect;
}


+ (ISCallOutView*) addCalloutView:(UIView*)parent text:(NSString*)text point:(CGPoint)pt target:(id)target action:(SEL)selector
{
	ISCallOutView *callout = [[ISCallOutView alloc] initWithText:text point:pt target:target action:selector];
	[callout showWithAnimiation:parent];
	return callout ;
}


-(void) showWithAnimiation:(UIView*)parent
{
	self.transform = CGAffineTransformMakeScale(0.2f, 0.2f);
    self.alpha = 0;
    [parent addSubview:self];
    
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.2f];
	self.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
    self.alpha = 1;
	[UIView commitAnimations];
}

-(void)setText:(NSString *)aText{
	calloutLabel.text = aText;
	[calloutLabel setNeedsLayout];
}


- (void) initialize {
	self.backgroundColor = [UIColor clearColor];
	self.opaque = false;
	
	if (CALLOUT_LEFT_IMAGE == nil) {
		CALLOUT_LEFT_IMAGE = [[UIImage imageNamed:@"callout_left"] stretchableImageWithLeftCapWidth:15 topCapHeight:0];
	}
	
	if (CALLOUT_CENTER_IMAGE == nil) {
        CALLOUT_CENTER_IMAGE = [UIImage imageNamed:@"callout_center"];
	}
	
	if (CALLOUT_RIGHT_IMAGE == nil) {
        CALLOUT_RIGHT_IMAGE = [[UIImage imageNamed:@"callout_right"] stretchableImageWithLeftCapWidth:1 topCapHeight:0];
	}
	
	
	float imageWidth = self.frame.size.width - CENTER_IMAGE_WIDTH;
	float left_width = imageWidth / 2;
	float right_width = left_width;
	
	calloutLeft = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, left_width, CALLOUT_HEIGHT)];
	calloutLeft.image = CALLOUT_LEFT_IMAGE;
	[self addSubview:calloutLeft];

	
	calloutCenter = [[UIImageView alloc] initWithFrame:CGRectMake(left_width, 0, CENTER_IMAGE_WIDTH, CALLOUT_HEIGHT)];
	calloutCenter.image = CALLOUT_CENTER_IMAGE;
	[self addSubview:calloutCenter];
	
	
	calloutRight = [[UIImageView alloc] initWithFrame:CGRectMake(left_width + CENTER_IMAGE_WIDTH, 0, right_width, CALLOUT_HEIGHT)];
	calloutRight.image = CALLOUT_RIGHT_IMAGE;
	[self addSubview:calloutRight];
	
	calloutLabel = [[UILabel alloc] initWithFrame:CGRectMake(MIN_LEFT_IMAGE_WIDTH, 0, self.frame.size.width - - MIN_LEFT_IMAGE_WIDTH - BUTTON_WIDTH - MIN_RIGHT_IMAGE_WIDTH - 2 , LABEL_HEIGHT)];
	calloutLabel.font = [UIFont boldSystemFontOfSize:LABEL_FONT_SIZE];
	calloutLabel.textColor = [UIColor whiteColor];
	calloutLabel.backgroundColor = [UIColor clearColor];
	[self addSubview:calloutLabel];
	
	
	calloutButton = [UIButton buttonWithType:UIButtonTypeCustom];
	calloutButton.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 15);
    calloutButton.backgroundColor = [UIColor clearColor];
	[self addSubview:calloutButton];	
}


- (void) layoutSubviews {
	[super layoutSubviews];
	
    float imageWidth = self.frame.size.width - CENTER_IMAGE_WIDTH;
    
	float left_width = imageWidth / 2;
	float right_width = left_width;
	
	calloutLeft.frame = CGRectMake(0, 0, left_width, CALLOUT_HEIGHT);
	calloutCenter.frame = CGRectMake(left_width, 0, CENTER_IMAGE_WIDTH, CALLOUT_HEIGHT);
	calloutRight.frame = CGRectMake(left_width+CENTER_IMAGE_WIDTH, 0, right_width, CALLOUT_HEIGHT);
	calloutLabel.frame = CGRectMake(MIN_LEFT_IMAGE_WIDTH, 0, self.frame.size.width, LABEL_HEIGHT);
	
	calloutButton.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 15);
}

- (void) addButtonTarget:(id)target action:(SEL)selector
{
	[calloutButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
}



@end
