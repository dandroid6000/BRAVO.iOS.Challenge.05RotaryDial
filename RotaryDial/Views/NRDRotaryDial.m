//
//  NRDRotaryDial.m
//  RotaryDial
//
//  Created by Dan Kane on 4/16/14.
//  Copyright (c) 2014 The Nerdery. All rights reserved.
//

#import "NRDRotaryDial.h"
#import "NRDRotaryDialSegment.h"
#import "UIColor+Adjustable.h"
#import "NRDMath.h"

static const CGFloat kAngleBottomCenter = M_PI_2;
static const CGFloat kAngleHandleLeft = M_PI*1.42;
static const CGFloat kAngleHandleRight = M_PI*1.58;

@interface NRDRotaryDial ()

@property (strong, nonatomic) NRDRotaryDialSegment *leftSegment;
@property (strong, nonatomic) NRDRotaryDialSegment *rightSegment;
@property (strong, nonatomic) NRDRotaryDialSegment *handleSegment;

@property (assign, nonatomic) CGFloat startDragAngle;

@end

@implementation NRDRotaryDial

- (id)initWithRadius:(NSUInteger)radius thickness:(NSUInteger)thickness
{
    self = [super initWithFrame:CGRectMake(0, 0, 2*radius, 2*radius)];
    if (self) {
        // Set properties
        self.thickness = thickness;
        self.ringColor = [UIColor colorWithWhite:0.8 alpha:1.0];
        
        // Create and add subviews
        self.leftSegment = [[NRDRotaryDialSegment alloc] initWithInnerRadius:radius - thickness
                                                                 outerRadius:radius
                                                                  startAngle:kAngleBottomCenter
                                                                    endAngle:kAngleHandleLeft];
        self.leftSegment.color = self.ringColor;
        [self.leftSegment addTarget:self action:@selector(didTapRing:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.leftSegment];
        self.leftSegment.center = self.center;
        
        self.rightSegment = [[NRDRotaryDialSegment alloc] initWithInnerRadius:radius - thickness
                                                                  outerRadius:radius
                                                                   startAngle:kAngleHandleRight
                                                                     endAngle:kAngleBottomCenter];
        self.rightSegment.color = self.ringColor;
        [self.rightSegment addTarget:self action:@selector(didTapRing:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.rightSegment];
        self.rightSegment.center = self.center;
        
        self.handleSegment = [[NRDRotaryDialSegment alloc] initWithInnerRadius:radius - thickness
                                                                   outerRadius:radius
                                                                    startAngle:kAngleHandleLeft
                                                                      endAngle:kAngleHandleRight];
        self.handleSegment.color = [self.ringColor darkerColor];
        [self.handleSegment addTarget:self action:@selector(didPressHandle:withEvent:) forControlEvents:UIControlEventTouchDown];
        [self.handleSegment addTarget:self action:@selector(didTapRing:) forControlEvents:UIControlEventTouchUpInside];
        [self.handleSegment addTarget:self action:@selector(didMoveHandle:withEvent:)
                     forControlEvents:UIControlEventTouchDragInside | UIControlEventTouchDragOutside];
        [self addSubview:self.handleSegment];
        self.handleSegment.center = self.center;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    // Make a dial that fits the frame with a 25% thickness
    NSUInteger radius = MIN(frame.size.width, frame.size.height)/2;
    NSUInteger thickness = radius * 0.25;
    return [self initWithRadius:radius thickness:thickness];
}

#pragma mark - Accessor Methods

- (void)setThickness:(NSUInteger)thickness
{
    _thickness = thickness;
    
    // Update the subviews
    self.leftSegment.innerRadius = self.leftSegment.outerRadius - thickness;
    self.rightSegment.innerRadius = self.rightSegment.outerRadius - thickness;
    self.handleSegment.innerRadius = self.handleSegment.outerRadius - thickness;
    [self.subviews makeObjectsPerformSelector:@selector(setNeedsDisplay)];
}

- (void)setRingColor:(UIColor *)ringColor
{
    _ringColor = ringColor;
    
    // Update the subviews
    self.leftSegment.color = ringColor;
    self.rightSegment.color = ringColor;
    self.handleSegment.color = self.handleColor ?: [ringColor darkerColor];
    [self.subviews makeObjectsPerformSelector:@selector(setNeedsDisplay)];
}

- (void)setHandleColor:(UIColor *)handleColor
{
    _handleColor = handleColor;
    
    // Update the subview
    self.handleSegment.color = handleColor ?: [self.ringColor darkerColor];
    [self.handleSegment setNeedsDisplay];
}

- (void)setValue:(CGFloat)value
{
    if (self.minimumValue <= value && value <= self.maximumValue) {
        _value = value;
        
        // Rotate to show the new value
        if (self.minimumValue != self.maximumValue) {
            CGFloat percent = (value - self.minimumValue)/(self.maximumValue - self.minimumValue);
            self.transform = CGAffineTransformMakeRotation(percent * 2*M_PI);
        } else {
            self.transform = CGAffineTransformIdentity;
        }
        
        // Send actions to targets
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

#pragma mark - Event Handlers

- (void)didPressHandle:(id)sender withEvent:(UIEvent *)event {
    // Save the angle to the center for the starting point
    UITouch *touch = [event.allTouches anyObject];
    CGPoint point = [touch locationInView:self.handleSegment];
    self.startDragAngle = angle_for_point(point, self.handleSegment.center);
}

- (void)didMoveHandle:(id)sender withEvent:(UIEvent *)event {
    // Get the angle to the center for the current touch point
    UITouch *touch = [event.allTouches anyObject];
    CGPoint point = [touch locationInView:self.handleSegment];
    CGFloat angle = angle_for_point(point, self.handleSegment.center);
    
    // Subtract off starting angle and add rotation to transform
    angle = angle - self.startDragAngle;
    self.transform = CGAffineTransformRotate(self.transform, angle);

    // Determine the absolute angle (using the transform) and set the value
    CGFloat absoluteAngle = angle_from_transform(self.transform);
    self.value = [self valueForAngle:absoluteAngle];
    
    // Send actions to targets
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)didTapRing:(id)sender
{
    if (sender == self.leftSegment
        && [self.delegate respondsToSelector:@selector(leftSegmentTapped)]) {
        [self.delegate leftSegmentTapped];
    }
    else if (sender == self.rightSegment
             && [self.delegate respondsToSelector:@selector(rightSegmentTapped)]) {
        [self.delegate rightSegmentTapped];
    }
    else if (sender == self.handleSegment) {
        // Anything to do?
        NSLog(@"DidReleaseHandle");
    }
}

#pragma mark - Helper Methods

- (CGFloat)valueForAngle:(CGFloat)angle
{
    CGFloat percent = angle/(2*M_PI);
    return self.minimumValue + percent * (self.maximumValue - self.minimumValue);
}

@end
