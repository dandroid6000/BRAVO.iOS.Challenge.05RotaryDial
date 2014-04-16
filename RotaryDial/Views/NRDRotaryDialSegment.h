//
//  NRDRotaryDialSegment.h
//  RotaryDial
//
//  Created by Dan Kane on 4/15/14.
//  Copyright (c) 2014 The Nerdery. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NRDRotaryDialSegment : UIControl

@property (nonatomic, assign) NSUInteger innerRadius;
@property (nonatomic, assign) NSUInteger outerRadius;
@property (nonatomic, assign) CGFloat startAngle;
@property (nonatomic, assign) CGFloat endAngle;
@property (nonatomic, strong) UIColor *color;

- (id)initWithInnerRadius:(NSUInteger)innerRadius
              outerRadius:(NSUInteger)outerRadius
               startAngle:(CGFloat)startAngle
                 endAngle:(CGFloat)endAngle;

@end
