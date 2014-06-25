//
//  IVAnnotationDetailsView.m
//  iViewer
//
//  Created by Mina Haleem on 24.03.13.
//  Copyright (c) 2013 Mina Haleem. All rights reserved.
//

#import "ISAnnotationDetailsView.h"

@interface ISAnnotationDetailsView ()
@property(nonatomic,strong) UIButton *_callButton;
@end

@implementation ISAnnotationDetailsView
@synthesize _callButton;
@synthesize textLabel = _textLabel;
@synthesize detailTextLabel = _detailTextLabel;
@synthesize callButtonTappedBlock = _callButtonTappedBlock;

- (id)initWithFrame:(CGRect)frame {
    UIImage *backgroundImage = [UIImage imageNamed:@"popup"];
    CGRect adjustedFrame = (CGRect) { frame.origin, backgroundImage.size };
    
    self = [super initWithFrame:adjustedFrame];
    if (self) {
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
        
        CGRect textFrame, detailTextFrame, lastUpdatedLabelFrame;
        CGFloat detailFontSize = 10.0;
        UIColor *textColor = RGB(0x323332);
        
        textFrame = CGRectMake(14, 12, 166, 26);
        lastUpdatedLabelFrame = CGRectMake(14, 38, 64, 12);
        detailTextFrame = CGRectMake(78, 38, 102, 26);
        
        _textLabel = [[UILabel alloc] initWithFrame:textFrame];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.font = [UIFont fontWithName:@"PTSans-Bold" size:19.0];
        _textLabel.adjustsFontSizeToFitWidth = YES;
        _textLabel.minimumFontSize = 14.0;
        _textLabel.textColor = textColor;
        
        UILabel *lastUpdatedLabel = [[UILabel alloc] initWithFrame:lastUpdatedLabelFrame];
        lastUpdatedLabel.backgroundColor = [UIColor clearColor];
        lastUpdatedLabel.font = [UIFont fontWithName:@"PT Sans" size:detailFontSize];
        lastUpdatedLabel.textColor = textColor;
        lastUpdatedLabel.text = @"Last Updated:";
        
        _detailTextLabel = [[UILabel alloc] initWithFrame:detailTextFrame];
        _detailTextLabel.backgroundColor = [UIColor clearColor];
        _detailTextLabel.font = [UIFont fontWithName:@"PT Sans" size:detailFontSize];
        _detailTextLabel.textColor = textColor;
        _detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
        _detailTextLabel.numberOfLines = 2;
        
        UIImage *callButtonImage = [UIImage imageNamed:@"popup-button"];
        UIImage *callButtonPressedImage = [UIImage imageNamed:@"popup-button-pressed"];
        UIImage *callButtonDisabledImage = [UIImage imageNamed:@"popup-button-disabled"];
        
        _callButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _callButton.frame = (CGRect) { { 181.0, 11.0 }, callButtonImage.size };
        [_callButton setImage:callButtonImage forState:UIControlStateNormal];
        [_callButton setImage:callButtonPressedImage forState:UIControlStateHighlighted];
        [_callButton setImage:callButtonDisabledImage forState:UIControlStateDisabled];
        [_callButton addTarget:self action:@selector(callButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:backgroundImageView];
        [self addSubview:_textLabel];
        [self addSubview:lastUpdatedLabel];
        [self addSubview:_detailTextLabel];
        [self addSubview:_callButton];
    }
    return self;
}

- (BOOL)callButtonEnabled {
    return _callButton.enabled;
}

- (void)setCallButtonEnabled:(BOOL)callButtonEnabled {
    _callButton.enabled = callButtonEnabled;
}

- (void)callButtonTapped {
    if (_callButtonTappedBlock) {
        _callButtonTappedBlock();
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    return view == self ? nil : view;
}



@end
