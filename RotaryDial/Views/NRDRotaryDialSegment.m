//
//  NRDRotaryDialSegment.m
//  RotaryDial
//
//  Created by Dan Kane on 4/15/14.
//  Copyright (c) 2014 The Nerdery. All rights reserved.
//

#import "NRDRotaryDialSegment.h"
#import "NRDMath.h"

@implementation NRDRotaryDialSegment

- (id)initWithInnerRadius:(NSUInteger)innerRadius
              outerRadius:(NSUInteger)outerRadius
               startAngle:(CGFloat)startAngle
                 endAngle:(CGFloat)endAngle
{
    // Set frame to full circle size (easier to line up centers!)
    self = [super initWithFrame:CGRectMake(0, 0, 2*outerRadius, 2*outerRadius)];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.innerRadius = innerRadius;
        self.outerRadius = outerRadius;
        self.startAngle = normalize_angle(startAngle);
        self.endAngle = normalize_angle(endAngle);
        self.color = [UIColor lightGrayColor];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(contextRef, self.outerRadius - self.innerRadius);
    
    CGPoint arcCenter = CGPointMake(self.outerRadius, self.outerRadius);
    CGFloat radius = (self.innerRadius + self.outerRadius)/2.0;
    
    // Note: fudging endAngle by half a degree to avoid gaps
    CGContextAddArc(contextRef, arcCenter.x, arcCenter.y, radius, self.startAngle, self.endAngle + 0.01, false);

    CGContextSetStrokeColorWithColor(contextRef, self.color.CGColor);
    
    CGContextDrawPath(contextRef, kCGPathStroke);
}

#pragma mark - Hit Testing

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    // Compute radius to center and compare
    CGPoint pointToCenter = CGPointMake(point.x - self.outerRadius, point.y - self.outerRadius);
    CGFloat radius = sqrt((pointToCenter.x * pointToCenter.x) + (pointToCenter.y * pointToCenter.y));
    
    if (radius > self.outerRadius || radius < self.innerRadius) {
        return NO;
    }
    
    // Compute angle and compare
    CGFloat angle = atan2f(pointToCenter.y, pointToCenter.x);
    angle = normalize_angle(angle);
    
    // Rotate all angles to make startAngle == 0 (easier comparison)
    CGFloat endAngleR = normalize_angle(self.endAngle - self.startAngle);
    CGFloat angleR = normalize_angle(angle - self.startAngle);
    
    // Now check if point angle is greater than endAngle (i.e. outside range)
    // Note: 0 counts as in, endAngle counts as out (to eliminate overlap)
    if (angleR >= endAngleR) {
        return NO;
    }
    
    return [super pointInside:point withEvent:event];
}

@end
